#' NetCDF axes
#' 
#' An `axis` is an instance of a dimension. 
#' 
#' Each data source has a set of dimensions available for use by variables. Each axis is
#' a 1-dimensional instance. 
#'
#' @param x NetCDF source
#' @param variables names of vars to query
#' @param ... ignored
#'
#'@name nc_axes
#'@export
nc_axes <- function(x, variables = NULL, ...) {
  UseMethod("nc_axes")
}
#'@name nc_axes
#'@export
nc_axes.character <- function(x, variables = NULL, ...) {
  if (nchar(x) < 1) stop("NetCDF source cannot be empty string")
  
  nc <- RNetCDF::open.nc(x)
  on.exit(RNetCDF::close.nc(nc), add  = TRUE)
  nc_axes(nc, variables = variables, ...)
}

#'@name nc_axes
#'@export
#'@importFrom dplyr  row_number transmute 
#'@importFrom rlang .data
nc_axes.NetCDF <- function(x, variables = NULL, ...) {
  if (is.null(variables)) {
    vars_to_query <- nc_vars(x)
    if (nrow(vars_to_query) < 1L) return(tibble())
    variables <- vars_to_query$name
  }
 axes <-   dplyr::bind_rows(
    lapply(variables, function(variable) {
      nc_axis_var(x, variable)
    })
  )

#  axes$id <- seq_len(nrow(axes)) ## row_number wtf

  #dplyr::transmute(axes, axis = row_number(), variable = .data$name, dimension = .data$dimids)
    tibble::as_tibble(list(axis = seq_len(nrow(axes)), variable = axes[["name"]], dimension = axes[["dimids"]]))

}

## note this is a bit weird, but we have to ensure
## we work relative to all axes, so use the hidden function nc_axis_var
nc_axis_var <- function(x, i) {
  out <- RNetCDF::var.inq.nc(x, i)
  #dimids <- out$dimids
  
  out[sapply(out, is.null)] <- NA
  
  ## as_tibble expands each vector to the length of the longest one
  ## which is what we want here
  longest <- max(lengths(out))
  if (longest > 1L) out <- lapply(out, function(a) rep_len(a, length.out = longest))
  out <- out[lengths(out) > 0]
  tibble::as_tibble(out)
}


