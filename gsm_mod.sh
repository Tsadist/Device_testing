#!/bin/bash
. ./diabox.sh

serport () {
cat /dev/ttyS0 > res.log &
touch res.log
echo $1 > /dev/ttyS0
sleep 1
ans=$(cat res.log)
echo "..."
echo "$ans"
if [[ $ans == *"OK"* ]]
then
con=`echo "Выполнена успешно"`
echo $con >> resultsGSM.txt
else
con=`echo "Возникли проблемы при выполнении"`
echo $con >> resultsGSM.txt
fi
killall cat
}

function GSM {
stty -F /dev/ttyS0 115200 -echo -inlcr
touch resultsGSM.txt
rm resultsGSM.txt
title="Проверка GSM модуля"

serport "ATI"
mbox "$title" "Команда ATI: $con"
if [ -s res.log ]
then

serport "AT+IPR=115200"
mbox "title" "Команда AT+IPR=115200: $con"

serport "AT&W"
mbox "$title" "Команда AT&W: $con"

serport "AT+CREG?"
if [[ $ans == *"0,1"* ]]
then
con1=`echo "Выполнена успешно"`
echo $con1 >> resultsGSM.txt
else
con1=`echo "Возникли проблемы при выполнении"`
echo $con1 >> resultsGSM.txt
fi
mbox "$title" "Команда AT+CREG?: $con1"

serport "AT+CMGF=1"
mbox "$title" "Команда AT+CMGF=1: $con"

serport "AT&W"
mbox "$title" "Команда AT&W: $con"


serport "ATD+79202113428;"
yesno "$title"  "Подождите несколько секунд. \nВам идёт звонок?" "Звонки на телефон идут" "Проблема со звонками"

mbox "$title" "Перезвоните на номер с которого поступил звонок"

{
    for ((i = 0 ; i <= 100 ; i+=15)); do
        sleep 1
        echo $i
    done
} | whiptail --gauge "Пожалуйста подождите немного" 6 60 0

serport "ATH"
if (whiptail --title "$title" --yesno "Звонок сбросился?" 10 60)
then
	con1=`echo "Выполнена успешно"`
	echo $con1 >> resultsGSM.txt
else
	con1=`echo "Возникли проблемы при выполнении"`
	echo $con1 >> resultsGSM.txt
fi

cat /dev/ttyS0 > res.log &
killall cat
cat /dev/ttyS0 >> res.log &
touch res.log
cat res.log
echo "AT+CPOWD=1" > /dev/ttyS0
{
    for ((i = 0 ; i <= 100 ; i+=2)); do
        sleep 1
        echo $i
    done
} | whiptail --gauge "Идет выполнение команды, подождите пожалуйста" 6 60 0

cat res.log
ans=$(cat res.log)
if [[ $ans =~ SMS.Ready ]];
then
	con2=`echo "Выполнена успешно"`
	echo $con2 >> resultsGSM.txt
else
	con2=`echo "Возникли проблемы при выполнении"`
	echo $con2 >> resultsGSM.txt
fi
mbox "$title" "Команда AT+CPOWD=1: $con2"

rm res.log
killall cat

res=$(awk '/^Возникли проблемы/{print $2}' resultsGSM.txt)

if [[ $res == *"проблемы"* ]]
then
        echo "С GSM модулем возникли проблемы" >> results.txt
	mbox "$title" "С GSM модулем возникли проблемы"
else
        echo "GSM модуль выполняет все требуемые функции" >> results.txt
	mbox "$title" "GSM модуль выполняет все требуемые функции"
fi


else
mbox "Проверка GSM модуля" "Serial port не отвечает"
fi
}

#GSM
