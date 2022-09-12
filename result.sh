#!/bin/bash

function result {
res=$(cat results.txt)
whiptail --title "Результаты тестирования" --msgbox "$res" 25 60
rm results.txt
}
#result
