context("nc utils")

test_that("get_var_by_att", {
  nc <- system.file("extdata/daymet_sample.nc", package = "ncmeta")

  expect_true(ncmeta:::find_var_by_att(nc, "coordinates") == "prcp")

  expect_true(length(ncmeta:::find_var_by_att(nc, "units")) == 4)

  expect_true(length(ncmeta:::find_var_by_att(
    nc, "long_name", "coordinate of projection", strict = FALSE)) == 2)

  expect_true(length(ncmeta:::find_var_by_att(
    nc, "long_name", "coordinate of projection", strict = TRUE)) == 0)

  expect_true(length(ncmeta:::find_var_by_att(
    nc, "units", "mm/day", strict = TRUE)) == 1)

  nc <- RNetCDF::open.nc(nc)

  expect_true(ncmeta:::find_var_by_att(nc, "coordinates") == "prcp")

  expect_true(ncmeta:::find_var_by_att(ncmeta::nc_atts(nc),
                         "coordinates") == "prcp")
})
