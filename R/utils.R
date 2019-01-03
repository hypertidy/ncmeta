## https://gist.github.com/mdsumner/c086a5005c59373f4965fa6afd0d5a7c#gistcomment-2132051
# fast_tibble <- function(x) {
#   stopifnot(length(unique(unlist(lapply(x, length)))) == 1L)
#   structure(x, class = c("tbl_df", "tbl", "data.frame"), row.names = as.character(seq_along(x[[1]])))
# }
# use with caution!  this will cause problems if a ragged list is given ...
faster_as_tibble <- function(x) {
  ## stopifnot(length(unique(lengths(x))) == 1L)
  
  structure(x, class = c("tbl_df", "tbl", "data.frame"), row.names = as.integer(seq_along(x[[1]])))
}

split_fast_tibble <- function (x, f, drop = FALSE, ...) 
  lapply(split(x = seq_len(nrow(x)), f = f,  ...), 
         function(ind) faster_as_tibble(lapply(x, "[", ind)))

we_are_raady <- function() {
  fp <- getOption("default.datadir")
  #print(fp)
  stat <- FALSE
  if (!is.null(fp) && file.exists(file.path(fp, "data"))) stat <- TRUE
  stat
}

# This is a silly little function, but it can be useful.
#' Find NetCDF Variable by attribute
#' @description Given an attribute name and potentially a value,
#' searches for and returns variables with the desired attribute.
#'
#' @param x open NetCDF object, or character file path or url to be opened with 
#' RNetCDF::open.nc
#' @param attribute character the attribute name to search for variables with
#' @param value character defaults to any only return variables that have the
#' attribute with the given value
#' @param strict boolean if TRUE, only exact matches of value will be returned
#'
#' @importFrom RNetCDF open.nc close.nc
#' @noRd
#'
#' @examples
#' nc <- system.file("extdata/metdata.nc", package = "intersectr")
#'
#' find_var_by_att(nc, "coordinates")
#'
#' find_var_by_att(nc, "units")
#'
#' find_var_by_att(nc, "units", "degrees", strict = FALSE)
#'
#' find_var_by_att(nc, "units", "degrees", strict = TRUE)
#'
#' find_var_by_att(nc, "units", "degrees_east", strict = TRUE)
#'
find_var_by_att <- function(x, attribute, value = ".*", strict = TRUE) {
  
  open_nc <- FALSE
  if (is.character(x)) {
    x <- open.nc(x)
    open_nc <- TRUE
  }
  
  if (inherits(x, "NetCDF")) {
    atts <- nc_atts(x)
  } else if (inherits(x, "data.frame")) {
    atts <- x
  }
  
  if (strict) value <- paste0("^", value, "$")
  
  atts <- atts[atts$name == attribute, ]
  atts <- atts[grepl(value, atts$value), ]
  
  if (open_nc) close.nc(x)
  
  return(atts$variable)
}
