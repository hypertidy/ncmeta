# Changelog

## ncmeta 0.4.0

CRAN release: 2024-03-25

- New function
  [`nc_extended()`](https://hypertidy.github.io/ncmeta/reference/nc_extended.md)
  to enerate a table of extended dimension attributes, supporting ‘time’
  currently (contributed by Patrick Van Laake).

## ncmeta 0.3.6

CRAN release: 2023-11-01

- Fixed namespace doc thanks to CRAN.

## ncmeta 0.3.5

CRAN release: 2022-10-26

- Removed LazyData, unused.

- Extra info now provided by RNetCDF was causing non-nested data frame
  problems, fixed by PR from [@mjwoods](https://github.com/mjwoods) in
  [\#44](https://github.com/hypertidy/ncmeta/issues/44) and
  [\#45](https://github.com/hypertidy/ncmeta/issues/45).

- Changed default branch name to “main”, so please check if you have a
  fork and submit PRs.

- Fix bug where Scalar variables were treated as an axis. Picked up in
  stars PR [\#399](https://github.com/hypertidy/ncmeta/issues/399).

## ncmeta 0.3.0

CRAN release: 2020-08-27

- Fix file path mangling introduced in
  [\#27](https://github.com/hypertidy/ncmeta/issues/27).

## ncmeta 0.2.5

CRAN release: 2020-05-12

- Improved equivalence test thanks to Romain Francois
  [\#37](https://github.com/hypertidy/ncmeta/issues/37).

## ncmeta 0.2.0

CRAN release: 2019-10-22

- Simplified error handling when file not able to be opened.
  <https://github.com/ropensci/tidync/issues/98>

- Fixed bug in nc_atts()
  <https://github.com/hypertidy/ncmeta/issues/36>.

## ncmeta 0.1.0

CRAN release: 2019-08-28

- Extra checks and fixes to align with stars, and a future release of
  RNetCDF.

- Condition on version of tidyr for new `nest()` syntax \> 0.8.3.

- The output of
  [`nc_atts()`](https://hypertidy.github.io/ncmeta/reference/nc_atts.md)
  is now more consistent, with the same structure given for only global
  attributes, or a mix of variable attributes and global attributes. If
  there are no attributes at all the output has zero rows, but now has
  the correct column types.

## ncmeta 0.0.4

CRAN release: 2019-04-19

- [`nc_grids()`](https://hypertidy.github.io/ncmeta/reference/nc_grids.md)
  now normal form, with nested variables so we can easily link grids to
  variables.

- New functions `nc_coord_var` to find coordinate variables (if any),
  `gm_to_prj` to determine PROJ string in use, and
  `nc_grid_mapping_atts` to determine grid mapping parameters;
  [\#19](https://github.com/hypertidy/ncmeta/issues/19),
  [\#14](https://github.com/hypertidy/ncmeta/issues/14),
  [\#12](https://github.com/hypertidy/ncmeta/issues/12),
  [\#9](https://github.com/hypertidy/ncmeta/issues/9).

## ncmeta 0.0.3

CRAN release: 2018-10-26

- Fix for grid organization providing variables out of native order.

- Added ‘variable’ argument to ‘nc_atts’, per
  [\#8](https://github.com/hypertidy/ncmeta/issues/8).

## ncmeta 0.0.2

CRAN release: 2018-02-13

- added some extra checks for bad source strings, particularly the empty
  string to prevent crashing (this happens with
  [`system.file()`](https://rdrr.io/r/base/system.file.html) where the
  file does not exist)
- fix attribute types problem

## ncmeta 0.0.1

CRAN release: 2017-12-01

\*updates from CRAN feedback

- ncmeta now provides support for dimensions that do not have explicit
  coordinates: dimension and variable tables now have information about
  “dimvals”, in the form of “dim_coord” and “coord_dim” i.e. if a
  variable is 1D and its name corresponds to a dimension name, then it
  is a rectlinear coordinate vector of that dimension. (The coordinates
  can be of type “char”, and that must be dealt with down stream as it
  now is in tidync).

- new function nc_grids, the spaces available to variables

- new function nc_axes, nc_axis for the instances of dimensions

- nc_vars now returns only variables

- First working version.
