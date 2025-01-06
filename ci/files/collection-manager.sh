#!/usr/bin/env bash

# Make Bash Great Again
set -o errexit # exit when a command fails.
set -o nounset # exit when using undeclared variables
set -o pipefail # catch non-zero exit code in pipes
# set -o xtrace # uncomment for bug hunting

script_usage () {
cat << EOF
Webarchiv.cz collection manager create symlinks to archives in structured way. It translate physical structure of archives to pywb collections. Goal is to expose collections to curators in meaningful way.

Collection manager accepts only single parameter -> archive year in format YY.
One of these: 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25.

Usage: ./collection-manager.sh YY
Example: ./collection-manager.sh 05
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


# /mnt/archive/15 is empty and nowhere to be found.
param="$1"
case $param in
		13)
			ARCHIVE_YEAR=13
			SEARCH_ROOT_DIR=/mnt/datas/178/archive13
			;;
		14)
			ARCHIVE_YEAR=14
			SEARCH_ROOT_DIR="/mnt/datas/178/archive14 /mnt/datas/178/archive14 /mnt/datas/178/archive14Serials /mnt/datas/178/Archive14NDK-part /mnt/datas/180"
			;;
		16)
			ARCHIVE_YEAR=16
			SEARCH_ROOT_DIR=/mnt/datas/181/archive16
			;;
		17)
			ARCHIVE_YEAR=17
			SEARCH_ROOT_DIR=/mnt/datas/181/archive17
			;;
		18)
			ARCHIVE_YEAR=18
			SEARCH_ROOT_DIR=/mnt/datas/179/archive18
			;;
		19)
			ARCHIVE_YEAR=19
			SEARCH_ROOT_DIR=/mnt/datas/181/archive19
			;;
		20)
			ARCHIVE_YEAR=20
			SEARCH_ROOT_DIR="/mnt/archive/20 /mnt/handsbery/manuals/2020"
			;;
		21)
			ARCHIVE_YEAR=21
			SEARCH_ROOT_DIR="/mnt/archive/21 /mnt/handsbery/manuals/2021"
			;;
		22)
			ARCHIVE_YEAR=22
			SEARCH_ROOT_DIR="/mnt/archive/22 /mnt/handsbery/manuals/2022"
			;;
		24)
			ARCHIVE_YEAR=24
			SEARCH_ROOT_DIR="/mnt/datas/181/archive24 /mnt/archive/24"
			;;
        05|06|07|08|09|10|11|12|15|23|25)
			ARCHIVE_YEAR=$param
			SEARCH_ROOT_DIR=/mnt/archive/${ARCHIVE_YEAR}
        	;;
        *)
        	"Invalid parameter was provided: $param"
			exit 1
        ;;
esac

# Exported for availability in spawned find exec subshell
export ARCHIVE_YEAR
export ARCHIVE_SYMLINK_ROOT_DIR=/mnt/index/collections/wayback/archive
export COLLECTIONS_ROOT_DIR=/mnt/index/collections/

echo "Processing Archive: $param. Mounted at ${SEARCH_ROOT_DIR}. Time for coffer break."

create_collection () {
mkdir -p ${COLLECTION_PATH}/archive
mkdir -p ${COLLECTION_PATH}/indexes
mkdir -p ${COLLECTION_PATH}/acl
mkdir -p ${COLLECTION_PATH}/templates
mkdir -p ${COLLECTION_PATH}/static
# Following two dirs are not used yet, but we can create them for future use to split logs and temporary index files from collection root.
mkdir -p ${COLLECTION_PATH}/logs
mkdir -p ${COLLECTION_PATH}/tmp
if [ ! -L ${COLLECTION_PATH}/archive/${ARCHIVE_NAME} ]; then
        ln -s ${ARCHIVE_PATH} ${COLLECTION_PATH}/archive/
fi
}

