#!/bin/bash
. ./diabox.sh
. ./result.sh

function ATtiny13 {

title="Комплексная проверка"

sudo hwclock -w
kod=$(echo $?)
if [ $kod == 0 ]
then
	text1="Часы синхронизированы"
	mbox "$title" "$text1"
	echo "$text1" >> results.txt

num1=$(grep -c rtc_time /proc/driver/rtc)
num2=$(grep -c rtc_date /proc/driver/rtc)
let sum=$num1+$num2
#echo $sum

if [ $sum == 2 ]
then

        sudo sh -c "echo 0 > /sys/class/rtc/rtc0/wakealarm"
	kod=$(echo $?)
	#echo $kod
	if [ $kod == 0 ]
	then
		text1="Будильник очищен"
		mbox "$title" "$text1"
		echo $text1 >> results.txt
	else
		text2="Возникли проблемы при очистке будильника"
                mbox "$title" "$text2"
                echo $text2 >> results.txt
	fi

	sudo sh -c "echo `date '+%s' -d '+ 1 minutes'` > /sys/class/rtc/rtc0/wakealarm"
	kod=$(echo $?)
	#echo $kod
	if [[ $kod == 0 && `grep -c "alarm_IRQ\s:\syes" /proc/driver/rtc` == 1 ]]
        then
                text1="Будильник установлен на 1 минуту"
                mbox "$title" "$text1. После демонстрации результатов проверки устройство будет отключено. Оно должно включится само по установленному будильнику."
                echo $text1 >> results.txt
		result
		sudo halt
        else
                text2="Возникли проблемы при установке будильника"
                mbox "$title" "$text2"
                echo $text2 >> results.txt
        fi

fi

else
        text2="Проблема с синхронизацией часов"
        mbox "$title" "$test2"
        echo "$text2" >> results.txt
fi
}
#ATtiny13
