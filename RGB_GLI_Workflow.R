# RGB orthomosaic to plot-level GLI traits
# Run this script section by section in RStudio.

library(terra)
library(sf)

terraOptions(progress = 0)

rgb <- terra::rast("data/rgb_orthomosaic.tif")
plots <- terra::vect("data/plot_boundaries.geojson")

rgb <- rgb[[1:3]]
names(rgb) <- c("Red", "Green", "Blue")

plot_id_candidates <- c("plot_id", "Plot_ID", "plot", "Plot", "id", "ID")
plot_id_matches <- plot_id_candidates[plot_id_candidates %in% names(plots)]
if (length(plot_id_matches) == 0) {
  plots$plot_id <- paste0("Plot_", seq_len(nrow(plots)))
  plot_id_field <- "plot_id"
} else {
  plot_id_field <- plot_id_matches[[1]]
}

red <- rgb[["Red"]]
green <- rgb[["Green"]]
blue <- rgb[["Blue"]]
gli_denominator <- 2 * green + red + blue
gli <- terra::ifel(gli_denominator == 0, NA, (2 * green - red - blue) / gli_denominator)
names(gli) <- "GLI"

calculate_otsu_threshold <- function(raster, sample_size = 100000, bins = 256) {
  sampled <- terra::spatSample(
    raster,
    size = min(sample_size, terra::ncell(raster)),
    method = "regular",
    na.rm = TRUE,
    values = TRUE
  )
  pixel_values <- as.numeric(sampled[, 1])
  pixel_values <- pixel_values[is.finite(pixel_values)]
  h <- hist(pixel_values, breaks = bins, plot = FALSE)
  probabilities <- h$counts / sum(h$counts)
  omega <- cumsum(probabilities)
  mu <- cumsum(probabilities * h$mids)
  mu_total <- sum(probabilities * h$mids)
  variance <- (mu_total * omega - mu)^2 / (omega * (1 - omega))
  variance[!is.finite(variance)] <- NA_real_
  h$mids[which.max(variance)]
}

otsu_threshold <- calculate_otsu_threshold(gli)
vegetation_mask <- terra::ifel(gli > otsu_threshold, 1, 0)
names(vegetation_mask) <- "Vegetation_Mask"
vegetation_rgb <- rgb * terra::ifel(vegetation_mask == 1, 1, NA)
vegetation_gli <- terra::ifel(vegetation_mask == 1, gli, NA)
names(vegetation_gli) <- "Vegetation_GLI"

if (!terra::same.crs(vegetation_gli, plots)) {
  plots <- terra::project(plots, terra::crs(vegetation_gli))
}

plot(vegetation_gli, col = hcl.colors(100, "YlGn"), main = "Vegetation GLI with Plot Boundaries")
plot(plots, add = TRUE, border = "black", lwd = 1.5)

mean_result <- terra::extract(vegetation_gli, plots, fun = mean, na.rm = TRUE, exact = TRUE)
sd_result <- terra::extract(vegetation_gli, plots, fun = sd, na.rm = TRUE, exact = TRUE)
cover_result <- terra::extract(vegetation_mask, plots, fun = mean, na.rm = TRUE, exact = TRUE)

plot_level_traits <- data.frame(
  plot_id = as.data.frame(plots)[[plot_id_field]],
  mean_vegetation_gli = round(mean_result[, 2], 4),
  sd_vegetation_gli = round(sd_result[, 2], 4),
  canopy_cover_percent = round(100 * cover_result[, 2], 2)
)

dir.create("outputs", showWarnings = FALSE)
write.csv(plot_level_traits, "outputs/plot_level_rgb_gli_traits.csv", row.names = FALSE, na = "")
print(plot_level_traits)
