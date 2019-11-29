#!/usr/bin/env bash

shortcutName="${1}"
app="{{ app }}"
Source="/Applications/$app"
Destination="{{ home }}/{{ user }}/Desktop/${shortcutName}"
/usr/bin/osascript -e "tell application \"Finder\" to make alias file to POSIX file \"$Source\" at POSIX file \"$Destination\""

