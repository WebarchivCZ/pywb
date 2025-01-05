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
export COLLECTION_ARCHIVE_PATH=${COLLECTION_PATH}/archive
export COLLECTION_INDEXES_PATH=${COLLECTION_PATH}/indexes
export COLLECTION_INDEX=${COLLECTION_PATH}/indexes/index.cdxj
export INDEX_BACKUP_PATH=/mnt/index/cdxj-archive
export INDEX_BACKUP_LOGS_PATH=/mnt/index/cdxj-archive/logs
export INDEXER=cdxj-indexer

create_index () {
    ARCHIVE_PATH=$1
    ARCHIVE_NAME=$(basename ${ARCHIVE_PATH})
    INDEX_PATH=${COLLECTION_PATH}/${ARCHIVE_NAME}.cdxj
    if [ -f ${INDEX_BACKUP_PATH}/${ARCHIVE_NAME} ]; then
                echo "Index for ${ARCHIVE_NAME} already exists in cdxj-archive. Making local copy instead of indexing."
                cp ${INDEX_BACKUP_PATH}/${ARCHIVE_NAME}.cdxj ${INDEX_PATH}
        else
                echo "Processing ${ARCHIVE_PATH} into ${INDEX_PATH}"
                ${INDEXER} -s ${ARCHIVE_PATH} -o ${INDEX_PATH} \
                        > ${INDEX_BACKUP_LOGS_PATH}/${ARCHIVE_NAME}.cdxj.stdout \
                        2> ${INDEX_BACKUP_LOGS_PATH}/${ARCHIVE_NAME}.cdxj.stderr
    fi

}

export -f create_index

find ${COLLECTION_ARCHIVE_PATH} -type l \( -name "*.warc.gz" -o -name "*.arc.gz" \) -exec bash -c 'create_index "$0"' {} \;

echo "Archive indexes created in ${COLLECTION_PATH}/"
echo "Merging & sorting all indexes to ${COLLECTION_INDEX}"
LANG=C.UTF-8 sort ${COLLECTION_PATH}/*.cdxj > ${COLLECTION_INDEX}
echo "Collection ${COLLECTION_NAME} index created in ${COLLECTION_INDEX}"
echo "Moving archive indexes to ${INDEX_BACKUP_PATH}"
mv ${COLLECTION_PATH}/*.cdxj ${INDEX_BACKUP_PATH}/
echo "Indexes moved to ${INDEX_BACKUP_PATH}. Nothing left to do. My work is done. Happy Oink! <=~"
echo "Check out https://pywb.webarchiv.cz/${COLLECTION_NAME}/"