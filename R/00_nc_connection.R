#' NetCDF connection
#'
#' Currently ncdf4 or RNetCDF are available as engine, with default RNetCDF. 
#' 
#' The preferred engine can be controlled by setting `options(ncmeta.engine = "RNetCDF")` or
#' `options(ncmeta.engine = "ncdf4")`, or by the 'engine' argument to `nc_connection`. If the 
#' `engine` argument is set explicitly this will override the global setting. 
#' @param x character string source
#' @param engine preferred NetCDF interface
#' @param ... ignored currently 
#' @param verbose if `TRUE` print diagnostic messages
#' @return NetCDF connection object
#' @export
#' @examples 
#' f <- system.file("extdata", "S2008001.L3m_DAY_CHL_chlor_a_9km.nc", package = "ncmeta")
#' a <- nc_connection(f, verbose = TRUE)
#' RNetCDF::close.nc(a)
#' b <- nc_connection(f, engine = "ncdf4", verbose = TRUE)
#' ncdf4::nc_close(b)
#' 
#' ## set for session
#' options(ncmeta.engine = "ncdf4")
#' nc <- nc_connection(f, verbose = TRUE)
#' ncdf4::nc_close(nc)
#' 
#' ## argument overrides the option setting
#' nc <- nc_connection(f, engine = "RNetCDF", verbose = TRUE)
#' RNetCDF::close.nc(nc)
nc_connection <- function(x, engine = NULL, ..., verbose = FALSE) {
  UseMethod("nc_connection")
}
#' @export
nc_connection.character <- function(x, engine = NULL, ..., verbose = FALSE) {
  if (length(x) > 1) stop("no multiple sources, 'x' should be length == 1")
  if (!is.character(x) || is.na(x) || nchar(x) < 1) stop("NetCDF source cannot be invalid, missing, or empty string")
  if (is.null(engine)) {
    maybe_engine <- getOption("ncmeta.engine")
    if (!is.null(maybe_engine) && nchar(maybe_engine) > 0 && !is.na(maybe_engine)) {
      engine <- maybe_engine
    } else {
      engine <- "RNetCDF"
    }
  } else {
    if (nchar(engine) < 1 || is.na(engine)) {
      stop(sprintf("invalid 'engine' specification: '%s', must be the name of a known NetCDR provider (e.g. ncdf4, RNetCDF)", engine))
    }
  }
  if (verbose) print(sprintf("using engine: %s", engine))
  out <- switch(engine, 
         RNetCDF = RNetCDF::open.nc(x), 
         ncdf4 = ncdf4::nc_open(x, suppress_dimvals = TRUE)
    )
  if (is.null(out)) stop("interface '", engine, "' is not supported")
  invisible(out)
}

nc_cleanup <- function(x) {
  res <- switch(tail(class(x), 1), 
   RNetCDF = RNetCDF::close.nc(x), 
   ncdf4 = ncdf4::nc_close(x)
  )
  invisible(res)
}

