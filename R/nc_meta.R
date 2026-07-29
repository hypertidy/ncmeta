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
#'
#' @return a list of data frames, with class 'ncmeta', named 'dimension', 'variable'
#' (NULL if the source has no variables), 'attribute', 'extended', 'axis', 'grid',
#' 'source'
#' @export
#' @examples 
#' f <- system.file("extdata", "S2008001.L3m_DAY_CHL_chlor_a_9km.nc", package = "ncmeta")
#' nc_meta(f)
#' \dontrun{
#' ## remote server, not run in checks
#' u <- "https://upwell.pfeg.noaa.gov/erddap/tabledap/FRDCPSTrawlLHHaulCatch"
#' nc_meta(u)
#' }
nc_meta <- function(x, ...) {
  if (missing(x)) stop("'x' must be a valid NetCDF source, filename or URL")
 UseMethod("nc_meta")   
}

#' @name nc_meta
#' @export
nc_meta.NetCDF <- function(x, ...) {
  inq <- nc_inq(x)
  dims <- nc_dims_internal(x, inq$ndims)
  if (inq$nvars > 0) {
    vars <- nc_vars_internal(x, inq$nvars)
  } else {
    vars <- empty_vars_table()
  }
  if (nrow(vars) > 1) axis <- nc_axes(x, vars$name) else axis <- nc_axes(x)

  ## does a dimension have dim-vals?
  if (nrow(dims) > 0) dims$coord_dim <- dims$name %in% vars$name

  ## is a variable a dim-val?
  if (nrow(vars) > 0) {
    vars$dim_coord <- vars$ndims == 1L & vars$name %in% dims$name
  } else {
    vars <- NULL ## avoid passing along a 0-row data frame
  }
  
  atts <- nc_atts(x)
  grids <- nc_grids_dimvar(dims, vars, axis)
  flags <- bounds_flags(atts, dims, vars, axis, grids)

  structure(list(dimension = flags$dimension, 
       variable = flags$variable, 
       attribute = atts, 
       extended = nc_extended(x, ...),
       axis = axis,
       grid = flags$grid),
       class = "ncmeta")
}

## CF cell boundaries: a variable named by a "bounds" (or "climatology")
## attribute of a coordinate variable is part of that coordinate variable
## metadata, not independent data (CF conventions section 7.1), see
## https://github.com/hypertidy/ncmeta/issues/48
## We flag rather than remove: everything in the file stays reported, and
## downstream tools can choose to demote bounds content. Dimensions used
## only by bounds variables (the "bnds"/"nv" vertex dimension) are flagged
## via bnds_dim, without catching e.g. staggered-grid dimensions that carry
## real data variables.
bounds_flags <- function(atts, dims, vars, axis, grids) {
  targets <- character(0)
  if (!is.null(atts) && nrow(atts) > 0) {
    b <- atts[atts$name %in% c("bounds", "climatology") & atts$variable != "NC_GLOBAL", ]
    targets <- unique(unlist(lapply(b$value, as.character)))
  }
  if (!is.null(vars) && nrow(vars) > 0) {
    vars$bnds <- vars$name %in% targets
    coord_vars <- vars$name[vars$dim_coord]
  } else {
    coord_vars <- character(0)
  }
  if (!is.null(dims) && nrow(dims) > 0) {
    dims$bnds_dim <- vapply(dims$id, function(d) {
      users <- unique(axis$variable[axis$dimension == d])
      data_users <- setdiff(users, coord_vars)
      length(data_users) > 0 && all(data_users %in% targets)
    }, logical(1))
  }
  if (!is.null(grids)) {
    grids$bnds <- vapply(grids$variables, function(v) {
      nrow(v) > 0 && all(v$variable %in% targets)
    }, logical(1))
  }
  list(dimension = dims, variable = vars, grid = grids)
}

#' @name nc_meta
#' @export
nc_meta.character <- function(x, ...) {
  if (nchar(x) < 1) stop("NetCDF source cannot be empty string")

  nc <- RNetCDF::open.nc(x)
  on.exit(RNetCDF::close.nc(nc), add  = TRUE)
  out <- nc_meta(nc)
  out$source <- nc_sources(x)
  out
}