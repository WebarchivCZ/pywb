#!/usr/bin/env bash

# Make Bash Great Again
set -o errexit # exit when a command fails.
set -o nounset # exit when using undeclared variables
set -o pipefail # catch non-zero exit code in pipes
# set -o xtrace # uncomment for bug hunting

cd ci && ansible-playbook -i local deploy.yaml

#docker run --rm -it -p 8000:8000 -v ${PWD}:/docs squidfunk/mkdocs-material
