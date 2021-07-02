# Run Neuromatch Academy (NMA) with JupyterLab instead of Colab
This project facilitates access to NMA content for students who like to run everything locally for various reasons, such as limited Internet or electricity access.

##  Install the only dependency
Docker: https://docs.docker.com/get-docker/

## Usage:
Open your terminal in Linux or MacOS (or Command Prompt in Windows)
### Download (or update) it:
``docker pull arashash/nma``

### Run it
``docker run -p 8888:8888 arashash/nma``

### Access it
Use the given link that starts with `http://127.0.0.1:8888/lab?token=`
