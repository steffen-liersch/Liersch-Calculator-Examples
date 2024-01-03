::----------------------------------------------------------------------------
::
::  Copyright © 2023-2024 Steffen Liersch
::  https://www.steffen-liersch.de/
::
::----------------------------------------------------------------------------

@echo off
goto main


:main

set base=%~dp0


pushd "%base%Go"
call :try go test || goto error
popd


pushd "%base%Java"
call :try mvn --quiet package || goto error
popd


pushd "%base%"

call :check fpc && (call :run "%base%ObjectPascal\build-and-test.bat" --nowait || goto error)

call :try node --no-warnings "%base%JavaScript\tests.js" || goto error
call :try deno run "%base%JavaScript\tests.js" || goto error
call :try deno run "%base%TypeScript\tests.ts" || goto error
call :try dotnet test "%base%CSharp" || goto error
call :try julia "%base%Julia\Tests.jl" || goto error
call :try php "%base%PHP\tests.php" || goto error
call :try py "%base%Python\tests.py" || goto error

popd


echo All the tests performed were successful.
pause
exit /B 0


:try

call :check %1 || exit /B 0
goto run


:run

echo ^> %*
cmd /C %*
if not %ERRORLEVEL%==0 exit /B 1

echo.
exit /B 0


:check

echo ================ Testing %1 ================
echo.

where /Q %1
if not %ERRORLEVEL%==0 (echo %1 is not installed & echo. & echo. & exit /B 1)
exit /B 0


:error

echo Test failed
popd
pause
exit /B 1
