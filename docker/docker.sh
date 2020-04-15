#!/bin/bash

# usage
SCRIPT_FILE=`basename $0`
function usage()
{
  echo "usage: ${SCRIPT_FILE} docker/nvidia-docker" 1>&2
}

# arguments
if [ $# -ne 1 ]; then
  usage
  exit 1
fi
DOCKER_CMD=$1

# constant
SCRIPT_DIR=$(cd $(dirname $0); pwd)
LOG_FILE=${SCRIPT_DIR}/../logs/docker.log
CONTAINER_NAME=template_pytorch_1_0_1
CONTAINER_IMAGE=template_pytorch_1_0_1
HOST_PORT=18888
CONTAINER_PORT=8888

# log
function log() {
  local fname=${BASH_SOURCE[1]##*/}
  echo "$(date '+%Y-%m-%dT%H:%M:%S') ${PROCNAME} (${fname}:${BASH_LINENO[0]}:${FUNCNAME[1]}) $@" | tee -a ${LOG_FILE}
}

# main
log "info start script"
log "info CONTAINER_NAME: ${CONTAINER_NAME}, CONTAINER_IMAGE: ${CONTAINER_IMAGE}, HOST_PORT: ${HOST_PORT}, CONTAINER_PORT: ${CONTAINER_PORT}"

${DOCKER_CMD} run --name ${CONTAINER_NAME} \
  -v $(pwd)/../config:/opt/config \
  -v $(pwd)/../data:/opt/data \
  -v $(pwd)/../features:/opt/features \
  -v $(pwd)/../logs:/opt/logs \
  -v $(pwd)/../models:/opt/models \
  -v $(pwd)/../notebook:/opt/notebook \
  -v $(pwd)/../scripts:/opt/scripts \
  -v $(pwd)/../utils:/opt/utils \
  -p ${HOST_PORT}:${CONTAINER_PORT} \
  -it ${CONTAINER_IMAGE}
if [ $? -gt 0 ]; then
  log "error docker run"
fi

# log "info end script"
