::----------------------------------------------------------------------------
::
::  Copyright © 2023 Steffen Liersch
::  https://www.steffen-liersch.de/
::
::----------------------------------------------------------------------------

@echo off

set suffix= ^&^& (popd ^& exit /B 0)
set base=%~dp0
set args=%*

pushd "%base%"

call :run php "%base%PHP\program.php" %suffix%
call :run dotnet run --project "%base%CSharp\Calculator" %suffix%

echo The program could not be started because no suitable runtime environment is installed.
popd
pause
exit /B 1


:run

if not exist %1% (
  where %1 >nul 2>&1
  if not %ERRORLEVEL%==0 exit /B 1
)

if "%args%"=="" (
  echo.
  echo ^> %* %args%
)

cmd /c %* %args%
exit /B 0
