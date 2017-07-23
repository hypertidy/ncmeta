context("file")

f <- system.file("extdata", "S2008001.L3m_DAY_CHL_chlor_a_9km.nc", package = "ncmeta")

inq_structure <- structure(c("double", "double", "double", "logical", "character"
), .Names = c("ndims", "nvars", "ngatts", "unlimdimid", "filename"
))

test_that("file inquiry works", {
  inq <- nc_inq(f) %>% expect_s3_class("tbl_df")
  expect_that(nrow(inq), equals(1L))
  expect_that(inq$ndims, equals(4L))
  expect_that(inq$nvars, equals(4L))
  expect_that(inq$ngatts, equals( 65L))
  expect_that(inq$unlimdimid, equals(NA))
  expect_that(unlist(lapply(inq, typeof)), 
              equals(inq_structure))
  
  })

test_that("multiple file inquiry works", {
  inqfiles <- nc_inq(c(f, f)) %>% expect_s3_class("tbl_df")
  expect_that(nrow(inqfiles), equals(2L))
  expect_that(unique(inqfiles$ndims), equals(4L))
  expect_that(unique(inqfiles$nvars), equals(4L))
  expect_that(unique(inqfiles$ngatts), equals( 65L))
  expect_that(unique(inqfiles$unlimdimid), equals(NA))
  expect_that(unlist(lapply(inqfiles, typeof)), 
              equals(inq_structure))
  
})

test_that("thredds access works", {
  u <- "https://upwell.pfeg.noaa.gov/erddap/tabledap/FRDCPSTrawlLHHaulCatch"
  thredds <- nc_inq(u) %>% expect_s3_class("tbl_df")
  expect_that(nrow(thredds), equals(1L))
  
})


test_that("no attributes vs. no variables", {
  skip_if_not(we_are_raady)
  afile <- "/rdsi/PRIVATE/raad/data/ftp.aviso.altimetry.fr/global/delayed-time/grids/madt/all-sat-merged/h/2009/dt_global_allsat_madt_h_20090104_20140106.nc"
  l3_file <- "/rdsi/PRIVATE/raad/data/oceandata.sci.gsfc.nasa.gov/MODISA/L3BIN/2002/184/A2002184.L3b_DAY_RRS.nc"
  
  expect_silent(ncmeta::nc_meta(afile))
#  expect_warning(nc_meta(l3_file), "Evaluation error")
})
