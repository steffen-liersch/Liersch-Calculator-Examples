/*--------------------------------------------------------------------------*\
::
::  Copyright © 2023 Steffen Liersch
::  https://www.steffen-liersch.de/
::
\*--------------------------------------------------------------------------*/

using System;
using System.IO;
using System.Text;

namespace Liersch.Calculator.Tests;

static class Helpers
{
  public static string LoadTests()
  {
    string fn = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "../../../../Unit-Testing/tests.json");
    return File.ReadAllText(fn, Encoding.UTF8);
  }
}
