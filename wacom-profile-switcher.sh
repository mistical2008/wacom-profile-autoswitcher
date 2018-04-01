#!/bin/bash
awk_string1="/"
awk_string2="/{print \$1}"
window_in_focus_old=""

while true; do
	#get ID of windows in the focus
	window_in_focus=$(xprop -root | awk '/_NET_ACTIVE_WINDOW/ {print $5; exit;}')
	figma=$(xdotool getwindowfocus getwindowname | tr -d '[:space:]''[="=]' | sed -r 's/(–|-)/ /g' | cut -f 2 -d " ")
	# echo $figma
	#if the focus didn't change - do nothing
	if [[ "$window_in_focus" -ne "$window_in_focus_old" ]]; then
		window_in_focus_old=$window_in_focus
		#reading program's name from file "programs"
		list_of_progr=$(<$HOME/wacom-profile-switcher/programs)
		# program's names cycle
		for name_of_progr in $list_of_progr; do
			awk_string_result="$awk_string1$name_of_progr$awk_string2"
			# getting the list of windows, wich titles has keyword from list of programs
			list_of_running_prog=$(wmctrl -l | awk "${awk_string_result}")
			# if in focus - then will execute script in the xsetwacom directory
			for running_progr in $list_of_running_prog; do
				if [[ "$running_progr" -ne "$window_in_focus" ]]; then
					$HOME/wacom-profile-switcher/default
				elif [[ "$running_progr" -eq "$window_in_focus" ]]; then
					$HOME/wacom-profile-switcher/$name_of_progr
				elif [[  "$running_progr" -ne "$window_in_focus" && "$figma" -eq "Figma" ]]; then
					$HOME/wacom-profile-switcher/figma
				fi
			done
		done
	fi
	sleep 1
done

## Get window name. Assign to variable
# xprop | awk -F= '/_NET_WM_NAME/{print $2}' | tr -d '[:space:]' | sed -e 's/^"//' -e 's/"$//'
# RESULT iOS10GUINativebyGreatSimpleStudio(Copy)–Figma-GoogleChrome

# xprop | awk -F= '/_NET_WM_NAME/{print $2}' | tr -d '[:space:]''[="=]'
# RESULT Sendilla–Figma-GoogleChrome

# xprop | awk -F= '/_NET_WM_NAME/{print $2}' | tr -d '[:space:]''[="=]' | sed -r 's/(–|-)/ /g' | cut -f 2 -d " "
#RESULT Figma

# xdotool getwindowfocus getwindowname | tr -d '[:space:]''[="=]' | sed -r 's/(–|-)/ /g' | cut -f 2 -d " "

## Cut Figma from window name. Assign to variable
# cut -f 1 -d ':' /etc/passwd  cut first field from strings divided by ':'

## Add condition to profile cycle
