#!/bin/bash

#Pobiera 3 argumenty
#Wartosci domyslne argumentow
SOURCE_DIR=${1:-"lab_uno"}
RM_LIST=${2:-"2remove"}
TARGET_DIR=${3:-"bakap"}

#Jezeli TARGET_DIR nie istnieje, to jest tworzony
if [[ ! -d ${TARGET_DIR} ]]; then
    mkdir ${TARGET_DIR}
fi

#Iterujemy po zawartosci pliku RM_LIST
FILES=$(cat ${RM_LIST})
for FILE in ${FILES}; do
    #Jesli plik o takiej nazwie istnieje w katalogu SOURCE_DIR to go usuwamy
    if [[ -f ${SOURCE_DIR}/${FILE} ]]; then
        rm ${SOURCE_DIR}/${FILE}
    fi
done

#Jezeli pliku nie ma na liscie RM_LIST, ale jest plikiem regularnym, to przenosimy go do TARGET_DIR
FILES=$(ls ${SOURCE_DIR})
for FILE in ${FILES}; do
    if [[ -f ${SOURCE_DIR}/${FILE} ]]; then
        mv ${SOURCE_DIR}/${FILE} $TARGET_DIR
    fi
done

#Jezeli pliku nie ma na liscie RM_LIST, ale jest katalogiem, to kopiujemy do TARGET_DIR z zawartoscia
FILES=$(ls ${SOURCE_DIR})
for FILE in ${FILES}; do
    if [[ -d ${SOURCE_DIR}/${FILE} ]]; then
        cp -R ${SOURCE_DIR}/${FILE} $TARGET_DIR
    fi
done

#Jezeli po ukonczeniu operacji sa jeszcze jakies pliki w katalogu SOURCE_DIR to wypisujemy odpowiednie komunikaty
ITER=0
for i in ${SOURCE_DIR}/*; do
    if [[ -f ${SOURCE_DIR}/${i} ]]; then
        ITER=$((ITER + 1))
    fi
done

if [[ ITER -gt 0 ]]; then
    echo "Jeszcze cos zostalo"
fi

if [[ ITER -ge 2 ]]; then
    echo "Zostaly conajmniej 2 pliki"
fi

if [[ ITER -gt 4 ]]; then
    echo "Zostalo wiecej niz 4 pliki"
fi

if [[ (ITER -gt 1) && (ITER -lt 4) ]]; then
    echo "Zostalo wiecej niz 1 i mniej niz 4 pliki"
fi

if [[ ITER -eq 0 ]]; then
    echo "Tu byl Kononowicz"
fi

#Po wszystkim spakuj katalog TARGET_DIR i nazwij go bakap_DATA.zip
zip -r bakap_$(date +"%Y-%m-%d").zip bakap
