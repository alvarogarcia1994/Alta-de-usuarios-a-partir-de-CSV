#!/bin/bash
#source /home/alvaro/myscript.conf

#Versión 2 del script

if [ -z $uidnum ]
then
    Uid=10000
else
    Uid=$(($uidnum+1))
fi

comprobafile(){
	#Función que se encargará de comprobar: la existencia del fichero y el parámetro
	if [[ -z $archivo ]]; then
		echo "El parámetro del archivo está vacío o no se ha especificado"
	elif [[ ! -e $archivo ]]; then
		echo "El fichero $archivo es inexistente o inaccesible"
		exit
	fi
}

while [ $# -ne 0 ]
do
	case $1 in
		-a | --archivo)
			archivo=$2;
			shift;
			;;
		*)
			echo -e "Parámetro no válido"
			shift;
			;;
	esac
	shift
done

comprobafile

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
	pwd=$(openssl rand -base64 $longPWD)
	echo "userPassword: $pwd)" >> altas.ldif
	echo "loginShell: /bin/bash" >> altas.ldif
	echo "homeDirectory: /home/$nom" >> altas.ldif
	echo "gecos: $nom" >> altas.ldif
	echo "">> altas.ldif

	#Generamos el fichero .log
	echo "uid:$nom userPassword: $pwd" >> garcia.log
done < $archivo
#sed
sed -i 'y/áàäâåÁÀÄÂÅéèëêÉÈËÊíìïîÍÌÏÎóòöôÓÒÖÔúùüûÚÙÜÛçÇ/aaaaaAAAAAeeeeEEEEiiiiIIIIooooOOOOuuuuUUUUcC/' altas.ldif

#ldapadd
ldapadd -x -D "cn=admin,dc=garcia,dc=local" -W -H ldap:// -f altas.ldif
