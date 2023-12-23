/*--------------------------------------------------------------------------*\
::
::  Copyright © 2023 Steffen Liersch
::  https://www.steffen-liersch.de/
::
\*--------------------------------------------------------------------------*/

package de.steffen_liersch.calculator;

import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.util.Locale;

final class FloatFormatter
{
  public FloatFormatter()
  {
    this(6);
  }

  public FloatFormatter(int maximumSignificantDigits)
  {
    _format = new DecimalFormat("0." + "#".repeat(maximumSignificantDigits - 1),
        DecimalFormatSymbols.getInstance(Locale.US));
  }

  public String format(double value)
  {
    return _format.format(value);
  }

  private final DecimalFormat _format;
}
