::----------------------------------------------------------------------------
::
::  Copyright © 2023 Steffen Liersch
::  https://www.steffen-liersch.de/
::
::----------------------------------------------------------------------------

@echo off

if not exist "%JAVA_HOME%\bin" (echo Java not installed & pause & exit /B 1)

set base=%~dp0

pushd "%base%"
"%JAVA_HOME%\bin\javac" -encoding utf8 -d "%base%_out\classes" @files-to-compile.txt
if not %ERRORLEVEL%==0 (echo Failed to compile & popd & pause & exit /B 1)
popd

"%JAVA_HOME%\bin\jar" -cfm "%base%_out\calculator.jar" "%base%manifest.txt" -C "%base%_out\classes" .
if not %ERRORLEVEL%==0 (echo Failed to create JAR file & pause & exit /B 1)

"%JAVA_HOME%\bin\java" -jar "%base%_out\calculator.jar" %*
if not %ERRORLEVEL%==0 (echo Failed to start & pause & exit /B 1)

exit /B 0
