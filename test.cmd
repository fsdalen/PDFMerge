@setlocal enableextensions enabledelayedexpansion
@echo off

::Delete temp dir if it exists
IF EXIST "temp" (
	RMDIR temp /s /q
)
IF EXIST "temp2" (
	RMDIR temp2 /s /q
)

::create temp dir
mkdir temp
mkdir temp2

SET /p splitPage="Enter last page number in report: "

::Split report in report and front pages
CALL sejda-console splitbypages -f .\Report\report.pdf -o .\temp2 -n %splitPage%

SET /A splitPage2=%splitPage%+1
forfiles /M %splitPage2%_* /C "ECHO @file"

::Split front pages
cd temp2
forfiles /M 
CALL sejda-console simplesplit -f .\Front_pages\0front.pdf -o .\temp -s all


::Rename and move report file
cd temp2
forfiles /M 1_* /C "cmd /c ren @file 00@file"
forfiles /M 00* /C "cmd /c copy @file ..\temp"
cd ..