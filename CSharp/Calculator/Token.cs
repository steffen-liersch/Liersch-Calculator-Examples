/*--------------------------------------------------------------------------*\
::
::  Copyright © 2023 Steffen Liersch
::  https://www.steffen-liersch.de/
::
\*--------------------------------------------------------------------------*/

using System;
using System.Globalization;

namespace Liersch.Calculator;

sealed class Token
{
  public readonly double? AsNumber;

  public readonly string AsString;

  public Token(double value)
  {
    AsNumber = value;
    AsString = value.ToString(CultureInfo.InvariantCulture);
  }

  public Token(string value)
  {
    if(double.TryParse(value, NumberStyles.Float, CultureInfo.InvariantCulture, out double v))
    {
      AsNumber = v;
      AsString = value;
    }
    else
    {
      switch(value.ToUpperInvariant())
      {
        case "E":
          AsNumber = Math.E;
          AsString = "E";
          break;

        case "PI":
          AsNumber = Math.PI;
          AsString = "PI";
          break;

        default:
          AsString = value;
          break;
      }
    }
  }

  public override string ToString() => AsString;
}
