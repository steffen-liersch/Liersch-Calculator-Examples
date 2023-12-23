/*--------------------------------------------------------------------------*\
::
::  Copyright © 2023 Steffen Liersch
::  https://www.steffen-liersch.de/
::
\*--------------------------------------------------------------------------*/

package de.steffen_liersch.calculator;

final class Token
{
  public final Double asNumber;

  public final String asString;

  public Token(double value)
  {
    asNumber = value;
    asString = String.valueOf(value);
  }

  public Token(String value)
  {
    Double d = tryParseDouble(value);
    if(d != null)
    {
      asNumber = d;
      asString = value;
    }
    else
    {
      switch(value.toUpperCase())
      {
        case "E":
          asNumber = Math.E;
          asString = "E";
          break;

        case "PI":
          asNumber = Math.PI;
          asString = "PI";
          break;

        default:
          asNumber = null;
          asString = value;
          break;
      }
    }
  }

  @Override
  public String toString()
  {
    if(asNumber != null && asNumber < 0)
      return "(" + asNumber + ")";
    return asString;
  }

  private static Double tryParseDouble(String value)
  {
    try
    {
      return Double.parseDouble(value);
    }
    catch(NumberFormatException e)
    {
      return null;
    }
  }
}