create_collection_structure () {
ARCHIVE_PATH=$1
ARCHIVE_NAME=$(basename ${ARCHIVE_PATH})
ARCHIVE_PATH_DIR=$(dirname ${ARCHIVE_PATH})
COLLECTION_PATH=${COLLECTIONS_ROOT_DIR}${ARCHIVE_YEAR}-$(basename ${ARCHIVE_PATH_DIR})


case "${ARCHIVE_PATH_DIR}" in
        *ArchiveIt*)
                COLLECTION_PATH=${COLLECTIONS_ROOT_DIR}${ARCHIVE_YEAR}-ArchiveIt
                # echo ArchiveIt Collection ${COLLECTION_PATH}
                create_collection
                ;;

        *Continuous*)
                case "${ARCHIVE_PATH_DIR}" in
                        *UkraineWar*)
                                COLLECTION_PATH=${COLLECTIONS_ROOT_DIR}${ARCHIVE_YEAR}-Continuous-UkraineWar
                                # echo UkraineWar - Continuous Collection ${COLLECTION_PATH}
                                create_collection
                                ;;
                        *Cov19*)
                                COLLECTION_PATH=${COLLECTIONS_ROOT_DIR}${ARCHIVE_YEAR}-Continuous-Cov19
                                # echo Covid19 - Continuous Collection ${COLLECTION_PATH}
                                create_collection
                                ;;
                        *NewsDigest*)
                                COLLECTION_PATH=${COLLECTIONS_ROOT_DIR}${ARCHIVE_YEAR}-Continuous-NewsDigest
                                # echo NewDigest - Continuous Collection ${COLLECTION_PATH}
                                create_collection
                                ;;
                        *)
								COLLECTION_PATH=${COLLECTIONS_ROOT_DIR}${ARCHIVE_YEAR}-Continuous
                                # echo Warning! Unknown Continuous Collection
                                create_collection
                                ;;
                esac
                ;;
        *crawler*)
                COLLECTION_PATH=${COLLECTIONS_ROOT_DIR}${ARCHIVE_YEAR}-NDK
                # echo NDK Collection ${COLLECTION_PATH}
                create_collection
                ;;
		*manuals*)
                COLLECTION_PATH=${COLLECTIONS_ROOT_DIR}${ARCHIVE_YEAR}-Manuals
                # echo Manual Collection ${COLLECTION_PATH}
                create_collection
                ;;
		*novaBudovaNK|*novaBudovaNK*)
				COLLECTION_PATH=${COLLECTIONS_ROOT_DIR}novaBudovaNK
                # echo novaBudovaNK - Topics Collection ${COLLECTION_PATH}
                create_collection
				;;
		*novaBudovaSTK|*novaBudovaSTK*)
				COLLECTION_PATH=${COLLECTIONS_ROOT_DIR}novaBudovaSTK
                # echo novaBudovaSTK - Topics Collection ${COLLECTION_PATH}
                create_collection
				;;
        *Serials*|*serials)
                COLLECTION_PATH=${COLLECTIONS_ROOT_DIR}${ARCHIVE_YEAR}-Serials
                # echo Serials Collection ${COLLECTION_PATH}
                create_collection
                ;;
        *Tests|*Tests*|*test_files|*test_files*|*Test|*Test*|*test_*)
                COLLECTION_PATH=${COLLECTIONS_ROOT_DIR}${ARCHIVE_YEAR}-Tests
                # echo Tests Collection ${COLLECTION_PATH}
                create_collection
                ;;
        *Topics*)
                case "${ARCHIVE_PATH_DIR}" in
                        *Cov19|*Cov19*|*covid19*|*covid19)
                                COLLECTION_PATH=${COLLECTIONS_ROOT_DIR}${ARCHIVE_YEAR}-Topics-Cov19
                                # echo Cov19 - Topic Collection ${COLLECTION_PATH}
                                create_collection
                                ;;
                        *PrezidentskeVolby2023|*PrezidentskeVolby2023*)
                                COLLECTION_PATH=${COLLECTIONS_ROOT_DIR}${ARCHIVE_YEAR}-Topics-PrezidentskeVolby2023
                                # echo PrezidentskeVolby2023 - Topic Collection ${COLLECTION_PATH}
                                create_collection
                                ;;

						*VolbyKrajeSenat2020|*VolbyKrajeSenat2020*)
                                COLLECTION_PATH=${COLLECTIONS_ROOT_DIR}${ARCHIVE_YEAR}-Topics-VolbyKrajeSenat2020
                                # echo VolbyKrajeSenat2020 - Topic Collection ${COLLECTION_PATH}
                                create_collection
                                ;;
						*verejnopravni_puvodci|*verejnopravni_puvodci*)
                                COLLECTION_PATH=${COLLECTIONS_ROOT_DIR}${ARCHIVE_YEAR}-Topics-verejnopravni_puvodci
                                # echo verejnopravni_puvodci - Topic Collection ${COLLECTION_PATH}
                                create_collection
                                ;;
						*Volby_PS|*Volby_PS*)
                                COLLECTION_PATH=${COLLECTIONS_ROOT_DIR}${ARCHIVE_YEAR}-Topics-Volby_PS
                                # echo Volby_PS - Topic Collection ${COLLECTION_PATH}
                                create_collection
                                ;;

                        *)
                                # echo Warning! Unknown or Aggregated Topic Collection
                                COLLECTION_PATH=${COLLECTIONS_ROOT_DIR}${ARCHIVE_YEAR}-Topics
                                create_collection
                                ;;
                esac
                ;;
        *)
                # echo Standard Collection
                create_collection
        ;;
esac

}
# Make function available in shell spawned by find exec
export -f create_collection_structure
export -f create_collection

# Find splitting argument from find outuput in exec should be safer according to stracktrace
find ${SEARCH_ROOT_DIR} -type f \( -name "*.warc.gz" -o -name "*.arc.gz" \) -exec bash -c 'create_collection_structure "$0"' {} \;

#echo symbolic links to archives prexising\t ${ARCHIVE_SYMLINK_EXISTS_COUNT}
#echo symbolic links to archives created\t ${ARCHIVE_SYMLINK_CREATED_COUNT}