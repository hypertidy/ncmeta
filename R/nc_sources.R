#' NetCDF sources
#' 
#' A record of file, URL, or any data source with NetCDF. 
#' @param x data source string
#'
#' @param ... ignored
#'
#' @return data frame with columns 'access' (time of access), 'source' (the source string)
#' @examples
#' f <- system.file("extdata", "S2008001.L3m_DAY_CHL_chlor_a_9km.nc", package = "ncmeta")
#' nc_sources(f)
#' @name nc_sources
#' @export
nc_sources <- function(x, ...) {
  UseMethod("nc_sources")
}
#' @name nc_sources
#' @export
nc_sources.character <- function(x, ...) {
  if (file.exists(x)) {
    path <- normalizePath(x, winslash = "/")
  } else {
    path <- x
  }
  tibble(access = Sys.time(), source = path)
}
