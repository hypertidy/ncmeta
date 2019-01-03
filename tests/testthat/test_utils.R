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

test_that("nc_grid_mapping", {

  nc <- system.file("extdata/S2008001.L3m_DAY_CHL_chlor_a_9km.nc", package = "ncmeta")
  expect_warning(gm <- nc_grid_mapping(nc),
                 paste("No variables with a grid mapping found.\n",
                       "Defaulting to WGS84 Lon/Lat"))
  expect_equal(gm, list(grid_mapping_name = "latitude_longitude",
                        semi_major_axis = 6378137,
                        inverse_flattening = 298.257223563,
                        longitude_of_prime_meridian = 0))

  nc <- system.file("extdata/daymet_sample.nc", package = "ncmeta")
  gm <- nc_grid_mapping(nc)

  expect(all(list(grid_mapping_name = "lambert_conformal_conic",
                  longitude_of_central_meridian = -100,
                  latitude_of_projection_origin = 42.5,
                  false_easting = 0,
                  false_northing = 0,
                  standard_parallel = c(25, 60),
                  semi_major_axis = 6378137,
                  inverse_flattening = 298.257223563,
                  longitude_of_prime_meridian = 0) %in% gm))

  expect_is(nc_grid_mapping(ncmeta::nc_atts(nc)), "list")

  expect_is(nc_grid_mapping(RNetCDF::open.nc(nc)), "list")
})
