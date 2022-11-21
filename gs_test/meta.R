library(ncmeta)
f <- system.file("extdata", "S2008001.L3m_DAY_CHL_chlor_a_9km.nc", package = "ncmeta")
# f <- "../ropensci_tidync/gs_test/ftp.cdc.noaa.gov/Datasets/noaa.oisst.v2/sst.wkmean.1990-present.nc"
# nc_inq(f) # one-row summary of file
#
# nc_dim(f, 1)  ## first dimension
# nc_dims(f)  ## all dimensions
# nc_vars(f)

aa <- function(b) {
  b <- unlist(unlist(b, FALSE))
  b <- paste(toString(b))
  return(b)
}

nc_atts(f) |>
  dplyr::rowwise() |>
  dplyr::mutate(vv = aa(value)) |>
  subset(select = c("name", "variable", "vv")) |>
  dplyr::group_by(variable) |>
  tidyr::pivot_wider(names_from = "name", values_from = "vv") |>
  dplyr::ungroup() |>
  subset(select = c(1:3, 6:7))


