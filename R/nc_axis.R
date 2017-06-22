# nc_vars(f)  ## should be distinct
# nc_axes(f)  ## all of them 
# nc_axes(f, var) ## just these ones
# nc_axis(i)  ## just one, of all ??

shapes <- function(x) UseMethod("shapes")
shapes.tidync <- function(x) x$grid
shapes.list <- function(x) {
  if (nrow(x$variable) < 1 & nrow(x$dimension) < 1) return(tibble())
  shape_instances_byvar <- x$variable %>% 
    group_by(name) %>% 
    split(.$name) %>% purrr::map(function(xa) xa$dimids)
  shape_classify_byvar <- factor(unlist(lapply(shape_instances_byvar, 
                                               function(xb) paste(paste0("D", xb), collapse = ","))))
  out <- tibble(variable  = names(shape_classify_byvar), 
                shape = levels(shape_classify_byvar)[shape_classify_byvar]) %>% 
    arrange(desc(nchar(shape)), shape, variable)
  ## catch the NA shapes (the scalars) and set to "-"
  out$shape[is.na(out$shape) | out$shape == "DNA"] <- "S"
  out 
  out$grid <- out$shape
  out$shape <- NULL
  out
}

dimensions <- function(x) {
  x$dimension
}