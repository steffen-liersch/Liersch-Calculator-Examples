/*--------------------------------------------------------------------------*\
::
::  Copyright © 2023 Steffen Liersch
::  https://www.steffen-liersch.de/
::
\*--------------------------------------------------------------------------*/

export { CalculatorError };

class CalculatorError extends Error
{
  constructor(message: string)
  {
    super(message);
    this.name = 'CalculatorError';
  }
}
