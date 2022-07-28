#!/bin/bash
. ./cameras.sh
. ./fan_and_switch.sh
. ./dry_contacts.sh
. ./gsm_mod.sh
. ./result.sh
. ./mega328p.sh



function test {
rm results.txt
dev=$(cat conf.txt)

if [[ $dev == *"Duo"*"mega328p"* ]]
then
        mega328p
	result

elif [[ $dev == *"Duo"* ]]
then
	cameras
	fan
	switch
	dry_contacts
	GSM
	result

elif [[ $dev == *"Uno"* ]]
then
	cameras
	fan
	switch
	dry_contacts
	result
fi
}
