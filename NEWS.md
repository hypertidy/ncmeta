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


