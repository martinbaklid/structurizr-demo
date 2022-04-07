# !/bin/bash

SCRIPT_DIR=$(realpath $(dirname "$0"))

docker run -it --rm -v ${SCRIPT_DIR}:/usr/local/structurizr structurizr/cli push -id 73267 -key 59f14252-04b9-4b2c-8f10-9e9b03a2baf8 -secret 7a687206-010b-40a1-bbd7-098be3763aa0 -workspace workspace.json
