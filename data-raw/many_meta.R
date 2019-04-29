library(dplyr)
f <- raadfiles::get_raad_filenames() %>% dplyr::filter(stringr::str_detect(file, "nc$")) %>% 
  group_by((dirname(dirname(file)))) %>% slice(1) %>% ungroup() %>% sample_frac(1) %>% transmute(fullname = file.path(root, file))
dim(f)
f <- f[!grepl("RRS.nc$",basename(f$fullname)), ]
dim(f)
library(furrr)
plan(multiprocess)
safefun <- purrr::safely(function(x) ncmeta::nc_meta(x))
system.time(a <- furrr::future_map(f$fullname, safefun))
#get all attribute tables
d <- purrr::map_dfr(a, ~if (is.null(.x$error)) .x$result$attribute else NULL, .id = "ch")
saveRDS(d, file = "data-raw/many-atts.rds")
saveRDS(a, "data-raw/many_meta.rds")