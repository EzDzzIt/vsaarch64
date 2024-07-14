#!/bin/bash

XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}

if [ -d "/opt/system/Tools/PortMaster/" ]; then
  controlfolder="/opt/system/Tools/PortMaster"
elif [ -d "/opt/tools/PortMaster/" ]; then
  controlfolder="/opt/tools/PortMaster"
elif [ -d "$XDG_DATA_HOME/PortMaster/" ]; then
  controlfolder="$XDG_DATA_HOME/PortMaster"
else
  controlfolder="/roms/ports/PortMaster"
fi

source $controlfolder/control.txt
source $controlfolder/device_info.txt
export PORT_32BIT="Y"
export LD_LIBRARY_PATH="/usr/lib32:$GAMEDIR/libs"

get_controls
[ -f "${controlfolder}/mod_${CFW_NAME}.txt" ] && source "${controlfolder}/mod_${CFW_NAME}.txt"

$ESUDO chmod 666 /dev/tty0

GAMEDIR="/$directory/ports/voidstranger"

cd $GAMEDIR

export GMLOADER_DEPTH_DISABLE=1
export GMLOADER_SAVEDIR="$GAMEDIR"
export GMLOADER_PLATFORM="os_linux"

# log the execution of the script into log.txt
exec > >(tee "$GAMEDIR/log.txt") 2>&1

# Patch the data.win file
if [ -f "gamedata/vs-patched.win" ]; then
  echo "Found patched data file."
elif [ -f "gamedata/data.win" ]; then
  echo "Patching data.win"
  $ESUDO $controlfolder/xdelta3 -d -s gamedata/"data.win" gamedata/"vs.vcdiff" gamedata/"vs-patched.win"
fi

# Check if there is an empty file called "loadedapk" in the dir
if [ ! -f loadedapk ]; then

  echo "Zipping game files..."

  $SUDO mkdir -p ./assets/

  $SUDO cp gamedata/"audiogroup1.dat" ./assets/
  $SUDO cp gamedata/"audiogroup2.dat" ./assets/
  $SUDO cp gamedata/"splash.png" ./assets/
  $SUDO cp gamedata/"voidstranger_data.csv" $GAMEDIR

  $ESUDO zip -r -0 $GAMEDIR/game.apk ./assets/

  $SUDO rm -r ./assets/
  touch loadedapk

  echo "Files loaded in to .apk"

fi

# Check for file existence before trying to manipulate them:
[ -f "./gamedata/vs-patched.win" ] && cp gamedata/vs-patched.win $GAMEDIR/game.droid

# Make sure uinput is accessible so we can make use of the gptokeyb controls
$ESUDO chmod 666 /dev/uinput

$GPTOKEYB "gmloader" -c ./voidstranger.gptk &

$ESUDO chmod +x "$GAMEDIR/gmloader"

./gmloader game.apk

$ESUDO kill -9 $(pidof gptokeyb)
$ESUDO systemctl restart oga_events &
printf "\033c" > /dev/tty0