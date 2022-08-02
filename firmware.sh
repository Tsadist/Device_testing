#!/bin/bash

function firmware_flash {
whiptail --title "Прошивка устройства" --msgbox "Начата загрузка прошивки. " 10 60

./flash
kod=$(echo $?)
echo $kod

if [ $kod == 0 ]
then
	echo "Прошивка загружена успешно" >> results.txt
	whiptail --title "Прошивка устройства" --msgbox "Прошивка загружена успешно. Устройство будет отключено" 10 60
	sudo halt
else
	echo "Возникли проблемы при загрузке прошивки" >> results.txt
	whiptail --title "Прошивка устройства" --msgbox "Возникли проблемы при загрузке прошивки" 10 60
fi


}


function firmware_sim7600 {

sed -i '1067s/  reset = 25;/  reset = 5;/' /usr/local/etc/avrdude.conf
sed -i '1068s/#  reset = 5;/#  reset = 25;/' /usr/local/etc/avrdude.conf
sed -i '1069s/  baudrate = 400000;/  baudrate = 12000;/' /usr/local/etc/avrdude.conf
sed -i '1070s/#  baudrate = 12000;/#  baudrate = 400000;/' /usr/local/etc/avrdude.conf

str=$(grep -c '^dtoverlay=gpio-poweroff,active_low="y",gpiopin=6,input,active_delay_ms=0,inactive_delay_ms=0' /boot/config.txt)

if [[ $str == "1" ]]
        then
	/home/pi/7600/install.sh
	kod1=$(echo $?)
	echo $kod1

	if [[ $kod1 == 0 ]]
	then
		echo "Прошивка загружена успешно" >> results.txt
		whiptail --title "Прошивка устройства" --msgbox "Прошивка загружена успешно" 10 60
	else
		echo "Возникли проблемы при загрузке прошивки" >> results.txt
        	whiptail --title "Прошивка устройства" --msgbox "Возникли проблемы при загрузке прошивки" 10 60
	fi

	else
		whiptail --title "Прошивка модема sim7600" --msgbox 'В файле конфигурации не найдена требуемая строка' 10 60
fi
}
