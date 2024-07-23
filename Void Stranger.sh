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
export LD_LIBRARY_PATH="/usr/lib:/usr/lib32:/$GAMEDIR/lib:$LD_LIBRARY_PATH"

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

# Check to see if a patched game already exists at the start, and verify with current patch version:
if [ -f "game.droid" ]; then
  final_chksm=$(md5sum "game.droid" | awk '{print $1}')
  if [ "$final_chksm" = "e07f256f18394491b4bace0e1b675465" ]; then
    echo "Found patched GAME.DROID game file. Checksum good. ""$final_chksm"
  else
    echo "WARNING: game.droid checksum does not match; expecting e07f256f18394491b4bace0e1b675465; md5: ""$final_chksm"
    ##exit 0
  fi
else
  # get data.win checksum
  game_chksm=$(md5sum gamedata/"data.win" | awk '{print $1}')
  # verify if Steam Version, then patch
  if [[ -f "gamedata/data.win" ]] && [[ "$game_chksm" = "29f820538024539f18171fb447034fe7" ]]; then
    echo "Steam Version Found. Patching data.win. data.win md5 ""$game_chksm"
    $ESUDO $controlfolder/xdelta3 -d -s gamedata/"data.win" gamedata/"vs.xdelta" gamedata/"vs-patched.win"
  # or check if it's the Itch version, patch for Steam Version parity and then patch again
  elif [[ -f "gamedata/data.win" ]] && [[ "$game_chksm" = "1a666b533539af4cebb7c12311bd9a56" ]]; then
    echo "Itch Version Found. Patching to be equivalent to Steam version. data.win md5 ""$game_chksm"
    mv gamedata/"data.win" gamedata/"data_itch.win"
    $ESUDO $controlfolder/xdelta3 -d -s gamedata/"data_itch.win" gamedata/"vs-itch-to-steam.xdelta" gamedata/"data.win"
    echo "Patching Updated data.win"
    $ESUDO $controlfolder/xdelta3 -d -s gamedata/"data.win" gamedata/"vs.xdelta" gamedata/"vs-patched.win"
    echo "Cleaning up."
    $ESUDO rm gamedata/"data_itch.win"
  else
    echo "Incorrect game checksum or game data not found; check the instructions and your game version. data.win md5 ""$game_chksm"
    exit 0
  fi
  if [ -f "gamedata/vs-patched.win" ]; then 
    patched_chksm=$(md5sum gamedata/"vs-patched.win" | awk '{print $1}')
    echo "Patched game checksum expecting e07f256f18394491b4bace0e1b675465; current md5: ""$patched_chksm"
  fi
fi

# Check if there is an empty file called "loadedapk" in the dir, then add audio files if not
if [ ! -f loadedapk ]; then
  echo "Zipping game files..."
  $ESUDO mkdir -p ./assets/
  $ESUDO mv gamedata/"audiogroup1.dat" ./assets/
  $ESUDO mv gamedata/"audiogroup2.dat" ./assets/
  # Splash Screen currently broken
  # $ESUDO mv gamedata/"splash.png" ./assets/ 
  $ESUDO zip -r -0 $GAMEDIR/game.apk ./assets/
  $ESUDO rm -r ./assets/
  touch loadedapk
  echo "Files loaded in to .apk"
fi

# move csv data file to main dir and clean if the ini has been generated already
if [ ! -f csvstring.ini ]; then
  if [ ! -f voidstranger_data.csv ]; then
    $ESUDO cp gamedata/"voidstranger_data.csv" ./
    echo "CSV data file copied to main dir."
  fi
else
  if [ -f voidstranger_data.csv ]; then
    echo "Cleaning up CSV file."
    $ESUDO rm "voidstranger_data.csv"
  fi
fi

# Move patched file to main directory
[ -f "./gamedata/vs-patched.win" ] && mv gamedata/vs-patched.win $GAMEDIR/game.droid

# Make sure uinput is accessible so we can make use of the gptokeyb controls
$ESUDO chmod 666 /dev/uinput

$GPTOKEYB "gmloadernext" -c ./voidstranger.gptk &

$ESUDO chmod +x "$GAMEDIR/gmloadernext"

./gmloadernext game.apk

$ESUDO kill -9 $(pidof gptokeyb)
$ESUDO systemctl restart oga_events &
printf "\033c" > /dev/tty0