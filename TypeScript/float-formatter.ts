/*--------------------------------------------------------------------------*\
::
::  Copyright © 2023 Steffen Liersch
::  https://www.steffen-liersch.de/
::
\*--------------------------------------------------------------------------*/

export { FloatFormatter };

class FloatFormatter
{
  constructor();
  constructor(format: Intl.NumberFormat);
  constructor(maximumSignificantDigits: number);
  constructor(arg?: Intl.NumberFormat | number)
  {
    if(typeof arg == 'object')
      this._format = arg;
    else this._format = createFormat(typeof arg == 'number' ? arg : 6);
  }

  format(value: number): string { return this._format.format(value); }

  private _format: Intl.NumberFormat;
}

function createFormat(maximumSignificantDigits: number): Intl.NumberFormat
{
  return new Intl.NumberFormat('en-US', {
    notation: 'standard',
    style: 'decimal',
    useGrouping: false,
    maximumSignificantDigits,
  });
}
