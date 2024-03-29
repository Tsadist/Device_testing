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
<<<<<<< HEAD
title="Прошивка устройства"
firmware_common
=======

firmware_common

whiptail --title "Прошивка устройства" --msgbox "Начата загрузка прошивки. " 10 60
>>>>>>> 4793d3f7419be00fb618818be08a426dc0baf95c

str=$(grep -c '^dtoverlay=gpio-poweroff,active_low="y",gpiopin=6,input,active_delay_ms=0,inactive_delay_ms=0' /boot/config.txt)

if [[ $str == "1" ]]
        then
<<<<<<< HEAD
	mbox "$title" "Начата загрузка прошивки. "
=======
>>>>>>> 4793d3f7419be00fb618818be08a426dc0baf95c
        $1 $2
        kod1=$(echo $?)
        echo $kod1

        if [[ $kod1 == 0 ]]
        then
                echo "Прошивка загружена успешно" >> results.txt
<<<<<<< HEAD
                mbox "$title" "Прошивка загружена успешно. Устройство будет отключено"
		result
		sudo halt
        else
                echo "Возникли проблемы при загрузке прошивки" >> results.txt
                mbox "$title" "Возникли проблемы при загрузке прошивки"
        fi

        else
                mbox "$title" "В файле конфигурации не найдена требуемая строка"
=======
                whiptail --title "Прошивка устройства" --msgbox "Прошивка загружена успешно. Устройство будет отключено" 10 60
		sudo halt
        else
                echo "Возникли проблемы при загрузке прошивки" >> results.txt
                whiptail --title "Прошивка устройства" --msgbox "Возникли проблемы при загрузке прошивки" 10 60
        fi

        else
                whiptail --title "Прошивка модема sim7600" --msgbox 'В файле конфигурации не найдена требуемая строка' 10 60
>>>>>>> 4793d3f7419be00fb618818be08a426dc0baf95c
fi

}


function firmware_no_halt {

<<<<<<< HEAD
title="Прошивка устройства"
firmware_common

=======
>>>>>>> 4793d3f7419be00fb618818be08a426dc0baf95c
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
<<<<<<< HEAD
		mbox "$title" "В файле конфигурации не найдена требуемая строка"
fi
}

#firmware_no_halt
=======
		whiptail --title "Прошивка модема устройства" --msgbox 'В файле конфигурации не найдена требуемая строка' 10 60
fi
}

#firmware_flash
>>>>>>> 4793d3f7419be00fb618818be08a426dc0baf95c
