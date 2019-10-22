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
#' @return data frame of attribute with numeric id, character attribute name,
#' character or numeric variable id or name depending on input, and attribute value. 
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
#' @importFrom stats setNames
nc_att.NetCDF <- function(x, variable, attribute, ...) {
  att_info <- RNetCDF::att.inq.nc(x, variable, attribute)
  
## att <- structure(RNetCDF::att.get.nc(x, variable, attribute), names = att_info$name)
 att <- RNetCDF::att.get.nc(x, variable, attribute)
  tibble::as_tibble(list(id = att_info$id, name = att_info$name, variable = variable, 
                         value = setNames(list(att), att_info$name)))

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
#' All attributes in the file, globals are treated as if they belong to variable 'NC_GLOBAL'. Attributes 
#' for a single variable may be returned by specifying 'variable' - 'NC_GLOBAL' can stand in to return
#' only those attributes. 
#' @param x filename or handle
#' @param variable  optional single name of a variable, or 'NC_GLOBAL'
#' @param ... ignored
#'
#' @return data frame of attributes
#' @export
#'
#' @examples
#' f <- system.file("extdata", "S2008001.L3m_DAY_CHL_chlor_a_9km.nc", package = "ncmeta")
#' nc_atts(f)
nc_atts <- function(x, variable = NULL, ...) {
 UseMethod("nc_atts") 
}

#' @name nc_atts
#' @export
#' @importFrom dplyr distinct
#' @importFrom tibble tibble
nc_atts.NetCDF <- function(x, variable = NULL,  ...) {
    global <- tibble::as_tibble(list(id = -1, name = "NC_GLOBAL", 
                    natts = nc_inq(x)$ngatts))
  
    #vars <- nc_axes(x)
    vars <- try(nc_vars(x), silent = TRUE)
    
  ## bomb out if ndims is NA
  if (inherits(vars, "try-error") || nrow(vars) < 1L) {
    warning("no variables recognizable")
    atts <- lapply(seq_len(global$natts), function(a) nc_att(x, "NC_GLOBAL", a - 1))
    if (length(atts) > 0) {
      value <- unlist(lapply(atts, function(b) b$value), recursive = FALSE)
      name <- unlist(lapply(atts, function(b) b$name))
    } else {
      value <- list()
      name <- character(0)
    }
    global <- tibble::tibble(id = -1, name = name, variable = "NC_GLOBAL", value = value)
    return(global)
  } else {
    #var <- dplyr::distinct(vars, .data$id, .data$name, .data$natts)
    var <- vars[, c("id", "name", "natts")]
    var <- var[!duplicated(var), ]

    var <- dplyr::bind_rows(var, global)  
    if (!is.null(variable)) {
      var <- dplyr::filter(var, .data$name == variable[1])
    } 
  }
    if (!is.null(variable) && !variable %in% var$name) stop("specified variable not found")
  #bind_rows(lapply(split(var, var$name), function(v) bind_rows(lapply(seq_len(v$natts), function(iatt) nc_att(x, v$name, iatt - 1)))))
#bind_rows <- function(x) x

  if (any(var$natts > 0)) {
   out <-  dplyr::bind_rows(lapply(split(var, var$name)[unique(var$name)], 
                     function(v) dplyr::bind_rows(lapply(seq_len(v$natts), function(iatt) nc_att(x, v$name, iatt - 1)))))
   } else {
     out <- tibble::tibble(id = double(0), name = character(0), variable = character(0), value = list())
   }
   out
}

#varfun <- function(v) dplyr::bind_rows(lapply(seq_len(v$natts), function(iatt) nc_att(x, v$name, iatt - 1))))

#' @name nc_atts
#' @export
nc_atts.character <- function(x, variable = NULL, ...)  {
  if (nchar(x) < 1) stop("NetCDF source cannot be empty string")
  
  nc <- RNetCDF::open.nc(x)
  on.exit(RNetCDF::close.nc(nc), add  = TRUE)
  nc_atts(nc, variable = variable)
}


