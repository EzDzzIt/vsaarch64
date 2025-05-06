# vsaarch64
experimental void stranger port to Linux handhelds via PortMaster (testing on rg35xxh)  
https://portmaster.games/faq.html  

Currently only supports v1.1.3 of the Steam version of the game, or v1.1.3 of the itch.io version (itch version is patched to be equivalent to the Steam version). <br />

## *Instructions*

-Purchase game via https://store.steampowered.com/app/2121980/Void_Stranger/ <br />

-If v1.1.3 is no longer the latest release, ensure you download that version by using:  

    steam://nav/console (in a browser)  
    download_depot 2121980 2121981 6229122826867526209 (enter in the Steam console)  
    

-Place game .png, .dat, .csv, and .win files in the "assets" folder. <br />

-On first run, the game will take up to 30 minutes to load. It is running through patching the data.win file via xdelta, compressing and zipping audio files and other files into the .apk, and parsing the .csv data file. Subsequent starts should go much faster. <br />

## *Controls*

-The game should recongnize an xinput controller natively if you are using one with your device for some reason. <br />

| Button | Action |
|--|--| 
|A|ACTION|
|B|ACTION|
|X|ACTION|
|Y|ACTION|
|L1|ACTION|
|DPAD|MOVEMENT|
|L STICK|MOVEMENT|
|R1|RIGHT CLICK (ACTIVATE CURSOR SHORTCUT)|
|R STICK|MOUSE MOVEMENT|
|L2|TOGGLE TIMER|
|R2|TOGGLE STEPS|
|START|MENU|
|SELECT|EXIT GAME|


The "X" and "L1" buttons will enter multiple actions if held down, mainly for skipping dialogue. <br />

## *Known Issues*

-Music looping incorrectly. <br />

-High CPU/RAM usage. <br />

-(Workaround added) Splash Screen not displaying on boot. <br />

-(Workaround added) Slowdown during later puzzle gameplay. <br />

-(Workaround added) Late game key event not saving properly. (Fixed by AbbyV) <br />

-(Workaround added) Enemies always spawning in default orientation. (Fixed by Fayti1703, gooeyPhantasm, and skirlez) <br />

-(Workaround added) Problems saving data after certain key events (initially seen with rest area 1). <br />

-(Workaround added) Fruit refusal results in endless loop. <br />

-(Workaround added) Locust count for void court not updating properly.<br />

-(Workaround added) Settings file not saving after an option is changed. <br />

-(Lowered) Long start-up time on boot (1.5min even without unpacking/repacking assets). <br />

## *Patch Notes*

-Fixed controls not updating as expected. <br />

-Call the "savegame" script after key events to trigger new save data properly (this fixes rest area 1, but more issues may arise). <br />

-Call the "exit_game" script before running "end_game" to ensure trackers update; also forcefully calling exit when select is held down. <br />

-Attempt to save game settings file whenever the "resume game" script runs (to save settings, enter the menu, make changes, and make sure to select "Resume" to go back into the game. This should force the settings file to be saved). <br />

-On first boot, game script data is parsed from a .csv file. A separate .ini file is then saved in the game directory which can be called for much faster startup on subsequent boots (60s -> 1s). This file needs to be removed if the .csv file is updated. <br />

-"var buffer" variable for text spacing increased in battle objs. <br />

-Added some additional palettes from SE Discord; the additional ones are pushed into the main palette array in the menu alarm script that runs after initial menu creation. <br />

-Removed some existing logging for clarity in debugging (Pausing allowed, Player Path were taking up 80% of the log file). <br />

-Added additional collision object code to ensure enemies spawn facing the correct direction. <br />

-Additional forced saving to fix certain key lategame events. <br />

-Changed the quantity of objects onscreen during a lategame puzzle to reduce slowdown. <br />

-Added "splash" binary, code by nate. Simple SDL2 binary to display our workaround Splash Screens on load. <br />

## *ToDo*

-Investigate audio looping issues. <br />

## *Credits*

-Void Stranger by System Erasure.  <br />

-Testing and update maintenance by [gPhantasm](https://github.com/gPhantasm). <br />

-gmloader by JohnnyOnFlame. <br />

-Thanks to the Portmaster Discord for their support.  <br />

-Thanks to the System Erasure Discord group of modding enthusiasts (gooey for testing, @skirlez & @Malkav0 for gml palette implementation, @skirlez, @AbbyV and @Fayti1703 for coding fixes). <br />

-Custom palettes that are included from the System Erasure Discord: <br />
    "ZERORANGER (FAMILIORANGE)" by gooeyPhantasm  <br />
    "GB GREEN" by gooeyPhantasm  <br />
    "GB POCKET" by gooeyPhantasm  <br />
    "VOID TRANSGER" by Moonie  <br />
    "GREY" by Moonie  <br />
    "S U N S E T" by Moonie <br />
    "PACHINKO" by Moonie <br />
    "PORTMASTER" by Moonie <br />
    "P***" by Ayre223 <br />
    "ICEEY" by Rafl <br />
    "MAMMON" by Rafl <br />

-Custom loading splash screen by gooeyPhantasm. Font is Alkhemikal by Jeti. <br />

## *Built With*

[gmloader-next](https://github.com/JohnnyonFlame/gmloader-next/blob/master/LICENSE.md) <br />

[UndertaleModTool](https://github.com/UnderminersTeam/UndertaleModTool/blob/master/LICENSE.txt) <br />
