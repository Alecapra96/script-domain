#!/bin/sh
sudo apt -y install dialog
# creamos la funcion fundialog 
fundialog=${fundialog=dialog}

echo "Dependencias para el  dominio"
sudo apt -y install sssd-ad sssd-tools realmd adcli sed 
sudo apt-get -y install realmd packagekit

#_______________
dialog --infobox "Bienvenido al script para administrar los permisos del dominio en la maquina!" 5 82 ; sleep 3
#________________

DIALOG=${DIALOG=dialog}
tempfile=`tempfile 2>/dev/null` || tempfile=/tmp/test$$
trap "rm -f $tempfile" 0 1 2 5 15

$DIALOG --backtitle "Creado por : linkedin.com/in/alejandro-capra" \
	--title "PERMISOS DEL DOMINIO" --clear \
        --radiolist "Selecciona con la tecla space el permiso que deseas" 17 100 10 \
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
    echo "Elegiste la opcion '$choice'"
    nombreDominio=`$fundialog --stdout --title "nombre" --inputbox "Escribe el nuevo nombre del dominio mas el .local :" 5 82`
    sudo realm discover $nombreDominio
    if [ $? -eq 0 ] 
    then
        case $choice in
        1)
            echo "Denegar login a todos los usuarios y permitir login de un usuario en particular"
            nombreUsuario=`$fundialog --stdout --title "Denegar login a todos los usuarios y permitir login de un usuario en particular" --inputbox "Escribe el nuevo nombre del usuario que va a poder acceder a esta PC mas el @${nombreDominio}"  5 82`
            sudo realm deny -vR $nombreDominio -a
            sudo realm permit -vR $nombreDominio $nombreUsuario
            ;;
        2)
            echo "Denegar login a todos los usuarios y permitir login de un grupo en particular"
            nombreGrupo=`$fundialog --stdout --title "Denegar login a todos los usuarios y permitir login de un grupo en particular" --inputbox "Escribe el nuevo nombre del grupo mas el @dominio.local que va a poder acceder a esta PC mas el @${nombreDominio}"  5 82`
            sudo realm deny -vR $nombreDominio -a
            sudo realm permit -vR $nombreDominio -g  $nombreGrupo
            ;;
        3) 
            echo "Permitir login a todos los usuarios del realm/Dominio"
            sudo realm permit -vR $nombreDominio -a
            ;;
        4)
            echo "Permitir login a un usuario particular del realm/Dominio"
            nombreUsuario=`$fundialog --stdout --title "Permitir login a un usuario particular del realm/Dominio" --inputbox "Escribe el nuevo nombre del usuario que va a poder acceder a esta PC mas el @${nombreDominio}"  5 82`
            sudo realm permit -vR $nombreDominio $nombreUsuario
            ;;
        5)
            echo "Denegar login a todos los usuarios del realm/Dominio"
            sudo realm deny -vR $nombreDominio -a
            ;;
        6)
            echo "Permitir login a los miembros de un Grupo"
            nombreGrupo=`$fundialog --stdout --title "Permitir login a los miembros de un Grupo" --inputbox "Escribe el nuevo nombre del grupo mas el @dominio.local que va a poder acceder a esta PC mas el @${nombreDominio}"  5 82`
            sudo realm permit -vR $nombreDominio -g $nombreGrupo
            ;;
        7)
            echo "Denegar login a los miembros de un Grupo ya agregado"
            nombreGrupo=`$fundialog --stdout --title "Denegar login a los miembros de un Grupo ya agregado" --inputbox "Escribe el nuevo nombre del grupo mas el @dominio.local que no va a poder acceder a esta PC mas el @${nombreDominio}"  5 82`
            sudo realm permit -vR $nombreDominio -x $nombreGrupo
            ;;
        esac
    else
    dialog --infobox "No elegiste ninguna opcion" 5 82 ; sleep 3

    fi
 ;;

    
  1)
    echo "Cancel pressed.";;
  255)
    echo "ESC pressed.";;
esac
