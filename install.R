options(
  repos = c(
    CRAN = "https://cloud.r-project.org"
  )
)

# Install these first and sequentially.
# knitr 1.50 or newer is required with xfun 0.56 or newer.
install.packages(
  c(
    "xfun",
    "knitr",
    "rmarkdown"
  ),
  Ncpus = 1
)

# Install the remaining tutorial packages only after
# xfun, knitr, and rmarkdown are compatible.
tutorial_packages <- c(
  "shiny",
  "learnr",
  "terra",
  "sf",
  "leaflet",
  "leafem",
  "plotly",
  "DT"
)

install.packages(
  tutorial_packages,
  Ncpus = 1
)

required_packages <- c(
  "xfun",
  "knitr",
  "rmarkdown",
  "shiny",
  "learnr",
  "terra",
  "sf",
  "leaflet",
  "leafem",
  "plotly",
  "DT"
)

failed_packages <- required_packages[
  !vapply(
    required_packages,
    requireNamespace,
    logical(1),
    quietly = TRUE
  )
]

if (length(failed_packages) > 0) {
  stop(
    paste(
      "Failed to install:",
      paste(
        failed_packages,
        collapse = ", "
      )
    )
  )
}

message("Installed package versions:")

for (package in required_packages) {
  message(
    package,
    ": ",
    as.character(
      packageVersion(package)
    )
  )
}
