#!/bin/bash
. ./cameras.sh
. ./fan_switch_led.sh
. ./dry_contacts.sh
. ./gsm_mod.sh
. ./result.sh
. ./mega328p.sh
. ./firmware.sh
. ./sim7600.sh
. ./rtc.sh
. ./converter.sh
<<<<<<< HEAD
. ./ATtiny13.sh
=======
>>>>>>> 4793d3f7419be00fb618818be08a426dc0baf95c

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

<<<<<<< HEAD
elif [[ $dev == 'Мезонинная плата "Страж солнце". До прошивки' ]]
then
	fan
	rtc mcp
	firmware_halt ./flash13 t13.hex

elif [[ $dev == 'Мезонинная плата "Страж солнце". После прошивки' ]]
then
	converter
	ATtiny13
=======
elif [[ $dev == 'Мезонинная плата "Страж солнце"' ]]
then
	fan
	rtc
	firmware_halt ./flash13 t13.hex
	converter
	

	result
>>>>>>> 4793d3f7419be00fb618818be08a426dc0baf95c

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

elif [[ $dev == 'Выходы управления светодиодами' ]]
then
	two_leds
	result

elif [[ $dev == "Ключи управления камерами" ]]
then
	cameras
	result

elif [[ $dev == "Модем с супервизером на основе sim7600" ]]
then
	sim7600
	result

elif [[ $dev == 'Ключ управления вентилятором' ]]
then
	fan
	result

elif [[ $dev == 'Ключ управления коммутатором' ]]
then
	switch
	result

elif [[ $dev == 'Менеджер управления питания на основе МК ATtiny13' ]]
then
	ATtiny13
	result

elif [[ $dev == 'Многофункциональный светодиод' ]]
then
	led
	result

elif [[ $dev == 'Преобразователи интерфейса rs232uart' ]]
then
	converter
	result

elif [[ $dev == 'ЧРВ с будильником "mcp7940x' ]]
then
	rtc mcp
	result

elif [[ $dev == 'ЧРВ "ds1307"' ]]
then

	rtc ds
	result

fi
rm conf.conf
}
