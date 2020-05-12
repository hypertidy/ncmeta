sysname <- tolower(Sys.info()[["sysname"]])
if (!"sunos" %in% sysname) {
  library(testthat)
  library(ncmeta)
  #skip_on_os("solaris")
  test_check("ncmeta")
}