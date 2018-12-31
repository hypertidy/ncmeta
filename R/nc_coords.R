#' NetCDF Coordinates
#' 
#' In NetCDF, variables are defined along dimensions and are said to have "coordinate 
#' variables" that define the typically spatio-temporal positions of the data's cells.
#' 
#' This function attempts to identify the X, Y, Z, and T coordinate variables for each
#' data variable in the provided NetCDF source. The NetCDF-CF attribute conventions are
#' used to make this determination.
#' 
#' See \url{http://cfconventions.org/cf-conventions/v1.6.0/cf-conventions.html#coordinate-system}
#' for more.
#' 
#' @return tibble with "variable", "X", "Y", "Z", "T", and "order" columns. The "variable",
#' "X", "Y", "Z", and "T" columns of the response reference variables by name.
#' 
#' @name nc_coords
#' @export
nc_coords <- function(x, ...) UseMethod("nc_coords")

#' @param x NetCDF source
#'
#' @param ... ignored
#'
#' @name nc_coords
#' @export
nc_coords.character <- function(x, ...) {
  if (nchar(x) < 1) stop("NetCDF source cannot be empty string")
  
  nc <- RNetCDF::open.nc(x)
  on.exit(RNetCDF::close.nc(nc), add  = TRUE)
  nc_coords_finder(nc_dims(nc), nc_vars(nc), nc_atts(nc), nc_axes(x))
}

#' @name nc_coords
#' @export
nc_coords.NetCDF <- function(x, ...) {
  nc_coords_finder(nc_dims(x), nc_vars(x), nc_atts(x), nc_axes(x))
}


#' @importFrom dplyr filter select left_join group_by arrange mutate ungroup
nc_coords_finder <- function(dim, var, att, axe) {
  
  if (is.null(var) || (nrow(var) < 1 & nrow(dim) < 1)) return(tibble::tibble())
  
  native_var <- unique(axe$variable)
  native_var_dims <- select(axe, -axis) %>%
    filter(variable %in% native_var)
  
  # COARDS style coordinate variables have the same name as a dimension.
  coord_var <- native_var[native_var %in% dim$name]
  
  # NetCDF-CF introduces a "coordinates" attribute
  coordinates_atts <- filter(att, name == "coordinates")[, c("variable", "value")]
  
  coordinates_vals <- paste(coordinates_atts[["value"]], collapse = " ")
  coordinates_vals <- unique(strsplit(coordinates_vals, " ")[[1]])
  coordinates_vals <- coordinates_vals[nchar(coordinates_vals) > 0]
  
  coord_var <- unique(c(coord_var, coordinates_vals[nchar(coordinates_vals) > 0]))
  
  coord_var <- sapply(coord_var, devine_XYZT,
                      atts = filter(att, variable %in% coord_var), 
                      simplify = FALSE)
  
  coord_var_base <- tibble::as_tibble(list(coord_var = names(coord_var),
                                      axis = unlist(coord_var)))
  
  data_var <- native_var[!native_var %in% names(coord_var)]
  
  out <- tibble::tibble(variable = character(0), 
                        X = character(0),
                        Y = character(0),
                        Z = character(0),
                        T = character(0))
  
  if(length(data_var[!data_var %in% coordinates_atts$variable]) > 0) {
    # coordinate variables not named in a coordinates attribute relate 
    # by a shared dimension. First we need to get their dimension joined in.
    coord_var <- coord_var_base %>%
      left_join(select(axe, -axis), by = c("coord_var" = "variable"))
    
    # Now we can build up a table that relates data variables to 
    # coordinate variables.
    var_df <- tibble::as_tibble(list(variable = data_var)) %>%
      left_join(select(axe, -axis), by = "variable") %>%
      left_join(coord_var, by = "dimension") %>%
      filter(!is.na(coord_var)) %>%
      select(variable, axis, coord_var) %>%
      tidyr::spread(key = axis, value = coord_var)
    
    out <- bind_rows(out, var_df)
  }
  
  if(length(coordinates_atts$variable) > 0) {
    ca <- coordinates_atts %>%
      mutate(value = as.character(value)) %>%
      mutate(value = strsplit(value, " ")) %>%
      tidyr::unnest() %>%
      left_join(coord_var_base, by = c("value" = "coord_var")) %>%
      tidyr::spread(key = axis, value = value)
    
    out <- bind_rows(out, ca)
  }
  out
}

axis <- variable <- name <- value <- NULL

devine_XYZT <- function(var, atts) {
  att_sub <- filter(atts, variable == var)
  att_sub <- stats::setNames(att_sub$value, att_sub$name)
  
  # By units is preferred by COARDS
  lon_units <- c("degrees_east|degree_east|degree_E|degrees_E|degreeE|degreesE")
  if(grepl(lon_units, att_sub[["units"]], ignore.case = TRUE)) return("X")
  
  lat_units <- "degrees_north|degree_north|degree_N|degrees_N|degreeN|degreesN"
  if(grepl(lat_units, att_sub[["units"]], ignore.case = TRUE)) return("Y")
  
  # lat/lon by standard name
  if(!is.null(att_sub[["standard_name"]]) && 
     grepl("longitude", att_sub[["standard_name"]], ignore.case = TRUE)) return("X")
  
  if(!is.null(att_sub[["standard_name"]]) && 
     grepl("latitude", att_sub[["standard_name"]], ignore.case = TRUE)) return("Y")
  
  if(!is.null(att_sub[["standard_name"]]) && 
     grepl("time", att_sub[["standard_name"]], ignore.case = TRUE)) return("T")
  
  # X/Y/Z/T by Axis
  if(!is.null(att_sub[["axis"]])) return(att_sub[["axis"]])
  
  if(!is.null(att_sub[["positive"]])) return("Z")
  
  if(grepl("since", att_sub[["units"]])) return("T")
}


               