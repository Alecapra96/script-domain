#!/bin/sh
sudo apt -y install dialog
# creamos la funcion fundialog 



#_______________
dialog --infobox "Bienvenido al script para administrar los permisos del dominio en la maquina!" 0 0 ; sleep 3
#________________

DIALOG=${DIALOG=dialog}
tempfile=`tempfile 2>/dev/null` || tempfile=/tmp/test$$
trap "rm -f $tempfile" 0 1 2 5 15

$DIALOG --backtitle "Creado por : linkedin.com/in/alejandro-capra" \
	--title "PERMISOS DEL DOMINIO" --clear \
        --radiolist "Selecciona el permiso que deseas" 20 61 5 \
        "1"    "Denegar login a todos los usuarios y permitir login de un usuario en particular" off \
        "2"    "Denegar login a todos los usuarios y permitir login de un grupo en particular" off \
        "3"  "Permitir login a todos los usuarios del realm/Dominio" off \
        "4"    "Permitir login a un usuario particular del realm/Dominio" off \
        "5" "Denegar login a todos los usuarios del realm/Dominio" off \
        "6"    "Permitir login a los miembros de un Grupo" off \
        "7"    "Denegar login a los miembros de un Grupo ya agregado" off  2> $tempfile

retval=$?

choice=`cat $tempfile`
case $retval in
  0)
    echo "'$choice' is your favorite singer";;
  1)
    echo "Cancel pressed.";;
  255)
    echo "ESC pressed.";;
esac