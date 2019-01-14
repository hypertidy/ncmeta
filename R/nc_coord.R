#' Get Coordinate Variables for Given Variable
#' 
#' In NetCDF, variables are defined along dimensions and are said to have "coordinate 
#' variables" that define the (typically spatio-temporal) positions of the data's cells.
#' 
#' This function attempts to identify the X, Y, Z, and T coordinate variables for each
#' data variable in the provided NetCDF source. The NetCDF-CF attribute conventions are
#' used to make this determination.
#' 
#' All variables that can be related to a spatio-temporal axis, including coordinate 
#' variables are returned. For coordinate variables, a "bounds" column is included in 
#' the response indicating which variable contains bounds information.
#' 
#' See \url{http://cfconventions.org/cf-conventions/v1.6.0/cf-conventions.html#coordinate-system}
#' for more.
#' 
#' @return tibble with "variable", "X", "Y", "Z", "T", and "bounds" columns that reference 
#' variables by name. 
#' 
#' @name nc_coord_var
#' @export
#' @examples
#' f <- system.file("extdata", "S2008001.L3m_DAY_CHL_chlor_a_9km.nc", package = "ncmeta")
#' nc_coord_var(f, "chlor_a")
#' 
#' f <- system.file("extdata", "guam.nc", package = "ncmeta")
#' nc_coord_var(f)

nc_coord_var <- function(x, variable = NULL, ...) UseMethod("nc_coord_var")

#' @param x NetCDF source
#' @param variable variable name of interest. 
#' If not included, all variables will be returned.
#' @param ... ignored
#'
#' @name nc_coord_var
#' @export
nc_coord_var.character <- function(x, variable = NULL, ...) {
  if (nchar(x) < 1) stop("NetCDF source cannot be empty string")
  
  nc <- RNetCDF::open.nc(x)
  on.exit(RNetCDF::close.nc(nc), add  = TRUE)
  nc_coord_var_call(nc_dims(nc), nc_vars(nc), nc_atts(nc), nc_axes(x), variable)
}

#' @name nc_coord_var
#' @export
nc_coord_var.NetCDF <- function(x, variable = NULL, ...) {
  nc_coord_var_call(nc_dims(x), nc_vars(x), nc_atts(x), nc_axes(x), variable)
}

#' @importFrom dplyr bind_rows
nc_coord_var_call <- function(dim, var, att, axe, variable) {
  if (is.null(var) || (nrow(var) < 1 & nrow(dim) < 1)) return(tibble::tibble())
  
  if(is.null(variable)) {
    bind_rows(lapply(var$name, 
                     function(v) nc_coord_var_finder(dim, var, att, axe, v)))
    
  } else {
    nc_coord_var_finder(dim, var, att, axe, variable)
  }
}

