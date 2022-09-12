#!/bin/bash

. ./diabox.sh
function port {

title="Проверка преобразователя"
cat /dev/$1 > res.log &
touch res.log
echo 'Hello' > /dev/$1
ans=$(cat res.log)
killall cat
#echo "..."
#echo "$ans"
if [[ $ans == *"Hello"* ]]
then
        mbox "$title" "$2 преобразователь работает"
        echo "$2 преобразователь работает" >> results.txt
else
        mbox "$title" "$2 преобразователь не работает"
        echo "$2 преобразователь не работает" >> results.txt
fi

rm res.log
}

function converter {
if(whiptail --title "Проверка преобразователей" --yes-button "Один" --no-button "Два" --yesno "Выберете сколько преобразоватлей интерфейсов вам нужно проверить" 10 60 )
then
port ttyS0 "Первый"
else
port ttyS0 "Первый"
port ttyS0 "Второй"
fi
=======

}
#converter
