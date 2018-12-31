context("nc_coords")

f <- system.file("extdata", "S2008001.L3m_DAY_CHL_chlor_a_9km.nc", package = "ncmeta")

nc <- RNetCDF::open.nc(f)

coord_vars <- nc_coords(f)

test_that("nc_coords brings back expected content for sample", {
  expect_equal(coord_vars, data.frame(variable = "chlor_a", 
                                      X = "lon", Y = "lat", 
                                      Z = NA_character_, T = NA_character_, 
                                      stringsAsFactors = FALSE))
})
  
f <- system.file("extdata", "guam.nc", package = "ncmeta")

nc <- RNetCDF::open.nc(f)

coord_vars <- nc_coords(f)

test_that("nc_coords brings back expected content for sample", {
  expect(nrow(coord_vars) == 4)
  
  expect(all(coord_vars$X == "XLONG"))
  expect(all(coord_vars$Y == "XLAT"))
  expect(all(is.na(coord_vars$Z)))
  expect(all(coord_vars$T == "Time"))
})
