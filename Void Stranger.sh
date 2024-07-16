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

game_chksm=$(md5sum gamedata/"data.win" | awk '{print $1}')
patch_chksm=$(md5sum gamedata/"vs.xdelta" | awk '{print $1}')
itch_chksm=$(md5sum gamedata/itch/"vs-itch-to-steam.xdelta" | awk '{print $1}')
audio1_chksm=$(md5sum gamedata/"audiogroup1.dat" | awk '{print $1}')
audio2_chksm=$(md5sum gamedata/"audiogroup2.dat" | awk '{print $1}')
data_chksm=$(md5sum gamedata/"voidstranger_data.csv" | awk '{print $1}')

# Patch the data.win file, with support for ItchIo version
if [ -f "gamedata/vs-patched.win" ]; then
  echo "Found patched data file."
elif [[ -f "gamedata/data.win" ]] && [[ "$game_chksm" = "29f820538024539f18171fb447034fe7" ]]; then
  echo "Patching Steam Version data.win"
  $ESUDO $controlfolder/xdelta3 -d -s gamedata/"data.win" gamedata/"vs.xdelta" gamedata/"vs-patched.win"
elif [[ -f "gamedata/data.win" ]] && [[ "$game_chksm" = "1a666b533539af4cebb7c12311bd9a56" ]]
  echo "Itch Version Found. Patching to be equivalent to Steam version."
  mv gamedata/"data.win" gamedata/itch/"data_itch.win"
  $ESUDO $controlfolder/xdelta3 -d -s gamedata/itch/"data_itch.win" gamedata/itch/"vs-itch-to-steam.xdelta" gamedata/"data.win"
  if [[ -f "gamedata/data.win" ]] && [[ "$game_chksm" = "29f820538024539f18171fb447034fe7" ]]; then
    echo "Patching Updated data.win"
    $ESUDO $controlfolder/xdelta3 -d -s gamedata/"data.win" gamedata/"vs.xdelta" gamedata/"vs-patched.win"
  else
    echo "Error while patching. Ensure all required files are in place."
  fi
else
  echo "Incorrect game checksum or game data not found; check the instructions and your game version."
fi

final_chksm=$(md5sum gamedata/"vs-patched.win" | awk '{print $1}')

echo "Compare these checksum values to the included checksums_info.txt for troubleshooting."
echo " "
echo "Game md5: ""$game_chksm"
echo "Main Patch md5: ""$patch_chksm"
echo "Itch Patch md5: ""$itch_chksm"
echo "Final Patched Game md5: ""$final_chksm"
echo "audiogroup1 md5: ""$audio1_chksm"
echo "audiogroup2 md5: ""$audio2_chksm"
echo "data CSV md5: ""$data_chksm"
echo " "


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