## https://gist.github.com/mdsumner/c086a5005c59373f4965fa6afd0d5a7c#gistcomment-2132051
fast_tibble <- function(x) {
  stopifnot(length(unique(unlist(lapply(x, length)))) == 1L)
  structure(x, class = c("tbl_df", "tbl", "data.frame"), row.names = as.character(seq_along(x[[1]])))
}
# use with caution!  this will cause problems if a ragged list is given ...
faster_as_tibble <- function(x) {
  ## stopifnot(length(unique(lengths(x))) == 1L)
  structure(x, class = c("tbl_df", "tbl", "data.frame"), row.names = as.integer(seq_along(x[[1]])))
}

split_fast_tibble <- function (x, f, drop = FALSE, ...) 
  lapply(split(x = seq_len(nrow(x)), f = f,  ...), 
         function(ind) faster_as_tibble(lapply(x, "[", ind)))

we_are_raady <- function() {
  fp <- getOption("default.datadir")
  #print(fp)
  stat <- FALSE
  if (!is.null(fp) && file.exists(file.path(fp, "data"))) stat <- TRUE
  stat
}