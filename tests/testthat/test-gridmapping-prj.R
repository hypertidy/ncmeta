context("prj and grid mappings")

test_that("nc_grid_mapping_atts", {
  
  nc <- system.file("extdata/S2008001.L3m_DAY_CHL_chlor_a_9km.nc", package = "ncmeta")
  expect_warning(gm <- nc_grid_mapping_atts(nc),
                 paste("No variables with a grid mapping found.\n",
                       "Defaulting to WGS84 Lon/Lat"))
  expect_equal(stats::setNames(gm$value, gm$name), list(grid_mapping_name = "latitude_longitude",
                        semi_major_axis = 6378137,
                        inverse_flattening = 298.257223563,
                        longitude_of_prime_meridian = 0))
  
  nc <- system.file("extdata/daymet_sample.nc", package = "ncmeta")
  gm <- nc_grid_mapping_atts(nc)
  
  expect_true(all(list(grid_mapping_name = "lambert_conformal_conic",
                  longitude_of_central_meridian = -100,
                  latitude_of_projection_origin = 42.5,
                  false_easting = 0,
                  false_northing = 0,
                  standard_parallel = c(25, 60),
                  semi_major_axis = 6378137,
                  inverse_flattening = 298.257223563,
                  longitude_of_prime_meridian = 0) %in% stats::setNames(gm$value, gm$name)))
  
  expect_is(nc_grid_mapping_atts(ncmeta::nc_atts(nc)), "data.frame")
  
  expect_is(nc_grid_mapping_atts(RNetCDF::open.nc(nc)), "data.frame")
  
  gm2 <- nc_grid_mapping_atts(nc, data_variable = "prcp")
  
  expect_equal(nrow(gm), nrow(gm2))
  
  expect_warning(nc_grid_mapping_atts(nc, data_variable = "borked"),
                 "no grid_mapping attribute found for this variable")
})

test_that("nc_prj_to_gridmapping returns an empty list if no mapping exists", {
  p <- ""

  expect_warning(crs <- nc_prj_to_gridmapping(p), 
                 "not a valid crs, returning an empty tibble")

  expect_equal(names(crs), c("name", "value"))
  expect_equal(nrow(crs), 0)
})

test_that("wgs 84 lat lon", {
  p <- "+proj=longlat +a=6378137 +f=0.00335281066474748 +pm=0 +no_defs"

  c <- list(grid_mapping_name="latitude_longitude",
              longitude_of_prime_meridian = 0,
              semi_major_axis = 6378137,
              inverse_flattening = 298.257223563)

  prj <- nc_gm_to_prj(c)

  expect_equal(prj, p)

  prj <- nc_gm_to_prj(c)

  expect_equal(prj, p)

  crs <- nc_prj_to_gridmapping(p)

  crs <- stats::setNames(crs$value, crs$name)
  
  expect_equal(crs, c[names(crs)])
})

test_that("NAD27 lat lon", {
  p <- "+proj=longlat +datum=NAD27 +no_defs"
  
  p2 <- "+proj=longlat +a=6378206.4 +f=0.00339007530392762 +pm=0 +no_defs"
  
  c <- list(grid_mapping_name="latitude_longitude",
            longitude_of_prime_meridian = 0,
            semi_major_axis = 6378206.4,
            inverse_flattening = 294.978698214)
  
  prj <- nc_gm_to_prj(c)
  
  expect_equal(prj, p2)
  
  crs <- nc_prj_to_gridmapping(p)
  
  crs <- stats::setNames(crs$value, crs$name)
  
  expect_equal(crs, c[names(crs)])
})

