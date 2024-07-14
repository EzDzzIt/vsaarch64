# vsaarch64
experimental void stranger port to Linux handhelds via PortMaster (testing on rg35xxh)  
https://portmaster.games/faq.html  

using utmtCE and gmloader-next  
using v1.1.1 of the Steam version of the game  

## *Instructions for Testing*

*Not technically ready for distribution yet*

-Purchase game via https://store.steampowered.com/app/2121980/Void_Stranger/<br />

-Place game .png, .dat, .csv, and .win files in the "gamedata" folder. <br />

-Compile gmloader-next via https://github.com/JohnnyonFlame/gmloader-next and rename output file "gmloader." Drop this file in the main port directory. <br />

-On first run, the game will take a couple of minutes to load. It is running through patching the data.win file via xdelta, zipping audio files and other files into the .apk, and parsing the .csv data file. Subsequent starts should go faster. <br />

## *Known Issues*

-(Workaround added) Problems saving data after certain key events (initially seen with rest area 1).<br />

-(Workaround added) Fruit refusal reults in endless loop <br />

-Music looping incorrectly <br />

-(Workaround added) Locust count for void court not updating properly.<br />

-(Workaround added) Settings file not saving after an option is changed. <br />

-(Lowered) Long start-up time on boot (1.5min even without unpacking/repacking assets)<br />

-High CPU/RAM usage. <br />

-Splash Screen not displaying on boot. <br />

-Font overlap during jrpg battle scene <br />

## *Patch Notes*

-Fixed controls not updating as expected.<br />

-Call the "savegame" script after key events to trigger new save data properly (this fixes rest area 1, but more issues may arise). <br />

-Call the "exit_game" script before running "end_game" to ensure trackers update; also forcefully calling exit when select is held down. <br />

-Attempt to save game settings file whenever the "resume game" script runs (to save settings, enter the menu, make changes, and make sure to select "Resume" to go back into the game. This should force the settings file to be saved).<br />

-On first boot, game script data is parsed from a .csv file. A separate .ini file is then saved in the game directory which can be called for much faster startup on subsequent boots (60s -> 1s). This file needs to be removed if the .csv file is updated. <br />

-(Not added to UTMTCE version of the patch yet) "var buffer" variable for text spacing increased in battle objs <br />

-Added some addityional palettes from SE Discord <br />

## *ToDo*

-Compress audio data to lower ram usage <br />

-Play through each ending to ensure they are all attainable <br />

-Adjust main script to include auto-patching of base game data using xdelta3 <br />

-Test on other devices <br />

-Add save backup script for testing paths <br />

-Add additional palette options into menu directly. Not a necessity but would be a fun addition. <br />

-Fix (or wait for a fix for) Splash Screen Rendering in gmloader-next <br />

## *Credits*

-Void Stranger by System Erasure  <br />

-Testing by Discord User @gooeyphantasm <br />

-gmloader by JohnnyOnFlame <br />

-Thanks to the Portmaster Discord for their support <br />

-Thanks to the System Erasure Discord group of modding enthusiasts.

-Custom palettes that are/will be included from the System Erasure Discord: <br />
    "ZERORANGER (FAMILIORANGE)" by gooeyphantasm  <br />
    "GB GREEN" by gooeyphantasm  <br />
    "GB POCKET" by gooeyphantasm  <br />
    "VOID TRANSGER" by Moonie  <br />
    "GREY" by Moonie  <br />

## *Built With*

-https://github.com/jmacd/xdelta/blob/release3_1_apl/xdelta3/LICENSE <br />

-https://github.com/JohnnyonFlame/gmloader-next/blob/master/LICENSE.md <br />

-https://github.com/XDOneDude/UndertaleModToolCE/blob/master/LICENSE.txt <br />
