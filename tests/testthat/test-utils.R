context("nc utils")

test_that("get_var_by_att", {
  nc <- system.file("extdata/daymet_sample.nc", package = "ncmeta")

  expect(ncmeta:::find_var_by_att(nc, "coordinates") == "prcp")

  expect(length(ncmeta:::find_var_by_att(nc, "units")) == 4)

  expect(length(ncmeta:::find_var_by_att(
    nc, "long_name", "coordinate of projection", strict = FALSE)) == 2)

  expect(length(ncmeta:::find_var_by_att(
    nc, "long_name", "coordinate of projection", strict = TRUE)) == 0)

  expect(length(ncmeta:::find_var_by_att(
    nc, "units", "mm/day", strict = TRUE)) == 1)

  nc <- RNetCDF::open.nc(nc)

  expect(ncmeta:::find_var_by_att(nc, "coordinates") == "prcp")

  expect(ncmeta:::find_var_by_att(ncmeta::nc_atts(nc),
                         "coordinates") == "prcp")
})
