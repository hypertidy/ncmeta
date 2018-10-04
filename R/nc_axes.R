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
  nc <- nc_connection(x)
  on.exit(nc_cleanup(nc), add = TRUE)
  nc_axes(nc)
}

#'@name nc_axes
#'@export
#'@importFrom dplyr  row_number transmute 
#'@importFrom rlang .data
nc_axes.default <- function(x, variables = NULL, ...) {  ## CHECKME
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
    tibble::as_tibble(list(axis = seq_len(nrow(axes)), variable = axes[["name"]], dimension = axes[["dimids"]]))

}

## note this is a bit weird, but we have to ensure
## we work relative to all axes, so use the hidden function nc_axis_var
nc_axis_var <- function(x, i) {
 UseMethod("nc_axis_var") 
}
nc_axis_var.ncdf4 <- function(x, i) {
  
  dim_names <- names(x$dim)
  var_names <- names(x$var)
  is_dim <- i %in% dim_names
  if (is_dim) {
    dd <- x$dim[[i]]
    out1 <- tibble::tibble(id = dd$id, name = i, type = "PLACEHOLDER", ndims = 1, dimids = dd$id, natts = -1)
  } else {
    vv <- x$var[[i]]
    out1 <- tibble::tibble(id = vv$id$id, name = i, type = "PLACEHOLDER", ndims = vv$ndims, dimids = unlist(lapply(vv$dim, "[[", "id")), natts = vv$natts)
  }
  out1
}
# # A tibble: 1 x 6
#  id   name  type     ndims    dimids   natts
# <dbl> <chr> <chr>    <dbl>    <dbl>  <dbl>
#   0  time  NC_FLOAT     1      0     2
nc_axis_var.NetCDF <- function(x, i) {
  out <- RNetCDF::var.inq.nc(x, i)

  ## as_tibble expands each vector to the length of the longest one
  ## which is what we want here
  longest <- max(lengths(out))
  if (longest > 1L) out <- lapply(out, function(a) rep_len(a, length.out = longest))
  tibble::as_tibble(out)
}


