#' Get Grid Mapping
#'
#' @description Get the grid mapping from a NetCDF file
#'
#' @return tibble containing attributes that make up the file's grid_mapping.
#' A data_variable column is included to indicate which data variable the grid
#' mapping belongs to.
#' @export
#' 
#' @name nc_grid_mapping_atts
#' @examples
#' 
#' nc_grid_mapping_atts(system.file("extdata/daymet_sample.nc", package = "ncmeta"))

nc_grid_mapping_atts <- function(x, data_variable = NULL) UseMethod("nc_grid_mapping_atts")

#' @param x open NetCDF object, character file path or url to be 
#' opened with RNetCDF::open.nc, or data.frame as returned from ncmeta::nc_atts
#' 
#' @param data_variable character variable of interest
#' 
#' @name nc_grid_mapping_atts
#' @export
nc_grid_mapping_atts.character <- function(x, data_variable = NULL) {
  nc <- RNetCDF::open.nc(x)
  on.exit(RNetCDF::close.nc(nc), add  = TRUE) 
  nc_grid_mapping_atts(nc, data_variable)
}

#' @name nc_grid_mapping_atts
#' @export
nc_grid_mapping_atts.NetCDF <- function(x, data_variable = NULL) {
  nc_grid_mapping_atts(nc_atts(x), data_variable)
}

#' @name nc_grid_mapping_atts
#' @export
nc_grid_mapping_atts.data.frame <- function(x, data_variable = NULL) {
  
  gm_att <- "grid_mapping"
  
  if(is.null(data_variable)) {
    data_variable <- find_var_by_att(x, gm_att)
  } else if(!gm_att %in% dplyr::filter(x, variable == data_variable)$name) {
    warning(paste("no grid_mapping attribute found for this variable"))
    return(tibble::tibble())
  }
  
  if (length(data_variable) == 0 ) {
    warning(paste("No variables with a grid mapping found.\n",
                  "Defaulting to WGS84 Lon/Lat"))
    
    return(tibble::as_tibble(list(name = c("grid_mapping_name", 
                                           "semi_major_axis", 
                                           "inverse_flattening", 
                                           "longitude_of_prime_meridian"),
                                  value = list("latitude_longitude", 
                                               6378137, 
                                               298.257223563, 
                                               0))))
  }
  
  grid_mapping_vars <- dplyr::filter(x, variable %in% data_variable & 
                                      name %in% gm_att) %>%
    dplyr::mutate(value = as.character(value))
  
  grid_mapping_atts <- dplyr::filter(x, variable %in% grid_mapping_vars$value)
  
  grid_mapping_atts <- 
    dplyr::left_join(grid_mapping_atts, 
                     select(grid_mapping_vars, data_variable = variable, value = value),
                     by = c("variable" = "value"))
  
  return(grid_mapping_atts)
}

#' Get NetCDF-CF grid mapping from projection
#'
#' Takes a proj4 string and returns a NetCDF-CF projection as
#' a named list of attributes.
#'
#' @param prj character PROJ string as used in raster, sf, sp, proj4, and rgdal packages.
#'
#' @return A named list containing attributes required for that grid_mapping.
#'
#' 
#' @references 
#' \enumerate{
#'   \item \url{https://en.wikibooks.org/wiki/PROJ.4}
#'   \item \url{https://trac.osgeo.org/gdal/wiki/NetCDF_ProjectionTestingStatus}
#'   \item \url{http://cfconventions.org/cf-conventions/cf-conventions.html#appendix-grid-mappings}
#' }
#'
#' @export
#' 
#' @examples
#' prj <- "+proj=longlat +datum=NAD27 +no_defs"
#' nc_prj_to_gridmapping(prj)
#' p1 <- "+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=23 +lon_0=-96"
#' p2 <- "+x_0=0 +y_0=0 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"
#' prj2 <- sprintf("%s %s", p1, p2) 
#' nc_prj_to_gridmapping(prj2)
#' 
#' nc_prj_to_gridmapping("+proj=longlat +a=6378137 +f=0.00335281066474748 +pm=0 +no_defs")
#' 
nc_prj_to_gridmapping <- function(prj) {
  
  al <- prepCRS(prj)
  
  if(is.null(al)) {
    return(tibble::as_tibble(list(name = character(0), value = list()))) 
  } else {
    
    gm <- GGFP(al)
    
    return(tibble::as_tibble(list(name = names(gm), value = unname(gm))))
  }
}

GGFP <- function(al) UseMethod("GGFP")

