#!/bin/bash

#This program coordinates rotating and flipping the screen of the Thinkpad
#  x230t. It is meant to be called from the compositor using options. See
#  help() or call 'rotator -h' for configuration specifics. 

#This program is free software: you can redistribute it and/or modify it
#  under the terms of the GNU General Public License as published by the
#  Free Software Foundation, either version 3 of the license, or (at your
#  option) any later version.

#This program is distributed in the hope that it will be useful, but WITHOUT
#  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
#  FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
#  more details.

#You should have received a copy of the GNU General Public License along
#  with this program. If not, see <https://www.gnu.org/licenses/>.

#Display help function
help() {
	echo 
	echo "This is the Thinkpad Tablet Screen Rotation Script."
	echo "If you have reached this menu, you're likely wondering how to configure"
	echo "this tool."
	echo
	echo "This was developed for the Niri compositor, and is meant to be written"
	echo "into Niri's configuration under binds{}."
	echo
	echo "For the X230t, the X windows system has bound the two screen rotation"
	echo "buttons to XF86RotateWindows and XF86TaskPane. On other systems, YMMV,"
	echo "use \$ wev | grep 'sym' to identify keycodes within Wayland."
	echo
	echo "Once you've identified your keycodes, configure niri's config.kdl with:"
	echo "XF86RotateWindows { spawn-sh \"rotator -v\"; }"
	echo "XF86TaskPane { spawn-sh \"rotator -f\"; }"
	echo
	echo "To appropriately map tablet input, add this to your config.kdl under the"
	echo "trackpoint {} function, per <niri/docs/wiki/Configuration-Input.md>:"
	echo
	echo "tablet {"
	echo "  // off"
	echo "  map-to-output \"$OUTPUT\""
	echo "  // left-handed"
	echo "}"
	echo
	echo "On the X230t, the display output should be \"LVDS-1\". You can find it"
	echo "in niri's config.kdl within output {}."
	echo "You may also uncomment left-handed, if you're like me."
	echo
	echo "Finally, place .screenstate into your home directory."
}

# This function will rotate the screen by 90 degrees with intelligent logic.
rotate-screen() {
	screenstate=$(cat $HOME/.screenstate)
	#Use a switch statement to handle values 
	case $screenstate in 
		0) # if screenstate is 0, set screen to 90
			$(wlr-randr --output LVDS-1 --transform 90)
			echo "1" | tee $HOME/.screenstate
			return;;
		1) # if screenstate is 1, set screen to normal 
			$(wlr-randr --output LVDS-1 --transform normal)
			echo "0" | tee $HOME/.screenstate
			return;;
		2) # if screenstate is 2, set screen to 270
			$(wlr-randr --output LVDS-1 --transform 270)
			echo "3" | tee $HOME/.screenstate
			return;;
		3) # if screenstate is 3, set screen to 180
			$(wlr-randr --output LVDS-1 --transform 180)
			echo "2" | tee $HOME/.screenstate
			return;;
	esac
}

#This function will flip the screen 180 degrees with intelligent logic.
flip-screen() {
	screenstate=$(cat $HOME/.screenstate)
	#Use a switch statement to handle values
	case $screenstate in
		0) # if screenstate is 0, set screen to 180
			$(wlr-randr --output LVDS-1 --transform 180)
			echo "2" | tee $HOME/.screenstate
			return;;
		1) # if screenstate is 1, set screen to 270
			$(wlr-randr --output LVDS-1 --transform 270)
			echo "3" | tee $HOME/.screenstate
			return;;
		2) # if screenstate is 2, set screen to normal
			$(wlr-randr --output LVDS-1 --transform normal)
			echo "0" | tee $HOME/.screenstate
			return;;
		3) # if screenstate is 3, set screen to 90
			$(wlr-randr --output LVDS-1 --transform 90)
			echo "1" | tee $HOME/.screenstate
			return;;
	esac
}

#MAIN PROGRAM#
while getopts "vfh" option; do
	case $option in
		h) #Display help command
			help
			exit;;
		v) #Rotates screen 90 degrees, back and forth 
			rotate-screen
			exit;;
		f) #Flips screen 180 degrees
			flip-screen
			exit;;
		?)
		echo "Invalid option"
		exit;;
	esac
done
echo "If you see this text, you have called rotator with no arguments."
echo "Please call rotator -h to learn how to configure rotator."
