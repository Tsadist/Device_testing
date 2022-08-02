#!/bin/bash
. ./cameras.sh
. ./fan_and_switch.sh
. ./dry_contacts.sh
. ./gsm_mod.sh
. ./result.sh
. ./mega328p.sh
. ./firmware.sh


function test {
rm results.txt
dev=$(cat conf.txt)

if [[ $dev =~ .*Duo.*mega328p$ ]]
then
        mega328p
	result

elif [[ $dev =~ .*Мезонин.Duo.* ]];
then
	cameras
	fan
	switch
	dry_contacts
	GSM
	firmware_flash
	result

elif [[ $dev =~ .*Мезонин.Uno.* ]]
then
	cameras
	fan
	switch
	dry_contacts
	firmware_sim7600
	result
fi
}
