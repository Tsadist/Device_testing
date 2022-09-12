#!/bin/bash
. ./diabox.sh

sudo dtparam spi=on

function mega328p {
mbox "Проверка процессора" "Проверка процессора начата"
sudo dtparam spi=on

count=$(./test_atm | grep -c "param=[1-9][0-9]*")
#echo $count
if [[ $count -eq 7 ]]
then
	pwd=$(./test_atm | awk '/PWD.*param=/{print $10}' | awk -F= '{print $2}')
	#echo $pwd
	if [[ $pwd -le 6 ]];
	then
		echo "Процессор от mega328p работает" >> results.txt
		mbox "Проверка процессора" "Процессор от mega328p работает"
		mbox "Проверка процессора" "Отправьте на номер телефона, который вам звонил смс с паролем: $pwd. Устройство должно перезагрузится"
	else
		echo "Возникли проблемы с паролем процессора" >> results.txt
		if (whiptail --title "Проверка процессора" --yesno "Возникли проблемы с паролем процессора. Вывести пароль?" 10 60 )
		then
		mbox "Проверка процессора" "Пароль: $pwd"
		fi
	fi
	  	v5=$(./test_atm | awk '/5V.*param=/{print $10}' | awk -F= '{print $2}')
                A=$((v5 * 10 / 1000 ))
                B=$((v5 % 100 ))
                echo "При 5-ти вольтах устройство выдаёт $A.$B миливольт" >> results.txt

                v12=$(./test_atm | awk '/12V.*param=/{print $10}' | awk -F= '{print $2}')
                C=$((v12 * 10 / 1000 ))
                D=$((v12 % 100 ))
                echo "При 12-ти вольтах устройство выдаёт $C.$D миливольт" >> results.txt
else
	echo "Возникли проблемы с процессором" >> results.txt
fi

}
#mega328p
