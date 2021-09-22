# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
ARG OWNER=jupyter
ARG BASE_CONTAINER=$OWNER/scipy-notebook
FROM $BASE_CONTAINER

LABEL maintainer="Pekka Ahtonen <pekka.ahtonen@dainstudios.com>"

USER $NB_UID

RUN conda install -q -y -c conda-forge 'blas=*=mkl' 'cudatoolkit=10.2*' && \
    conda install -q -y -c pytorch \
    'pytorch' \
    'torchvision' \
    'torchaudio' && \
    conda clean --all -f -y && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

WORKDIR $HOME