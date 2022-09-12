#!/bin/bash
. ./diabox.sh
. ./result.sh

function firmware_common {

sed -i '1067s/  reset = 25;/  reset = 5;/' /usr/local/etc/avrdude.conf
sed -i '1068s/#  reset = 5;/#  reset = 25;/' /usr/local/etc/avrdude.conf
sed -i '1069s/  baudrate=400000;/  baudrate = 12000;/' /usr/local/etc/avrdude.conf
sed -i '1070s/#  baudrate=12000;/#  baudrate = 400000;/' /usr/local/etc/avrdude.conf

}

function firmware_halt {
title="Прошивка устройства"
firmware_common

str=$(grep -c '^dtoverlay=gpio-poweroff,active_low="y",gpiopin=6,input,active_delay_ms=0,inactive_delay_ms=0' /boot/config.txt)

if [[ $str == "1" ]]
        then
	mbox "$title" "Начата загрузка прошивки. "
        $1 $2
        kod1=$(echo $?)
        echo $kod1

        if [[ $kod1 == 0 ]]
        then
                echo "Прошивка загружена успешно" >> results.txt
                mbox "$title" "Прошивка загружена успешно. Устройство будет отключено"
		result
		sudo halt
        else
                echo "Возникли проблемы при загрузке прошивки" >> results.txt
                mbox "$title" "Возникли проблемы при загрузке прошивки"
        fi

        else
                mbox "$title" "В файле конфигурации не найдена требуемая строка"
fi

}


function firmware_no_halt {

title="Прошивка устройства"
firmware_common

str=$(grep -c '^dtoverlay=gpio-poweroff,active_low="y",gpiopin=6,input,active_delay_ms=0,inactive_delay_ms=0' /boot/config.txt)

if [[ $str == "1" ]]
        then
	$1 $2
	kod1=$(echo $?)
	echo $kod1

	if [[ $kod1 == 0 ]]
	then
		echo "Прошивка загружена успешно" >> results.txt
		mbox "$title" "Прошивка загружена успешно"
	else
		echo "Возникли проблемы при загрузке прошивки" >> results.txt
        	mbox "$title" "Возникли проблемы при загрузке прошивки"
	fi

	else
		mbox "$title" "В файле конфигурации не найдена требуемая строка"
fi
}

#firmware_no_halt