GGFP.latitude_longitude <- function(al) {
  gm <- c(list(grid_mapping_name = "latitude_longitude"),
          getGeoDatum_gm(al))
}

GGFP.albers_conical_equal_area <- function(al) {
  gm <- c(list(grid_mapping_name = "albers_conical_equal_area"),
       lonCentMer_gm(al),
       latProjOrig_gm(al),
       falseEastNorth_gm(al),
       standPar_gm(al),
       getGeoDatum_gm(al))
}

GGFP.azimuthal_equidistant <- function(al) {
  gm <- c(list(grid_mapping_name = "azimuthal_equidistant"),
          lonProjOrig_gm(al),
          latProjOrig_gm(al),
          falseEastNorth_gm(al),
          getGeoDatum_gm(al))
}

GGFP.lambert_azimuthal_equal_area <- function(al) {
  gm <- c(list(grid_mapping_name = "lambert_azimuthal_equal_area"),
          latProjOrig_gm(al),
          lonProjOrig_gm(al),
          falseEastNorth_gm(al),
          getGeoDatum_gm(al))
}

GGFP.lambert_conformal_conic <- function(al) {
  gm <- c(list(grid_mapping_name = "lambert_conformal_conic"),
                    standPar_gm(al),
                    falseEastNorth_gm(al),
                    latProjOrig_gm(al),
                    lonCentMer_gm(al),
                    getGeoDatum_gm(al))
}

GGFP.lambert_cylindrical_equal_area <- function(al) {
  gm <- c(list(grid_mapping_name = "lambert_cylindrical_equal_area"),
                    lonCentMer_gm(al),
                    oneStandPar_gm(al),
                    falseEastNorth_gm(al),
                    getGeoDatum_gm(al))
}

GGFP.mercator <- function(al) {
  if(!is.null(al$k)) {
    gm <- c(list(grid_mapping_name = "mercator"),
                      lonProjOrig_gm(al),
                      scaleFactor_gm(al),
                      falseEastNorth_gm(al),
                      getGeoDatum_gm(al))
  } else {
    gm <- c(list(grid_mapping_name = "mercator"),
                      lonProjOrig_gm(al),
                      oneStandPar_gm(al),
                      falseEastNorth_gm(al),
                      getGeoDatum_gm(al))
  }
}

GGFP.oblique_mercator <- function(al) {
  #!!!! Check this one out. the oMerc function is a hack !!!!
  gm <- c(list(grid_mapping_name = "oblique_mercator"),
                    latProjOrig_gm(al),
                    lonProjCent_gm(al),
                    scaleFactor_gm(al),
                    oMerc_gm(al),
                    falseEastNorth_gm(al),
                    getGeoDatum_gm(al))
}

GGFP.orthographic <- function(al) {
  gm <- c(list(grid_mapping_name = "orthographic"),
                    latProjOrig_gm(al),
                    lonProjOrig_gm(al),
                    falseEastNorth_gm(al),
                    getGeoDatum_gm(al))
}

# GGFP.polar_stereographic <- function(al) {
#   if(!is.null(al$k)) {
#     gm <- c(list(grid_mapping_name = "polar_stereographic"),
#                       latProjOrig_gm(al),
#                       stVertLon_gm(al),
#                       scaleFactor_gm(al),
#                       falseEastNorth_gm(al),
#                       getGeoDatum_gm(al))
#   } else {
#     gm <- c(list(grid_mapping_name = "polar_stereographic"),
#                       latProjOrig_gm(al),
#                       stVertLon_gm(al),
#                       oneStandPar_gm(al),
#                       falseEastNorth_gm(al),
#                       getGeoDatum_gm(al))
#   }
# }

# GGFP.sinusoidal <- function(al) {
#   gm <- c(list(grid_mapping_name = "sinusoidal"),
#                     lonProjOrig_gm(al),
#                     falseEastNorth_gm(al),
#                     getGeoDatum_gm(al))
# }

GGFP.stereographic <- function(al) {
  gm <- c(list(grid_mapping_name = "stereographic"),
                    latProjOrig_gm(al),
                    lonProjOrig_gm(al),
                    scaleFactor_gm(al),
                    falseEastNorth_gm(al),
                    getGeoDatum_gm(al))
}

GGFP.transverse_mercator <- function(al) {
  gm <- c(list(grid_mapping_name = "transverse_mercator"),
                    latProjOrig_gm(al),
                    lonProjOrig_gm(al),
                    scaleFactor_gm(al),
                    falseEastNorth_gm(al),
                    getGeoDatum_gm(al))
}

lonCentMer_gm <- function(al) {
  list(longitude_of_central_meridian = as.numeric(al$lon_0))
}

