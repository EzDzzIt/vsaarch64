# vsaarch64
experimental void stranger port to Linux handhelds via PortMaster (testing on rg35xxh)

using utmt bleeding edge and gmloader-next
using v1.1.1 of the steam version of the game

## *Instructions for Testing*

-Purchase game via https://store.steampowered.com/app/2121980/Void_Stranger/<br />
-Place game .png, .dat, .csv, and .win files in the "gamedata" folder. <br />
-Compile gmloader-next via https://github.com/JohnnyonFlame/gmloader-next and rename output file "gmloader." Drop this file in the main port directory. 

## *Known Issues*

-Problems saving data after certain key events (initially seen with rest area 1).<br />
-Settings file not saving after an option is changed. <br />
-Long start-up time on boot (1.5min even without unpacking/repacking assets)<br />
-High CPU/RAM usage. <br />
-Splash Screen not displaying on boot. <br />
-Font overlap during jrpg battle scene <br />

## *Patch Notes*

-Fixed controls not updating as expected.<br />
-Call the "savegame" script after key events to trigger new save data properly (this fixes rest area 1, but more issues may arise). <br />
-Attempt to save game settings file whenever the "resume game" script runs (to save settings, enter the menu, make changes, and make sure to select "Resume" to go back into the game. This should force the settings file to be saved).<br />
-On first boot, game script data is parsed from a .csv file. A separate .ini file is then saved in the game directory which can be called for much faster startup on subsequent boots (60s -> 1s). This file needs to be removed if the .csv file is updated. <br />

## *ToDo*

-Test zipping splash screen into .apk <br />
-Compress audio data to lower ram usage <br />
-Play through each ending to ensure they are all attainable <br />
-Test on other devices <br />
-Add save backup script for testing paths <br />