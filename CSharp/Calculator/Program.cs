/*--------------------------------------------------------------------------*\
::
::  Copyright © 2023 Steffen Liersch
::  https://www.steffen-liersch.de/
::
\*--------------------------------------------------------------------------*/

using System;
using System.Linq;

namespace Liersch.Calculator;

static class Program
{
  static void RunUI()
  {
    Console.WriteLine();
    Console.WriteLine("Liersch Calculator (C#)");
    Console.WriteLine("==================");
    Console.WriteLine();

    Console.WriteLine("Copyright © 2023 Steffen Liersch");
    Console.WriteLine("https://www.steffen-liersch.de/");
    Console.WriteLine();

    var calculator = new Calculator();

    int exitState = 0;
    while(true)
    {
      Console.Write("? ");

      string? s = Console.ReadLine();
      s = s?.Trim();

      if(!string.IsNullOrEmpty(s))
      {
        foreach(string x in calculator.CalculateAndFormat(s))
          Console.WriteLine(x);
        exitState = 0;
      }
      else
      {
        if(exitState > 0)
          break;

        Console.WriteLine("Press [Enter] again to exit.");
        exitState++;
      }

      Console.WriteLine();
    }
  }

  static void RunWithArgs(string[] args)
  {
    var calculator = new Calculator();
    foreach(string a in args)
      Console.WriteLine(calculator.CalculateAndFormat(a, "").LastOrDefault(""));
  }

  static void Main(string[] args)
  {
    if(args.Length > 0)
      RunWithArgs(args);
    else RunUI();
  }
}
