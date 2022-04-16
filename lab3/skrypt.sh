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