test_that("albers equal area epsg:5070", {
  p <- "+proj=aea +lat_1=29.5 +lat_2=45.5 +x_0=0 +y_0=0 +units=m +lat_0=23 +lon_0=-96 +a=6378137 +f=0.00335281066474748 +pm=0 +no_defs"

  c <- list(grid_mapping_name = "albers_conical_equal_area",
              longitude_of_central_meridian = -96,
              latitude_of_projection_origin = 23,
              false_easting = 0.0,
              false_northing = 0.0,
              standard_parallel = c(29.5, 45.5),
              semi_major_axis = 6378137.0,
              inverse_flattening = 298.257223563,
              longitude_of_prime_meridian = 0)

  prj <- nc_gm_to_prj(c)

  expect_equal(prj, p)

  crs <- nc_prj_to_gridmapping(p)
  crs <- stats::setNames(crs$value, crs$name)
  
  expect_equal(crs, c[names(crs)])
})

test_that("albers equal area epsg:5070 with datum instead of a b", {
  p <- "+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=23 +lon_0=-96 +x_0=0 +y_0=0 +units=m +datum=NAD83 +units=m +no_defs +ellps=GRS80 +towgs84=0,0,0"

  c <- list(grid_mapping_name = "albers_conical_equal_area",
            longitude_of_central_meridian = -96,
            latitude_of_projection_origin = 23,
            false_easting = 0.0,
            false_northing = 0.0,
            standard_parallel = c(29.5, 45.5),
            semi_major_axis = 6378137.0,
            inverse_flattening = 298.257222101,
            longitude_of_prime_meridian = 0)

  crs <- nc_prj_to_gridmapping(p)
  crs <- stats::setNames(crs$value, crs$name)

  expect_equal(crs, c[names(crs)])
})

test_that("Azimuthal Equidistant", {
  p <- "+proj=aeqd +lat_0=30 +lon_0=-40 +x_0=0 +y_0=0 +units=m +a=6378137 +f=0.00335281066474748 +pm=0 +no_defs"

  c <- list(grid_mapping_name = "azimuthal_equidistant",
              longitude_of_projection_origin = -40,
              latitude_of_projection_origin = 30,
              false_easting = 0.0,
              false_northing = 0.0,
              longitude_of_prime_meridian = 0.0,
              semi_major_axis = 6378137.0,
              inverse_flattening = 298.257223563)

  prj <- nc_gm_to_prj(c)

  expect_equal(prj, p)

  crs <- nc_prj_to_gridmapping(p)
  crs <- stats::setNames(crs$value, crs$name)

  expect_equal(crs[names(c)], c)

})

test_that("lambert conformal conic daymet", {
  p <- "+proj=lcc +lat_1=25 +lat_2=60 +x_0=0 +y_0=0 +units=m +lat_0=42.5 +lon_0=-100 +a=6378137 +f=0.00335281066474748 +pm=0 +no_defs"

  c <- list(grid_mapping_name = "lambert_conformal_conic",
              longitude_of_central_meridian = -100.0,
              latitude_of_projection_origin = 42.5,
              false_easting = 0.0,
              false_northing = 0.0,
              standard_parallel = c(25.0, 60.0),
              longitude_of_prime_meridian = 0.0,
              semi_major_axis = 6378137.0,
              inverse_flattening = 298.257223563)

  prj <- nc_gm_to_prj(c)

  expect_equal(prj, p)

  crs <- nc_prj_to_gridmapping(p)
  crs <- stats::setNames(crs$value, crs$name)

  expect_equal(crs[names(c)], c)

})

test_that("lambert_azimuthal_equal_area", {
  p <- "+proj=laea +lat_0=90 +lon_0=0 +x_0=0 +y_0=0 +units=m +a=6371228 +b=6371228 +pm=0 +no_defs"

  c <- list(grid_mapping_name = "lambert_azimuthal_equal_area",
              longitude_of_projection_origin = 0,
              latitude_of_projection_origin = 90,
              false_easting = 0.0,
              false_northing = 0.0,
              semi_major_axis = 6371228,
              semi_minor_axis = 6371228,
              longitude_of_prime_meridian = 0.0)

  prj <- nc_gm_to_prj(c)

  expect_equal(prj, p)

  crs <- nc_prj_to_gridmapping(p)
  crs <- stats::setNames(crs$value, crs$name)

  c <- list(grid_mapping_name = "lambert_azimuthal_equal_area",
              longitude_of_projection_origin = 0,
              latitude_of_projection_origin = 90,
              false_easting = 0.0,
              false_northing = 0.0,
              longitude_of_prime_meridian = 0.0,
              semi_major_axis = 6371228)

  prj <- nc_gm_to_prj(c)

  expect_equal(prj, p)

  crs <- nc_prj_to_gridmapping(p)
  crs <- stats::setNames(crs$value, crs$name)

  expect_equal(crs[names(c)], c)

})


