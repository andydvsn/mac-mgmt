#!/usr/bin/env bash

## whatami.sh v1.01 (7th January 2021)
##  Displays useful information about what a Mac actually is.

# Data Grabbers
ioreg=$(ioreg -p IODeviceTree -r -n / -d 1)
nvram=$(nvram -p)

# Bootloader Identifier
bootloader=$(nvram 4D1FDA02-38C7-4A6A-9CC6-4BCCA8B30102:opencore-version 2>&1)
if [[ "$bootloader" =~ "not found" ]]; then
	bootloader="Apple"
else
	bootloader="OpenCore $(echo "$bootloader" | awk -F\  '{print $2}')"
fi

# Hardware

gpudata=$(system_profiler SPDisplaysDataType 2>/dev/null)

if [[ "$(echo "$ioreg" | grep model | awk -F\"  {'print $4'})"" =~ "MacPro"" ]]; then
	bay1="Empty"
	bay2="Empty"
	bay3="Empty"
	bay4="Empty"
	# for d in "$(diskutil list | grep "/dev" | awk -F\  '{print $1}')"; do
	# 	bay=$(diskutil info "$d" | grep "Device Location" | grep "Bay" | awk -F\"Bay\  {'print $2'} | cut -b1)
	# 	#if [[ "$bay" != "" ]]; then
	# 	#	declare bay$bay="$d"
	# 	#fi
	# 	#$(diskutil info "$d")
	# 	#echo "$d"
	# done
fi



# Output

echo
echo "                                                                  whatami v1.00"
echo "==============================================================================="
echo
echo "Bootloader:   "$bootloader""
echo
echo "--- Hardware ------------------------------------------------------------------"
echo
echo "Model:        $(echo "$ioreg" | grep model | awk -F\"  {'print $4'})"
echo "Board ID:     $(echo "$ioreg" | grep board-id | awk -F\"  {'print $4'})"
echo
echo "CPU:          $(sysctl -n machdep.cpu.brand_string)"
echo "Virtualised:  $([[ $(sysctl -n machdep.cpu.features) =~ "VMM" ]] && echo "Virtual (VMM Present)" || echo "Physical (VMM Absent)")"
echo
echo "GPU:          $(echo "$gpudata" | grep "Chipset Model" | awk -F\:\  {'print $2'})"
echo "VRAM:         $(echo "$gpudata" | grep "VRAM" | awk -F\:\  {'print $2'})"
echo "Metal:        $(echo "$gpudata" | grep "Metal" | awk -F\:\  {'print $2'})"
echo
if [[ "$bay1" != "" ]]; then
	echo "Drive Bay 1:  $bay1"
	echo "Drive Bay 2:  $bay2"
	echo "Drive Bay 3:  $bay3"
	echo "Drive Bay 4:  $bay4"
fi

echo


kextstat | grep -v com.apple







