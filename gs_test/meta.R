library(ncmeta)
f <- system.file("extdata", "S2008001.L3m_DAY_CHL_chlor_a_9km.nc", package = "ncmeta")
f <- "../../ropensci_tidync/gs_test/ftp.cdc.noaa.gov/Datasets/noaa.oisst.v2/sst.wkmean.1990-present.nc"
# nc_inq(f) # one-row summary of file
#
# nc_dim(f, 1)  ## first dimension
# nc_dims(f)  ## all dimensions
# nc_vars(f)

vars <- c("lat", "chlor_a")
a <- nc_atts(f) |>
  subset(variable %in% vars)
names <- unique(a$name)

v <- tibble::tibble(vars)
v
t <- dplyr::bind_rows(
  lapply(seq_along(vars), function(k)
    dplyr::bind_cols(
      lapply(seq_along(names), function(i) getv(a, names[i], vars[k])),
      .name_repair = ~ names
    )
  )
)
v <- cbind(v,t)
v
k <- 10

getv <- function(vars, name, var) {
  a <- unlist(vars$value[vars$name == name & vars$variable == var])
  if(is.null(a)) {
    a <- NA
  }
  a
}

getv(a, "long_name", "chlor_a")

       dplyr::bind_cols(vars)

nc_vars_internal <- function(x, nvars) {
  dplyr::bind_rows(lapply(seq_len(nvars), function(i) nc_var(x, i-1))) %>% 
    dplyr::distinct(.data$id, .data$name, .data$type, .data$ndims, .data$natts)
  
}

names
unlist(a$value[a$name == names[3]])

aa <- function(b) {
  b <- unlist(unlist(b, FALSE))
  b <- paste(toString(b))
  return(b)
}
# suppressWarnings(
nc_atts(f, "lat") |>
  dplyr::rowwise() |>
  dplyr::mutate(vv = aa(value)) |>
  subset(select = c("name", "variable", "vv")) |>
  dplyr::group_by(variable) |>
  tidyr::pivot_wider(names_from = "name", values_from = "vv") |>
  dplyr::ungroup()

# )

?dplyr::mutate_if(4:6, as.numeric)
