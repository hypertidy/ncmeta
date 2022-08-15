# ncmeta 0.3.5

* Changed default branch name to "main", so please check if you have a fork and submit PRs. 

* Fix bug where Scalar variables were treated as an axis. Picked up in stars PR #399. 

# ncmeta 0.3.0

* Fix file path mangling introduced in #27. 

# ncmeta 0.2.5 

* Improved equivalence test thanks to Romain Francois #37. 

# ncmeta 0.2.0

* Simplified error handling when file not able to be opened. https://github.com/ropensci/tidync/issues/98

* Fixed bug in nc_atts() https://github.com/hypertidy/ncmeta/issues/36. 

# ncmeta 0.1.0

* Extra checks and fixes to align with stars, and a future release of RNetCDF. 

* Condition on version of tidyr for new `nest()` syntax > 0.8.3. 

* The output of `nc_atts()` is now more consistent, with the same structure given for 
 only global attributes, or a mix of variable attributes and global attributes. If 
 there are no attributes at all the output has zero rows, but now has the correct 
 column types. 


# ncmeta 0.0.4

* `nc_grids()` now normal form, with nested variables so we can easily link grids to variables. 

* New functions `nc_coord_var` to find coordinate variables (if any), 
 `gm_to_prj` to determine PROJ string in use, and `nc_grid_mapping_atts` to 
  determine grid mapping parameters; #19, #14, #12, #9. 

# ncmeta 0.0.3

* Fix for grid organization providing variables out of native order. 

* Added 'variable' argument to 'nc_atts', per #8. 

# ncmeta 0.0.2

* added some extra checks for bad source strings, particularly the empty string
 to prevent crashing (this happens with `system.file()` where the file does not
 exist)
* fix attribute types problem

# ncmeta 0.0.1

*updates from CRAN feedback

* ncmeta now provides support for dimensions that do not have explicit 
 coordinates: dimension and variable tables now have information about 
 "dimvals", in the form of "dim_coord" and "coord_dim" i.e. if a variable 
 is 1D and its name corresponds to a dimension name, then it is a rectlinear 
 coordinate vector of that dimension. (The coordinates can be of type "char", 
 and that must be dealt with down stream as it now is in tidync).

* new function nc_grids, the spaces available to variables

* new function nc_axes, nc_axis for the instances of dimensions

* nc_vars now returns only variables

* First working version. 


