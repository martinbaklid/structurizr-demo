# !/bin/bash

SCRIPT_DIR=$(realpath $(dirname "$0"))

docker run -it --rm -v ${SCRIPT_DIR}:/usr/local/structurizr structurizr/cli push -id 73266 -key cfefb122-0fb1-4261-91cf-c8d4c778f029 -secret 9d765da9-582b-4328-8a9b-6c74724fd890 -workspace workspace.json
