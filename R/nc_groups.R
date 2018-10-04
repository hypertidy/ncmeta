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