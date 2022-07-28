#!/bin/bash

str=$(grep -c '^dtoverlay=gpio-poweroff,active_low="y"' /boot/config.txt)
if [[ $str < 1 ]]
	then
	whiptail --title "Прошивка модема sim7600" --msgbox 'В файле конфигурации не найдена требуемая строка. Пожалуйста выполните команду sudo nano /boot/config.txt и замените текст строки 82 на: dtoverlay=gpio-poweroff,active_low="y",gpiopin=6,input,active_delay_ms=0,inactive_delay_ms=0 После этого запустите проверку модема sim7600' 15 65
fi
exit
sed -i '1067s/reset = 25;/reset = 5;/' /usr/local/etc/avrdude.conf
sed -i '1068s/baudrate = 400000;/baudrate = 12000;/' /usr/local/etc/avrdude.conf

cd /home/pi/7600
./install.sh >> res
cat res
