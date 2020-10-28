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
#  Pytorch 1.6 with CUDA 10.2 support
#  Torchvision
#  Ignite
#  OpenCV
#  Intel MKL backend, replaces OpenBLAS
#  Tensorboard
#
RUN conda config --show channels && \
    conda config --add channels pytorch && \
    conda config --add channels conda-forge && \
    conda config --show channels && \
    conda config --system --set channel_priority flexible && \
    conda install -q -y \
    'conda-forge::blas=*=mkl' \
    'pytorch=1.6*' \
    'torchvision=0.7*' \
    'ignite=0.4*' \
    'cudatoolkit=10.2*' \
    && \
    conda config --system --set channel_priority strict && \
    conda clean --all -f -y && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

RUN conda config --system --set channel_priority flexible && \
    conda install -q -y \
    'tensorboard=2.*' \
    'yarl>=1.0,<1.6*' \
    'fire' \
    'gdown' \
    'nibabel' \
    'pillow' \
    'pytorch::captum=0.2*' \
    'flask' \
    'nodejs>=8.*' \
    'yarn>=1.5*' \
    && \
    jupyter nbextension install --py --symlink --sys-prefix captum.insights.widget && \
    jupyter nbextension enable captum.insights.widget --py --sys-prefix && \
    rm -rf "/home/${NB_USER}/.cache/yarn" && \
    rm -rf "/home/${NB_USER}/.node-gyp" && \
    conda config --system --set channel_priority strict && \
    conda clean --all -f -y && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

# Install MONAI milestone edition with some extras
RUN pip install -q --no-cache-dir 'monai'

# Install and build MONAI from master branch, latest development version
#RUN pip install -q --no-cache-dir git+https://github.com/Project-MONAI/MONAI#egg=MONAI

WORKDIR $HOME