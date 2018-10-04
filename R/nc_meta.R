#' Top level NetCDF metadata. 
#' 
#' This function exists to maintain the open connection
#' while all dimension, variable, and attribute metadata is extracted. 
#'
#' This function is pretty ambitious, and will send nearly any string
#' to the underlying NetCDF library other than "", which immediately 
#' generates an error. This should be robust, but might present fairly 
#' obscure error messages from the underlying library. 
#' @param ... ignored
#' @param x data source address, file name or handle
#' @param group specify the name of a group to treat as source
#'
#' @export
#' @examples 
#' f <- system.file("extdata", "S2008001.L3m_DAY_CHL_chlor_a_9km.nc", package = "ncmeta")
#' nc_meta(f)
#' \donttest{
#' \dontrun{
#' u <- "https://upwell.pfeg.noaa.gov/erddap/tabledap/FRDCPSTrawlLHHaulCatch"
#' nc_meta(u)
#' }}
nc_meta <- function(x, ..., group = NULL) {
  if (missing(x)) stop("'x' must be a valid NetCDF source, filename or URL")
 UseMethod("nc_meta")   
}

nc_meta.default <- function(x, ..., group = NULL) {
  inq <- nc_inq(x)
  dims <- nc_dims_internal(x, inq[["ndims"]])
  
  vars <- nc_vars_internal(x, inq$nvars)
  if (nrow(vars) > 1) axis <- nc_axes(x, vars$name) else axis <- nc_axes(x)
  ## does a dimension have dim-vals?
  if (nrow(dims) > 0) dims[["coord_dim"]] <- dims[["name"]] %in% vars[["name"]]
  ## is a variable a dim-val?
  
  if (nrow(vars) > 0) {
    vars[["dim_coord"]] <- vars[["ndims"]] == 1L & vars[["name"]] %in% dims[["name"]]
  } else {
    vars <- NULL ## avoid passing along a 0-row data frame
  }
  
  structure(list(dimension = dims, 
                 variable = vars, 
                 attribute = nc_atts_internal(x, inq$ngatts, vars), 
                 axis = axis,
                 grid = nc_grids_dimvar(dims, vars, axis)),
            class = "ncmeta")
}
#' @name nc_meta
#' @export
nc_meta.NetCDF <- function(x, ..., group = NULL) {
  if (!is.null(group)) stop("group not supported with RNetCDF")
  nc_meta.default(x, ..., group = NULL)
}
#' @name nc_meta
#' @export
nc_meta.ncdf4 <- function(x, ..., group = NULL) {
 nc_meta.default(x, ..., group = group)  
}
#' @name nc_meta
#' @export
nc_meta.character <- function(x, ..., group = NULL) {
  if (nchar(x) < 1) stop("NetCDF source cannot be empty string")

  nc <- try(RNetCDF::open.nc(x), silent = TRUE)
  if (inherits(nc, "try-error")) {
    stop(sprintf("failed to open 'x', value given was: \"%s\"", x))
  } else {
    fileinfo <- try(file.inq.nc(nc))
    if (inherits(fileinfo, "try-error")) stop("error on file.inq.nc")
    if (fileinfo$ndims + fileinfo$nvars < 0) {
      ## let's try ncdf4
      nc <- try(ncdf4::nc_open(x, suppress_dimvals = TRUE))
      if (inherits(nc, "try-error")) stop("error on open with ncdf4")
      on.exit(ncdf4::nc_close(nc), add  = TRUE)
    }
    on.exit(RNetCDF::close.nc(nc), add  = TRUE)
  }
  out <- nc_meta(nc)
  out$source <- nc_sources(x)
  out
}