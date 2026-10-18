FROM rocker/binder:4.4.1

COPY install.R /tmp/install.R
RUN Rscript /tmp/install.R

ARG NB_USER=jovyan
ARG NB_UID=1000

ENV APP_HOME=/home/pawar

USER root

RUN mkdir -p ${APP_HOME} /home/rstudio

COPY --chown=${NB_UID}:users . ${APP_HOME}

RUN chmod +x ${APP_HOME}/start \
    && chmod -R a+rX ${APP_HOME} \
    && ln -sfn ${APP_HOME} /home/rstudio/pawar

USER ${NB_USER}

WORKDIR ${APP_HOME}
