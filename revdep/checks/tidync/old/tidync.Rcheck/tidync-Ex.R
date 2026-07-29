pkgname <- "tidync"
source(file.path(R.home("share"), "R", "examples-header.R"))
options(warn = 1)
library('tidync')

base::assign(".oldSearch", base::search(), pos = 'CheckExEnv')
base::assign(".old_wd", base::getwd(), pos = 'CheckExEnv')
cleanEx()
nameEx("activate")
### * activate

flush(stderr()); flush(stdout())

### Name: activate
### Title: Activate a NetCDF grid
### Aliases: activate active active<- activate.tidync active.tidync
###   active.default active<-.default

### ** Examples

if (!tolower(Sys.info()[["sysname"]]) == "sunos") {
 l3file <- "S20080012008031.L3m_MO_CHL_chlor_a_9km.nc"
 rnc <- tidync(system.file("extdata", "oceandata", l3file,
 package = "tidync"))
 activate(rnc, "palette")

 ## extract available grid names
 hyper_grids(rnc)
}



cleanEx()
nameEx("hyper_array")
### * hyper_array

flush(stderr()); flush(stdout())

### Name: hyper_array
### Title: Extract NetCDF data as an array
### Aliases: hyper_array tidync_data hyper_slice hyper_array.tidync
###   hyper_array.character

### ** Examples

f <- "S20080012008031.L3m_MO_CHL_chlor_a_9km.nc"
l3file <- system.file("extdata/oceandata", f, package= "tidync")

## extract a raw list by filtered dimension
library(dplyr)
araw1 <- tidync(l3file) %>%
 hyper_filter(lat = between(lat, -78, -75.8), 
              lon = between(lon, 165, 171)) %>%
 hyper_array()

araw <- tidync(l3file) %>% 
         hyper_filter(lat = abs(lat) < 10, 
                     lon = index < 100) %>%
  hyper_array()

## hyper_array will pass the expressions to hyper_filter
braw <- tidync(l3file) %>% 
  hyper_array(lat = abs(lat) < 10, lon = index < 100)

## get the transforms tables (the axis coordinates)
lapply(attr(braw, "transforms"), 
   function(x) nrow(dplyr::filter(x, selected)))
## the selected axis coordinates should match in order and in size
lapply(braw, dim)



cleanEx()
nameEx("hyper_filter")
### * hyper_filter

flush(stderr()); flush(stdout())

### Name: hyper_filter
### Title: Subset NetCDF variable by expression
### Aliases: hyper_filter hyper_filter.tidync

### ** Examples

f <- "S20080012008031.L3m_MO_CHL_chlor_a_9km.nc"
l3file <- system.file("extdata/oceandata", f, package= "tidync")
## filter by value
tidync(l3file) %>% hyper_filter(lon = lon < 100)
## filter by index
tidync(l3file) %>% hyper_filter(lon = index < 100)

## be careful that multiple comparisons must occur in one expression
 tidync(l3file) %>% hyper_filter(lon = lon < 100 & lon > 50)

## filter in combination/s
tidync(l3file) %>% hyper_filter(lat = abs(lat) < 10, lon = index < 100)



cleanEx()
nameEx("hyper_tbl_cube")
### * hyper_tbl_cube

flush(stderr()); flush(stdout())

### Name: hyper_tbl_cube
### Title: A dplyr cube tbl
### Aliases: hyper_tbl_cube hyper_tbl_cube.tidync hyper_tbl_cube.character

### ** Examples

f <- "S20080012008031.L3m_MO_CHL_chlor_a_9km.nc"
l3file <- system.file("extdata/oceandata", f, package= "tidync")
(cube <- hyper_tbl_cube(tidync(l3file) %>%
activate(chlor_a), lon = lon > 107, lat = abs(lat) < 30))
ufile <- system.file("extdata", "unidata", "test_hgroups.nc", 
 package = "tidync", mustWork = TRUE)
 
## some versions of NetCDF don't support this file
## (4.1.3 tidync/issues/82)
group_nc <- try(tidync(ufile), silent = TRUE)
if (!inherits(group_nc, "try-error")) {
 res <-  hyper_tbl_cube(tidync(ufile))
 print(res)
} else {
 ## the error was
 writeLines(c(group_nc))
}



cleanEx()
nameEx("hyper_tibble")
### * hyper_tibble

flush(stderr()); flush(stdout())

### Name: hyper_tibble
### Title: Extract NetCDF data as an expanded table.
### Aliases: hyper_tibble hyper_tibble.character hyper_tibble.tidync

### ** Examples

l3file <- "S20080012008031.L3m_MO_CHL_chlor_a_9km.nc"
f <- system.file("extdata", "oceandata", l3file, package= "tidync")
rnc <- tidync(f)
hyper_filter(rnc)
library(dplyr)
lapply(hyper_array(f, lat = lat > 0, lon = index > 3000), dim)

 ht <- hyper_tibble(rnc) %>%
 filter(!is.na(chlor_a))
ht
library(ggplot2)
ggplot(ht %>% filter(!is.na(chlor_a)),
aes(x = lon, y = lat, fill = chlor_a)) + geom_tile()



cleanEx()
nameEx("hyper_transforms")
### * hyper_transforms

flush(stderr()); flush(stdout())

### Name: hyper_transforms
### Title: Axis transforms
### Aliases: hyper_transforms hyper_transforms.default

