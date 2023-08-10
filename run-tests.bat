::----------------------------------------------------------------------------
::
::  Copyright © 2023 Steffen Liersch
::  https://www.steffen-liersch.de/
::
::----------------------------------------------------------------------------

@echo off

set suffix= ^|^| (echo Test failed ^& popd ^& pause ^& exit /B 1)
set base=%~dp0

pushd "%base%CSharp\Calculator.Tests"
call :run dotnet test %suffix%
popd

pushd "%base%"

call :run php "%base%PHP\tests.php" %suffix%
call :run py "%base%Python\tests.py" %suffix%

echo All the tests performed were successful.
popd
pause
exit /B 0


:run

echo ================ Testing %1 ================
echo.

where %1 >nul 2>&1
if not %ERRORLEVEL%==0 (echo %1 is not installed & echo. & echo. & exit /B 0)

echo ^> %*
cmd /c %*
if not %ERRORLEVEL%==0 exit /B 1

echo.
exit /B 0