test_that("lambert_cylindrical_equal_area", {
  p <- "+proj=cea +lon_0=0 +lat_ts=0 +x_0=0 +y_0=0 +units=m +a=6378137 +f=0.00335281066474748 +pm=0 +no_defs"

  c <- list(grid_mapping_name = "lambert_cylindrical_equal_area",
              longitude_of_central_meridian = 0,
              standard_parallel=0,
              false_easting = 0.0,
              false_northing = 0.0,
              longitude_of_prime_meridian = 0.0,
              semi_major_axis = 6378137.0,
              inverse_flattening = 298.257223563)

  prj <- nc_gm_to_prj(c)

  expect_equal(prj, p)

  crs <- nc_prj_to_gridmapping(p)
  crs <- stats::setNames(crs$value, crs$name)

  expect_equal(crs[names(c)], c)

})

test_that("mercator", {
  p <- "+proj=merc +lon_0=0 +lat_ts=0 +x_0=0 +y_0=0 +units=m +a=6378137 +f=0.00335281066474748 +pm=0 +no_defs"

  c <- list(grid_mapping_name = "mercator",
              longitude_of_projection_origin = 0,
              standard_parallel=0,
              false_easting = 0.0,
              false_northing = 0.0,
              longitude_of_prime_meridian = 0.0,
              semi_major_axis = 6378137.0,
              inverse_flattening = 298.257223563)

  prj <- nc_gm_to_prj(c)

  expect_equal(prj, p)

  crs <- nc_prj_to_gridmapping(p)
  crs <- stats::setNames(crs$value, crs$name)

  expect_equal(crs[names(c)], c)

  p <- "+proj=merc +lon_0=0 +k=1 +x_0=0 +y_0=0 +units=m +a=6378137 +f=0.00335281066474748 +pm=0 +no_defs"

  c <- list(grid_mapping_name = "mercator",
              longitude_of_projection_origin = 0,
              scale_factor_at_projection_origin=1,
              false_easting = 0.0,
              false_northing = 0.0,
              longitude_of_prime_meridian = 0.0,
              semi_major_axis = 6378137.0,
              inverse_flattening = 298.257223563)

  prj <- nc_gm_to_prj(c)

  expect_equal(prj, p)

  crs <- nc_prj_to_gridmapping(p)
  crs <- stats::setNames(crs$value, crs$name)

  expect_equal(crs[names(c)], c)


})

test_that("oblique_mercator", {
  p <- "+proj=omerc +lat_0=45.3091666666667 +lonc=-86 +k=0.9996 +alpha=337.25556 +gamma=337.25556 +no_uoff +x_0=2546731.496 +y_0=-4354009.816 +units=m +a=6378137 +f=0.00335281066474748 +pm=0 +no_defs"

  c <- list(grid_mapping_name = "oblique_mercator",
              azimuth_of_central_line = 337.25556,
              longitude_of_projection_origin = -86,
              latitude_of_projection_origin = 45.3091666666667,
              scale_factor_at_projection_origin = 0.9996,
              false_easting = 2546731.496,
              false_northing = -4354009.816,
              longitude_of_prime_meridian = 0.0,
              semi_major_axis = 6378137.0,
              inverse_flattening = 298.257223563)

  prj <- nc_gm_to_prj(c)

  expect_equal(prj, p)

  crs <- nc_prj_to_gridmapping(p)
  crs <- stats::setNames(crs$value, crs$name)

  expect_equal(crs[names(c)], c)

})

