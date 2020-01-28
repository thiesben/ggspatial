
#' @export
df_spatial.Raster <- function(x, ...) {
  # get values in a data frame
  nrows <- x@nrows
  ncols <- x@ncols
  bbox <- raster::as.matrix(x@extent)

  fused <- cbind(
    expand.grid(x = seq_len(ncols), y = seq_len(nrows)),
    raster::values(x)
  )

  # set names to be x, y, band1, band2, ...
  nbands <- ncol(fused) - 2
  names(fused) <- c("x", "y", paste0("band", seq_len(nbands)))

  # fix x and y to be physical coordinates using the bbox
  bbox_width <- bbox[1, 2] - bbox[1, 1]
  bbox_height <- bbox[2, 1] - bbox[2, 2]

  fused$x <- bbox[1, 1] + (fused$x - 1) / ncols * bbox_width
  fused$y <- bbox[2, 1] + (fused$y - nrows) / nrows * bbox_height

  tibble::as_tibble(fused)
}