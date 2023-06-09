@echo off
REM thank you gpt-sama

IF EXIST release (
    RD /S /Q release
    echo Deleting release directory.
)

echo Recreating release directory.
mkdir release

echo Copying base files.
copy main.lua release\main.lua
copy LICENSE release\LICENSE
copy id.txt release\id.txt
copy info.txt release\info.txt
copy preview.jpg release\preview.jpg

echo Creating source directory.
mkdir release\source

echo Copying project files.
copy source\* release\source\

echo Removing comments, unnecessary spaces, and newlines from .lua files.
for %%f in (release\source\*.lua) do (
    echo %%f
    powershell -Command "(Get-Content %%f) | ForEach-Object { $_.TrimStart() } | Set-Content -Path %%f" 
    powershell -Command "Get-Content %%f | Select-String '^\s*--' | ForEach-Object { $_.Line }" 
    powershell -Command "(Get-Content %%f) | ForEach-Object { $_ -replace '^\s*--.*$', '' } | Set-Content -Path %%f" 
    powershell -Command "(Get-Content %%f) | Where-Object { $_ -ne '' } | Set-Content -Path %%f" 
    echo.
)

echo Updating local.lua

REM Location of local.lua file
set file=release\source\local.lua

REM Get the current date
set date=%date%

echo Adding 'Packaged on %date%' to main.lua
set file=release\main.lua
IF EXIST %file% (
    echo. >> %file%
    echo -- Packaged on %date% >> %file%
    echo Line added successfully in %file%
) ELSE (
    echo Error: %file% not found
)

echo Finished.