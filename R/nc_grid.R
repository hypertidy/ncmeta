#' @name nc_grids
#' @export
nc_grids <- function(x, ...) UseMethod("nc_grids")

#' @name nc_grids
#' @export
nc_grids.character <- function(x, ...) {
  nc_grids_dimvar(nc_dims(x), nc_vars(x), nc_axes(x))
}

#' @name nc_grids
#' @export
#' @importFrom dplyr %>% arrange group_by
#' @importFrom tibble tibble
nc_grids.NetCDF <- function(x, ...) {
  nc_grids_dimvar(nc_dims(x), nc_vars(x), nc_axes(x))
}


# nc_vars(f)  ## should be distinct
# nc_axes(f)  ## all of them 
# nc_axes(f, var) ## just these ones
# nc_axis(i)  ## just one, of all ??


nc_grids_dimvar <- function(dimension, variable, axes) {
  if (nrow(variable) < 1 & nrow(dimension) < 1) return(tibble::tibble())
  shape_instances_byvar <- axes %>% 
   # dplyr::group_by(variable) %>% 
    split(.$variable) %>% purrr::map(function(xa) xa$dimension)
  shape_classify_byvar <- factor(unlist(lapply(shape_instances_byvar, 
                                               function(xb) paste(paste0("D", xb), collapse = ","))))
  out <- tibble::tibble(variable  = names(shape_classify_byvar), 
                shape = levels(shape_classify_byvar)[shape_classify_byvar]) %>% 
    dplyr::arrange(desc(nchar(shape)), shape, variable)
  ## catch the NA shapes (the scalars) and set to "-"
  out$shape[is.na(out$shape) | out$shape == "DNA"] <- "S"
  out  %>% dplyr::rename(grid = shape)
}

