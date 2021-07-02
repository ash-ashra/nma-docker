# OS/ARCH: Ubuntu 20.04 (focal)
ARG ROOT_CONTAINER=ubuntu:focal-20210609@sha256:376209074d481dca0a9cf4282710cd30a9e7ff402dea8261acdaaf57a18971dd
ARG BASE_CONTAINER=$ROOT_CONTAINER
FROM $BASE_CONTAINER

LABEL maintainer="Arash Ash <arash.ash@neuromatch.io>"
ARG NB_USER="jovyan"

ENV PYTHON_VERSION 3.7
ENV LANG C.UTF-8
USER root

RUN apt-get -qq update && apt-get install -y --no-install-recommends \
    sudo \
    tini \
    run-one \
    apt-utils \
    build-essential \
    ca-certificates \
    apt-transport-https \
    git \
    wget \
    curl \
    unzip \
    locales \
    fonts-liberation \
    lmodern \
    python3-dev \
    python3-pip \
    python3-setuptools \
#     # ---- nbconvert dependencies ----
#     pandoc \
#     inkscape \
#     texlive-xetex \
#     texlive-fonts-recommended \
#     texlive-latex-recommended
#     # ----
    
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install jupyter and notebook extension
RUN pip3 --no-cache-dir install jupyter ipywidgets && \
    jupyter nbextension enable --py widgetsnbextension && \
    jupyter notebook --generate-config

# Install jupyterlab
RUN pip3 --no-cache-dir install jupyterlab && jupyter serverextension enable --py jupyterlab

# # Install nbconvert for downloading to PDF option
# RUN pip3 --no-cache-dir install nbconvert

# Install packages
RUN curl -sSL https://raw.githubusercontent.com/NeuromatchAcademy/course-content/master/requirements.txt -o requirements.txt
RUN pip3 --no-cache-dir install -r requirements.txt
RUN rm requirements.txt

# Expose port & cmd
EXPOSE 8888

# Set default work directory
RUN mkdir /workspace
WORKDIR /workspace
RUN git clone https://github.com/NeuromatchAcademy/course-content

USER ${NB_USER}
CMD jupyter lab --ip=* --port=8888 --no-browser --notebook-dir=/workspace
