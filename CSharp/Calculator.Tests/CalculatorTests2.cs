/*--------------------------------------------------------------------------*\
::
::  Copyright © 2023 Steffen Liersch
::  https://www.steffen-liersch.de/
::
\*--------------------------------------------------------------------------*/

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.Json.Nodes;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace Liersch.Calculator.Tests;

[TestClass]
public sealed class CalculatorTests2
{
  [TestMethod]
  public void PerformTests()
  {
    int testCount = 0;
    int errorCount = 0;
    var calculator = new Calculator(new FloatFormatter("G"));
    string json = Helpers.LoadTests();
    JsonArray tests = JsonNode.Parse(json)!.AsArray();
    foreach(JsonNode? node in tests)
    {
      JsonObject test = node!.AsObject();
      Console.WriteLine("Test: " + test["name"]);
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

  static IList<string> ToStringArray(JsonNode? node)
  {
    if(node == null)
      throw new ArgumentNullException(nameof(node));

    if(node is JsonArray a)
      return a.Select(x => x != null ? x.ToString() : "").ToList();

    return new string[] { node.ToString() };
  }
}
