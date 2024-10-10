::----------------------------------------------------------------------------
::
::  Copyright © 2023 Steffen Liersch
::  https://www.steffen-liersch.de/
::
::----------------------------------------------------------------------------

@echo off

where /Q mvn
if not %ERRORLEVEL%==0 (echo Mavon utility "mvn" not installed & pause & exit /B 1)
if not exist "%JAVA_HOME%\bin" (echo Java not installed & pause & exit /B 1)

set base=%~dp0

pushd "%base%"
cmd /C mvn --quiet package
if not %ERRORLEVEL%==0 (echo Failed to compile & popd & pause & exit /B 1)
popd

"%JAVA_HOME%\bin\java" -jar "%base%target\calculator-1.0-SNAPSHOT.jar" %*
if not %ERRORLEVEL%==0 (echo Failed to start & pause & exit /B 1)

exit /B 0
