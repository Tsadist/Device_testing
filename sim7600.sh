#!/bin/bash

serport () {
cat /dev/ttyUSB2 > res.log &
touch res.log
echo $1 > /dev/ttyUSB2
sleep 1
ans=$(cat res.log)
echo "..."
echo "$ans"
if [[ $ans == *"OK"* ]]
then
con=`echo "Выполнена успешно"`
echo $con >> results.txt
else
con=`echo "Возникли проблемы при выполнении"`
echo $con >> results.txt
fi
killall cat
}

function sim7600 {

stty -F /dev/ttyUSB2 -echo

serport "ATI"
whiptail --title "Проверка модема sim7600" --msgbox "Команда ATI: $con" 10 60

serport "AT+CUSBADB=1"
whiptail --title "Проверка модема sim7600" --msgbox "Команда AT+CUSBADB=1: $con" 10 60

cat /dev/ttyUSB2 >> res.log &
touch res.log
cat res.log
echo "AT+CRESET" > /dev/ttyUSB2
{
    for ((i = 0 ; i <= 100 ; i+=4)); do
        sleep 1.5
        echo $i
    done
} | whiptail --gauge "Идет выполнение команды, подождите пожалуйста" 6 60 0
cat /dev/ttyUSB2 > res.log &
cat res.log


ans=$(cat res.log)
if [[ $ans =~ PB.DONE ]];
then
        con2=`echo "Выполнена успешно"`
        echo $con2 >> results.txt
else
        con2=`echo "Возникли проблемы при выполнении"`
        echo $con2 >> results.txt
fi
whiptail --title "Проверка модема sim7600" --msgbox "Команда AT+CRESET: $con2" 10 60

rm res.log
killall cat


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
                whiptail --title "Проверка модема sim7600" --msgbox "Прошивка загружена успешно" 10 60
        else
                echo "Возникли проблемы при загрузке прошивки" >> results.txt
                whiptail --title "Проверка модема sim7600" --msgbox "Возникли проблемы при загрузке прошивки" 10 60
        fi

        else
                whiptail --title "Проверка модема sim7600" --msgbox 'В файле конфигурации не найдена требуемая строка' 10 60
fi

/home/pi/7600/wan.sh > wan.txt
cat wan.txt
kod2=$(echo $?)
echo $kod2

        if [[ $kod2 == 0 ]]
        then
                echo "Настройка интернет соединения прошла успешно" >> results.txt
                whiptail --title "Проверка модема sim7600" --msgbox "Прошивка загружена успешно" 10 60
        else
                echo "Возникли проблемы при загрузке прошивки" >> results.txt
                whiptail --title "Проверка модема sim7600" --msgbox "Возникли проблемы при загрузке прошивки" 10 60
        fi

}

sim7600
