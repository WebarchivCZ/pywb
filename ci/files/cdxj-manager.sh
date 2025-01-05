#!/usr/bin/env bash

# Make Bash Great Again
set -o errexit # exit when a command fails.
set -o nounset # exit when using undeclared variables
set -o pipefail # catch non-zero exit code in pipes
# set -o xtrace # uncomment for bug hunting

script_usage () {
cat << EOF
Index manager create cdxj index for archives in collection. Exposing collection to PyWb.

Collection manager accepts collection name as parameter.

Usage: ./collection-manager.sh collection
Example: ./collection-manager.sh 07-cz2007
EOF
}

if [ $# -eq 0 ]; then
        script_usage
        exit 0
elif [  $# -gt 1 ]; then
        echo -e "Error! Too many parameters provided!\n"
        script_usage
        exit 1
fi

export COLLECTION_NAME=$1
export COLLECTIONS_ROOT_PATH=/mnt/index/collections
export COLLECTION_PATH=${COLLECTIONS_ROOT_PATH}/${COLLECTION_NAME}
export COLLECTION_ARCHIVE_PATH=${COLLECTIONS_PATH}/archive
export COLLECTION_INDEXES_PATH=${COLLECTIONS_PATH}/indexes
export COLLECTION_INDEX=${COLLECTIONS_PATH}/indexes/prase.cdxj
export INDEX_BACKUP_PATH=/mnt/index/cdxj-archive
export INDEXER=cdxj-indexer

create_index () {
    ARCHIVE_PATH=$1
    ARCHIVE_NAME=$(basename ${ARCHIVE_PATH})
    INDEX_PATH=${COLLECTION_PATH}/${ARCHIVE_NAME}.cdxj
    ${INDEXER} -s ${ARCHIVE_PATH} -o ${INDEX_PATH}

}
find ${COLLECTION_ARCHIVE_PATH} -type f \( -name "*.warc.gz" -o -name "*.arc.gz" \) -exec bash -c 'create_index "$0"' {} \;

echo "Archive indexes created in ${COLLECTION_PATH}"
echo "Merging & sorting all indexes to ${COLLECTION_INDEX}"
LANG=C.UTF-8 sort ${COLLECTION_PATH}*.cdxj > ${COLLECTION_INDEX}
echo "${COLLECTION_NAME} index created in ${COLLECTION_INDEX}"
echo "Moving archive indexes to ${INDEX_BACKUP_PATH}"
mv ${COLLECTION_PATH}*.cdxj ${INDEX_BACKUP_PATH}/
echo "Indexes moved to ${INDEX_BACKUP_PATH}. Nothing left to do. My work is done. Happy Oink! <=~"
echo "Check out https://pywb.webarchiv.cz/${COLLECTION_NAME}/"