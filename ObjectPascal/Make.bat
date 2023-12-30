::----------------------------------------------------------------------------
::
::  Copyright © 2023 Steffen Liersch
::  https://www.steffen-liersch.de/
::
::----------------------------------------------------------------------------

@echo off

where /Q fpc
if not %ERRORLEVEL%==0 (echo Free Pascal not installed & pause & exit /B 1)

set exe=%~dp0
set target=%~dp0_out
if not exist "%target%" mkdir "%target%"

fpc "-FE%exe%" "-FU%target%" "%~dp0Tests.pas"
if not %ERRORLEVEL%==0 (pause & exit /B 1)

"%exe%\Tests.exe"
if not %ERRORLEVEL%==0 (pause & exit /B 1)

fpc "-FE%exe%" "-FU%target%" "%~dp0Program.dpr"
if not %ERRORLEVEL%==0 (pause & exit /B 1)
"%exe%\Program.exe"
