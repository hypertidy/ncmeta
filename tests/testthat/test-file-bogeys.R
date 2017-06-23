context("file-bogeys")

test_that("files and bad files are handled", {
  skip_if_not(we_are_raady())
  oisst_dayfile <- raadtools::sstfiles()$fullname[1]
  nc_meta(oisst_dayfile)
  oisst_monfile <- raadtools::sstfiles(time.resolution = "monthly")$fullname[1]
  nc_meta(oisst_monfile)
  roms_file <- raadtools::cpolarfiles()$fullname[1]
  nc_meta(roms_file)
  
  l3_file <- raadtools::ocfiles()$fullname[1]  
  nc_meta(l3_file)
})


