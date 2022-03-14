#!/bin/bash

#Pobiera 3 argumenty
#Wartosci domyslne argumentow

SOURCE_DIR=${1:-"lab_uno"}
RM_LIST=${2:-"2remove"}
TARGET_DIR=${3:-"bakap"}

#Jezeli TARGET_DIR nie istnieje, to jest tworzony
if [[ ! -d ${TARGET_DIR} ]]; then
    mkdir ${TARGET_DIR}
    #echo "Jest"
fi

#Iterujemy po zawartosci pliku RM_LIST
FILES=$(cat ${RM_LIST})
for FILE in ${FILES}; do
    #echo "${FILE}"
    #Jesli plik o takiej nazwie istnieje w katalogu SOURCE_DIR to go usuwamy
    if [[ -f ${SOURCE_DIR}/${FILE} ]]; then
        rm ${SOURCE_DIR}/${FILE}
        #echo "Usunieto"
    fi
done

#Jezeli pliku nie ma na liscie RM_LIST, ale jest katalogiem, to kopiujemy do TARGET_DIR z zawartoscia
FILES=$(ls ${SOURCE_DIR})
for FILE in ${FILES}; do
     if [[ -d ${SOURCE_DIR}/${FILE} ]]; then
        cp -R ${SOURCE_DIR}/${FILE} $TARGET_DIR
    fi
done

