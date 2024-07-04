# vsaarch64
experimental void stranger port to Linux handhelds via PortMaster

using utmt bleeding edge and gmloader-next
currently using v1.1.1 of the steam version of the game

*Open Issues*

-*Saving Issues*- Game Key Events. Save.vs (the main save file) is not always updating for key events.
     
Workarounds: I think this may be due to gmloader killing the application really quickly before new save data can be written. Initial testing for my issue shows that the correct player flags get set, but the game exits through a different script. I forced that other script to call the main savegame script before it exits, and upon reload, it looks like data saves properly. The savegame script should hopefully check to make sure saving is allowed... (possibly this breaks something in the future).

-*Saving Issues*- Settings file. Settings.vs not saving in the main game directory, so no new settings are properly set on reload.
     
Workarounds: Added a "default" settings.vs to the main game dir so one is created initially, then added a call to the settings save script when the "resume game" script runs. Basically, settings will now save if you enter the menu, change something, leave the menu via "resume game." IDK why this is happening but I think it's a gml sandbox/directory issue.

-*Start-up Time*. Takes a solid 30-60 sec to get in-game; this is because of the way the game loads data for its text on startup (it manually parses a .csv file for all script data and loads that script into a "ds_grid" (gml matrix?))
     
Possible workaround would be to serialize that data and buffer it straight in to a variable without all the parsing logic; this would lock the port to a certain version of the game. Adding some debug code so I can measure exactly how long the script loading process takes. 

-*Controls* not updating properly (probably an issue with my configuration of the .gptk at this point). Existing game debug messages show that controller inputs and keyboard inputs are being detected simulataneously. 

-*Optimization*. On MuOS, currently using 50% cpu load and 90% of RAM during gameplay. Goal would be to cut those both in half. RAM usage could be lowered through audio compression. CPU load decreases by 10% if you kill the frontend first. Killing the os frontend does help, could include it in thr script as long as you could restart the frontend on quit. Adding code to log fps. 
