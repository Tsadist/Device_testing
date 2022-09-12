#!/bin/bash
. ./diabox.sh
. ./firmware.sh

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
title="Проверка модема sim7600"

serport "ATI"
mbox "$title" "Команда ATI: $con"

serport "AT+CUSBADB=1"
mbox "$title" "Команда AT+CUSBADB=1: $con"

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
mbox "$title" "Команда AT+CRESET: $con2"

rm res.log
killall cat

firmware_no_halt /home/pi/7600/install.sh

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

#echo $ip

if [[ $ip < "101"  ]]
then
	echo "IP-адрес соответствует параметрам  и начинается с цифры $ip" >> results.txt
	mbox "$title" "IP-адрес соответствует параметрам и начинается с цифры $ip"
else
	echo "IP-адрес не соответствует параметрам  и начинается с цифры $ip" >> results.txt
	mbox "$title" "IP-адрес не соответствует параметрам  и начинается с цифры $ip"
fi


ping=$(ping -c 5 8.8.8.8 -I wwan0)
kod2=$(echo $?)
echo $kod2
#echo $ping
if [[ $kod2 == 0 ]]
then
	echo "Интернет соединение успешно работает" >> results.txt
	mbox "$title" "Интернет соединение успешно работает"
else
	echo "Команда PING не дала результатов" >> results.txt
	mbox "$title" "Команда PING не дала результатов"
fi

res=$(grep 'проблемы' results7600.txt)
echo $res

if [[ $res ]]
then
        echo "С модемом sim7600 возникли проблемы" >> results.txt
	mbox "$title" "С модемом sim7600 возникли проблемы"
else
        echo "Модем sim7600 выполняет все требуемые функции" >> results.txt
	mbox "$title" "Модем sim7600 выполняет все требуемые функции"
fi

stty -F /dev/ttyUSB4 -echo

cat /dev/ttyUSB4 > res.log &
touch res.log
echo "AT+CONFIG?" > /dev/ttyUSB4
pas=$(grep "Password" res.log | awk -F= '{print $2}')

mbox "$title" "Отправьте смс с паролем: $pas. Устройство должно перезагрузится"
rm res.log
killall cat

}

#sim7600
