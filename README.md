# vsaarch64
experimental void stranger port to Linux handhelds via PortMaster (testing on rg35xxh)

using utmt bleeding edge and gmloader-next
using v1.1.1 of the steam version of the game

#################################################################<br />
*Instructions for Testing*<br />
#################################################################<br />

-Purchase game via https://store.steampowered.com/app/2121980/Void_Stranger/<br />
-Place game .png, .dat, .csv, and .win files in the "gamedata" folder. <br />
-Compile gmloader-next via https://github.com/JohnnyonFlame/gmloader-next and rename output file "gmloader." Drop this file in the main port directory. 

#################################################################<br />
*Known Issues*<br />
##################################################################<br />

-Problems saving data after certain key events (initially seen with rest area 1).<br />
-Settings file not saving after an option is changed. 
-Long start-up time on boot (1.5min even without unpacking/repacking assets)
---Controls not updating as expected.--
-High CPU/RAM usage. 
-Splash Screen not displaying on boot. 
-Font overlap during jrpg battle scene

#################################################################
*Patch Notes*
##################################################################

-Call the "savegame" script after key events to trigger new save data properly (this fixes rest area 1, but more issues may arise). 
-Attempt to save game settings file whenever the "resume game" script runs (to save settings, enter the menu, make changes, and make sure to select "Resume" to go back into the game. This should force the settings file to be saved)..
-On first boot, game script data is parsed from a .csv file. A separate .ini file is then saved in the game directory which can be called for much faster startup on subsequent boots (60s -> 1s). This file needs to be removed if the .csv file is updated. 

#################################################################
*ToDo*
#################################################################

-Test zipping splash screen into .apk
-Compress audio data to lower ram usage
-Play through each ending to ensure they are all attainable
-Test on other devices
-Add save backup script for testing paths