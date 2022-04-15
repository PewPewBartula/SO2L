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
    for i in ${DIR1}/*; do
        #Jesli plik jest linkiem
        if [ -L ${i} ] ; then
            #Jesli link jest uszkodzony
            if [ ! -e ${i} ] ; then
                #Usuniecie uszkodzonego linku
                rm ${i}
                #Wpisanie uszkodzonego pilu do wskazanego pliku
                if [[ -f ${DIR2} ]]; then
                    echo "${i,,} $(date +"%Y-%m-%d")" >> ${DIR2}
                fi
            fi
        fi
    done
fi