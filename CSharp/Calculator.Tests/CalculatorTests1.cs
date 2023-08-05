/*--------------------------------------------------------------------------*\
::
::  Copyright © 2023 Steffen Liersch
::  https://www.steffen-liersch.de/
::
\*--------------------------------------------------------------------------*/

using System;
using System.Collections.Generic;
using System.Linq;
using Liersch.Json;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace Liersch.Calculator.Tests;

[TestClass]
public sealed class CalculatorTests1
{
  [TestMethod]
  public void PerformTests()
  {
    int testCount = 0;
    int errorCount = 0;
    var calculator = new Calculator(new FloatFormatter("G"));
    string json = Helpers.LoadTests();
    JsonNode tests = JsonNode.Parse(json);
    foreach(JsonNode test in tests)
    {
      Console.WriteLine("Test: " + test["name"].AsString);
      IList<string> output = ToStringArray(test["output"]);
      IList<string> array = ToStringArray(test["expression"]);
      foreach(string expr in array)
      {
        IList<string> lines = calculator.CalculateAndFormat(expr, "");
        if(!Helpers.AssertEqual(output, lines))
          errorCount++;
        testCount++;
      }
    }
    Console.WriteLine($"=> {testCount} tests completed with {errorCount} errors");

    if(errorCount > 0)
      Assert.Fail();
  }

  static IList<string> ToStringArray(JsonNode node)
  {
    if(node.IsArray)
      return node.Select(x => x.AsString).ToList();

    return new string[] { node.AsString };
  }
}
