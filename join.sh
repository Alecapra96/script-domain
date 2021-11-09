#!/bin/sh
sudo apt -y install dialog
# creamos la funcion fundialog 
fundialog=${fundialog=dialog}


#_______________
dialog --infobox "Bienvenido al script para unir una maquina linux a un dominio!" 0 0 ; sleep 3
#________________
echo "Actualizo el sistema"
sudo apt -y install && sudo apt -y upgrade
echo $?
dialog --infobox "Recuerde que el nombre de la pc tiene que tener menos de 15 caracteres!" 0 0 ; sleep 3

dialog --title "Script de ale"  --yesno "¿Deseas unir el equipo al dominio?" 0 0
texto=$?
if [ $texto = "0" ]; then
echo "Dependencias para unir al dominio"
sudo apt -y install sssd-ad sssd-tools realmd adcli sed 
sudo apt-get -y install realmd packagekit

echo "Preparando para unir al dominio"
sleep 2
nombreMaquina=$(hostname)
nombreDominio=`$fundialog --stdout --title "nombre" --inputbox "Escribe el nuevo nombre del dominio mas el .local :" 0 0`

sudo sed -i "1s+.*+${nombreMaquina}.${nombreDominio}+g" /etc/hostname
sudo sed -i "2s+.*+127.0.1.1       ${nombreMaquina}.${nombreDominio}+g" /etc/hosts
sudo rm /etc/systemd/timesyncd.conf
sudo rm /etc/systemd/resolved.conf

sudo echo -e "[Resolve] \nDomains=${nombreDominio}">> ~/resolved.conf
ntpPrincipal=`$fundialog --stdout --title "nombre" --inputbox "Escribe el nuevo nombre del dominio mas el .local :" 0 0`
ntpFallback=`$fundialog --stdout --title "nombre" --inputbox "Escribe el nuevo nombre del dominio mas el .local :" 0 0`

sudo echo -e "[Time] \nNTP=${ntpPrincipal} \nFallbackNTP=${ntpFallback} \n#RootDistanceMaxSec=5 \n#PoolIntervalMinSec=32 \n#PoolIntervalMaxSec=2048">> ~/timesyncd.conf
sudo mv ~/resolved.conf /etc/systemd/resolved.conf
sudo mv  ~/timesyncd.conf /etc/systemd/timesyncd.conf
sudo realm discover ${nombreDominio}
sleep 2
read -p "Ingrese el usuario del dominio: " usuarioAD
sudo realm join -U ${usuarioAD} ${nombreDominio}



echo "Haciendo ajustes finales..."
sleep 1
echo "Script ejectuado.."
echo "Echo por alejandro Capra."
sleep 1
echo "Reiniciando."
sleep 1
echo "Reiniciando.."
sleep 1
echo "Reiniciando..."
sleep 1
sudo reboot
else
echo "Cancelo el script."
fi
