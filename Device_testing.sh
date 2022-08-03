#!/bin/bash
source Testing.sh

OPTION=$(whiptail --title "Перечень устройств" --menu "Выберете устройство для тестирования" 20 85 7 \
"1" 'Мезонинная плата "Мезонин Duo" (2-х симочная) для "Умный двор" (Smart gate)' \
"2" 'Мезонинная плата "Мезонин Duo". Процессор от mega328p' \
"3" 'Мезонинная плата "Мезонин Uno" (1 симочная) для "Умный двор" (Smart gate)' \
"10" 'Отдельный модуль' 3>&1 1>&2 2>&3)


function get {
echo $1 > conf.txt
test
}

case $OPTION in

1)
	get 'Мезонинная плата "Мезонин Duo" (2-х симочная) для "Умный двор" (Smart gate)';;
2)
	get 'Мезонинная плата "Мезонин Duo". Процессор от mega328p';;
3)
	get 'Мезонинная плата "Мезонин Uno" (1 симочная) для "Умный двор" (Smart gate)';;
10)
	OPTION=$(whiptail --title "Перечень модулей" --menu "Выберете модуль для тестирования" 20 70 7 \
	"1" "GSM модуль sim800" \
	"2" "Переферийный процессор от mega328p" \
	"3" 'Выходы "сухой контакт" / реле' \
	"4" 'Ключи камер' \
	"5" 'Модем sim7600' 3>&1 1>&2 2>&3)

	case $OPTION in
	1)
	get 'GSM модуль sim800';;
	2)
	get 'Переферийный процессор от mega328p';;
	3)
	get 'Выходы "сухой контакт" / реле' ;;
	4)
	get 'Ключи камер' ;;
	5)
	get 'Модем sim7600' ;;
	esac
esac

cat conf.txt
