#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

ROOT=/app
VENV=$ROOT/virtualenv
VERSIONFILE=$ROOT/.current_version_requirements

printf "\n>>> Rebuilding the Python virtualenv...\n\n"
# Create version file if it doesn't exist yet
if ! docker-compose run -T --no-deps app bash -c "[[ -f '$VERSIONFILE' ]]"; then
  docker-compose run --no-deps app touch $VERSIONFILE;
fi

INSTALLED_VERSION=$( docker-compose run -T --no-deps app cat $VERSIONFILE )
CURRENT_VERSION=$( docker-compose run -T --no-deps app bash -c "md5sum $ROOT/requirements.txt | awk '{ print \$1 }'" )
# If version is different or if virtualenv doesn't exist
if [[ "$CURRENT_VERSION" != "$INSTALLED_VERSION" ]] || \
   $(docker-compose run -T --no-deps app bash -c "[[ ! -d '$VENV' ]] && echo true || echo false"); then
  printf "Resetting virtualenv to $CURRENT_VERSION...\n"
  docker-compose run --no-deps app bash -c "rm -rf $VENV && virtualenv -p python3.6 $VENV && pip install --user -r $ROOT/requirements.txt"
  docker-compose run --no-deps app bash -c "echo $CURRENT_VERSION > $VERSIONFILE"
else
  printf "Virtualenv is up to date.\n"
fi
