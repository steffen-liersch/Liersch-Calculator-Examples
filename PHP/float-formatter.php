<?php /*--------------------------------------------------------------------*\
::
::  Copyright © 2023 Steffen Liersch
::  https://www.steffen-liersch.de/
::
\*--------------------------------------------------------------------------*/

namespace Liersch\Calculator;

require_once dirname(__FILE__) . '/default-format.php';

// https://www.php.net/manual/en/function.sprintf.php
final class FloatFormatter
{
  public function __construct(string $format = DEFAULT_FLOAT_FORMAT_6)
  {
    $this->format = $format;
  }

  public function format(float $value): string
  {
    return sprintf($this->format, $value);
  }

  private string $format;
}
