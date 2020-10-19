#!/bin/bash
if [ $# -eq 0 ]; then
    echo "Usage: build_xai.sh <build no for today>"
    exit 1
fi
if [ $1 = "help" ]; then
    echo "Usage: build_xai.sh <build no for today>"
    exit 1
fi

# Build number for today
BUILD_NUMBER=$1
# NOTE AWS profile must point to your DAIN credentials in your AWS configs
AWS_PROFILE="dain"
AWS_REGION="eu-central-1"
AWS_ECR_REPO="575790519909.dkr.ecr.${AWS_REGION}.amazonaws.com"
DOCKER_AWS_IMAGE="${AWS_ECR_REPO}/xai"
DOCKER_TAG=$(date +%m%d%Y).$BUILD_NUMBER

# Tag HEAD in Git repository.
git tag -f $DOCKER_TAG
echo "Tagged repository head with: $DOCKER_TAG"

# rebuild stack up to pytorch-notebook
make -j build-pytorch | tee pytorch-notebook.log

# login to DAIN AWS ECR repo
aws --profile $AWS_PROFILE ecr get-login-password --region $AWS_REGION | \
docker login --username AWS --password-stdin $AWS_ECR_REPO

# tag built image and push it to repo
docker tag dain/pytorch-notebook:latest $DOCKER_AWS_IMAGE:$DOCKER_TAG
docker push $DOCKER_AWS_IMAGE:$DOCKER_TAG