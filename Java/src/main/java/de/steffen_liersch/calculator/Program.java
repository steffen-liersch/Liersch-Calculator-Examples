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
  static PrintWriter writer = new PrintWriter(console.writer(), true);

  static void runUI()
  {
    writer.println();
    writer.println("Liersch Calculator (Java)");
    writer.println("==================");
    writer.println();

    writer.println("Copyright © 2023-2024 Steffen Liersch");
    writer.println("https://www.steffen-liersch.de/");
    writer.println();

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
          writer.println(x);
        exitState = 0;
      }
      else
      {
        if(exitState > 0)
          break;

        writer.println("Press [Enter] again to exit.");
        exitState++;
      }

      writer.println();
    }
  }

  static void runWithArgs(String[] args)
  {
    var calculator = new Calculator();
    for(String a : args)
    {
      List<String> x = calculator.calculateAndFormat(a, "");
      int c = x.size();
      writer.println(c > 0 ? x.get(c - 1) : "");
    }
  }

  public static void main(String[] args)
  {
    if(args.length > 0)
      runWithArgs(args);
    else runUI();
  }
}
