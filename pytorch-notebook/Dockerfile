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

RUN conda install -q -y -c conda-forge \
    'tensorboard' \    
    'nibabel' \
    'pillow' \
    'black' \
    'pylint' \    
    'isort' && \
    conda clean --all -f -y && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

RUN pip install -q --no-cache-dir 'monai' && \
    fix-permissions /home/$NB_USER

COPY .bash_aliases /home/$NB_USER/

WORKDIR $HOME