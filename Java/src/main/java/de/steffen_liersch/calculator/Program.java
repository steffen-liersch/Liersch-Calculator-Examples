/*--------------------------------------------------------------------------*\
::
::  Copyright © 2023-2024 Steffen Liersch
::  https://www.steffen-liersch.de/
::
\*--------------------------------------------------------------------------*/

package de.steffen_liersch.calculator;

import java.io.Console;
import java.io.PrintWriter;
import java.util.List;

final class Program
{
  static Console console = System.console();
  static PrintWriter wr = console.writer();

  static void runUI()
  {
    wr.println();
    wr.println("Liersch Calculator (Java)");
    wr.println("==================");
    wr.println();

    wr.println("Copyright © 2023-2024 Steffen Liersch");
    wr.println("https://www.steffen-liersch.de/");
    wr.println();

    var calculator = new Calculator();

    int exitState = 0;
    while(true)
    {
      String s = console.readLine("? ");
      if(s != null)
        s = s.trim();

      if(s != null && s.length() > 0)
      {
        for(String x : calculator.calculateAndFormat(s))
          wr.println(x);
        exitState = 0;
      }
      else
      {
        if(exitState > 0)
          break;

        wr.println("Press [Enter] again to exit.");
        exitState++;
      }

      wr.println();
    }
  }

  static void runWithArgs(String[] args)
  {
    var calculator = new Calculator();
    for(String a : args)
    {
      List<String> x = calculator.calculateAndFormat(a, "");
      int c = x.size();
      wr.println(c > 0 ? x.get(c - 1) : "");
    }
  }

  public static void main(String[] args)
  {
    if(args.length > 0)
      runWithArgs(args);
    else runUI();
  }
}
