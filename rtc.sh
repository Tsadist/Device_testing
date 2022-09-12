#!/bin/bash
<<<<<<< HEAD
. ./diabox.sh

function exam {
num1=$(grep -c "dtparam=i2c_arm=on" /boot/config.txt)
num2=$(grep -c "$1" /boot/config.txt)
let sum=$num1+$num2

if [[ $sum != 2 ]]
then
	mbox "Проверка часов реального времени" "В файле конфигурации не найдена требуемая строка"
	exit
fi
}

function rtc {
title="Проверка часов реального времени"
mbox "$title" "Начата проверка часов реального времени"
if [[ $1 == "mcp" ]]
then
	exam "dtoverlay=i2c-rtc,mcp7940x,wakeup-source"
elif [[ $1 == "ds" ]]
then
	exam "dtoverlay=i2c-rtc,ds1307"
fi
sudo hwclock -w
kod=$(echo $?)
#echo $kod
if [[ $kod == 0 ]]
then
	mbox "$title" "Часы синхронизированы"
	echo "Часы синхронизированы" >> results.txt
else
	mbox "$title" "Возникли проблемы часами реального времени"
        echo "Возникли проблемы часами реального времени" >> results.txt

fi

sleep 2

tim=$(sudo hwclock -r)
kod=$(echo $?)
#echo $kod
if [[ $kod == 0 ]]
then
	mbox "$title" "Время на часах: $tim"
        echo "Время корректно отображается" >> results.txt
else
	mbox "$title" "Возникли проблемы с выводом времени"
        echo "Возникли проблемы с выводом времени" >> results.txt

fi
}

#rtc
=======

sudo hwclock -w
echo $?
sleep 3

sudo hwclock -r
echo $?
>>>>>>> 4793d3f7419be00fb618818be08a426dc0baf95c
