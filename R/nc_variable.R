
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
  if (nchar(x) < 1) stop("NetCDF source cannot be empty string")
  
  nc <- RNetCDF::open.nc(x)
  on.exit(RNetCDF::close.nc(nc), add  = TRUE)
  nc_vars(nc)
}
#' @name nc_vars
#' @export
#' @importFrom dplyr %>% 
#' @importFrom rlang .data
nc_vars.NetCDF <- function(x, ...) {
  nvars <- nc_inq(x)$nvars
  if (nvars  < 1) return(empty_vars_table())
  nc_vars_internal(x, nvars)
}
## type-stable zero-row analogue of nc_vars_internal() output, so that
## consumers (e.g. dims$name %in% vars$name) work without warnings when
## a source has no classic-model variables
empty_vars_table <- function() {
  tibble::tibble(id = integer(), name = character(), type = character(),
                 ndims = integer(), natts = integer())
}
nc_vars_internal <- function(x, nvars) {
  dplyr::bind_rows(lapply(seq_len(nvars), function(i) nc_var(x, i-1))) %>% 
    dplyr::distinct(.data$id, .data$name, .data$type, .data$ndims, .data$natts)
  
}