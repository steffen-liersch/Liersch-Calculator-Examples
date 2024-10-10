::----------------------------------------------------------------------------
::
::  Copyright © 2023-2024 Steffen Liersch
::  https://www.steffen-liersch.de/
::
::----------------------------------------------------------------------------

@echo off
pushd "%~dp0"

where /Q docker || (echo Docker is not installed & goto error)
docker compose ps --all
echo.

docker compose build || goto error
docker compose run --rm example || goto error

goto end

:end
popd
exit /B 0

:error
popd
echo.
pause
exit /B 1
