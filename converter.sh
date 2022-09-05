#!/bin/bash

function converter {

cat /dev/ttyS0 > res.log &
touch res.log
echo 'Hello' > /dev/ttyS0
sleep 1
ans=$(cat res.log)
killall cat
echo "..."
#echo "$ans"
if [[ $ans == *"Hello"* ]]
then
	whiptail --title "Проверка преобразователя" --msgbox "Преобразователь работает" 10 60
	echo "Преобразователь работает" >> results.txt
else
	whiptail --title "Проверка преобразователя" --msgbox "Преобразователь не работает" 10 60
        echo "Преобразователь не работает" >> results.txt
fi

rm res.log

}
#converter
