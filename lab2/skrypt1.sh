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
    #Informacja ze to katalog
    echo "First path consists of:"
    #Wypisanie plikow
    for i in ${DIR1}/*; do
        #Informacja o odnalezieniu pliku
        if [[ -f ${i} ]]; then
            echo "File: ${i}"
            #Informacja o odnalezieniu linku
            if [[ -L ${i} ]]; then
                echo "File: ${i} is a link"
            else
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
            ln -s ${i} ${DIR2}/${F}

            fi
        fi
        #Informacja o odnalezieniu katalogu
        if [[ -d ${i} ]]; then
            echo "Directory: ${i}"
        fi
    done
fi

