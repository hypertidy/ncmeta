fast_tibble <- function(x) {
  stopifnot(length(unique(unlist(lapply(x, length)))) == 1L)
  structure(x, class = c("tbl_df", "tbl", "data.frame"), row.names = as.character(seq_along(x[[1]])))
}
faster_tibble <- function(x) {
  structure(x, class = c("tbl_df", "tbl", "data.frame"), row.names = as.character(seq_along(x[[1]])))
}

we_are_raady <- function() {
  fp <- getOption("default.datadir")
  #print(fp)
  stat <- FALSE
  if (!is.null(fp) && file.exists(file.path(fp, "data"))) stat <- TRUE
  stat
}