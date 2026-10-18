options(repos = c(CRAN = "https://cloud.r-project.org"))

# Upgrade the R Markdown toolchain sequentially to avoid xfun/knitr incompatibility.
install.packages("xfun", Ncpus = 1)
install.packages("knitr", Ncpus = 1)
install.packages("rmarkdown", Ncpus = 1)

packages <- c(
  "shiny",
  "learnr",
  "terra",
  "exactextractr",
  "sf",
  "leaflet",
  "plotly",
  "DT"
)

missing <- packages[
  !vapply(packages, requireNamespace, logical(1), quietly = TRUE)
]

if (length(missing) > 0) {
  install.packages(missing, Ncpus = 1)
}

required <- c("xfun", "knitr", "rmarkdown", packages)
failed <- required[
  !vapply(required, requireNamespace, logical(1), quietly = TRUE)
]

if (length(failed) > 0) {
  stop("Failed to install: ", paste(failed, collapse = ", "))
}
