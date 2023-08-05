/*--------------------------------------------------------------------------*\
::
::  Copyright © 2023 Steffen Liersch
::  https://www.steffen-liersch.de/
::
\*--------------------------------------------------------------------------*/

using System.Globalization;

namespace Liersch.Calculator;

// https://learn.microsoft.com/de-de/dotnet/api/system.double.tostring?view=net-7.0
sealed class FloatFormatter
{
  public FloatFormatter() : this("G6", CultureInfo.InvariantCulture) { }

  public FloatFormatter(string format) : this(format, CultureInfo.InvariantCulture) { }

  public FloatFormatter(string format, CultureInfo culture)
  {
    _culture = culture;
    _format = format;
  }

  public string Format(double value) => value.ToString(_format, _culture);

  readonly CultureInfo _culture;
  readonly string _format;
}
