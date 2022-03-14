#!/usr/bin/env bash

## whatami.sh v1.07 (7th February 2022)
##  Displays useful information about what a Mac actually is.

version="1.06"

# Data Grabbers
ioreg=$(ioreg -p IODeviceTree -r -n / -d 1)
nvram=$(nvram -p)

# Bootloader Identifier
bootloader=$(nvram 4D1FDA02-38C7-4A6A-9CC6-4BCCA8B30102:opencore-version 2>&1)
if [[ "$bootloader" =~ "not found" ]]; then
	bootloader="Apple"
else
	bootloader="OpenCore $(echo "$bootloader" | awk -F\  '{print $2}')"
	efibootlocation=$(nvram 4D1FDA02-38C7-4A6A-9CC6-4BCCA8B30102:boot-path | sed 's/.*GPT,\([^,]*\),.*/\1/')
fi

# EFI Mount and Dismount
if [[ "$1" == "mount" ]]; then
	sudo diskutil mount $efibootlocation
	/usr/bin/open /Volumes/EFI 
	exit 0
elif [[ "$1" == "unmount" ]]; then
	sudo diskutil unmount $efibootlocation
	exit 0
fi

if [[ "$1" == "test" ]]; then
	/usr/bin/plutil -convert xml1 /Volumes/EFI/EFI/OC/config.plist && /usr/bin/plutil /Volumes/EFI/EFI/OC/config.plist
	exit 0
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

# Software
syssoft=$(system_profiler SPSoftwareDataType 2>/dev/null)


# Output

echo
echo "                                                                  whatami v$version"
echo "==============================================================================="
echo
echo "Bootloader:    $bootloader"
echo "EFI Location:  $efibootlocation"
echo

echo "--- Hardware ------------------------------------------------------------------"
echo
echo "Model:         $(echo "$ioreg" | grep \"model\" | awk -F\"  {'print $4'})"
echo "Board ID:      $(echo "$ioreg" | grep \"board-id\" | awk -F\"  {'print $4'})"
echo "System UUID:   $(echo "$ioreg" | grep \"IOPlatformUUID\" | awk -F\"  {'print $4'})"
echo "Bridge:        $(echo "$ioreg" | grep \"bridge-model\" | awk -F\"  {'print $4'} | grep . || echo "None")"
echo
echo "CPU:           $(sysctl -n machdep.cpu.brand_string)"
echo "Virtualised:   $([[ $(sysctl -n machdep.cpu.features) =~ "VMM" ]] && echo "Virtual (VMM Present)" || echo "Physical (VMM Absent)")"
echo
echo "GPU:           $(echo "$gpudata" | grep "Chipset Model" | awk -F\:\  {'print $2'})"
echo "Metal:         $(echo "$gpudata" | grep "Metal" | awk -F\:\  {'print $2'})"
echo "VBIOS:         $(echo "$gpudata" | grep "VBIOS" | awk -F\:\  {'print $2'})"
echo "VRAM:          $(echo "$gpudata" | grep "VRAM" | awk -F\:\  {'print $2'})"
echo
#if [[ "$bay1" != "" ]]; then
#	echo "Drive Bay 1:  $bay1"
#	echo "Drive Bay 2:  $bay2"
#	echo "Drive Bay 3:  $bay3"
#	echo "Drive Bay 4:  $bay4"
#fi

echo "--- Software ------------------------------------------------------------------"
echo
echo "Kernel:        $(echo "$syssoft" | grep "Kernel Version" | awk -F\:\  {'print $2'})"
echo "System:        $(echo "$syssoft" | grep "System Version" | awk -F\:\  {'print $2'})"
echo

echo "--- Security Settings ---------------------------------------------------------"
echo
echo "SIP:           $(echo "$syssoft" | grep "System Integrity Protection" | awk -F\:\  {'print $2'})"
echo "SVM:           $(echo "$syssoft" | grep "Secure Virtual Memory" | awk -F\:\  {'print $2'})"
echo

echo "--- Non-Apple Kernel Extensions -----------------------------------------------"
echo
/usr/bin/kmutil showloaded 2>/dev/null | grep -v com.apple | grep -v "(Version)" | awk -F\  {'print $6 " " $7'}
echo

exit 0
