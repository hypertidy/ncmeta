
#' NetCDF variables
#'
#' Generate a table of all variables. 
#' @param x filename or handle
#' @param ... ignored currently
#'
#' @return data frame of variable information
#' @export
#'
nc_vars <- function(x, ...)  {
  UseMethod("nc_vars")
}
#' @name nc_vars
#' @export
nc_vars.character <- function(x, ...) {
  nc <- RNetCDF::open.nc(x)
  on.exit(RNetCDF::close.nc(nc), add  = TRUE)
  nc_vars(nc)
}
#' @name nc_vars
#' @export
#' @importFrom dplyr %>% 
#' @importFrom rlang .data
nc_vars.NetCDF <- function(x, ...) {
  vars <- nc_inq(x)$nvars
  if (vars  < 1) return(tibble::tibble())
  dplyr::bind_rows(lapply(seq_len(vars), function(i) nc_var(x, i-1))) %>% 
    dplyr::distinct(.data$id, .data$name, .data$type, .data$ndims, .data$natts)
  
}
