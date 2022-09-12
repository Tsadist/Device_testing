#!/bin/bash
. ./diabox.sh

function on_off {
raspi-gpio set $1 op dh
yesno "$2" "$3" "$4" "$5"
raspi-gpio set $1 ip
}


function off_on {
raspi-gpio set $1 op dl
yesno "$2" "$3" "$4" "$5"
raspi-gpio set $1 ip
}


