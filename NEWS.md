# nmeta dev

* align to RNetCDF 1.9-1

# ncmeta 0.0.1

* ncmeta now provides support for dimensions that do not have explicit coordinates: dimension and variable tables now have
 information about "dimvals", in the form of "dim_coord" and "coord_dim" i.e. if a variable is 1D and its name corresponds to
 a dimension name, then it is a rectlinear coordinate vector of that dimension. (The coordinates can be of type "char", and
 that must be dealt with down stream as it now is in tidync). 

* new function nc_grids, the spaces available to variables

* new function nc_axes, nc_axis for the instances of dimensions

* nc_vars now returns only variables

* First working version. 


