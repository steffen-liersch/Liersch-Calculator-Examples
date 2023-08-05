#!/usr/bin/env php
<?php /*--------------------------------------------------------------------*\
::
::  Copyright © 2023 Steffen Liersch
::  https://www.steffen-liersch.de/
::
\*--------------------------------------------------------------------------*/

function showEnvironmentInfo()
{
  echo str_repeat('-', 64) . "\n";
  echo 'Configuration   : ' . php_ini_loaded_file() . "\n";
  echo 'Interpreter     : ' . PHP_BINARY . "\n";
  echo 'Version         : ' . PHP_VERSION . "\n";
  echo 'Operating System: ' . PHP_OS_FAMILY . "\n";
  echo str_repeat('-', 64) . "\n\n";
}

if (get_included_files()[0] == __FILE__)
  showEnvironmentInfo();
