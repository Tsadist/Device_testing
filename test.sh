#!/bin/bash
/home/pi/7600/wan.sh > wan.txt
cat wan.txt
kod2=$(echo $?)
#echo $kod2

        if [[ $kod2 == 0 ]]
        then
                echo "Подключение к интернету прошло успешно" >> results.txt
                whiptail --title "Проверка модема sim7600" --msgbox "Прошивка загружена успешно" 10 60
        else
                echo "Возникли проблемы при загрузке прошивки" >> results.txt
                whiptail --title "Проверка модема sim7600" --msgbox "Возникли проблемы при загрузке прошивки" 10 60
        fi

sed '1067s/  reset = 25;/  reset = 5;/' /usr/local/etc/avrdude.conf
awk '/wwan0/{print $0}' wan.txt
rm wan.txt
