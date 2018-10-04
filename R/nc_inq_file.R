# nc_meta <- function(x) {
#   nc_vars(x)
#   nc_dims(x)
#   
# }

#' File info
#'
#' Get information about a NetCDF data source, may be a file path, or a `RNetCDF` 
#' file handle, or an OpenDAP/Thredds server address. 
#' @param x filename or handle
#' @param ... ignored
#'
#' @export 
#' @examples 
#' \donttest{
#' \dontrun{
#'  f <- raadfiles:::cmip5_files()$fullname[1]
#'  nc_inq(f)
#'  nc_var(f, 0)
#'  nc_dim(f, 0)
#'  }
#' }
#' f <- system.file("extdata", "S2008001.L3m_DAY_CHL_chlor_a_9km.nc", package = "ncmeta")
#' nc_inq(f)
#' nc_var(f, 0)
#' nc_dim(f, 0)
#' 
#' nc_vars(f)
#' nc_dims(f)
#' \donttest{
#' \dontrun{
#' ## thredds (see rerddap)
#' u <- "https://upwell.pfeg.noaa.gov/erddap/tabledap/FRDCPSTrawlLHHaulCatch"
#' nc_inq(u)
#' # A tibble: 1 x 5
#' #ndims nvars ngatts unlimdimid
#' #<dbl> <dbl>  <dbl>      <lgl>
#' #  1     2    18     37         NA
#' # ... with 1 more variables: filename <chr>
#' }}
nc_inq <- function(x, ..., group = NULL) {
  UseMethod("nc_inq")
}
#' @name nc_inq
#' @export
#' @importFrom RNetCDF file.inq.nc
#' @importFrom tibble as_tibble
nc_inq.NetCDF <- function(x, ..., group = NULL) {
    out <- tibble::as_tibble(RNetCDF::file.inq.nc(x)) 
    out$ngroups <- NA
    out
}
#' @name nc_inq
#' @export
nc_inq.ncdf4 <- function(x, ..., group = NULL) {
   if (is_group_multi(x) && is.null(group)) {
     group <- first_valid_group(x)
     groupnames <- unlist(lapply(x$groups, "[[", "name"))
     groupnumber <- match(group, groupnames)
     message(sprintf("no group specified, using %s", group))
   } else {
     groupnumber <- 1
   }
 # if (is.null(group)) group <- 2
  out <- tibble::as_tibble(x$groups[[groupnumber]][c("ndims", "nvars")]) 
  ## ncdf4 stores ngatts and unlimdimid differently, do we need to have it here
  atts <- ncdf4::ncatt_get(x, 0)
  out$ngatts <- length(atts)
  out$unlimdimid <- ifelse(x$unlimdimid < 0, NA,  x$unlimdimid)
  out$ngroups <- length(groupnames)  ## FIXME: should this be subtract 1?
  out
}
first_valid_group <- function(x) {
  stopifnot(inherits(x, "ncdf4"))
  x$groups[[2]]$name
}
is_group_multi <- function(x) {
  stopifnot(inherits(x, "ncdf4"))
  x$groups[[1]]$name == "" && 
    x$groups[[1]]$ndims == 0 &&
    x$groups[[1]]$nvars == 0
}

is_group_multi_RNetCDF <- function(x) {
  inherits(x, "NetCDF") &&
  nrow(nc_dims(x)) == 0 && nrow(nc_vars(x)) == 0
}

#' @name nc_inq
#' @export
#' @importFrom dplyr bind_rows
nc_inq.character <- function(x, ..., group = NULL) {
  if (nchar(x) < 1) stop("NetCDF source cannot be empty string")
  nc <- nc_connection(x)
  if (is_group_multi_RNetCDF(nc)) {
    nc <- nc_connection(x, preference = "ncdf4")
  }
  out <- nc_inq(nc, group = group)
  out$filename <- x

  out[, c("ndims", "nvars", "ngatts", "unlimdimid", "ngroups", "filename")]
 }


