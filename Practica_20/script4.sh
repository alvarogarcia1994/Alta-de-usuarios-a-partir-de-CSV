#!/bin/bash

#Variables
#datafile=/home/alvaro/MOCK_DATA.csv

#Comprobar usuario
checkuser() {
	if [ id $nom > /dev/null 2>&1 ]
	then
		return 0
	else
		return 1
	fi
}

while read line
do
	nombre=$(echo "${line}" | cut -d, -f1)
	apellido1=$(echo "${line}" | cut -d, -f2)
	apellido2=$(echo "${line}" | cut -d, -f3)
	if checkuser -ge 1; then
		echo "El usuario $nombre ya existe"
		continue
	fi

done < $datafile
