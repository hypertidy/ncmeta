# nc_meta <- function(x) {
#   nc_vars(x)
#   nc_dims(x)
#   
# }

#' File info
#'
#' Get information about a NetCDF data source, may be a file path, or a `RNetCDF` 
#' file handle, or an Thredds server address. 
#'
#' @param x filename or handle
#' @param ... ignored
#' @param groups recurse into groups, `FALSE` by default
#'
#' @export 
#' @examples 
#' #f <- raadfiles:::cmip5_files()$fullname[1]
#' #nc_inq(f)
#' #nc_var(f, 0)
#' #nc_dim(f, 0)
#' f <- system.file("extdata", "S2008001.L3m_DAY_CHL_chlor_a_9km.nc", package = "ncmeta")
#' nc_inq(f)
#' nc_var(f, 0)
#' nc_dim(f, 0)
#' 
#' nc_vars(f)
#' nc_dims(f)
#' ## thredds (see rerddap)
#' #u <- "https://upwell.pfeg.noaa.gov/erddap/tabledap/FRDCPSTrawlLHHaulCatch"
#' #nc_inq(u)
#' # A tibble: 1 x 5
#' #ndims nvars ngatts unlimdimid
#' #<dbl> <dbl>  <dbl>      <lgl>
#' #  1     2    18     37         NA
#' # ... with 1 more variables: filename <chr>
nc_inq <- function(x, groups = FALSE, ...) {
  UseMethod("nc_inq")
}
#' @name nc_inq
#' @export
#' @importFrom RNetCDF file.inq.nc
#' @importFrom tibble as_tibble
nc_inq.NetCDF <- function(x, groups  = FALSE, ...) {
  group_summary <- RNetCDF::grp.inq.nc(x)
  out <- faster_as_tibble(RNetCDF::file.inq.nc(x))  %>% dplyr::mutate(group = group_summary$name)
  ## WIP: yikes, hopefully groups can't have groups ...
  if (groups & length(group_summary$grps) > 0) {
   group2 <- lapply(group_summary$grps, RNetCDF::grp.inq.nc)
   names2 <- unlist(lapply(group2, "[[", "name"))
   out2 <- dplyr::bind_rows(lapply(group_summary$grps, function(y) faster_as_tibble(RNetCDF::file.inq.nc(y)))) %>% dplyr::mutate(group = names2)
   out <- dplyr::bind_rows(out, out2)
  }
  out
}
#' @name nc_inq
#' @export
#' @importFrom dplyr bind_rows
nc_inq.character <- function(x, groups  = FALSE, ...) {
 ifun <- function(x, groups) { 
    nc <- RNetCDF::open.nc(x)
    on.exit(RNetCDF::close.nc(nc), add  = TRUE)
    nc_inq(nc, groups = groups)
 }
 out <- dplyr::bind_rows( lapply(x, ifun, groups = groups), .id = "source")
 out$source <- x[as.integer(out$source)]
 out[, c("ndims", "nvars", "ngatts", "unlimdimid",  "group", "format", "source")]
 }
# #' @importFrom RNetCDF close.nc open.nc
# #' @importFrom dplyr mutate
# nc_inq0 <- function(x) {
#   nc <- RNetCDF::open.nc(x)
#   on.exit(RNetCDF::close.nc(nc), add  = TRUE)
#   dplyr::mutate(nc_inq(nc), filename = x)
# }


