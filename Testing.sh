#!/bin/bash
. ./cameras.sh
. ./fan_and_switch.sh
. ./dry_contacts.sh
. ./gsm_mod.sh
. ./result.sh
. ./mega328p.sh
. ./firmware.sh
. ./sim7600.sh
. ./rtc.sh
. ./converter.sh

function test {
touch results.txt
rm results.txt
dev=$(cat conf.conf)

if [[ $dev == 'Мезонинная плата "Мезонин Duo". Процессор от mega328p' ]]
then
        mega328p
	result

elif [[ $dev == 'Мезонинная плата "Мезонин Duo" (2-х симочная) для "Умный двор" (Smart gate)' ]];
then
	cameras
	fan
	switch
	dry_contacts
	GSM
	firmware_halt ./flash
	result

elif [[ $dev == 'Мезонинная плата "Мезонин Uno" (1 симочная) для "Умный двор" (Smart gate)' ]]
then
	cameras
	fan
	switch
	dry_contacts
	sim7600
	result

elif [[ $dev == 'Мезонинная плата "Страж солнце"' ]]
then
	fan
	rtc
	firmware_halt ./flash13 t13.hex
	converter
	

	result

elif [[ $dev == "GSM модуль sim800" ]]
then
	GSM
	result

elif [[ $dev == "Переферийный процессор от mega328p" ]]
then
	mega328p
	result

elif [[ $dev == 'Выходы "сухой контакт" / реле' ]]
then
	dry_contacts
	result

elif [[ $dev == "Ключи камер" ]]
then
	cameras
	result

elif [[ $dev == "Модем sim7600" ]]
then
	sim7600
	result
fi
}
