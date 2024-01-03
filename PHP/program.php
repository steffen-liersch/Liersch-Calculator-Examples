#!/usr/bin/env php
<?php /*--------------------------------------------------------------------*\
::
::  Copyright © 2023-2024 Steffen Liersch
::  https://www.steffen-liersch.de/
::
\*--------------------------------------------------------------------------*/

namespace Liersch\Calculator;

require_once dirname(__FILE__) . '/calculator.php';

function runUI(): void
{
  echo "\n";
  echo "Liersch Calculator (PHP)\n";
  echo "==================\n";
  echo "\n";

  echo "Copyright © 2023-2024 Steffen Liersch\n";
  echo "https://www.steffen-liersch.de/\n";
  echo "\n";

  $calculator = new Calculator();

  $exitState = 0;
  while (true)
  {
    $s = readline('? ');
    $s = trim($s);

    if (strlen($s) > 0)
    {
      foreach ($calculator->calculateAndFormat($s) as $x)
        echo "{$x}\n";
      $exitState = 0;
    }
    else
    {
      if ($exitState > 0)
        break;

      echo "Press [Enter] again to exit.\n";
      $exitState++;
    }

    echo "\n";
  }
}

function runWithArgs(array $args): void
{
  $calculator = new Calculator();
  foreach ($args as $a)
  {
    $x = $calculator->calculateAndFormat($a, "");
    $c = count($x);
    echo ($c > 0 ? $x[$c - 1] : '') . "\n";
  }
}

if (get_included_files()[0] == __FILE__)
{
  if ($argc > 1)
    runWithArgs(array_slice($argv, 1));
  else
    runUI();
}
