#' NetCDF groups
#' 
#'  Groups in NetCDF behave much like a classic NetCDF source, but with multiple sources within
#'  a single source. 
#'  
#'  'ncdf4' and 'RNetCDF' have different approaches to groups, in the first the top level variable names
#'  are fully qualified group paths and in the latter the groups are obtained by recursively walking the
#'  tree of groups. Presumably it's all the same under the hood. 
#'  
#'  
#'
#' @param x NetCDF source
#' @param ... currently ignored
#'
#' @return data frame of groups
#' @export
#'
#' @examples
#' fng <- system.file("extdata", "S2008001.L3m_DAY_CHL_chlor_a_9km.nc", package = "ncmeta")
#' nc_groups(fng)  ## no group, or just one group ...
#' 
#' fg <- system.file("extdata/S2008001.L3b_DAY_CHL.nc", package= "ncmeta")
#' nc_groups(fg)
#' nc_inq(nc_connection(fg, engine = "ncdf4"), group = "/level-3_binned_data")
nc_groups <- function(x, ...) {
  UseMethod("nc_groups")
}

nc_groups.character <- function(x, ...) {
  nc <- nc_connection(x)
  on.exit(nc_cleanup(nc), add = TRUE)
  nc_groups(nc)
}

recurse_ptrs <- function(l, tag) {
  lapply(l, modify_ptr, name = tag)
}

modify_ptr <- function(ptr, name) {
  g <- RNetCDF::grp.inq.nc(ptr)
  if (length(g$grps) > 0) recurse_ptrs(g$grps, tag = paste(c(name, g$name), collapse = "/")) else paste(c(name, g$name), collapse = "/")
}

nc_groups.NetCDF <- function(x, ...) {
  if (packageVersion("RNetCDF") < "2.0.0") {
    warning(sprintf("no group support in RNetCDF < 2.0.0, installed version is %s", packageVersion("RNetCDF")))
    return(tibble::tibble(id = integer(), name = character()))
  }
  tibble::tibble(name = unlist(recurse_ptrs(RNetCDF::grp.inq.nc(x)$grps, "")))
}