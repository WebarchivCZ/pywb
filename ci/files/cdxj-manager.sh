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

export FORCE_REINDEX="false"

if [ $# -eq 0 ]; then
        script_usage
        exit 0
elif [ $# -eq 2 ]; then
        if [ "$2" = "force_reindex" ]; then
                export FORCE_REINDEX="true"
elif [ $# -gt 2 ]; then
        echo -e "Error! Too many parameters provided!\n"
        script_usage
        exit 1
fi

export COLLECTION_NAME="$1"
export COLLECTIONS_ROOT_PATH="/mnt/index/collections"
export COLLECTION_PATH="${COLLECTIONS_ROOT_PATH}/${COLLECTION_NAME}"
export COLLECTION_ARCHIVE_PATH="${COLLECTION_PATH}/archive"
export COLLECTION_INDEXES_PATH="${COLLECTION_PATH}/indexes"
export COLLECTION_INDEX="${COLLECTION_PATH}/indexes/index.cdxj"
export INDEX_BACKUP_PATH="/mnt/index/cdxj-archive"
export INDEX_BACKUP_LOGS_PATH="/mnt/index/cdxj-archive/logs"
export INDEXER="cdxj-indexer"
export COLLECTION_TMP_PATH="${COLLECTION_PATH}/tmp"
export COLLECTION_LOGS_PATH="${COLLECTION_PATH}/logs"
export SORT_TMP_PATH="/mnt/index/sort-tmp/" # Directory used to store temporary files by the sort command. Needs at least few TB of free space.

echo "[$(date -u --iso-8601=seconds)] Processing ${COLLECTION_NAME}"
create_index () {
        ARCHIVE_PATH="$1"
        ARCHIVE_NAME="$(basename ${ARCHIVE_PATH})"
        INDEX_PATH="${COLLECTION_TMP_PATH}/${ARCHIVE_NAME}.cdxj"
        if [ -f ${INDEX_PATH} ] && [ "$FORCE_REINDEX" != "true" ]; then
                echo "[$(date -u --iso-8601=seconds)] Index for ${ARCHIVE_NAME} already found in collection. No action required." \
                        >> ${COLLECTION_LOGS_PATH}/$(date -u --iso-8601).log
        elif [ -f ${INDEX_BACKUP_PATH}/${ARCHIVE_NAME}.cdxj ] && [ "$FORCE_REINDEX" != "true" ]; then
                echo "[$(date -u --iso-8601=seconds)] Index for ${ARCHIVE_NAME} already exists in cdxj-archive. Making local copy instead of indexing." \
                        >> ${COLLECTION_LOGS_PATH}/$(date -u --iso-8601).log
                cp ${INDEX_BACKUP_PATH}/${ARCHIVE_NAME}.cdxj ${INDEX_PATH}
        else
                echo "[$(date -u --iso-8601=seconds)] Processing ${ARCHIVE_PATH} into ${INDEX_PATH}" \
                        >> ${COLLECTION_LOGS_PATH}/$(date -u --iso-8601).log
                ${INDEXER} -s ${ARCHIVE_PATH} -o ${INDEX_PATH} \
                        2> ${INDEX_BACKUP_LOGS_PATH}/${ARCHIVE_NAME}.cdxj.stderr
                # Delete empty stderr logs
                [ -s ${INDEX_BACKUP_LOGS_PATH}/${ARCHIVE_NAME}.cdxj.stderr ] || rm ${INDEX_BACKUP_LOGS_PATH}/${ARCHIVE_NAME}.cdxj.stderr
                # copy new index file to backup dir
                cp "${INDEX_PATH}" "${INDEX_BACKUP_PATH}/"
        fi
}

export -f create_index

/usr/bin/time --format='elapsed wall time: %E\ncpu: %P\nuser: %U\nsys: %S' \
        find ${COLLECTION_ARCHIVE_PATH} -type l \( -name "*.warc.gz" -o -name "*.arc.gz" -o -name "*.warc" \) -exec bash -c 'create_index "$0"' {} \;

echo "Archive indexes created in ${COLLECTION_PATH}/"

echo "[$(date -u --iso-8601=seconds)] Merging & sorting all indexes to ${COLLECTION_INDEX}"
# Use find to print0 file names into sort, globular expressions cannot work, becouse we reached the limit on number of arguments
find "${COLLECTION_TMP_PATH}" -type f -name '*.cdxj' -print0 | LANG=C.UTF-8 sort -u --files0-from=- -T ${SORT_TMP_PATH} > ${COLLECTION_INDEX}
echo "[$(date -u --iso-8601=seconds)] Collection ${COLLECTION_NAME} index created in ${COLLECTION_INDEX}"

# Remove indexes from tmp directory
echo "[$(date -u --iso-8601=seconds)] Removing old files from ${COLLECTION_TMP_PATH}"
find "${COLLECTION_TMP_PATH}" -maxdepth 1 -type f -name '*.cdxj' -exec rm '{}' \;
echo "[$(date -u --iso-8601=seconds)] Done removing old files"

echo "Finished indexing collection ${COLLECTION_NAME}. Nothing left to do. My work is done. Happy Oink! <=~"
echo "Check out https://pywb.webarchiv.cz/${COLLECTION_NAME}/"
echo "[$(date -u --iso-8601=seconds)] Collection Ready" >> ${COLLECTION_LOGS_PATH}/$(date -u --iso-8601).log