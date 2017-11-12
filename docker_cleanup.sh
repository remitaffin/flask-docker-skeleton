#!/bin/bash

# This script really kills everything on docker including
# running containers, old stopped containers,
# dangling images (images that have been built locally).

# Set -e exits the script if any command has a non-zero exit status
# Set -u returns an error when a variable is unknown instead of silently ignore it
# Set -o pipefail prevents errors in a pipeline (sequence of |) from being masked
set -euo pipefail
IFS=$'\n\t'

DOCKER_BIN=$(which docker.io 2> /dev/null || which docker 2> /dev/null)
if [ -z "$DOCKER_BIN" ] ; then
  echo "Docker is not installed"
  exit 1
fi

printf "\n>>> Stop all docker containers...\n"
tostop=$($DOCKER_BIN ps -q)
if [ "$tostop" ]; then
  $DOCKER_BIN kill $tostop
fi
echo -e "[OK]\n"

printf "\n>>> Kill all stopped docker containers...\n"
tokill=$($DOCKER_BIN ps -aq)
if [ "$tokill" ]; then
  $DOCKER_BIN rm -v $tokill
fi
echo -e "[OK]\n"

printf "\n>>> Remove dangling docker images...\n"
toremove=$($DOCKER_BIN images -q -f "dangling=true")
if [ "${toremove}" ]; then
  $DOCKER_BIN rmi $toremove
fi
echo -e "[OK]\n"
