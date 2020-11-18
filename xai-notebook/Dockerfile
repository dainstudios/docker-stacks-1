#
# xAI stack
#
# First build a custom Captum wheel. Second build stage installs
# all other packages.
#
# Copyright (c) DAIN Studios.
# Distributed under the terms of the Modified BSD License.
#
ARG BASE_CONTAINER=dain/pytorch-notebook
ARG GIT_USER=ahtonen
ARG GIT_REPO=captum
ARG GIT_BRANCH=dev
ARG WHEEL="captum-0.4.0-py3-none-any.whl"

FROM $BASE_CONTAINER AS builder
ARG GIT_USER
ARG GIT_REPO
ARG GIT_BRANCH
ARG GIT_HASH="2580702cc1432dae394bedccd4ed2008efcfc697"
ARG WHEEL

USER root

# Install build requirements for Captum
RUN conda config --system --set channel_priority flexible
RUN conda install -q -y \
    'nodejs>=8.*' \
    'yarn>=1.5*'
# Checkout custom Captum code
RUN git clone git://github.com/$GIT_USER/$GIT_REPO /src/$GIT_REPO
WORKDIR /src/$GIT_REPO
RUN git checkout $GIT_HASH
# Build Insights
RUN BUILD_INSIGHTS=1 python setup.py develop
# Build Captum wheel
RUN pip wheel --no-deps -e .


# Final stage
FROM $BASE_CONTAINER
ARG GIT_REPO
ARG WHEEL

USER $NB_UID

LABEL maintainer="Pekka Ahtonen <pekka.ahtonen@dainstudios.com>"

# Copy Captum wheel
COPY --from=builder "/src/${GIT_REPO}/${WHEEL}" /tmp/

# Additional requirements
RUN conda config --system --set channel_priority flexible && \
    conda install -q -y \
    'tensorboard=2.*' \
    'yarl>=1.0,<1.6*' \
    'fire' \
    'gdown' \
    'nibabel' \
    'pillow' \
    'flask' && \
    conda config --system --set channel_priority strict && \
    conda clean --all -f -y && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

# Install Captum
RUN pip install -q --no-cache-dir "/tmp/${WHEEL}" && \
    jupyter nbextension install --py --symlink --sys-prefix captum.insights.attr_vis.widget && \
    jupyter nbextension enable captum.insights.attr_vis.widget --py --sys-prefix && \
    rm -rf "/home/${NB_USER}/.cache/yarn" && \
    rm -rf "/home/${NB_USER}/.node-gyp" && \
    fix-permissions /home/$NB_USER

# Install MONAI milestone edition with some extras
RUN pip install -q --no-cache-dir 'monai' && \
    fix-permissions /home/$NB_USER

# Install and build MONAI from master branch, latest development version
#RUN pip install -q --no-cache-dir git+https://github.com/Project-MONAI/MONAI#egg=MONAI

WORKDIR $HOME