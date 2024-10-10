::----------------------------------------------------------------------------
::
::  Copyright © 2023-2024 Steffen Liersch
::  https://www.steffen-liersch.de/
::
::----------------------------------------------------------------------------

@echo off
goto main


:error

if not "%1"=="--nowait" pause
exit /B 1


:main

where /Q fpc
if not %ERRORLEVEL%==0 (echo Free Pascal not installed & goto error)

set exe=%~dp0
set target=%~dp0_out
if not exist "%target%" mkdir "%target%"

fpc "-FE%exe%" "-FU%target%" "%~dp0Tests.pas"
if not %ERRORLEVEL%==0 goto error

"%exe%\Tests.exe"
if not %ERRORLEVEL%==0 goto error

exit /B 0
