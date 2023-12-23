/*--------------------------------------------------------------------------*\
::
::  Copyright © 2023 Steffen Liersch
::  https://www.steffen-liersch.de/
::
\*--------------------------------------------------------------------------*/

package de.steffen_liersch.calculator;

import com.fasterxml.jackson.databind.JsonNode;
import org.junit.Assert;
import org.junit.Test;

import java.text.MessageFormat;
import java.util.ArrayList;
import java.util.List;

public final class CalculatorTests
{
  @Test
  public void performTests()
  {
    int testCount = 0;
    int errorCount = 0;
    var calculator = new Calculator(new FloatFormatter(16));
    String json = Helpers.loadTests();
    JsonNode tests = JSON.parse(json);
    for(JsonNode test : tests)
    {
      System.out.println("Test: " + test.get("name").asText());
      List<String> output = toStringArray(test.get("output"));
      List<String> array = toStringArray(test.get("expression"));
      for(String expr : array)
      {
        List<String> lines = calculator.calculateAndFormat(expr, "");
        if(!assertEqual(output, lines))
          errorCount++;
        testCount++;
      }
    }
    System.out.println(
        MessageFormat.format("=> {0} tests completed with {1} errors", testCount, errorCount));

    if(errorCount > 0)
      Assert.fail();
  }

  private static boolean assertEqual(List<String> expected, List<String> actual)
  {
    int c1 = expected.size();
    int c2 = actual.size();
    if(c1 != c2)
    {
      System.out.println("Assertion failed: Arrays with different lengths");
      return false;
    }

    for(int i = 0; i < c1; i++)
    {
      if(!expected.get(i).equals(actual.get(i)))
      {
        System.out.println(
            MessageFormat.format("Assertion failed ({0}, {1}", expected.get(i), actual.get(i)));
        return false;
      }
    }

    return true;
  }

  private static List<String> toStringArray(JsonNode node)
  {
    var res = new ArrayList<String>();
    if(!node.isArray())
      res.add(node.asText());
    else
    {
      for(var x : node)
        res.add(x.asText());
    }

    return res;
  }
}
