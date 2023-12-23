<?php /*--------------------------------------------------------------------*\
::
::  Copyright © 2023 Steffen Liersch
::  https://www.steffen-liersch.de/
::
\*--------------------------------------------------------------------------*/

namespace Liersch\Calculator;

require_once dirname(__FILE__) . '/default-format.php';

final class Token
{
  // The following fields should be read-only.
  // As of PHP 8.1.0, the readonly modifier is supported.
  public float|null $asNumber;
  public string $asString;

  public function __construct(float|string $value)
  {
    if (is_float($value))
    {
      $this->asNumber = $value;
      $this->asString = sprintf(DEFAULT_FLOAT_FORMAT_16, $value);
    }
    elseif (is_numeric($value))
    {
      $v = floatval($value);
      $this->asNumber = $v;
      $this->asString = $value;
    }
    else
    {
      $v = strval($value);
      switch (strtoupper($v))
      {
        case 'E':
          $this->asNumber = M_E;
          $this->asString = 'E';
          break;

        case 'PI':
          $this->asNumber = M_PI;
          $this->asString = 'PI';
          break;

        default:
          $this->asNumber = null;
          $this->asString = $v;
          break;
      }
    }
  }
}
