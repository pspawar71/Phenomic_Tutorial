packages <- c("learnr","rmarkdown","shiny","terra","sf","leaflet","leafem","plotly","DT")
missing <- packages[!vapply(packages, requireNamespace, logical(1), quietly = TRUE)]
if (length(missing)) install.packages(missing, repos = "https://cloud.r-project.org", Ncpus = 2)
