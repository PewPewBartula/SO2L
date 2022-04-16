#!/bin/bash 

DIR1=${1}

#Sprawdzenie czy podany katalog istnieje
if [[ ! -e ${DIR1} ]]; then
    echo "Error: Given path doesn't exist"
    exit 1
fi

set -eu

#W zadanym katalogu
for i in ${DIR1}/*; do
    #Plikowi regularnemu z rozszerzeniem bak
    if [[ -f ${i} && ${i##*.} == "bak" ]]; then
        #odbierze wszystkim uprawnienia do edytowania
        chmod a-w ${i}
    #Katalogowi z rozszerzeniem bak
    elif [[ -d ${i} && ${i##*.} == "bak" ]]; then
        #pozwoli wchodzic do srodka tylko innym 
         chmod o+x ${i}
         chmod ug-x ${i}
    #Katalogowi z rozszerzeniem tmp
    elif [[ -d ${i} && ${i##*.} == "tmp" ]]; then
        #pozwoli kazdemu tworzyc i usuwac jego pliki 
         chmod a+rw ${i}
    #Plikowi regularnemu z rozszerzeniem txt
    elif [[ -f ${i} && ${i##*.} == "txt" ]]; then
        #bedzie czytany przez wlasciciela, edytowany przez grupe i wykonywany przez innych
        chmod 421 ${i}
    #Plikowi regularnemu z rozszerzeniem txt
    elif [[ -f ${i} && ${i##*.} == "exe" ]]; then
        #wykonywany przez wszystkich zawsze z uprawnieniami wlasciciela 
        chmod 111 ${i}
    fi
done