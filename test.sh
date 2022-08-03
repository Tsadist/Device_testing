#!/bin/bash

stty -F /dev/ttyUSB4 -echo

cat /dev/ttyUSB4 > res.log &
touch res.log
echo "AT+CONFIG?" > /dev/ttyUSB4
grep "Password" res.log | awk -F= '{print $2}'

rm res.log
killall cat
