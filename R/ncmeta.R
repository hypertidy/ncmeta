nc_meta <- function(x) {
  nc_vars(x)
  nc_dims(x)
  
}

nc_inq <- function(x) {
  #x <- op(x)
  #on.exit(RNetCDF::close.nc(x))
  tibble::as_tibble(RNetCDF::file.inq.nc(x))
}
nc_var <- function(x, i) {
  tibble::as_tibble(RNetCDF::var.inq.nc(x, i))
}
nc_vars <- function(file) {
  x <- op(file)
  on.exit(RNetCDF::close.nc(x))
  dplyr::bind_rows(lapply(seq_len(nc_inq(x)$nvars), function(i) nc_var(x, i-1)))
}

