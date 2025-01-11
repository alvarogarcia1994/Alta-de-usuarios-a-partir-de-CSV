#!/bin/bash
source /home/$(whoami)/myscript.conf

#Versión 3 del script

#Función que se encargará de comprobar: la existencia del fichero y el parámetro
comprobarFichero(){
	if [[ -z $archivo ]]; then
		echo "El parámetro del archivo está vacío o no se ha especificado"
	elif [[ ! -e $archivo ]]; then
		echo "El fichero $archivo es inexistente o inaccesible"
		exit
	fi
}

#Comprobación de parámetros
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

#Llamamos a la función comprobarFicehro
comprobarFichero


#Inicializamos el uidnum en 10000
if [ -z $uidnum ]; then
	Uid = 10000
else
	Uid = $((uidnum + 1))
fi


while IFS=',' read -r nom cognom cognom2
do
	#Distinguished Name
	dn: "uid=$nom$cognom$cognom2,ou=People,$ldapBase"

	#Agregamos los usuarios al fichero LDIF
	echo "$dn" >> altas.ldif
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
done < "$archivo"

#Sustitución de carácteres especiales
sed -i 'y/áàäâåÁÀÄÂÅéèëêÉÈËÊíìïîÍÌÏÎóòöôÓÒÖÔúùüûÚÙÜÛçÇ/aaaaaAAAAAeeeeEEEEiiiiIIIIooooOOOOuuuuUUUUcC/' altas.ldif

#Agregamos las entradas al servidor LDAP
ldapadd -x -D "cn=admin,dc=garcia,dc=local" -W -H ldap:// -f altas.ldif

#Verificamos si el comando ldapadd agregó correctamente las entradas
if [ $? -eq 0 ]; then
	echo "Entradas agregadas correctamente al servidor LDAP";
else
	echo "Error al agregar las entradas al servidor LDAP";
	exit 1
fi