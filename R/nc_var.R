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
  nc <- nc_connection(x)
  on.exit(nc_cleanup(nc), add = TRUE)
  nc_var(nc, i)
}

#'@name nc_var
#'@export
nc_var.NetCDF <- function(x, i) { # i is 0-based
  out <- RNetCDF::var.inq.nc(x, i)
  out$dimids <- NULL
  tibble::as_tibble(out)
}

#'@name nc_var
#'@export
nc_var.ncdf4 <- function(x, i) {  # i is 0-based
  dims <- unlist(lapply(x$dim, function(a) a$dimvarid$isdimvar))
  names <- c(names(x$dim)[dims], names(x$var))
  idx <- c(which(dims), seq_along(x$var) + sum(dims))
  ndims <- c(rep(1, sum(dims)), unlist(lapply(x$var, "[[", "ndims")))
  tibble::tibble(id = i, name = names[i + 1], type = "PLACEHOLDER", ndims = ndims[i + 1])  
}

