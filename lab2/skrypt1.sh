#!/bin/bash 

DIR1=${1} 
DIR2=${2} 

#Sprawdzenie czy podane katalogi istnieja
if [[ ! -e ${DIR1} || ! -e ${DIR2} ]]; then
    echo "Error: Given path doesn't exist"
    exit 1
fi

#Sprawdzenie czy podano dwa argumenty
if [[ ! ${DIR1} || ! ${DIR2} ]]; then
    echo "Error: Two paths have to be added as arguments"
    exit 1
fi

set -eu

#Jesli pierwszy argument to katalog 
if [[ -d ${DIR1} ]]; then
    #Wypisanie plikow
    echo "First path consists of:"
    for i in ${DIR1}/*; do
        #Informacja o odnalezieniu pliku
        if [[ -f ${i} ]]; then
            echo "File: ${i}"
            #Informacja o odnalezieniu linku
            if [[ -L ${i} ]]; then
                echo "File: ${i} is a link"
            elif [[ -d ${DIR2} ]]; then
            #sam plik z rozszerzeniem
            FE=${i##*/}
            #rozszerzenie
            E=${i##*.}
            #sam plik
            F=${FE%.*}
            #plik z dużych
            F=${F^^}
            #plik z dużych + _ln + rozszerzenie
            F=${F}"_ln."${E}

            #Linkowanie pliku do drugiej sciezki
            ln -sf "$(readlink -f ${i})" ${DIR2}/${F}

            fi
        fi
        #Informacja o odnalezieniu katalogu
        if [[ -d ${i} ]]; then
            echo "Directory: ${i}"
            #sam katalog
            F=${i##*/}
            #katalog z dużych
            F=${F^^}
            #katalog z dużych + _ln
            F=${F}"_ln"

            #Linkowanie katalogu do drugiej sciezki
            ln -sf "$(readlink -f ${i})" ${DIR2}/${F}
        fi
    done
fi

