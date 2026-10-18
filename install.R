packages <- c(
  "IRkernel", "terra", "sf", "mapview", "leafem", "leaflet",
  "magrittr", "DT", "htmlwidgets"
)
missing <- packages[!vapply(packages, requireNamespace, logical(1), quietly = TRUE)]
if (length(missing)) {
  install.packages(missing, repos = "https://cloud.r-project.org", Ncpus = 2)
}
IRkernel::installspec(user = FALSE, name = "ir", displayname = "R")