### ** Examples

l3file <- "S20080012008031.L3m_MO_CHL_chlor_a_9km.nc"
f <- system.file("extdata", "oceandata", l3file, package = "tidync")
ax <- tidync(f) %>% hyper_transforms()
names(ax)
lapply(ax, dim)

## this function returns the transforms tidync knows about for this source
str(tidync(f)$transforms)
names(hyper_transforms(tidync(f), all = TRUE))



cleanEx()
nameEx("hyper_vars")
### * hyper_vars

flush(stderr()); flush(stdout())

### Name: hyper_vars
### Title: Grid status
### Aliases: hyper_vars hyper_dims hyper_grids

### ** Examples

f <- "S20080012008031.L3m_MO_CHL_chlor_a_9km.nc"
l3file <- system.file("extdata/oceandata", f, package= "tidync")
tnc <- tidync(l3file)
hyper_vars(tnc)
hyper_dims(tnc)
hyper_dims(tnc %>% hyper_filter(lat = lat < 20))



cleanEx()
nameEx("print.tidync")
### * print.tidync

flush(stderr()); flush(stdout())

### Name: print.tidync
### Title: Print tidync object
### Aliases: print.tidync

### ** Examples

argofile <- system.file("extdata/argo/MD5903593_001.nc", package = "tidync")
argo <- tidync(argofile)
print(argo)

## the print is modified by choosing a new grid or running filters
argo %>% activate("D7,D9,D11,D8")

argo %>% hyper_filter(N_LEVELS = index > 300)



cleanEx()
nameEx("print.tidync_data")
### * print.tidync_data

flush(stderr()); flush(stdout())

### Name: print.tidync_data
### Title: Print tidync data
### Aliases: print.tidync_data

### ** Examples

argofile <- system.file("extdata/argo/MD5903593_001.nc", package = "tidync")
argodata <- tidync(argofile) %>% hyper_filter(N_LEVELS = index < 5) %>% 
              hyper_array(select_var = c("TEMP_ADJUSTED", "PRES"))
print(argodata)



cleanEx()
nameEx("reexports")
### * reexports

flush(stderr()); flush(stdout())

### Name: reexports
### Title: Objects exported from other packages
### Aliases: reexports %>%
### Keywords: internal

### ** Examples

system.file("extdata/argo/MD5903593_001.nc", package = "tidync") %>% 
     tidync()



cleanEx()
nameEx("tidync-package")
### * tidync-package

flush(stderr()); flush(stdout())

### Name: tidync-package
### Title: tidync: A Tidy Approach to 'NetCDF' Data Exploration and
###   Extraction
### Aliases: tidync-package
### Keywords: internal

### ** Examples

argofile <- system.file("extdata/argo/MD5903593_001.nc", package = "tidync")
argo <- tidync(argofile)
argo %>% active()
argo %>% activate("D3,D8") %>% hyper_array()
argo %>% hyper_filter(N_LEVELS = index < 4)
argo %>% hyper_tbl_cube()
argo %>% hyper_tibble(select_var = c("TEMP_QC"))
argo %>% hyper_transforms()
argo %>% hyper_vars()
argo %>% hyper_dims()
argo %>% hyper_grids()

## some global options
getOption("tidync.large.data.check")

getOption("tidync.silent")
op <- options(tidync.silent = TRUE)
getOption("tidync.silent")
options(op)



cleanEx()
nameEx("tidync")
### * tidync

flush(stderr()); flush(stdout())

### Name: tidync
### Title: Tidy NetCDF
### Aliases: tidync tidync.character tidync.tidync_data

### ** Examples

## a SeaWiFS (S) Level-3 Mapped (L3m) monthly (MO) chlorophyll-a (CHL)
## remote sensing product at 9km resolution (at the equator)
## from the NASA ocean colour group in NetCDF4 format (.nc)
## for 31 day period January 2008 (S20080012008031) 
f <- "S20080012008031.L3m_MO_CHL_chlor_a_9km.nc"
l3file <- system.file("extdata/oceandata", f, package= "tidync")
## skip on Solaris
if (!tolower(Sys.info()[["sysname"]]) == "sunos") {
tnc <- tidync(l3file)
print(tnc)
}

## very simple Unidata example file, with one dimension
## Not run: 
##D uf <- system.file("extdata/unidata", "test_hgroups.nc", package = "tidync")
##D recNum <- tidync(uf) %>% hyper_tibble()
##D print(recNum)
## End(Not run)
## a raw grid of Southern Ocean sea ice concentration from IFREMER
## it is 12.5km resolution passive microwave concentration values
## on a polar stereographic grid, on 2 October 2017, displaying the 
## "hole in the ice" made famous here:
## https://tinyurl.com/ycbchcgn
ifr <- system.file("extdata/ifremer", "20171002.nc", package = "tidync")
ifrnc <- tidync(ifr)
ifrnc %>% hyper_tibble(select_var = "concentration")



### * <FOOTER>
###
cleanEx()
options(digits = 7L)
base::cat("Time elapsed: ", proc.time() - base::get("ptime", pos = 'CheckExEnv'),"\n")
grDevices::dev.off()
###
### Local variables: ***
### mode: outline-minor ***
### outline-regexp: "\\(> \\)?### [*]+" ***
### End: ***
quit('no')
