FROM rocker/binder:4.4.1

COPY install.R /tmp/install.R
RUN Rscript /tmp/install.R

ARG NB_USER=jovyan
ARG NB_UID=1000
ENV APP_HOME=/home/pawar

USER root

RUN mkdir -p ${APP_HOME} /home/rstudio
COPY . ${APP_HOME}

# Both the Binder startup user and the RStudio user must be able to
# create Plot_Level_GLI_Tutorial.html beside the Rmd file.
RUN chmod -R a+rwX ${APP_HOME}     && chmod +x ${APP_HOME}/start     && ln -sfn ${APP_HOME} /home/rstudio/pawar

USER ${NB_USER}
WORKDIR ${APP_HOME}
