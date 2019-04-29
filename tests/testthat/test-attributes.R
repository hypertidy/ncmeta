context("attributes")
f <- system.file("extdata", "S2008001.L3m_DAY_CHL_chlor_a_9km.nc", package = "ncmeta")
u <- "https://upwell.pfeg.noaa.gov/erddap/tabledap/FRDCPSTrawlLHHaulCatch"

test_that("attributes works", {
  testthat::skip_on_cran()
  met <- nc_meta(f)
  da <- nc_atts(f) %>% expect_s3_class("tbl_df") %>% 
    expect_named(c("id", "name", "variable", "value")) 
  expect_that(nrow(da), equals(87L))
  expect_that(da$value, is_a("list"))
  
  da <- nc_atts(f, add_names = TRUE) %>% expect_s3_class("tbl_df") %>% 
    expect_named(c("id", "name", "variable", "value")) 
 })
test_that("attributes from Thredds works", {
  context("avoiding thredds tests for RNetCDF")
  skip_on_cran()
  skip_on_travis()
  
    du <- nc_atts(u) %>%  expect_s3_class("tbl_df") %>% 
    expect_named(c("id", "name", "variable", "value"))
  expect_that(nrow(du), equals(119L))
  expect_that(du$value, is_a("list"))
  
  })

test_that("individual attribute inquiry works", {
  testthat::skip_on_cran()
  
  nc_att(f, 0, 0) %>% expect_s3_class("tbl_df") %>% 
    expect_named(c("id", "name", "variable", "value")) 
  a3 <- nc_att(f, 0, 3)  
  expect_that(a3$id, equals(3.0))
  expect_that(a3$name, equals("_FillValue"))
  chk <- list(`_FillValue` = -32767)
  expect_that(a3$value, equals(chk))
  
  expect_identical(a3, nc_att(f, 0, "_FillValue"))
})

l3binfile <- system.file("extdata", "S2008001.L3b_DAY_CHL.nc", package = "ncmeta")

test_that("failure is graceful", {
  expect_warning(abin <- nc_atts(l3binfile), "no variables recognizable")
  
  abin %>%  expect_s3_class("tbl_df") %>% 
    expect_named(c("id", "name", "variable", "value")) 
  expect_that(nrow(abin), equals(49L))
  expect_that(abin$variable, equals(rep("NC_GLOBAL",49L)))
  expect_that(abin$name, equals(c("product_name", "title", "instrument", "platform", "temporal_range", 
                                  "start_orbit_number", "end_orbit_number", "date_created", "processing_version", 
                                  "history", "time_coverage_start", "time_coverage_end", "northernmost_latitude", 
                                  "southernmost_latitude", "easternmost_longitude", "westernmost_longitude", 
                                  "geospatial_lat_max", "geospatial_lat_min", "geospatial_lon_max", 
                                  "geospatial_lon_min", "geospatial_lat_units", "geospatial_lon_units", 
                                  "geospatial_lon_resolution", "geospatial_lat_resolution", "spatialResolution", 
                                  "data_bins", "percent_data_bins", "units", "binning_scheme", 
                                  "project", "institution", "standard_name_vocabulary", "Metadata_Conventions", 
                                  "Conventions", "naming_authority", "id", "license", "creator_name", 
                                  "publisher_name", "creator_email", "publisher_email", "creator_url", 
                                  "publisher_url", "processing_level", "cdm_data_type", "identifier_product_doi_authority", 
                                  "identifier_product_doi", "keywords", "keywords_vocabulary")))
  expect_that(unique(abin$id), equals(-1))

})

