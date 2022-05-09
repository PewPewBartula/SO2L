#!/bin/bash -eu

HAVE_D=0

function print_help () {
    echo "This script allows to search over movies database"
    echo -e "-y YEAR\n\tSearch movies that were made after given YEAR"
    echo -e "-d DIRECTORY\n\tDirectory with files describing movies"
    echo -e "-a ACTOR\n\tSearch movies that this ACTOR played in"
    echo -e "-t QUERY\n\tSearch movies with given QUERY in title"
    echo -e "-f FILENAME\n\tSaves results to file (default: results.txt)"
    echo -e "-x\n\tPrints results in XML format"
    echo -e "-h\n\tPrints this help message"
}

function print_error () {
    echo -e "\e[31m\033[1m${*@}\033[0m" >&2
}

function get_movies_list () {
    local -r MOVIES_DIR=${1}
    local -r MOVIES_LIST=$(cd "${MOVIES_DIR}" && realpath ./*)
    echo "${MOVIES_LIST}"
}

function query_title () {
    # Returns list of movies from ${1} with ${2} in title slot
    local -r MOVIES_LIST=${1}
    local -r QUERY=${2}

    local RESULTS_LIST=()
    for MOVIE_FILE in ${MOVIES_LIST}; do
        if grep "| Title" "${MOVIE_FILE}" | grep -q "${QUERY}"; then
            RESULTS_LIST+=( "${MOVIE_FILE}" )
        fi
    done
    echo "${RESULTS_LIST[@]:-}"
}

function query_actor () {
    # Returns list of movies from ${1} with ${2} in actor slot
    local -r MOVIES_LIST=${1}
    local -r QUERY=${2}

    local RESULTS_LIST=()
    for MOVIE_FILE in ${MOVIES_LIST}; do
        if grep "| Actors" "${MOVIE_FILE}" | grep -q "${QUERY}"; then
            RESULTS_LIST+=( "${MOVIE_FILE}" )
        fi
    done
    echo "${RESULTS_LIST[@]:-}"
}

function print_movies () {
    local -r MOVIES_LIST=${1}
    local -r OUTPUT_FORMAT=${2}

    for MOVIE_FILE in ${MOVIES_LIST}; do
        if [[ "${OUTPUT_FORMAT}" == "xml" ]]; then
            print_xml_format "${MOVIE_FILE}"
        else
            cat "${MOVIE_FILE}"
        fi
    done
}

function print_xml_format () {
    local -r FILENAME=${1}

    local TEMP
    TEMP=$(cat "${FILENAME}")

    # TODO: replace first line of equals signs

    # TODO: change 'Author:' into <Author>
    # TODO: change others too

    # append tag after each line
    TEMP=$(echo "${TEMP}" | sed -r 's/([A-Za-z]+).*/\0<\/\1>/')

    # replace the last line with </movie>
    TEMP=$(echo "${TEMP}" | sed '$s/===*/<\/movie>/')

    echo "${TEMP}"
}

function querry_after_year() {
    local -r MOVIES_LIST=${1}
    local -r QUERY_YEAR=${2}
    
    local RESULTS_LIST=()
    for MOVIE_FILE in ${MOVIES_LIST}; do
        if grep "| Year:" "${MOVIE_FILE}" | grep -q "${QUERY_YEAR}"; then
            RESULTS_LIST+=( "${MOVIE_FILE}" )
        fi
    done
    echo "${RESULTS_LIST[@]:-}"
}

while getopts ":hd:t:a:f:x:y:" OPT; do
    case ${OPT} in
        y)
            SEARCHING_BY_YEAR=true
            QUERY_YEAR=${OPTARG}
            ;;
        h)
            print_help
            exit 0
            ;;
        d)
            MOVIES_DIR=${OPTARG}
            HAVE_D=1
            ;;
        t)
            SEARCHING_TITLE=true
            QUERY_TITLE=${OPTARG}
            ;;
        f)
            FILE_4_SAVING_RESULTS=${OPTARG}
            ;;
        a)
            SEARCHING_ACTOR=true
            QUERY_ACTOR=${OPTARG}
            ;;
        x)
            OUTPUT_FORMAT="xml"
            ;;
        \?)
            print_error "ERROR: Invalid option: -${OPTARG}"
            exit 1
            ;;
    esac
done

if [[ HAVE_D -eq 0 ]]; then
    echo "Error: No -d flag"
    exit 0
fi

if [[ HAVE_D -eq 1 ]]; then
    if [[ ! -d ${2} ]]; then
        echo "Error: Given movies path isn't a directory"
        exit 0
    fi
fi

MOVIES_LIST=$(get_movies_list "${MOVIES_DIR}")

if ${SEARCHING_BY_YEAR:-false}; then
    MOVIES_LIST=$(querry_after_year "${MOVIES_LIST}" "${QUERY_YEAR}")
fi

if ${SEARCHING_TITLE:-false}; then
    MOVIES_LIST=$(query_title "${MOVIES_LIST}" "${QUERY_TITLE}")
fi

if ${SEARCHING_ACTOR:-false}; then
    MOVIES_LIST=$(query_actor "${MOVIES_LIST}" "${QUERY_ACTOR}")
fi

if [[ "${#MOVIES_LIST}" -lt 1 ]]; then
    echo "Found 0 movies :-("
    exit 0
fi

if [[ "${FILE_4_SAVING_RESULTS:-}" == "" ]]; then
    print_movies "${MOVIES_LIST}" "${OUTPUT_FORMAT:-raw}"
else
    print_movies "${MOVIES_LIST}" "${OUTPUT_FORMAT:-raw}" | tee "${FILE_4_SAVING_RESULTS}"
fi
