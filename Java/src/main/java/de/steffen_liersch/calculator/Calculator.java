/*--------------------------------------------------------------------------*\
::
::  Copyright © 2023 Steffen Liersch
::  https://www.steffen-liersch.de/
::
\*--------------------------------------------------------------------------*/

package de.steffen_liersch.calculator;

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

final class Calculator
{
  public List<List<Token>> getSteps()
  {
    return _steps;
  }

  public Calculator()
  {
    this(null);
  }

  public Calculator(FloatFormatter formatter)
  {
    _formatter = formatter != null ? formatter : new FloatFormatter();
  }

  String format(Token token)
  {
    Double v = token.asNumber;
    if(v == null)
      return token.asString;

    String s = this._formatter.format(v);
    return v < 0 ? '(' + s + ')' : s;
  }

  public List<String> calculateAndFormat(String expression)
  {
    return calculateAndFormat(expression, "= ");
  }

  public List<String> calculateAndFormat(String expression, String stepPrefix)
  {
    Double v = null;
    String e = null;
    try
    {
      v = calculate(expression);
    }
    catch(CalculatorException x) // Don't handle unexpected errors!
    {
      e = x.getMessage();
    }

    var res = new ArrayList<String>();
    _steps.stream()
        .map(p -> stepPrefix + p.stream().map(this::format).collect(Collectors.joining("")))
        .forEach(res::add);

    if(v != null)
      res.add(stepPrefix + _formatter.format(v));

    if(e != null)
      res.add(e);

    return res;
  }

  public Double calculate(String expression)
  {
    if(expression == null)
      throw new IllegalArgumentException("Value expected for expression");

    _isFirstStep = true;
    _steps.clear();
    _matches.clear();

    Matcher matcher = _re.matcher(expression);
    while(matcher.find())
      _matches.add(new Token(matcher.group()));

    if(_matches.isEmpty())
      return null;

    calculateFrom(0);

    if(_matches.isEmpty())
      throw new IllegalStateException();

    if(_matches.size() > 1)
      throw new CalculatorException("Operator expected instead of " + _matches.get(1).asString);

    Token m = _matches.get(0);
    if(m.asNumber == null)
      throw new IllegalStateException();

    return m.asNumber;
  }

  private int calculateFrom(int index)
  {
    resolve(index, "^", (op, x, y) -> Math.pow(x, y));
    resolve(index, "*/%", Calculator::performPointCalculation);
    return resolve(index, "+-", (op, x, y) -> op == '+' ? x + y : x - y);
  }

  private int resolve(int index, String operators, Function3<Character, Double, Double, Double> fn)
  {
    int i = index;
    Integer sgn = tryGetSign(i);
    if(sgn != null)
    {
      i++;

      // Power operator has priority over sign
      if(operators.equals("^"))
        sgn = null;
    }

    Double v1 = getValue(i++);
    if(sgn != null)
      v1 *= sgn;

    boolean saved = false;

    while(i < _matches.size() && !_matches.get(i).asString.equals(")"))
    {
      char op = getOperator(i++);
      double v2 = getValue(i++);

      if(operators.indexOf(op) >= 0)
      {
        v2 = fn.apply(op, v1, v2);

        if(!saved)
        {
          saved = true;
          saveResult();
        }

        int z = sgn != null ? 4 : 3;
        _matches.splice(i - z, z, new Token(v2));
        i -= z - 1;
      }

      v1 = v2;
      sgn = null;
    }

    if(sgn != null)
      _matches.splice(index, 2, new Token(v1));

    return i;
  }

  private Integer tryGetSign(int index)
  {
    if(index < _matches.size())
    {
      switch(_matches.get(index).asString)
      {
        case "+":
          return +1;

        case "-":
          return -1;
      }
    }
    return null;
  }

  private char getOperator(int index)
  {
    if(index >= _matches.size())
      throw new CalculatorException("Operator expected");

    String m = _matches.get(index).asString;
    if(m.length() == 1)
    {
      char op = m.charAt(0);
      if("+-*/%^".indexOf(op) >= 0)
        return op;
    }

    throw new CalculatorException("Operator expected instead of " + m);
  }

  private double getValue(int index)
  {
    if(index >= _matches.size())
      throw new CalculatorException("Number expected");

    Token m = _matches.get(index);

    if(m.asString.equals("("))
    {
      int i = calculateFrom(index + 1);

      if(i != index + 2)
        throw new IllegalStateException();

      if(i >= _matches.size() || !_matches.get(i).asString.equals(")"))
        throw new CalculatorException("Missing closing brace");

      m = _matches.get(index + 1);
      _matches.splice(index, 3, m);
    }

    if(m.asNumber != null)
      return m.asNumber;

    throw new CalculatorException("Number expected instead of " + m.asString);
  }

  private void saveResult()
  {
    if(_isFirstStep)
      _isFirstStep = false;
    else _steps.add(new ArrayList<>(_matches));
  }

  private static double performPointCalculation(char op, double x, double y)
  {
    switch(op)
    {
      case '*':
        return x * y;

      case '/':
        return x / y;

      case '%':
        return x % y;

      default:
        throw new IllegalStateException();
    }
  }

  private static final Pattern _re = Pattern
      .compile("\\d+(\\.\\d+)?|[A-Za-z]+|[+\\-*/%^()]|[^\\dA-Za-z+\\-*/%^()\\s]+");

  private final FloatFormatter _formatter;
  private final CustomArrayList<Token> _matches = new CustomArrayList<>();
  private final List<List<Token>> _steps = new ArrayList<>();
  private boolean _isFirstStep;
}
