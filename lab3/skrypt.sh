#!/bin/bash 

set -eu

#W pliku access_log
if [[ ${1} == "./access_log" ]]; then
    #Zapytania ktore maja fraze "denied" w linku
    grep "/*denied*" ./access_log
    #Zapytania wyslane z IP:64.242.88.10
    grep "64.242.88.10 - - *" ./access_log
    #Unikalne 10 adresow IP
    grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}" ./access_log | sort -u | head -n 10
    #Unikalne zapytania typu DELETE
    grep "\"DELETE*" ./access_log | sort -u
fi

#W pliku yolo.csv
if [[ ${1} == "./yolo.csv" ]]; then
    #Wypisanie osob z nieparzystym id na wyjscie bledow
    tail --lines +2 yolo.csv | grep -E "^[[:digit:]]*[1,3,5,7,9]," >&2
    #Wypisanie osob wartych dokladnie 2.99 lub 5.99 lub 9.99 (M lub B)
    tail --lines +2 yolo.csv | grep -E "\\\$[259]\.99[BM]$" >&2  
fi

# w plikach katalogu 'groovies'
if [[ ${1} == "./groovies" ]]; then
    for i in ./groovies/*; do
        #zamien HEADER na temat
        sed -i 's/HEADER/temat/g' ${i}
        #usun linie zawierajace "Help docs:"
        sed -i '/Help docs:/d' ${i}
    done
fi

# uruchom skrypt fakaping.sh
if [[ ${1} == "./fakaping.sh" ]]; then
    # linijki z zakonczeniem .conf wypisz na ekran i do pliku find_results.log
    ./fakaping.sh | grep -E "\.conf$" | tee find_results.log
    # bledy do pliku errors.log
    ./fakaping.sh 2> errors.log
    # standardowe wyjscie do nicosci, bledy posortuj (bez duplikatow)
    ./fakaping.sh 1> /dev/null 2> >(sort -u >> sorted.err)
    # errory zawierajace permission denied wypisz na ekran i do pliku denied.log (wyniki unikalne)
    ./fakaping.sh |& grep -i "permission denied" | sort -u | tee denied.log
fi