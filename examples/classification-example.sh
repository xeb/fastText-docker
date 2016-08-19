#!/usr/bin/env bash

source classification-data.sh

# Get absolute paths for mounting in Docker
LOCAL_RESULTDIR=$(python -c 'import os,sys;print(os.path.realpath(sys.argv[1]))' $RESULTDIR)
LOCAL_DATADIR=$(python -c 'import os,sys;print(os.path.realpath(sys.argv[1]))' $DATADIR)

# Note the only difference between the devel and binary tags in this context
# will be the "./fasttext" command within DOCKER_CMD.  The binary tag does not require it.
DOCKER_IMAGE_PREFIX=xebxeb/fasttext-docker:devel
DOCKER_CMD="docker run --rm -v ${LOCAL_RESULTDIR}:/${RESULTDIR} -v ${LOCAL_DATADIR}:/${DATADIR} ${DOCKER_IMAGE_PREFIX} ./fasttext"

if [[ -z $(docker images | grep -E "^${DOCKER_IMAGE_PREFIX}\s") ]]
then
  make
fi

echo Training model
$DOCKER_CMD supervised -input "/${DATADIR}/dbpedia.train" -output "/${RESULTDIR}/dbpedia" -dim 10 -lr 0.1 -wordNgrams 2 -minCount 1 -bucket 10000000 -epoch 5 -thread 4

echo Testing model
$DOCKER_CMD test "/${RESULTDIR}/dbpedia.bin" "/${DATADIR}/dbpedia.test"

echo Getting prediction
$DOCKER_CMD predict "/${RESULTDIR}/dbpedia.bin" "/${DATADIR}/dbpedia.test" > "${LOCAL_RESULTDIR}/dbpedia.test.predict"
