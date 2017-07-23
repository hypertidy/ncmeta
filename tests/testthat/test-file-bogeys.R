context("file-bogeys")

test_that("files and bad files are handled", {
  skip_if_not(we_are_raady())
  oisst_dayfile <- raadfiles::oisst_daily_files()$fullname[1]
  nc_meta(oisst_dayfile)
  oisst_monfile <- raadfiles::oisst_monthly_files()$fullname[1]
  nc_meta(oisst_monfile)
  roms_file <- raadtools::cpolarfiles()$fullname[1]
  nc_meta(roms_file)
  
  l3_file <- raadtools::ocfiles()$fullname[1]  
  nc_meta(l3_file)
})