test_that("orthographic", {
  p <- "+proj=ortho +lat_0=30 +lon_0=-40 +x_0=0 +y_0=0 +units=m +a=6378137 +f=0.00335281066474748 +pm=0 +no_defs"

  c <- list(grid_mapping_name = "orthographic",
              longitude_of_projection_origin = -40,
              latitude_of_projection_origin = 30,
              false_easting = 0.0,
              false_northing = 0.0,
              longitude_of_prime_meridian = 0.0,
              semi_major_axis = 6378137.0,
              inverse_flattening = 298.257223563)

  prj <- nc_gm_to_prj(c)

  expect_equal(prj, p)

  crs <- nc_prj_to_gridmapping(p)
  crs <- stats::setNames(crs$value, crs$name)

  expect_equal(crs[names(c)], c)

})

test_that("polar_stereographic", {
  p <- "+proj=stere +lat_0=-90 +lon_0=0 +k=1 +x_0=0 +y_0=0 +units=m +a=6378137 +f=0.00335281066474748 +pm=0 +no_defs"

  c <- list(grid_mapping_name = "polar_stereographic",
              straight_vertical_longitude_from_pole = 0,
              latitude_of_projection_origin = -90,
              scale_factor_at_projection_origin = 1,
              false_easting = 0.0,
              false_northing = 0.0,
              longitude_of_prime_meridian = 0.0,
              semi_major_axis = 6378137.0,
              inverse_flattening = 298.257223563)

  prj <- nc_gm_to_prj(c)

  expect_equal(prj, p)

  # crs <- nc_prj_to_gridmapping(p)
  # crs <- stats::setNames(crs$value, crs$name)
  #
  # expect_equal(crs[names(c)], c)

  p <- "+proj=stere +lat_0=-90 +lon_0=0 +lat_ts=-71 +x_0=0 +y_0=0 +units=m +a=6378137 +f=0.00335281066474748 +pm=0 +no_defs"

  c <- list(grid_mapping_name = "polar_stereographic",
              straight_vertical_longitude_from_pole = 0,
              latitude_of_projection_origin = -90,
              standard_parallel = -71,
              false_easting = 0.0,
              false_northing = 0.0,
              longitude_of_prime_meridian = 0.0,
              semi_major_axis = 6378137.0,
              inverse_flattening = 298.257223563)

  prj <- nc_gm_to_prj(c)

  expect_equal(prj, p)

  # crs <- nc_prj_to_gridmapping(p)
  # crs <- stats::setNames(crs$value, crs$name)
  #
  # expect_equal(crs[names(c)], c)

})

test_that("sinusoidal", {
  p <- "+proj=sinu +lon_0=0 +x_0=0 +y_0=0 +units=m +a=6378137 +f=0.00335281066474748 +pm=0 +no_defs"

  c <- list(grid_mapping_name = "sinusoidal",
              longitude_of_projection_origin = 0,
              false_easting = 0.0,
              false_northing = 0.0,
              longitude_of_prime_meridian = 0.0,
              semi_major_axis = 6378137.0,
              inverse_flattening = 298.257223563)

  prj <- nc_gm_to_prj(c)

  expect_equal(prj, p)

})

test_that("stereographic", {
  p <- "+proj=stere +lat_0=46.5 +lon_0=-66.5 +k=0.999912 +x_0=2500000 +y_0=7500000 +units=m +a=6378137 +f=0.00335281066474748 +pm=0 +no_defs"

  c <- list(grid_mapping_name = "stereographic",
              longitude_of_projection_origin = -66.5,
              latitude_of_projection_origin = 46.5,
              scale_factor_at_projection_origin = 0.999912,
              false_easting = 2500000,
              false_northing = 7500000,
              longitude_of_prime_meridian = 0.0,
              semi_major_axis = 6378137.0,
              inverse_flattening = 298.257223563)

  prj <- nc_gm_to_prj(c)

  expect_equal(prj, p)

  crs <- nc_prj_to_gridmapping(p)
  crs <- stats::setNames(crs$value, crs$name)

  expect_equal(crs[names(c)], c)


})

