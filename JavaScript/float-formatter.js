/*--------------------------------------------------------------------------*\
::
::  Copyright © 2023 Steffen Liersch
::  https://www.steffen-liersch.de/
::
\*--------------------------------------------------------------------------*/

export { FloatFormatter };

class FloatFormatter
{
  constructor(arg)
  {
    if(typeof arg == 'object')
      this._format = arg;
    else this._format = createFormat(typeof arg == 'number' ? arg : 6);
  }

  format(value) { return this._format.format(value); }

  _format;
}

function createFormat(maximumSignificantDigits)
{
  return new Intl.NumberFormat('en-US', {
    notation: 'standard',
    style: 'decimal',
    useGrouping: false,
    maximumSignificantDigits,
  });
}
