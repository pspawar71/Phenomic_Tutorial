#!/bin/bash
set -e

R --vanilla -q -e "rmarkdown::run(
  file='/home/pawar/Plot_Level_GLI_Tutorial.Rmd',
  shiny_args=list(host='0.0.0.0', port=3838, launch.browser=FALSE)
)" > /tmp/gli-tutorial.log 2>&1 &

exec "$@"
