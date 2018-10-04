context("file")

f <- system.file("extdata", "S2008001.L3m_DAY_CHL_chlor_a_9km.nc", package = "ncmeta")

#inq_structure <- structure(c("integer", "integer", "integer", "integer", "character"
#), .Names = c("ndims", "nvars", "ngatts", "unlimdimid", "filename"
#))

test_that("file open works", {
  rnc <- nc_connection(f, preference = "RNetCDF")  %>% expect_s3_class("NetCDF")
  nc_cleanup(rnc) %>% expect_null()
  nnc <- nc_connection(f, preference = "ncdf4")  %>% expect_s3_class("ncdf4")
  nc_cleanup(nnc) %>% expect_is("list")
}
)
test_that("file inquiry works", {
  inq <- nc_inq(f) %>% expect_s3_class("tbl_df")
  expect_that(nrow(inq), equals(1L))
  expect_that(inq$ndims, equals(4L))
  expect_that(inq$nvars, equals(4L))
  expect_that(inq$ngatts, equals( 65L))
  expect_true(is.na(inq$unlimdimid))
 # expect_that(unlist(lapply(inq, typeof)), 
#              equals(inq_structure))
  
  })

test_that("multiple file inquiry fails", {
  expect_error(nc_inq(c(f, f)) , "no multiple sources")
  
  
})

test_that("thredds access works", {
  skip_on_cran()
  
  u <- "https://upwell.pfeg.noaa.gov/erddap/tabledap/FRDCPSTrawlLHHaulCatch"
  thredds <- nc_inq(u) %>% expect_s3_class("tbl_df")
  expect_that(nrow(thredds), equals(1L))
  
})



