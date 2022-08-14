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
  if (nchar(x) < 1) stop("NetCDF source cannot be empty string")
  
  nc <- RNetCDF::open.nc(x)
  on.exit(RNetCDF::close.nc(nc), add  = TRUE)
  nc_var(nc, i)
}

#'@name nc_var
#'@export
nc_var.NetCDF <- function(x, i) {
  out <- RNetCDF::var.inq.nc(x, i)
  # Convert dimids to empty vector when variable is scalar:
  if (anyNA(out$dimids)) {
    out$dimids <- integer(0)
  }
  # Store vector values as nested lists:
  vectors <- c("dimids", "chunksizes", "filter_id", "filter_params")
  listcols <- vectors[vectors %in% names(out)]
  out[listcols] <- lapply(out[listcols], list)
  # Keep only list items with length 1:
  out <- out[lengths(out) == 1]
  # Transform list to tibble row:
  tibble::as_tibble_row(out)
}

