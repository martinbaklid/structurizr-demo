# !/bin/bash
SCRIPT_DIR=$(realpath $(dirname "$0"))

docker run -it --rm -p 8080:8080 -v ${SCRIPT_DIR}:/usr/local/structurizr structurizr/lite
