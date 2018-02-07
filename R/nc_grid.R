#' NetCDF grids
#' 
#' A `grid` is a discretized space, defined by a set of dimensions. These are the spaces used 
#' by one or more variables in a source. Traditional summaries are organized by variable, but 
#' when organized by space or grid we can treat multiple variables together using standard
#' database techniques. 
#' 
#' Each data source has a set of dimensions available for use by variables. Each grid is
#' an n-dimensional space available for use by 0, 1 or more variables. A grid only really
#' exists if  variable is defined for it, and 'grid' is an implicit entity not an explicit
#' part of the NetCDF API definition. The Unidata pages refer to "shape", which is more or less what
#' we mean by "grid". 
#' @name nc_grids
#' @export
nc_grids <- function(x, ...) UseMethod("nc_grids")

#' @param x NetCDF source
#'
#' @param ... ignored
#'
#' @name nc_grids
#' @export
nc_grids.character <- function(x, ...) {
  nc <- RNetCDF::open.nc(x)
  on.exit(RNetCDF::close.nc(nc), add  = TRUE)
  nc_grids_dimvar(nc_dims(nc), nc_vars(nc), nc_axes(nc))
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


#' @importFrom dplyr desc arrange
#' @importFrom rlang .data
nc_grids_dimvar <- function(dimension, variable, axes) {
  
  if (is.null(variable) || (nrow(variable) < 1 & nrow(dimension) < 1)) return(tibble::tibble())
  shape_instances_byvar <- split(axes$dimension, axes$variable)
#    axes %>% 
 #   split_fast_tibble(.$variable) %>% purrr::map(function(xa) xa$dimension)
  shape_classify_byvar <- factor(unlist(lapply(shape_instances_byvar, 
                                               function(xb) paste(paste0("D", xb), collapse = ","))))
  out <- faster_as_tibble(list(variable  = names(shape_classify_byvar), 
                grid = levels(shape_classify_byvar)[shape_classify_byvar]))
  out <-   dplyr::arrange(out, dplyr::desc(nchar(.data$grid)), .data$grid, variable)
  ## catch the NA shapes (the scalars) and set to "-"
  out[["grid"]][is.na(out[["grid"]]) | out[["grid"]] == "DNA"] <- "S"
  out  
}

