#' @keywords internal
"_PACKAGE"

## usethis namespace: start
## usethis namespace: end
NULL

#' ncmeta: straightforward NetCDF metadata
#'
#' `ncmeta` provides a consistent set of tools to obtain metadata from NetCDF. NetCDF
#' is 'Network Common Data Form' https://www.unidata.ucar.edu/software/netcdf/. 
#' These functions are generics, allowing methods to be written for various providers so that
#' everything can work from a common basis. All functions return a data frame.
#' 
#'  Each function responds to a character file name or data source (i.e. URL) or to a connection of a 
#'  given class, this is so a source connection may be created a minimal number of times and kept open
#'  while a number of entities are queried. 
#'  
#'   Each "given" entity may be referred to by index (0-based) or name, just as it would be by the NetCDF
#'   API and by the two R wrapper providers `RNetCDF` and `ncdf4`. 
#' \tabular{ll}{
#'  \code{\link{nc_att}} \tab find the given attribute of a given variable \cr
#'  \code{\link{nc_atts}} \tab find all attributes, of all variables and globals \cr
#'  \code{\link{nc_axes}} \tab find all the instances of dimensions \cr
#'  \code{\link{nc_axis}} \tab find given instance of a dimension (1-based)  \cr
#'  \code{\link{nc_dim}} \tab find the given dimension of a source (0-based) \cr
#'  \code{\link{nc_dims}} \tab find all the dimensions of a source \cr
#'  \code{\link{nc_grids}} \tab find the grids (sets of dimensions) of a source \cr
#'  \code{\link{nc_inq}} \tab inquire about a source (i.e. number of dimensions, number of variables, number of global attributes and presence of unlimited dimension \cr
#'  \code{\link{nc_meta}} \tab find all metadata for a source (runs all other functions) \cr
#'  \code{\link{nc_sources}} \tab tags a record of a source and its "access time" \cr
#'  \code{\link{nc_var}} \tab find a given variable (0-based) \cr
#'  \code{\link{nc_vars}} \tab find the variables of a source \cr
#' }
#' @name ncmeta-package
NULL
