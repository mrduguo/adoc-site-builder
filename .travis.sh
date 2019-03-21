#!/usr/bin/env bash

if [ "$TRAVIS_BUILD_NUMBER" == "" ]; then
    echo "This script suppose to run in travis environment!"
    exit 1
fi

DOCKER_TAG_VERSION=$TRAVIS_BRANCH-$(date -u +"%Y%m%d-%H%M%S")-${TRAVIS_COMMIT:0:7}-$TRAVIS_BUILD_NUMBER
DOCKER_TAG_LATEST=$TRAVIS_BRANCH
if [ "$DOCKER_TAG_LATEST" == "master" ]; then
    DOCKER_TAG_LATEST="latest"
fi

docker build -t $TRAVIS_REPO_SLUG:$DOCKER_TAG_VERSION -t $TRAVIS_REPO_SLUG:$DOCKER_TAG_LATEST -f Dockerfile .

echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
docker push $TRAVIS_REPO_SLUG:$DOCKER_TAG_VERSION
docker push $TRAVIS_REPO_SLUG:$DOCKER_TAG_LATEST