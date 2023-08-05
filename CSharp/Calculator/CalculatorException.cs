/*--------------------------------------------------------------------------*\
::
::  Copyright © 2023 Steffen Liersch
::  https://www.steffen-liersch.de/
::
\*--------------------------------------------------------------------------*/

using System;

namespace Liersch.Calculator;

sealed class CalculatorException : Exception
{
  public CalculatorException(string message) : base(message) { }
}
