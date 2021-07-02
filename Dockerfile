FROM ubuntu:18.04

ENV PYTHON_VERSION 3.7
ENV CONDA_ENV_NAME jupyterlab
ENV LANG C.UTF-8

RUN apt-get update && apt-get install -yq --no-install-recommends \
    apt-utils \
    ca-certificates \
    apt-transport-https \
    gnupg2 \
    wget \
    unzip \
    curl \
    bzip2 \
    git \
    fonts-liberation \
    build-essential \
    emacs \
    inkscape \
    jed \
    libsm6 \
    libxext-dev \
    libxrender1 \
    lmodern \
    nano \
    netcat \
    pandoc \
    python-dev \
    ffmpeg \
    libgtk2.0-0 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    pip
    
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install jupyter and notebook extension
RUN pip --no-cache-dir install jupyter ipywidgets && \
    jupyter nbextension enable --py widgetsnbextension && \
    jupyter notebook --generate-config

# Install jupyterlab
RUN pip --no-cache-dir install jupyterlab && jupyter serverextension enable --py jupyterlab

# Install packages
RUN curl -sSL https://raw.githubusercontent.com/arashash/nma-docker/main/requirements.txt -o requirements.txt
RUN pip --no-cache-dir install -r requirements.txt
RUN rm requirements.txt

# Copy jupyter password
RUN curl -sSL https://raw.githubusercontent.com/gzupark/jupyterlab-docker/master/assets/jupyter_notebook_config.py -o /root/.jupyter/jupyter_notebook_config.py

# Expose port & cmd
EXPOSE 8888

# Set default work directory
RUN mkdir /workspace
WORKDIR /workspace

RUN curl -sSL https://raw.githubusercontent.com/gzupark/jupyterlab-docker/master/assets/tutorial_change_passwd.ipynb -o /workspace/tutorial_change_passwd.ipynb

RUN jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --notebook-dir=/workspace
