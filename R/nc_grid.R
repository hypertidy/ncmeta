#' @name nc_grids
#' @export
nc_grids <- function(x, ...) UseMethod("nc_grids")

#' @name nc_grids
#' @export
nc_grids.character <- function(x, ...) {
  nc_grids(nc_meta(x))
}

#' @name nc_grids
#' @export
#' @importFrom dplyr %>% arrange group_by
#' @importFrom tibble tibble
nc_grids.NetCDF <- function(x, ...) {
  nc_grids(nc_meta(x))
}


# nc_vars(f)  ## should be distinct
# nc_axes(f)  ## all of them 
# nc_axes(f, var) ## just these ones
# nc_axis(i)  ## just one, of all ??

#' @name nc_grids
#' @export
nc_grids.ncmeta <- function(x) {
  if (nrow(x$variable) < 1 & nrow(x$dimension) < 1) return(tibble::tibble())
  shape_instances_byvar <- x$axes %>% 
   # dplyr::group_by(variable) %>% 
    split(.$variable) %>% purrr::map(function(xa) xa$dimension)
  shape_classify_byvar <- factor(unlist(lapply(shape_instances_byvar, 
                                               function(xb) paste(paste0("D", xb), collapse = ","))))
  out <- tibble::tibble(variable  = names(shape_classify_byvar), 
                shape = levels(shape_classify_byvar)[shape_classify_byvar]) %>% 
    dplyr::arrange(desc(nchar(shape)), shape, variable)
  ## catch the NA shapes (the scalars) and set to "-"
  out$shape[is.na(out$shape) | out$shape == "DNA"] <- "S"
  out 
  out$grid <- out$shape
  out$shape <- NULL
  out
}

