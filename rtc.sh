#!/bin/bash

sudo hwclock -w
echo $?
sleep 3

sudo hwclock -r
echo $?
