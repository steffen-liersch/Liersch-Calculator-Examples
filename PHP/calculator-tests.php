<?php /*--------------------------------------------------------------------*\
::
::  Copyright © 2023 Steffen Liersch
::  https://www.steffen-liersch.de/
::
\*--------------------------------------------------------------------------*/

namespace Liersch\Calculator;

require_once dirname(__FILE__) . '/calculator.php';

use \InvalidArgumentException;

function performTests(array &$tests): bool
{
  $testCount = 0;
  $errorCount = 0;
  $calculator = new Calculator(new FloatFormatter(DEFAULT_FLOAT_FORMAT_16));
  foreach ($tests as $test)
  {
    echo 'Test: ' . $test->name . "\n";
    $array = is_array($test->expression) ? $test->expression : array($test->expression);
    foreach ($array as $expr)
    {
      $lines = $calculator->calculateAndFormat($expr, '');
      if (!assertEqual($test->output, $lines))
        $errorCount++;
      $testCount++;
    }
  }
  echo "=> $testCount tests completed with $errorCount errors\n";
  return $errorCount <= 0;
}

function assertEqual(array &$expected, array &$actual): bool
{
  if (!is_array($expected))
    throw new InvalidArgumentException('Array expected (1)');

  if (!is_array($actual))
    throw new InvalidArgumentException('Array expected (2)');

  $c1 = count($expected);
  $c2 = count($actual);
  if ($c1 != $c2)
  {
    echo "Assertion failed: Arrays with different lengths\n";
    return false;
  }

  for ($i = 0; $i < $c1; $i++)
  {
    if ($expected[$i] != $actual[$i])
    {
      echo "Assertion failed: {$expected[$i]} != {$actual[$i]})\n";
      return false;
    }
  }

  return true;
}