latProjOrig_gm <- function(al) {
  list(latitude_of_projection_origin = as.numeric(al$lat_0))
}

lonProjOrig_gm <- function(al) {
  list(longitude_of_projection_origin = as.numeric(al$lon_0))
}

falseEastNorth_gm <- function(al) {
  list(false_easting = as.numeric(al$x_0),
  false_northing = as.numeric(al$y_0))
}

standPar_gm <- function(al) {
  if(al$lat_1 != al$lat_2) {
    list(standard_parallel = c(as.numeric(al$lat_1), as.numeric(al$lat_2)))
  } else if(al$lat_1 == al$lat_2) {
    list(standard_parallel = as.numeric(al$lat_1))
  }
}

oneStandPar_gm <- function(al) {
  list(standard_parallel = c(as.numeric(al$lat_ts)))
}

getGeoDatum_gm <- function(al) {
  if(!is.null(al$datum) && al$datum == "NAD83") {
    list(semi_major_axis = 6378137,
         inverse_flattening = 298.257222101,
         longitude_of_prime_meridian = 0)
  } else if(!is.null(al$datum) && al$datum == "WGS84") {
    list(semi_major_axis = 6378137,
         inverse_flattening = 298.257223563,
         longitude_of_prime_meridian = 0)
  } else if(!is.null(al$datum) && al$datum == "NAD27") {
    list(semi_major_axis = 6378206.4,
         inverse_flattening = 294.978698214,
         longitude_of_prime_meridian = 0)
  } else if(!is.null(al$ellps) && 
  					!is.null(al$towgs84) && 
  					al$towgs84 == "0,0,0,0,0,0,0") {
  	list(semi_major_axis = 6378137,
  			 inverse_flattening = 298.257223563,
  			 longitude_of_prime_meridian = 0)
  } else if(!is.null(al$a) && !is.null(al$f) && !is.null(al$pm)) {
    list(semi_major_axis = as.numeric(al$a),
        inverse_flattening = (1/as.numeric(al$f)),
        longitude_of_prime_meridian = as.numeric(al$pm))
  } else if(!is.null(al$a) && !is.null(al$b) && !is.null(al$pm)) {
  	list(semi_major_axis = as.numeric(al$a),
  			 semi_minor_axis = as.numeric(al$b),
  			 longitude_of_prime_meridian = as.numeric(al$pm))
  } else {
  	warning("no datum information found assuming WGS84")
  	list(semi_major_axis = 6378137,
  			 inverse_flattening = 298.257223563,
  			 longitude_of_prime_meridian = 0)
  }
}

scaleFactor_gm <- function(al) {
  list(scale_factor_at_projection_origin = as.numeric(al$k))
}

oMerc_gm <- function(al) {
  list(azimuth_of_central_line = as.numeric(al$alpha))
}

lonProjCent_gm <- function(al) {
  list(longitude_of_projection_origin = as.numeric(al$lonc))
}

check_args <- function (x) 
{
  ## FIXME: checks as in reproj stop("cannot convert from digits, did you enter an EPSG code?")
  if (is.numeric(x) || (nchar(x) %in% c(4, 5) && grepl("^[0-9]{1,5}$", 
                                                       x))) {
    return(FALSE)
  }
  if (!substr(x, 1, 1) == "+") 
    return(FALSE)
  TRUE
}

prepCRS <- function(prj) {
  if(class(prj) == "CRS") prj <- prj@projargs

  if(!check_args(prj)[1][[1]]) {
 
    warning("not a valid crs, returning an empty tibble")
    return(NULL)
  }

  args <- unique(unlist(strsplit(prj, " ")))

  argList <- list()

  for(arg in args) {
    a <- unlist(strsplit(sub("\\+", "", arg), "="))
    argList[a[1]] <- a[2]
  }

  cf_proj_lookup <- list(aea = "albers_conical_equal_area",
                         aeqd = "azimuthal_equidistant",
                         laea = "lambert_azimuthal_equal_area",
                         lcc = "lambert_conformal_conic",
                         cea = "lambert_cylindrical_equal_area",
                         longlat = "latitude_longitude",
                         merc = "mercator",
                         omerc = "oblique_mercator",
                         ortho = "orthographic",
                         stere = "stereographic",
                         tmerc = "transverse_mercator")

  class(argList) <- cf_proj_lookup[unlist(argList["proj"])][[1]]

  if(!class(argList) %in% cf_proj_lookup) {
    warning("no available mapping to netcdf projection, returning empty crs list")
    return(NULL) } else {
    return(argList) }
}
