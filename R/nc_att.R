#' NetCDF attributes
#'
#' Variable attributes are number 0:(n-1). Global attributes are indexed 
#' by -1 or the label "NC_GLOBAL".
#' 
#' `nc_inq` includes the number of global attributes
#' `nc_vars` includes the number of variable attributes 
#' @param x or file handle
#' @param variable name or index (zero based) of variable
#' @param attribute name or index (zero based) of attribute
#' @param ... ignored
#'
#' @return data frame of attribute 
#' @export
#'
#' @examples
#' f <- system.file("extdata", "S2008001.L3m_DAY_CHL_chlor_a_9km.nc", package = "ncmeta")
#' nc_att(f, 0, 0)
#' @name nc_att
#' @export 
nc_att <- function(x, variable, attribute, ...) {
  UseMethod("nc_att")
}
#' @name nc_att
#' @export 
#' @importFrom rlang .data
nc_att.NetCDF <- function(x, variable, attribute, ...) {
 att <- RNetCDF::att.get.nc(x, variable, attribute)

 faster_as_tibble(list(attribute = attribute, variable = variable, value = list(att)))
# structure(list(attribute = attribute, variable = variable, value = list(boom = att)), class = "data.frame")
 
}

#' @name nc_att
#' @export 
#' @importFrom tibble tibble
nc_att.character <- function(x, variable, attribute, ...) {
  if (nchar(x) < 1) stop("NetCDF source cannot be empty string")
  
  nc <- RNetCDF::open.nc(x)
  on.exit(RNetCDF::close.nc(nc), add  = TRUE)
  nc_att(nc, variable, attribute)
}

#' NetCDF attributes
#'
#' All attributes in the file, globals are treated as if they belong to variable 'NC_GLOBAL'. 
#' @param x filename or handle
#' @param ... ignored
#'
#' @return data frame of attributes
#' @export
#'
#' @examples
#' f <- system.file("extdata", "S2008001.L3m_DAY_CHL_chlor_a_9km.nc", package = "ncmeta")
#' nc_atts(f)
nc_atts <- function(x, ...) {
 UseMethod("nc_atts") 
}
#' @name nc_atts
#' @export
#' @importFrom dplyr distinct
#' @importFrom tibble tibble
nc_atts.NetCDF <- function(x, ...) {
    global <- faster_as_tibble(list(id = -1, name = "NC_GLOBAL", type = "NA_character_", 
                   ndims = NA_real_, dimids = NA_real_, natts = nc_inq(x)$ngatts))
  
    #vars <- nc_axes(x)
    vars <- try(nc_vars(x), silent = TRUE)
    
  ## bomb out if ndims is NA
  if (inherits(vars, "try-error") || nrow(vars) < 1L) {
    warning("no variables recognizable")
    return(global)
  } else {
    #var <- dplyr::distinct(vars, .data$id, .data$name, .data$natts)
    var <- vars[, c("id", "name", "natts")]
    var <- var[!duplicated(var), ]
  }
  
  var <- dplyr::bind_rows(var, global)
  #bind_rows(lapply(split(var, var$name), function(v) bind_rows(lapply(seq_len(v$natts), function(iatt) nc_att(x, v$name, iatt - 1)))))
#bind_rows <- function(x) x
    dplyr::bind_rows(lapply(split_fast_tibble(var, var$name), 
                     function(v) dplyr::bind_rows(lapply(seq_len(v$natts), function(iatt) nc_att(x, v$name, iatt - 1)))))
}

#varfun <- function(v) dplyr::bind_rows(lapply(seq_len(v$natts), function(iatt) nc_att(x, v$name, iatt - 1))))

#' @name nc_atts
#' @export
nc_atts.character <- function(x, ...)  {
  if (nchar(x) < 1) stop("NetCDF source cannot be empty string")
  
  nc <- RNetCDF::open.nc(x)
  on.exit(RNetCDF::close.nc(nc), add  = TRUE)
  nc_atts(nc)
}


## TODO: these functions aren't being used? except by nc_meta itself
## there are some internal functions that are used in different places
## but not others ...
nc_att_internal <- function(x, variable_id, attribute_id, variable_name) {
  #attinfo <- att.inq.nc(x, variable_id, attribute_id)
  nameflag <- 0
  globflag <- if (variable_id < 0) 1 else 0

  # attinfo <- .Call("R_nc_inq_att", as.integer(x), as.integer(variable_id),
  #       as.character(""), as.integer(attribute_id), as.integer(nameflag),
  #       as.integer(globflag), PACKAGE = "RNetCDF")
  #
  attinfo <- RNetCDF::att.inq.nc(x, variable_id, attribute_id)
  attribute <- attinfo[["name"]]
  numflag <- if(attinfo[["type"]] == "NC_CHAR") 0 else 1

  # att <- .Call("R_nc_get_att", as.integer(x), as.integer(variable_id),
  #              attribute, as.integer(numflag), as.integer(globflag),
  #              PACKAGE = "RNetCDF")
  att <- RNetCDF::att.get.nc(x, variable_id, attribute_id)
  faster_as_tibble(list(attribute = attribute, variable = variable_name, value = att))
}


nc_atts_internal <- function(x, n_global_atts, variables = NULL, ...) {

global <- faster_as_tibble(list(id = -1, name = "NC_GLOBAL", type = "NA_character_",
                                  ndims = NA_real_, natts = n_global_atts,
                                dim_coord = FALSE))




  ## bomb out if ndims is NA
  if (is.null(variables) || nrow(variables) < 1L) {
    warning("no variables recognizable")
    return(global)
  }

 variables <- rbind(variables, global)

  iatt_vector <- unlist(lapply(variables[["natts"]], seq_len)) - 1

  var_names <- rep(variables[["name"]], variables[["natts"]])

  var_ids <- rep(variables[["id"]], variables[["natts"]])

  l <- vector('list', length(var_names))

  for (iatt in seq_along(var_names)) {
    l[[iatt]] <- nc_att_internal(x, var_ids[iatt], iatt_vector[iatt], var_names[iatt])
    l[[iatt]][["value"]] <- list(l[[iatt]][["value"]])
}


do.call(rbind, l)
}
