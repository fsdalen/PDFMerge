@echo off
@setlocal enableextensions enabledelayedexpansion

::Path of current dir
SET parent=%~dp0

::Put sejda-console in PATH for current session
set PATH=%PATH%;%parent%\sejda-console-2.10.4\bin

::create temp dir
mkdir temp
mkdir temp\cover
mkdir temp\report
mkdir temp\toMerge

:::::::::::::::::::::::::::::::::::::::::::::::::
::Atemt to split report and cover in the script to avoid having to do it manually first.
::Splitting is working. Moving the two split files correctly is missing
::Split Cover and report.
set /p pNum="Split after page: "	::User input
CALL sejda-console splitbypages --files .\Report\* --output .\temp --pageNumbers %pNum%

:::::::::::::::::::::::::::::::::::::::::::::::::


::Copy cover file to temp
COPY .\CoverPages\* .\temp\cover

::Prefix cover file with 0
cd temp\cover
forfiles /M *.pdf /C "cmd /c ren @file 0@file"
cd ..\..

::Split file
CALL sejda-console simplesplit -f .\temp\cover\* -o .\temp\toMerge -s all

::Add 0 to single digit prefix og split front pages
cd temp\toMerge
forfiles /M ?_0* /C "cmd /c ren @file 0@file"
cd ..\..

::Merge subfolders into output folder
FOR /D %%i in (.\Appendices\*) do (CALL sejda-console merge -d %%i -o .\temp\toMerge\%%~ni.pdf -b discard)

::Copy Report to temp
COPY .\Report\* .\temp\report 

::Prefix Report
FORFILES /p .\temp\report /C "cmd /c ren @file 00@file"

::Move Report to temp
COPY .\temp\report\* .\temp\toMerge

::Merge files in outputfolder
CALL sejda-console merge -d .\temp\toMerge -o .\final.pdf --overwrite

:Delete temp dir
IF EXIST "temp" ECHO exists(
	RMDIR temp /s /q