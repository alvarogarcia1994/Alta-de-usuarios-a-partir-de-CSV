#!/bin/bash
#source /home/alvaro/myscript.conf
if [ -z $uidnum ]
then
    Uid=10000
else
    Uid=$(($uidnum+1))
fi

checkuser() {
        if [ id $nom > /dev/null 2>&1 ]
        then
                return 0
        else
                return 1
        fi
}

generapass() {
	found=0
	while [ $found -eq 0 ]		#Bucle encargado de iterar hasta encontrar un password que cumpla los requisitos de complejidad
	do 
		pass
		if [[ $pwd =~ [^a-zA-Z\d\s:] ]]; then
			found=1
		else
			pass
		fi
	done
}

while read line
do
	nom=$(echo $line | cut -d, -f1)
	cognom=$(echo $line | cut -d, -f2)
	cognom2=$(echo $line | cut -d, -f3)
	echo "dn: uid=$nom$cognom$cognom2,ou=People,$ldapBase" >> altas.ldif
	echo "objectClass: inetOrgPerson" >> altas.ldif
	echo "objectClass: posixAccount" >> altas.ldif
	echo "objectClass: shadowAccount" >> altas.ldif
	echo "cn: $nom $cognom $cognom2" >> altas.ldif
	echo "givenName: $nom" >> altas.ldif
	echo "sn: $cognom" >> altas.ldif
	echo "uid: $nomcognom$cognom2" >> altas.ldif
	echo "displayname: $nom" >> altas.ldif
	echo "uidnumber: $Uid" >> altas.ldif
	Uid=$(($Uid+1))
	echo "gidnumber: 6000" >> altas.ldif
	echo "userPassword: $pwd)" >> altas.ldif
	pwd=$((generapass))
	echo "loginShell: /bin/bash" >> altas.ldif
	echo "homeDirectory: /home/$nom" >> altas.ldif
	echo "gecos: $nom" >> altas.ldif
	echo "">> altas.ldif
	
	#Comprobamos que los usuarios existen
	if checkuser -ge 1; then
		echo "El usuario $nombre ya existe"
		continue
	fi
	if checkuser -eq 1; then 
		echo "El usuario $nom no se creará porque ya existe"			#Comprueba que si el usuario ya existe
		continue
	fi
	useradd ${nom} -m --comment "${username} ${cognom} ${cognom2}" > /dev/null
	echo "Usuario $nom creado"
	if [[ $? -eq 0 ]]; then 
		echo -e "El usuario $username se ha creado con password $password \n" >> garcia.log
	else 
		echo -e "--El usuario $username NO se ha creado debido a un ERROR--" >> garcia.log
	fi
	echo "Aplicando el password a $nom :"
	printf "${pwd}\n${pwd}" | passwd ${nom}
	#Generamos el fichero .log
	echo "uid:$nom userPassword: $pwd" >> garcia.log
done < $1
#sed
sed -i 'y/áàäâåÁÀÄÂÅéèëêÉÈËÊíìïîÍÌÏÎóòöôÓÒÖÔúùüûÚÙÜÛçÇ/aaaaaAAAAAeeeeEEEEiiiiIIIIooooOOOOuuuuUUUUcC/' altas.ldif

#ldapadd
ldapadd -x -D "cn=admin,dc=garcia,dc=local" -W -H ldap:// -f altas.ldif
