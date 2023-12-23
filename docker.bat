::----------------------------------------------------------------------------
::
::  Copyright © 2023 Steffen Liersch
::  https://www.steffen-liersch.de/
::
::----------------------------------------------------------------------------

@echo off
pushd "%~dp0"

where /Q docker-compose
if not %ERRORLEVEL%==0 (echo Docker utility "docker-compose" not installed & goto error)
docker-compose ps
echo.

docker-compose build
if not %ERRORLEVEL%==0 goto error

docker-compose run --rm example
if not %ERRORLEVEL%==0 goto error

goto end

:end
popd
exit /B 0

:error
echo.
pause
popd
exit /B 1
