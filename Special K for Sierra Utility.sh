#! /bin/bash

echo "This is an app to use Special [K] patchers on macOS Sierra."
echo " "
echo "This is in NO WAY associated or endorsed by the Special [K] group."
echo " "

# verify that command line tools are installed
# patching won't work without them
# the patcher will make a corrupt patch if they are installed while patching

echo "Checking for Command Line tools."
echo "Patching cannot proceed without them."
echo " "
echo "If the tools need to be installed, try patching again when they are done."
echo " "

check=$(xcode-select --install 2>&1)

echo "$check" | grep -q "install requested" && echo "Tools need to be installed...Quitting" && exit 1

echo "Command line tools are already installed."
echo " "


# ask user to select the Special [K] patcher
# keep trying until user quits or finds an acceptable patcher

while true ; do

	get_patcher=$(osascript -e "POSIX path of (choose file with prompt \"Choose the Special [K] patcher\" of type \"APPL\" default location (path to applications folder))" 2>&1)

	echo "$get_patcher" | grep -q "User cancelled" && echo "No patcher was chosen...Quitting" && exit 1

	patcher="${get_patcher}Contents/MacOS/patcher"
	eyepatch="${get_patcher}Contents/MacOS/eyePatch"

	[[ -e "$patcher" ]] && [[ -e "$eyepatch" ]] && break 

	echo "Does not appear to be a Special [K] patcher, try again..."
done


# ask user to select the app to patch
# there is no error checking for whether this is the correct app
# any output is suppressed so as to not confuse the user
# there does not appear to be any message if the app has already been patched
# nor if there is a specific error while patching

the_app=$(osascript -e "POSIX path of (choose file with prompt \"Choose the app to be patched\" of type \"APPL\" default location (path to applications folder))" 2>&1)

echo "$the_app" | grep -q "User cancelled" && echo "No app was chosen...Quitting" && exit 1


# do the patch
# suppress messages that might be confusing, but also might be helpful if problems

"$patcher" "$the_app" "$eyepatch" "$the_app" 2>&1 > /dev/null

echo " " && echo "All Done!" && exit 0
