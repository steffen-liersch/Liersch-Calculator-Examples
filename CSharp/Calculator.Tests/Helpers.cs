/*--------------------------------------------------------------------------*\
::
::  Copyright © 2023 Steffen Liersch
::  https://www.steffen-liersch.de/
::
\*--------------------------------------------------------------------------*/

using System;
using System.Collections.Generic;
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

  public static bool AssertEqual(IList<string> expected, IList<string> actual)
  {
    int c1 = expected.Count;
    int c2 = actual.Count;
    if(c1 != c2)
    {
      Console.WriteLine("Assertion failed: Arrays with different lengths");
      return false;
    }

    for(int i = 0; i < c1; i++)
    {
      if(expected[i] != actual[i])
      {
        Console.WriteLine($"Assertion failed ({expected[i]}, {actual[i]}");
        return false;
      }
    }

    return true;
  }
}
