#!/usr/bin/env php
<?php /*--------------------------------------------------------------------*\
::
::  Copyright © 2023 Steffen Liersch
::  https://www.steffen-liersch.de/
::
\*--------------------------------------------------------------------------*/

namespace Liersch\Calculator;

require_once dirname(__FILE__) . '/calculator-tests.php';

function runTests(): bool
{
  echo "\n";
  $n = dirname(__FILE__) . '/../Unit-Testing/tests.json';
  $json = file_get_contents($n);
  $tests = json_decode($json, false);
  $ok = performTests($tests);
  echo "\n";
  return $ok;
}

if (get_included_files()[0] == __FILE__)
  exit(runTests() ? 0 : 1);
