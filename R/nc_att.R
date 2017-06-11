#' NetCDF attributes
#'
#' Variable attributes are number 0:(n-1). Globabl attributes are indexed 
#' by -1 or the label "NC_GLOBAL".
#' 
#' `nc_inq` includes the number of globabl attributes
#' `nc_vars` inclues the number ofvariable attributes 
#' @param x or file handle
#' @param variable name or index (zero based) of variable
#' @param attribute name or index (zero based) of attribute
#' @param ... ignored
#'
#' @return data frame of attribute 
#' @export
#'
#' @examples
#' f <- system.file("extdata", "S2008001.L3m_DAY_CHL_chlor_a_9km.nc", package = "ncmeta")
#' nc_att(f, 0, 0)
#' @name nc_att
#' @export 
nc_att <- function(x, variable, attribute, ...) {
  UseMethod("nc_att")
}
#' @name nc_att
#' @export 
#' @importFrom rlang .data
nc_att.NetCDF <- function(x, variable, attribute, ...) {
 att <- RNetCDF::att.get.nc(x, variable, attribute)
 faster_tibble(list(attribute = attribute, variable = variable, value = list(att)))
# structure(list(attribute = attribute, variable = variable, value = list(boom = att)), class = "data.frame")
 
 }
#' @name nc_att
#' @export 
#' @importFrom tibble tibble
nc_att.character <- function(x, variable, attribute, ...) {
  nc <- RNetCDF::open.nc(x)
  on.exit(RNetCDF::close.nc(nc), add  = TRUE)
  nc_att(nc, variable, attribute)
}

#' NetCDF attributes
#'
#' All attributes in the file, globals are treated as if they bleong to variable 'NC_GLOBAL'. 
#' @param x filename or handle
#' @param ... ignored
#'
#' @return data frame of attributes
#' @export
#'
#' @examples
#' f <- system.file("extdata", "S2008001.L3m_DAY_CHL_chlor_a_9km.nc", package = "ncmeta")
#' nc_atts(f)
nc_atts <- function(x, ...) {
 UseMethod("nc_atts") 
}
#' @name nc_atts
#' @export
#' @importFrom dplyr distinct
#' @importFrom tibble tibble
nc_atts.NetCDF <- function(x, ...) {
  var <- dplyr::distinct(nc_vars(x), .data$id, .data$name, .data$natts)
  global <- tibble(id = -1, name = "NC_GLOBAL", type = "NA_character_", 
                   ndims = NA_real_, dimids = NA_real_, natts = nc_inq(x)$ngatts)
  var <- bind_rows(var, global)
  #bind_rows(lapply(split(var, var$name), function(v) bind_rows(lapply(seq_len(v$natts), function(iatt) nc_att(x, v$name, iatt - 1)))))
#bind_rows <- function(x) x
    bind_rows(lapply(split(var, var$name), 
                     function(v) bind_rows(lapply(seq_len(v$natts), function(iatt) nc_att(x, v$name, iatt - 1)))))
}
#' @name nc_atts
#' @export
nc_atts.character <- function(x, ...)  {
  nc <- RNetCDF::open.nc(x)
  on.exit(RNetCDF::close.nc(nc), add  = TRUE)
  nc_atts(nc)
}