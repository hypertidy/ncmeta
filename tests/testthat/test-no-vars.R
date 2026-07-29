f <- system.file("extdata", "dims_only.nc", package = "ncmeta", mustWork = TRUE)

test_that("nc_meta works on a source with zero variables", {
  ## regression: 0.4.0 errored in distinct() on a zero-column table
  ## (sources like NASA L3 bin files report nvars == 0 through the
  ## classic inquiry)
  meta <- expect_warning(nc_meta(f), "no variables recognizable")
  expect_s3_class(meta, "ncmeta")
  expect_null(meta$variable)
  expect_identical(meta$dimension$name, c("x", "y"))
  expect_identical(meta$dimension$length, c(4, 3))
  expect_false(any(meta$dimension$coord_dim))
  expect_identical(nrow(meta$grid), 0L)
  expect_identical(nrow(meta$axis), 0L)
})

test_that("sibling accessors work on a source with zero variables", {
  vars <- nc_vars(f)
  expect_s3_class(vars, "tbl_df")
  expect_identical(nrow(vars), 0L)
  expect_named(vars, c("id", "name", "type", "ndims", "natts"))
  
  axes <- nc_axes(f)
  expect_s3_class(axes, "tbl_df")
  expect_identical(nrow(axes), 0L)
  
  atts <- expect_warning(nc_atts(f), "no variables recognizable")
  expect_s3_class(atts, "tbl_df")
  expect_true("title" %in% atts$name)
  expect_true(all(atts$variable == "NC_GLOBAL"))
  
  dims <- nc_dims(f)
  expect_identical(nrow(dims), 2L)
  
  ## nc_grids() reached split() on a zero-row axes table in 0.4.0
  grids <- nc_grids(f)
  expect_s3_class(grids, "tbl_df")
  expect_identical(nrow(grids), 0L)
  expect_named(grids, c("grid", "ndims", "variables", "nvars"))
})