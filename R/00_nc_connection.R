#' NetCDF connection
#'
#' Currently ncdf4 or RNetCDF are available as preference, with default RNetCDF. 
#' @param x character string source
#' @param preference preferred engine 
#' @param ... ignored currently 
#'
#' @return NetCDF connection object
#' @export
nc_connection <- function(x, preference = NULL, ...) {
  UseMethod("nc_connection")
}
#' @export
nc_connection.character <- function(x, preference = NULL, ...) {
  if (length(x) > 1) stop("no multiple sources, 'x' should be length == 1")
  if (!is.character(x) || is.na(x) || nchar(x) < 1) stop("NetCDF source cannot be invalid, missing, or empty string")
  if (is.null(preference)) preference <- "RNetCDF"
  
  switch(preference, 
         RNetCDF = RNetCDF::open.nc(x), 
         ncdf4 = ncdf4::nc_open(x, suppress_dimvals = TRUE)
    )
}

nc_cleanup <- function(x) {
  res <- switch(tail(class(x), 1), 
   RNetCDF = RNetCDF::close.nc(x), 
   ncdf4 = ncdf4::nc_close(x)
  )
  invisible(res)
}

