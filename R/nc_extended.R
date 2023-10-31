#' NetCDF extended dimension attributes
#'
#' Generate a table of all extended dimension attributes. For now that means 
#' interpretation of any "time" dimension.
#' 
#' @param x filename or handle
#' @param ... ignored currently
#'
#' @return data frame of extended dimension attribute information
#' @export
#'
nc_extended <- function(x, ...)  {
  UseMethod("nc_extended")
}

#' @name nc_extended
#' @export
nc_extended.character <- function(x, ...) {
  if (nchar(x) < 1) stop("NetCDF source cannot be empty string")
  
  nc <- RNetCDF::open.nc(x)
  on.exit(RNetCDF::close.nc(nc), add  = TRUE)
  nc_extended(nc)
}

#' @name nc_extended
#' @export
#' @importFrom dplyr %>% 
#' @importFrom rlang .data
nc_extended.NetCDF <- function(x, ...) {
  ndims <- nc_inq(x)$ndims
  if (ndims  < 1) return(tibble::tibble())
  nc_extended_internal(x, nc_dims_internal(x, ndims, ...))
}

#' Compile extended dimension attributes
#'
#' This function will build extended dimension attributes from (mostly)
#' metadata. The resulting tibble will have a row for every dimension, having,
#' as a minimum, the id and variable name of the dimension. For every extended
#' attribute there is a column whose values describe the attribute. If the
#' attribute is not defined for the dimension, NA will be returned.
#'
#' @param x RNetCDF instance.
#' @param dims The dims tibble as returned from nc_dims_internal().
#'
#' @returns A tibble with extended dimension attributes
#' @noRd
nc_extended_internal <- function(x, dims) {
  ## Add time information for any "time" dimension. Since not all files have a 
  ## "calendar" attribute or "axis == "T"", just try to create a CFtime
  ## instance for any dimension variable with a "units" attribute and a 
  ## "calendar", if present.
  cftime <- lapply(dims$name, function(v) {
    units <- try(RNetCDF::att.get.nc(x, v, "units"), silent = TRUE)
    if (!inherits(units, "try-error") && nchar(units) >= 8) {
      cal <- try(RNetCDF::att.get.nc(x, v, "calendar"), silent = TRUE)
      if (inherits(cal, "try-error")) cal <- "standard"
      try({
        cft <- CFtime::CFtime(units, cal, as.vector(RNetCDF::var.get.nc(x, v)))
        return(cft)
      }, silent = TRUE)
    }
    return (NA)
  })
  
  ## Any other extended attributes to be added here
  
  ## Output
  tibble::tibble(dimension = dims$id, name = dims$name, time = cftime)
}