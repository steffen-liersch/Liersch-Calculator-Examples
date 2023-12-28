/*--------------------------------------------------------------------------*\
::
::  Copyright © 2023 Steffen Liersch
::  https://www.steffen-liersch.de/
::
\*--------------------------------------------------------------------------*/

export { FloatFormatter };

class FloatFormatter
{
  constructor(precision: number = 6)
  {
    this._precision = precision;
  }

  format(value: number): string
  {
    return value.toPrecision(this._precision)
      .replace(/e/, 'E')
      .replace(/\.?0+($|(?=E))/, '');
  }

  private _precision?: number;
}
