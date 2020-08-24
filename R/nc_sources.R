#' NetCDF sources
#' 
#' A record of file, URL, or any data source with NetCDF. 
#' @param x data source string
#'
#' @param ... ignored
#'
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
