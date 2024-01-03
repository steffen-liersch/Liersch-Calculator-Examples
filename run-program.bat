::----------------------------------------------------------------------------
::
::  Copyright © 2023-2024 Steffen Liersch
::  https://www.steffen-liersch.de/
::
::----------------------------------------------------------------------------

@echo off

set args=%*
goto main


:main

set suffix= ^&^& (popd ^& exit /B 0)
set base=%~dp0


pushd "%base%"

call :try node "%base%JavaScript\program.js" %suffix%
call :try py "%base%Python\program.py" %suffix%
call :try php "%base%PHP\program.php" %suffix%
call :try julia "%base%Julia\Program.jl" %suffix%
call :try dotnet run --project "%base%CSharp\Calculator" %suffix%

where /Q fpc && call :run "%base%ObjectPascal\build-and-run.bat" %suffix%
if exist "%JAVA_HOME%\bin" call :run "%base%Java\build-and-run.bat" %suffix%

:: Try with Deno last, because there is currently a problem in the prompt-function (seen on Windows 11)
call :try deno run "%base%TypeScript\program.ts" %suffix%
call :try deno run "%base%JavaScript\program.js" %suffix%

popd


pushd "%base%\Go"
call :try go run . %suffix%
popd


echo The program could not be started because no suitable runtime environment is installed.
pause
exit /B 1


:try

where /Q %1
if not %ERRORLEVEL%==0 exit /B 1
goto run


:run

if "%args%"=="" (
  echo.
  echo ^> %*
)

cmd /C %* %args% 
exit /B 0
