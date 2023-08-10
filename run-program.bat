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

call :run py "%base%Python\program.py" %suffix%
call :run php "%base%PHP\program.php" %suffix%
call :run dotnet run --project "%base%CSharp\Calculator" %suffix%

echo The program could not be started because no suitable runtime environment is installed.
popd
pause
exit /B 1


:run

where /Q %1 || exit /B 1

if "%args%"=="" (
  echo.
  echo ^> %* %args%
)

cmd /c %* %args%
exit /B 0
