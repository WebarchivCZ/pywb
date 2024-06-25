#!/usr/bin/env bash

# Make Bash Great Again
set -o errexit # exit when a command fails.
set -o nounset # exit when using undeclared variables
set -o pipefail # catch non-zero exit code in pipes
# set -o xtrace # uncomment for bug hunting


{% if env == "local" %}
docker-compose -f {{ pywb_dir }}/docker-compose-{{ env }}.yaml -p pywb-{{ env }} down
docker-compose -f {{ pywb_dir }}/docker-compose-{{ env }}.yaml -p pywb-{{ env }} pull
docker-compose -f {{ pywb_dir }}/docker-compose-{{ env }}.yaml -p pywb-{{ env }} up -d --remove-orphans
{% else %}
sudo docker-compose -f {{ pywb_dir }}/docker-compose-{{ env }}.yaml -p pywb-{{ env }} down
sudo docker-compose -f {{ pywb_dir }}/docker-compose-{{ env }}.yaml -p pywb-{{ env }} pull
sudo docker-compose -f {{ pywb_dir }}/docker-compose-{{ env }}.yaml -p pywb-{{ env }} up -d --remove-orphans
{% endif %}



