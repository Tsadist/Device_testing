#!/bin/bash
. ./diabox.sh

function 
sudo hwclock -w
num1=$(grep -c rtc_time /proc/driver/rtc)
num2=$(grep -c rtc_date /proc/driver/rtc)
let sum=$num1+$num2
if [ sum==2 ]
then
	echo $sum
	sudo sh -c "echo 0 > /sys/class/rtc/rtc0/wakealarm"

fi
