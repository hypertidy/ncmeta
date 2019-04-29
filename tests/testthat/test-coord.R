context("nc_coord_var")

f <- system.file("extdata", "S2008001.L3m_DAY_CHL_chlor_a_9km.nc", package = "ncmeta")

nc <- RNetCDF::open.nc(f)

test_that("nc_coord_var brings back expected content for one variable", {
  expect_equal(nc_coord_var(f, "chlor_a"), 
               data.frame(variable = "chlor_a", X = "lon", Y = "lat", 
                          Z = NA_character_, T = NA_character_,
                          bounds = NA_character_, 
                          stringsAsFactors = FALSE))
  
  expect_equal(nc_coord_var(f, "pallete"), 
               NULL)  
  
  expect_equal(nc_coord_var(f, "lat")$Y, 
               "lat")
})

test_that("nc_coord_vars brings back expected content for sample", {
  
  coord_vars <- nc_coord_var(f)
  
  expect_equal(dplyr::filter(coord_vars, variable == "chlor_a"),
               data.frame(variable = "chlor_a", 
                          X = "lon", Y = "lat", 
                          Z = NA_character_, T = NA_character_, 
                          bounds = NA_character_, 
                          stringsAsFactors = FALSE))
})
  
f <- system.file("extdata", "guam.nc", package = "ncmeta")

nc <- RNetCDF::open.nc(f)

test_that("nc_coord_var brings back expected content for one variable", {
  expect_equal(nc_coord_var(f, "RAINNC_present"), 
               data.frame(variable = "RAINNC_present", X = "XLONG", Y = "XLAT", 
                          Z = NA_character_, T = "Time",
                          bounds = NA_character_, stringsAsFactors = FALSE))
  
  expect_equal(nc_coord_var(f, "XLAT"), 
               NULL)  
  
  expect_equal(nc_coord_var(f, "Time")$T, 
               "Time")
})

test_that("nc_coord_vars brings back expected content for sample", {
  
  coord_vars <- nc_coord_var(f)
  
  expect_true(nrow(coord_vars) == 5)
  
  coord_vars <- coord_vars[coord_vars$variable != "Time", ]
  
  expect_true(nrow(coord_vars) == 4)
  
  expect_true(all(coord_vars$X == "XLONG"))
  expect_true(all(coord_vars$Y == "XLAT"))
  expect_true(all(is.na(coord_vars$Z)))
  expect_true(all(coord_vars$T == "Time"))
})



test_that("slightly broken projected coordinates work", {

  f <- system.file("extdata", "daymet_sample.nc", package = "ncmeta")
  
  expect_warning(coord_vars <- nc_coord_var(f), 
                 "missing coordinate variables names in coordinates attribute trying to find non-auxiliary coordinate variables.")
  
  expect_equal(as.character(coord_vars[coord_vars$variable == "prcp", ]),
               c("prcp", "x", "y", NA, "time", NA))
  
  expect_true(nrow(coord_vars) == 4)
  
  expect_equal(as.character(coord_vars[coord_vars$variable == "time", ]), 
               c("time", NA, NA, NA, "time", "time_bnds"))
  
})

test_that("degen z", {
  f <- system.file("extdata/avhrr-only-v2.19810901_header.nc", package = "ncmeta")
  
  coord_vars <- nc_coord_var(f)

  expect_true(all(is.na(coord_vars$Z)))
})

test_that("timeseries", {
  f <- system.file("extdata/rasterwise-timeseries.nc", package = "ncmeta")
  
  coord_vars <- nc_coord_var(f)
  
  expect_equal(as.character(coord_vars[coord_vars$variable == "pr",]), 
               c("pr", "lon", "lat", NA, "time", NA))
  expect_true(nrow(coord_vars) == 2)
})

test_that("high dim", {
  f <- system.file("extdata/rasterwise-high-dim-test-1.nc", package = "ncmeta")
  
  coord_vars <- nc_coord_var(f)
  
  expect_true(nrow(coord_vars) == 0)
})

test_that("all the things", {
  f <- system.file("extdata/rasterwise-bad_examples_62-example3.nc", package = "ncmeta")
  
  coord_vars <- nc_coord_var(f)
  
  expect_true(sum(coord_vars$variable == "pr") == 2)
  
})

