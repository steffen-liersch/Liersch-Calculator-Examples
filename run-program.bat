::----------------------------------------------------------------------------
::
::  Copyright © 2023 Steffen Liersch
::  https://www.steffen-liersch.de/
::
::----------------------------------------------------------------------------

@echo off

::       | The leading space is important to work around a
::       | bug at %args:"=% if no parameters are specified!
set args= %*
goto main


:main

set suffix= ^&^& (popd ^& exit /B 0)
set base=%~dp0

pushd "%base%\Go"
call :run go run . %suffix%
popd

pushd "%base%"

call :run node "%base%JavaScript\program.js" %suffix%
call :run py "%base%Python\program.py" %suffix%
call :run php "%base%PHP\program.php" %suffix%
call :run julia "%base%Julia\Program.jl" %suffix%
call :run dotnet run --project "%base%CSharp\Calculator" %suffix%

if exist "%JAVA_HOME%\bin" call :run_no_check "%base%Java\build-and-run.bat" %suffix%

:: Try with Deno last, because there is currently a problem in the prompt-function (seen on Windows 11)
call :run deno run "%base%TypeScript\program.ts" %suffix%
call :run deno run "%base%JavaScript\program.js" %suffix%

echo The program could not be started because no suitable runtime environment is installed.
popd
pause
exit /B 1


:run

where /Q %1
if not %ERRORLEVEL%==0 exit /B 1
goto run_no_check


:run_no_check

if "%args:"=%"==" " (
  echo.
  echo ^> %*
)

cmd /C %* %args%
exit /B 0
