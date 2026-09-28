@echo off
rem Mirror the mod into the Zomboid mods folder. A copy, not a junction:
rem junctions make the game's script checksum throw (see docs/development.md).
robocopy "%~dp0mod\FuelMod" "%USERPROFILE%\Zomboid\mods\FuelMod" /MIR /XF .gitkeep /NJH /NJS /NDL /NFL
if %ERRORLEVEL% GEQ 8 exit /b %ERRORLEVEL%
echo FuelMod installed to %USERPROFILE%\Zomboid\mods\FuelMod
exit /b 0
