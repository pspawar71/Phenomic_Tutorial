packages <- c(
  "learnr",
  "rmarkdown",
  "shiny",
  "terra",
  "sf",
  "leaflet",
  "leafem",
  "plotly",
  "DT"
)

missing_packages <- packages[
  !vapply(
    packages,
    requireNamespace,
    logical(1),
    quietly = TRUE
  )
]

if (length(missing_packages) > 0) {
  install.packages(
    missing_packages,
    repos = "https://cloud.r-project.org",
    Ncpus = 2
  )
}

for (package in packages) {
  message(
    package,
    ": ",
    as.character(packageVersion(package))
  )
}