#' @importFrom dplyr bind_rows filter select left_join group_by arrange mutate ungroup distinct
nc_coord_var_finder <- function(dim, var, att, axe, variable) {
  
  if(nrow(att) == 0) return(NULL)
  
  v_atts <- att$variable == variable
  v_atts <- filter(att, v_atts)
  
  aux = FALSE
  
  if ("coordinates" %in% v_atts$name) {
    # NetCDF-CF introduces a "coordinates" attribute
    coordinates_atts <- filter(v_atts, name == "coordinates")
    coord_vars <- strsplit(coordinates_atts[["value"]][[1]], " ")[[1]]
    coord_vars <- coord_vars[nchar(coord_vars) > 0]
    
    if(!any(coord_vars %in% var$name)) {
      warning(paste("missing coordinate variables names in coordinates attribute",
                    "trying to find non-auxiliary coordinate variables."))
    } else {
      aux = TRUE
    }
  }
  
  # COARDS style coordinate variables have the same name as a dimension.
  v_dims <- axe$dimension[axe$variable == variable]
  v_dims <- dim$name[dim$id %in% v_dims]
  
  if(!aux) {
    if(length(v_dims) == 0) return(NULL)
    
    if(any(v_dims %in% var$name)) { 
      coord_vars <- v_dims[v_dims %in% var$name]
    } else {
      return(NULL)
    }
  } else {
    if(any(v_dims %in% var$name)) {
      coord_vars <- unique(c(coord_vars, v_dims[v_dims %in% var$name]))
    }
  }
  
  coord_var <- sapply(coord_vars, divine_XYZT,
                      atts = filter(att, variable %in% coord_vars), 
                      simplify = FALSE)
  
  coord_var <- coord_var[!sapply(coord_var, is.null)]
  
  if(length(coord_var) == 0) {
    return(NULL)
  } else {
    coord_var_base <- tibble::as_tibble(list(coord_var = names(coord_var),
                                             axis = unlist(coord_var)))
    
    out <- tibble::tibble(variable = character(0), 
                          X = character(0),
                          Y = character(0),
                          Z = character(0),
                          T = character(0))
    
    # coordinate variables not named in a coordinates attribute relate 
    # by a shared dimension. First we need to get their dimension joined in.
    coord_var <- coord_var_base %>%
      left_join(select(axe, -axis), by = c("coord_var" = "variable"))
    
    # Now we can build up a table that relates data variables to 
    # coordinate variables.
    coord_var <- tibble::as_tibble(list(variable = variable)) %>%
      left_join(select(axe, -axis), by = "variable") %>%
      left_join(coord_var, by = "dimension") %>%
      filter(!is.na(coord_var)) %>%
      select(variable, axis, coord_var) %>%
      distinct()
    
    out <-tryCatch({
      bind_rows(out, coord_var %>%
                  tidyr::spread(key = axis, value = coord_var))
    }, error = function(e) { 
      # Takes care of the case where there are both normal and auxiliary coordinate variables.
      bind_rows(out, filter(coord_var, !coord_var %in% dim$name) %>%
                  tidyr::spread(key = axis, value = coord_var),
                filter(coord_var, coord_var %in% dim$name)  %>%
                  tidyr::spread(key = axis, value = coord_var))
    })
    
    bounds <- get_bounds(att)
    if(nrow(bounds) > 0) {
      out <- left_join(out, bounds, by = "variable")
    } else {
      if(nrow(out) > 0) {
        out$bounds <- NA_character_
      } else {
        out$bounds <- character(0)
      }
    }
    return(out)
  }
}

axis <- variable <- name <- value <- NULL

divine_XYZT <- function(var, atts) {
  att_sub <- filter(atts, variable == var)
  att_sub <- stats::setNames(att_sub$value, att_sub$name)
  
  # By units is preferred by COARDS
  lon_units <- c("degrees_east|degree_east|degree_E|degrees_E|degreeE|degreesE")
  if(!is.null(att_sub[["units"]]) &&
     grepl(lon_units, att_sub[["units"]], ignore.case = TRUE)) return("X")
  
  lat_units <- "degrees_north|degree_north|degree_N|degrees_N|degreeN|degreesN"
  if(!is.null(att_sub[["units"]]) &&
     grepl(lat_units, att_sub[["units"]], ignore.case = TRUE)) return("Y")
  
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
  
  if(!is.null(att_sub[["units"]]) &&
     grepl("since", att_sub[["units"]])) return("T")
  
  if(any(grepl("x coordinate of projection", att_sub)) | 
     any(grepl("projection_x_coordinate", att_sub))) return("X")
  
  if(any(grepl("y coordinate of projection", att_sub)) | 
     any(grepl("projection_y_coordinate", att_sub))) return("Y")
}
#' @importFrom rlang .data
get_bounds <- function(atts) {
  dplyr::filter(atts, grepl("bounds", atts$name, ignore.case = TRUE)) %>%
    dplyr::select(variable, bounds = value) %>%
    dplyr::mutate(bounds = as.character(.data$bounds))
}
