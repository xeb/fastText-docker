#!/usr/bin/env bash
#
# Copyright (c) 2016-present, Facebook, Inc.
# All rights reserved.
#
# This source code is licensed under the BSD-style license found in the
# LICENSE file in the root directory of this source tree. An additional grant
# of patent rights can be found in the PATENTS file in the same directory.
#
# This is an example of running the fastText classification-example with Docker containers

myshuf() {
  perl -MList::Util=shuffle -e 'print shuffle(<>);' "$@";
}

normalize_text() {
  tr '[:upper:]' '[:lower:]' | sed -e 's/^/__label__/g' | \
    sed -e "s/'/ ' /g" -e 's/"//g' -e 's/\./ \. /g' -e 's/<br \/>/ /g' \
        -e 's/,/ , /g' -e 's/(/ ( /g' -e 's/)/ ) /g' -e 's/\!/ \! /g' \
        -e 's/\?/ \? /g' -e 's/\;/ /g' -e 's/\:/ /g' | tr -s " " | myshuf
}

RESULTDIR=result
DATADIR=data
DOCKER_IMAGE_PREFIX=xebxeb/fasttext-docker
DOCKER_CONTAINER_NAME=fasttext-example
DOCKER_SLEEP_TIME=18000

mkdir -p "${RESULTDIR}"
mkdir -p "${DATADIR}"

if [ ! -f "${DATADIR}/dbpedia.train" ]
then
  wget -c "https://googledrive.com/host/0Bz8a_Dbh9QhbQ2Vic1kxMmZZQ1k" -O "${DATADIR}/dbpedia_csv.tar.gz"
  tar -xzvf "${DATADIR}/dbpedia_csv.tar.gz" -C "${DATADIR}"
  cat "${DATADIR}/dbpedia_csv/train.csv" | normalize_text > "${DATADIR}/dbpedia.train"
  cat "${DATADIR}/dbpedia_csv/test.csv" | normalize_text > "${DATADIR}/dbpedia.test"
  rm dbpedia_csv.tar.gz
fi

if [[ -z $(docker images | grep -E "^${DOCKER_IMAGE_PREFIX}\s") ]]
then
  make
fi

# remove any container that's running
echo Attempting to remove ${DOCKER_CONTAINER_NAME}
docker rm -f ${DOCKER_CONTAINER_NAME}

# start the container, but sleep
docker run -d --name=${DOCKER_CONTAINER_NAME} -v ${RESULTDIR}:/${RESULTDIR} ${DOCKER_IMAGE_PREFIX} /bin/sleep ${DOCKER_SLEEP_TIME}

# get the container's image ID
DOCKER_IMAGE_ID=$(docker inspect --format="{{.Id}}" ${DOCKER_CONTAINER_NAME})

# copy our source data into the container
echo Copying data into container ${DOCKER_IMAGE_ID}
docker cp data ${DOCKER_IMAGE_ID}:/

# start training!
docker exec ${DOCKER_IMAGE_ID} ./fasttext supervised -input "${DATADIR}/dbpedia.train" -output "${RESULTDIR}/dbpedia" -dim 10 -lr 0.1 -wordNgrams 2 -minCount 1 -bucket 10000000 -epoch 5 -thread 4

# test our model
echo Testing model
docker exec ${DOCKER_IMAGE_ID} ./fasttext test "/${RESULTDIR}/dbpedia.bin" "${DATADIR}/dbpedia.test"

# get a prediction
echo Getting prediction
docker exec ${DOCKER_IMAGE_ID} ./fasttext predict "/${RESULTDIR}/dbpedia.bin" "${DATADIR}/dbpedia.test" > "${RESULTDIR}/dbpedia.test.predict"

# copy out all results
echo Copying data out of container
docker cp ${DOCKER_IMAGE_ID}:/${RESULTDIR} ./

echo Removing container ${DOCKER_CONTAINER_NAME}
docker rm -f ${DOCKER_CONTAINER_NAME}
