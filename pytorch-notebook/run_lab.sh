#!/bin/bash
TOKEN=rihanna
DOCKER_IMAGE="dain/pytorch-notebook:latest"
CONTAINER_NAME="monai_stack"
RUN_ARGS="-d"
echo "Running $DOCKER_IMAGE"
#
# Port mappings:
# 8888, Jupyter Lab
# 6006, Tensorboard
#
docker run $RUN_ARGS \
--user root \
--gpus all \
--ipc host \
--name $CONTAINER_NAME \
-e NB_UID=1000 \
-e NB_GID=1000 \
-e GRANT_SUDO=yes \
-e JUPYTER_ENABLE_LAB=yes \
-p 8888:8888 \
-p 6006:6006 \
-v "${HOME}/src:/home/jovyan/src" $DOCKER_IMAGE \
start-notebook.sh \
--NotebookApp.token=$TOKEN
