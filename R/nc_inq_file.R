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
nc_inq <- function(x, ...) {
  UseMethod("nc_inq")
}
#' @name nc_inq
#' @export
#' @importFrom RNetCDF file.inq.nc
#' @importFrom tibble as_tibble
nc_inq.NetCDF <- function(x, ...) {
    faster_as_tibble(RNetCDF::file.inq.nc(x)) 
}
#' @name nc_inq
#' @export
#' @importFrom dplyr bind_rows
nc_inq.character <- function(x, ...) {
 ifun <- function(x) { 
   if (nchar(x) < 1) stop("NetCDF source cannot be empty string")
   
    nc <- RNetCDF::open.nc(x)
    on.exit(RNetCDF::close.nc(nc), add  = TRUE)
    nc_inq(nc)
 }
 out <- dplyr::bind_rows( lapply(x, ifun), .id = "filename")
 out$filename <- x[as.integer(out$filename)]
 out[, c("ndims", "nvars", "ngatts", "unlimdimid", "filename")]
 }


