FROM ubuntu:18.04

ENV PYTHON_VERSION 3.7
ENV CONDA_ENV_NAME jupyterlab
ENV LANG C.UTF-8

RUN apt-get update && apt-get install -yq --no-install-recommends \
    apt-utils \
    build-essential \
    ca-certificates \
    apt-transport-https \
    git \
    wget \
    curl \
    unzip \
    fonts-liberation \
    lmodern \
    pandoc \
    ffmpeg \
    python3-dev \
    python3-pip \
    python3-setuptools 
    
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install jupyter and notebook extension
RUN pip3 --no-cache-dir install jupyter ipywidgets && \
    jupyter nbextension enable --py widgetsnbextension && \
    jupyter notebook --generate-config

# Install jupyterlab
RUN pip3 --no-cache-dir install jupyterlab && jupyter serverextension enable --py jupyterlab

# Install packages
RUN curl -sSL https://raw.githubusercontent.com/NeuromatchAcademy/course-content/master/requirements.txt -o requirements.txt
RUN pip3 --no-cache-dir install -r requirements.txt
RUN rm requirements.txt

# Copy jupyter password
RUN curl -sSL https://raw.githubusercontent.com/gzupark/jupyterlab-docker/master/assets/jupyter_notebook_config.py -o /root/.jupyter/jupyter_notebook_config.py

# Expose port & cmd
EXPOSE 8888

# Set default work directory
RUN mkdir /workspace
WORKDIR /workspace
RUN git clone https://github.com/NeuromatchAcademy/course-content

RUN curl -sSL https://raw.githubusercontent.com/gzupark/jupyterlab-docker/master/assets/tutorial_change_passwd.ipynb -o /workspace/tutorial_change_passwd.ipynb

RUN jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --notebook-dir=/workspace