test_that("transverse_mercator", {
  p <- "+proj=tmerc +lat_0=53.5 +lon_0=-8 +k=0.99982 +x_0=600000 +y_0=750000 +units=m +a=6378137 +f=0.00335281066474748 +pm=0 +no_defs"

  c <- list(grid_mapping_name = "transverse_mercator",
              longitude_of_projection_origin = -8,
              latitude_of_projection_origin = 53.5,
              scale_factor_at_projection_origin = 0.99982,
              false_easting = 600000,
              false_northing = 750000,
              longitude_of_prime_meridian = 0.0,
              semi_major_axis = 6378137.0,
              inverse_flattening = 298.257223563)

  prj <- nc_gm_to_prj(c)

  expect_equal(prj, p)

  crs <- nc_prj_to_gridmapping(p)
  crs <- stats::setNames(crs$value, crs$name)

  expect_equal(crs[names(c)], c)


})

test_that("spherical", {
  
  p <- "+proj=lcc +lat_1=30 +lat_2=60 +x_0=0 +y_0=0 +units=m +lat_0=40.0000076294 +lon_0=-97 +a=6370000 +b=6370000 +pm=0 +no_defs"
  
  # From the National Water Model forcings
  cl <- list(transform_name = "lambert_conformal_conic", 
            grid_mapping_name = "lambert_conformal_conic", 
            standard_parallel = c(30, 60), 
            longitude_of_central_meridian = -97, 
            latitude_of_projection_origin = 40.0000076294, 
            false_easting = 0, 
            false_northing = 0, 
            earth_radius = 6370000)

  prj <- suppressWarnings(nc_gm_to_prj(cl))
  
  expect_equal(prj, p)
  
  crs <- nc_prj_to_gridmapping(p)
  crs <- stats::setNames(crs$value, crs$name)
  
  expect_equal(crs, 
               list(grid_mapping_name = "lambert_conformal_conic", 
                    standard_parallel = c(30, 60), 
                    false_easting = 0, 
                    false_northing = 0, 
                    latitude_of_projection_origin = 40.0000076294, 
                    longitude_of_central_meridian = -97, 
                    semi_major_axis = 6370000, 
                    semi_minor_axis = 6370000,
                    longitude_of_prime_meridian = 0))
 
})

test_that("more spherical", {
  p <- "+proj=lcc +lat_1=30 +lat_2=65 +x_0=-6000 +y_0=-6000 +units=m +lat_0=48 +lon_0=9.75 +a=6371229 +b=6371229 +pm=0 +no_defs"
  
  # from "https://github.com/mdsumner//rasterwise/extdata/EURO-CORDEX_81_DOMAIN000_54/EURO-CORDEX_81_DOMAIN000.nc"
  cl <- list(proj4_params = "+proj=lcc +lat_1=30.00 +lat_2=65.00 +lat_0=48.00 +lon_0=9.75 +x_0=-6000. +y_0=-6000. +ellps=sphere +a=6371229. +b=6371229. +units=m +no_defs", 
             grid_mapping_name = "lambert_conformal_conic", 
             standard_parallel = c(30, 65), 
             longitude_of_central_meridian = 9.75, 
             latitude_of_projection_origin = 48, 
             semi_major_axis = 6371229, 
             inverse_flattening = 0, # This is the BS that caused an Inf!
             false_easting = -6000, 
             false_northing = -6000, 
             `_CoordinateTransformType` = "Projection", 
             `_CoordinateAxisTypes` = "GeoX GeoY")
  

   prj <- suppressWarnings(nc_gm_to_prj(cl))
   
   expect_equal(prj, p)
   
   crs <- nc_prj_to_gridmapping(p)
   crs <- stats::setNames(crs$value, crs$name)
  
   expect_equal(crs, 
                list(grid_mapping_name = "lambert_conformal_conic", 
                     standard_parallel = c(30, 65), 
                     false_easting = -6000, 
                     false_northing = -6000, 
                     latitude_of_projection_origin = 48, 
                     longitude_of_central_meridian = 9.75, 
                     semi_major_axis = 6371229, 
                     semi_minor_axis = 6371229, 
                     longitude_of_prime_meridian = 0))
})
