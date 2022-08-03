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
echo $con >> results7600.txt
else
con=`echo "Возникли проблемы при выполнении"`
echo $con >> results7600.txt
fi
killall cat
}

function sim7600 {

stty -F /dev/ttyUSB2 -echo
rm results7600.txt

serport "ATI"
whiptail --title "Проверка модема sim7600" --msgbox "Команда ATI: $con" 10 60

serport "AT+CUSBADB=1"
whiptail --title "Проверка модема sim7600" --msgbox "Команда AT+CUSBADB=1: $con" 10 60

cat /dev/ttyUSB2 > res.log &
touch res.log
echo "AT+CRESET" > /dev/ttyUSB2
echo "..."
cat res.log

{
    for ((i = 0 ; i <= 100 ; i+=3)); do
        sleep 1
        echo $i
    done
} | whiptail --gauge "Идет выполнение команды, подождите пожалуйста" 6 60 0

cat /dev/ttyUSB2 > res.log &
touch res.log
cat res.log

ans=$(cat res.log)
if [[ $ans =~ PB.DONE ]];
then
        con2=`echo "Выполнена успешно"`
        echo $con2 >> results7600.txt
else
        con2=`echo "Возникли проблемы при выполнении"`
        echo $con2 >> results7600.txt
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

{
    for ((i = 0 ; i <= 100 ; i+=6)); do
        sleep 1.5
        echo $i
    done
} | whiptail --gauge "Идет перезагрузка устройста, подождите пожалуйста" 6 60 0


/home/pi/7600/wan.sh > wan.txt
#cat wan.txt
ip=$(grep -A1 "wwan0" wan.txt | grep "inet" | awk '{print $2}' | awk -F. '{print $1}')

rm wan.txt

echo $ip

if [[ $ip < "101"  ]]
then
	echo "IP-адрес соответствует параметрам  и начинается с цифры $ip" >> results.txt
        whiptail --title "Проверка модема sim7600" --msgbox "IP-адрес соответствует параметрам и начинается с цифры $ip" 10 60
else
	echo "IP-адрес не соответствует параметрам  и начинается с цифры $ip" >> results.txt
	whiptail --title "Проверка модема sim7600" --msgbox "IP-адрес не соответствует параметрам  и начинается с цифры $ip" 10 60
fi


ping=$(ping -c 5 8.8.8.8 -I wwan0)
kod2=$(echo $?)
echo $kod2
#echo $ping
if [[ $kod2 == 0 ]]
then
	echo "Интернет соединение успешно работает" >> results.txt
	whiptail --title "Проверка модема sim7600" --msgbox "Интернет соединение успешно работает" 10 60
else
	echo "Команда PING не дала результатов" >> results.txt
	whiptail --title "Проверка модема sim7600" --msgbox "Команда PING не дала результатов" 10 60
fi

res=$(grep 'проблемы' results7600.txt)
echo $res

if [[ $res ]]
then
        echo "С модемом sim7600 возникли проблемы" >> results.txt
        whiptail --title "Проверка модема sim7600" --msgbox "С модемом sim7600 возникли проблемы" 10 60
else
        echo "Модем sim7600 выполняет все требуемые функции" >> results.txt
        whiptail --title "Проверка модема sim7600" --msgbox "Модем sim7600 выполняет все требуемые функции" 10 60
fi

stty -F /dev/ttyUSB4 -echo

cat /dev/ttyUSB4 > res.log &
touch res.log
echo "AT+CONFIG?" > /dev/ttyUSB4
pas=$(grep "Password" res.log | awk -F= '{print $2}')

whiptail --title "Проверка модема sim7600" --msgbox "Отправьте смс с паролем: $pas. Устройство должно перезагрузится" 10 60
rm res.log
killall cat

}


#sim7600
