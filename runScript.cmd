@echo off
@setlocal enableextensions enabledelayedexpansion

::Path of current dir
SET parent=%~dp0

::Put sejda-console in PATH for current session
set PATH=%PATH%;%parent%\sejda-console-2.10.4\bin

::Delete temp dir if it exists
IF EXIST "temp" ECHO exists(
	RMDIR temp /s /q
)
IF EXIST "temp2" ECHO exists(
	RMDIR temp2 /s /q
)

::create temp dir
mkdir temp
mkdir temp2

::Split file
CALL sejda-console simplesplit -f .\Front_pages\0front.pdf -o .\temp -s all

::Add 0 to single digit prefix og split front pages
cd temp
forfiles /M ?_0front.pdf /C "cmd /c ren @file 0@file"
cd ..

::Merge subfolders into output folder
FOR /D %%i in (.\Appendices\*) do (CALL sejda-console merge -d %%i -o .\temp\%%~ni.pdf -b discard)

::Copy Report to temp2
COPY .\Report\* .\temp2 

::Prefix Report
FORFILES /p .\temp2 /C "cmd /c ren @file 00@file"

::Move Report to temp
MOVE .\temp2\* .\temp

::Merge files in outputfolder
CALL sejda-console merge -d .\temp -o .\final.pdf --overwrite
