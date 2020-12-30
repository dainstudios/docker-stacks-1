# Copyright (c) DAIN Studios.
# Distributed under the terms of the Modified BSD License.
ARG BASE_CONTAINER=dain/scipy-notebook
FROM $BASE_CONTAINER

LABEL maintainer="Pekka Ahtonen <pekka.ahtonen@dainstudios.com>"

USER $NB_UID

# Note that channel priority must be set flexible since cudatoolkit package is
# not available in conda-forge, to prevent a frozen dependency resolve
#
# Install following packages:
#  Pytorch with CUDA 10.2 support
#  Torchvision
#  Ignite
#  Intel MKL backend, replaces OpenBLAS
#
RUN conda config --show channels && \
    conda config --add channels pytorch && \
    conda config --add channels conda-forge && \
    conda config --show channels && \
    conda config --system --set channel_priority flexible && \
    conda install -q -y \
    'conda-forge::blas=*=mkl' \
    'pytorch=1.7*' \
    'torchvision=0.8*' \
    'ignite=0.4*' \
    'cudatoolkit=10.2*' \
    && \
    conda config --system --set channel_priority strict && \
    conda clean --all -f -y && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

WORKDIR $HOME