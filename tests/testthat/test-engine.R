context("test-engine")

groupsfile <- system.file("extdata/unidata/test_hgroups.nc", package = "ncmeta")
sfile <- system.file("extdata/S2008001.L3m_DAY_CHL_chlor_a_9km.nc", package = "ncmeta")
test_that("engine choice works", {
  nc4 <- nc_connection(groupsfile, engine = "ncdf4") %>% expect_s3_class("ncdf4")
  ncdf4::nc_close(nc4)
  rnc <- nc_connection(groupsfile, engine = "RNetCDF") %>% expect_s3_class("NetCDF")
  RNetCDF::close.nc(rnc)
  
  options(ncmeta.engine = "ncdf4")
  nc4 <- nc_connection(groupsfile) %>% expect_s3_class("ncdf4")
  ncdf4::nc_close(nc4)
  options(ncmeta.engine = "RNetCDF")
  nc <- nc_connection(groupsfile) %>% expect_s3_class("NetCDF")
  ncdf4::nc_close(nc)
  ## ensure manual override of options works
  options(ncmeta.engine = "RNetCDF")
  nc4 <- nc_connection(groupsfile, engine = "ncdf4") %>% expect_s3_class("ncdf4")
  
  
})



test_that("file open works", {
  rnc <- nc_connection(sfile, engine = "RNetCDF")  %>% expect_s3_class("NetCDF")
  nc_cleanup(rnc) %>% expect_null()
  nnc <- nc_connection(sfile, engine = "ncdf4")  %>% expect_s3_class("ncdf4")
  nc_cleanup(nnc) %>% expect_is("list")
}
)