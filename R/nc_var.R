#' NetCDF variable
#' 
#' Return a data frame about the variable at index `i`. 
#' @param x file name or handle
#' @param i variable index (zero based)
#' @name nc_var
#' @return data frame of variable information
#' @seealso `nc_vars` to obtain information about all variables, `nc_inq` for an 
#' overview of the file
#' @export
nc_var <- function(x, i) {
  UseMethod("nc_var")
}
#'@name nc_var
#'@export
nc_var.character <- function(x, i) {
  nc <- RNetCDF::open.nc(x)
  on.exit(RNetCDF::close.nc(nc), add  = TRUE)
  nc_var(nc, i)
}

#'@name nc_var
#'@export
nc_var.NetCDF <- function(x, i) {
  as_tibble(RNetCDF::var.inq.nc(x, i))
}


#'@name nc_axes
#'@export
nc_axes <- function(x, i) {
  UseMethod("nc_axes")
}
#'@name nc_axes
#'@export
nc_axes.character <- function(x, i = NULL) {
  nc <- RNetCDF::open.nc(x)
  on.exit(RNetCDF::close.nc(nc), add  = TRUE)
  nc_axes(nc, i)
}

#'@name nc_axes
#'@export
nc_axes.NetCDF <- function(x, i = NULL) {
   axes <-   dplyr::bind_rows(
    lapply(nc_vars(x)$name, function(variable) {
     nc_axis_var(x, variable)
    })
    ) 
   axes %>% dplyr::transmute(id = row_number(), variable = name, dimension = dimids)
   
}

nc_axis_var <- function(x, i) {
  as_tibble(RNetCDF::var.inq.nc(x, i))
}
