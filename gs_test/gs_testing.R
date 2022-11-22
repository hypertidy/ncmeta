library(ncmeta)
# x <- system.file("extdata", "S2008001.L3m_DAY_CHL_chlor_a_9km.nc", package = "ncmeta")
# nc_atts(x)
# nc_atts(x, variable = c("lat", "chlor_a"))
# nc_atts(x, variable = c("lat", "chlor_a"), values = TRUE)
# 
# x <- "../../ropensci_tidync/gs_test/ftp.cdc.noaa.gov/Datasets/noaa.oisst.v2/sst.wkmean.1990-present.nc"
x <- "/home/sapi/projekty/ropensci_tidync/gs_test/ftp.cdc.noaa.gov/Datasets/noaa.oisst.v2/sst.wkmean.1990-present.nc"
# x <- system.file("extdata", "S2008001.L3m_DAY_CHL_chlor_a_9km.nc", package = "ncmeta")
nc_att(x, "lat", 2, values = TRUE)


variable = c("lat", "lon")
attribute = 2

nc <- RNetCDF::open.nc(x)
att_info <- RNetCDF::att.inq.nc(nc, variable[1], attribute[1])
att_info
## att <- structure(RNetCDF::att.get.nc(x, variable, attribute), names = att_info$name)
att <- RNetCDF::att.get.nc(nc, variable[1], attribute[1])
att
out <- tibble::as_tibble(list(id = att_info$id, name = att_info$name, variable = variable[1], 
                       value = setNames(list(att), att_info$name)))
out$value <- ncmeta:::.get_value_of_name(out, out$name, out$variable)

out
  a <- unlist(vars$value[vars$name == name & vars$variable == var])


a$value
x <- system.file("extdata", "S2008001.L3m_DAY_CHL_chlor_a_9km.nc", package = "ncmeta")
x <- "../../ropensci_tidync/gs_test/ftp.cdc.noaa.gov/Datasets/noaa.oisst.v2/sst.wkmean.1990-present.nc"
# nc_atts.NetCDF(x, variable = c("lat", "chlor_a"), values = TRUE)
out <- nc_att(x, variable = c("chlor_a"), attribute = c("long_name"), values = FALSE)
variable = c("lat", "lon", "chlor_a")

names <- unique(out$name)
v <- tibble::tibble(variable)
t <- dplyr::bind_rows(
  lapply(seq_along(variable), function(k)
    dplyr::bind_cols(
      lapply(seq_along(names), function(i) .get_value_of_name(out, names[i], variable[k])),
      .name_repair = ~ names
    )
  )
)
out <- cbind(v,t)


ncmeta:::.get_value_of_name(out, names[1], variable[2])


.get_value_of_name(b, "actual_range", "lat")
vars <- b
name <- "actual_range"
var <- "lat"
.get_value_of_name <- function(vars, name, var) {
  a <- unlist(vars$value[vars$name == name & vars$variable == var])
  if(is.null(a)) {
    a <- NA
  }
  if(length(a)>1) {
    a <- paste(toString(a))
  }
  return(a)
}


nc_atts(x, )

variable = c("lat")
values = TRUE
values == TRUE

nc_atts.NetCDF <- function(x, variable = NULL, values = TRUE, ...) {
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
    
    # let's try to unlist variable values for given variables
    if(!is.null(variable) && isTRUE(values)) {
      names <- unique(out$name)
      v <- tibble::tibble(variable)
      t <- dplyr::bind_rows(
        lapply(seq_along(variable), function(k)
          dplyr::bind_cols(
            lapply(seq_along(names), function(i) ncmeta:::.get_value_of_name(out, names[i], variable[k])),
            .name_repair = ~ names
          )
        )
      )
      out <- cbind(v,t)
    }
    
  } else {
    out <- tibble::tibble(id = double(0), name = character(0), variable = character(0), value = list())
  }
  out
}
  