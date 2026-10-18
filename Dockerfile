FROM rocker/binder:4.4.1

USER root
RUN apt-get update && apt-get install -y --no-install-recommends \
    libgdal-dev libgeos-dev libproj-dev libudunits2-dev \
    libtiff-dev libjpeg-dev libpng-dev \
    && rm -rf /var/lib/apt/lists/*

COPY install.R /tmp/install.R
RUN Rscript /tmp/install.R && rm -f /tmp/install.R
