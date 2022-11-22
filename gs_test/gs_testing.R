library(ncmeta)
x <- system.file("extdata", "S2008001.L3m_DAY_CHL_chlor_a_9km.nc", package = "ncmeta")

nc_atts.NetCDF(x)
variable = c("lat")

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
      var <- dplyr::filter(var, .data$name %in% variable)
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
  # let's try to unlist variable values for given variables
  if(!is.null(variable)) {
    names <- unique(out$name)
    v <- tibble::tibble(variable)
    t <- dplyr::bind_rows(
      lapply(seq_along(variable), function(k)
        dplyr::bind_cols(
          lapply(seq_along(names), function(i) getv(a, names[i], variable[k])),
          .name_repair = ~ names
        )
      )
    )
    out <- cbind(v,t)
  }
  out
}
  