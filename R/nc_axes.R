#' NetCDF axes
#' 
#' An `axis` is an instance of a dimension. 
#' 
#' Each data source has a set of dimensions available for use by variables. Each axis is
#' a 1-dimensional instance. 
#'
#' @param x NetCDF source
#'
#'@name nc_axes
#'@export
nc_axes <- function(x) {
  UseMethod("nc_axes")
}
#'@name nc_axes
#'@export
nc_axes.character <- function(x) {
  nc <- RNetCDF::open.nc(x)
  on.exit(RNetCDF::close.nc(nc), add  = TRUE)
  nc_axes(nc)
}

#'@name nc_axes
#'@export
#'@importFrom dplyr  row_number transmute 
#'@importFrom rlang .data
nc_axes.NetCDF <- function(x) {
  vars_to_query <- nc_vars(x)
  if (nrow(vars_to_query) < 1L) return(tibble())
  axes <-   dplyr::bind_rows(
    lapply(vars_to_query$name, function(variable) {
      nc_axis_var(x, variable)
    })
  ) 
#  axes$id <- seq_len(nrow(axes)) ## row_number wtf
  axes %>% dplyr::transmute(axis = row_number(), variable = .data$name, dimension = .data$dimids)
  
}

## note this is a bit weird, but we have to ensure
## we work relative to all axes, so use the hidden function nc_axis_var
nc_axis_var <- function(x, i) {
  as_tibble(RNetCDF::var.inq.nc(x, i))
}


