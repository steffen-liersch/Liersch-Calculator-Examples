::----------------------------------------------------------------------------
::
::  Copyright © 2023 Steffen Liersch
::  https://www.steffen-liersch.de/
::
::----------------------------------------------------------------------------

@echo off
goto main


:main
set suffix= ^|^| (echo Test failed ^& popd ^& pause ^& exit /B 1)
set base=%~dp0

pushd "%base%"

call :run node --no-warnings "%base%JavaScript\tests.js" %suffix%
call :run deno run "%base%JavaScript\tests.js" %suffix%
call :run deno run "%base%TypeScript\tests.ts" %suffix%
call :run dotnet test "%base%CSharp" %suffix%
call :run julia "%base%Julia\Tests.jl" %suffix%
call :run php "%base%PHP\tests.php" %suffix%
call :run py "%base%Python\tests.py" %suffix%

echo All the tests performed were successful.
popd
pause
exit /B 0


:run

echo ================ Testing %1 ================
echo.

where /Q %1
if not %ERRORLEVEL%==0 (echo %1 is not installed & echo. & echo. & exit /B 0)

echo ^> %*
cmd /C %*
if not %ERRORLEVEL%==0 exit /B 1

echo.
exit /B 0
