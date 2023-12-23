/*--------------------------------------------------------------------------*\
::
::  Copyright © 2023 Steffen Liersch
::  https://www.steffen-liersch.de/
::
\*--------------------------------------------------------------------------*/

export { Token };

class Token
{
  asNumber;
  asString;

  constructor(value)
  {
    if(typeof value == 'number')
    {
      this.asNumber = value;
      this.asString = '' + value;
    }
    else
    {
      let v = Number(value);
      if(!Number.isNaN(v))
      {
        this.asNumber = v;
        this.asString = value;
      }
      else
      {
        switch(value.toUpperCase())
        {
          case 'E':
            this.asNumber = Math.E;
            this.asString = 'E';
            break;

          case 'PI':
            this.asNumber = Math.PI;
            this.asString = 'PI';
            break;

          default:
            this.asString = value;
            break;
        }
      }
    }
  }

  toString() { return this.asString; }
}
