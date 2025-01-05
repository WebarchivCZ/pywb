#!/usr/bin/env bash

# Make Bash Great Again
set -o errexit # exit when a command fails.
set -o nounset # exit when using undeclared variables
set -o pipefail # catch non-zero exit code in pipes
# set -o xtrace # uncomment for bug hunting

COLLECTION=$@

{% if env == "local" %}
docker exec -it pywb-local-pywb-1 wb-manager reindex ${COLLECTION} 2>&1 |tee logs/reindex.${COLLECTION}.$(date -u --iso-8601).log
{% else %}
sudo time docker exec -it pywb-{{ env }}-pywb-1 wb-manager reindex ${COLLECTION} 2>&1 |tee logs/reindex.${COLLECTION}.$(date -u --iso-8601).log
{% endif %}
