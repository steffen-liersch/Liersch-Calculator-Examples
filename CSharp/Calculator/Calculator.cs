/*--------------------------------------------------------------------------*\
::
::  Copyright © 2023 Steffen Liersch
::  https://www.steffen-liersch.de/
::
\*--------------------------------------------------------------------------*/

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;

namespace Liersch.Calculator;

sealed class Calculator
{
  public IList<IList<Token>> Steps => _steps;

  public Calculator(FloatFormatter? formatter = null) => _formatter = formatter ?? new();

  public string Format(Token token)
  {
    if(!token.AsNumber.HasValue)
      return token.AsString;

    double v = token.AsNumber.Value;
    string s = _formatter.Format(v);
    return v < 0 ? "(" + s + ")" : s;
  }

  public IList<string> CalculateAndFormat(string expression, string stepPrefix = "= ")
  {
    double? v = null;
    string? e = null;
    try
    {
      v = Calculate(expression);
    }
    catch(CalculatorException x) // Don't handle unexpected errors!
    {
      e = x.Message;
    }

    IList<string> res = _steps
      .Select(x =>
        stepPrefix +
        string.Join("", x.Select(x => Format(x))))
      .ToList();

    if(v.HasValue)
      res.Add(stepPrefix + _formatter.Format(v.Value));

    if(e != null)
      res.Add(e);

    return res;
  }

  public double? Calculate(string expression)
  {
    if(expression == null)
      throw new ArgumentNullException(nameof(expression));

    _isFirstStep = true;
    _steps.Clear();
    _matches.Clear();

    MatchCollection temp = _re.Matches(expression);
    int c = temp.Count;
    if(c <= 0)
      return null;

    for(int i = 0; i < c; i++)
      _matches.Add(new Token(temp[i].Value));

    CalculateFrom(0);

    if(_matches.Count <= 0)
      throw new InvalidOperationException();

    if(_matches.Count > 1)
      throw new CalculatorException("Operator expected instead of " + _matches[1].AsString);

    double? v = _matches[0].AsNumber;
    if(!v.HasValue)
      throw new InvalidOperationException();

    return v.Value;
  }

  int CalculateFrom(int index)
  {
    Resolve(index, "^", (_, x, y) => Math.Pow(x, y));
    Resolve(index, "*/%", PerformPointCalculation);
    return Resolve(index, "+-", (op, x, y) => op == '+' ? x + y : x - y);
  }

  int Resolve(int index, string operators, Func<char, double, double, double> fn)
  {
    int i = index;
    int? sgn = TryGetSign(i);
    if(sgn.HasValue)
    {
      i++;

      // Power operator has priority over sign
      if(operators == "^")
        sgn = null;
    }

    double v1 = GetValue(i++);
    if(sgn.HasValue)
      v1 *= sgn.Value;

    bool saved = false;

    while(i < _matches.Count && _matches[i].AsString != ")")
    {
      char op = GetOperator(i++);
      double v2 = GetValue(i++);

      if(operators.IndexOf(op) >= 0)
      {
        v2 = fn(op, v1, v2);

        if(!saved)
        {
          saved = true;
          SaveResult();
        }

        int z = sgn.HasValue ? 4 : 3;
        _matches.Splice(i - z, z, new Token(v2));
        i -= z - 1;
      }

      v1 = v2;
      sgn = null;
    }

    if(sgn.HasValue)
      _matches.Splice(index, 2, new Token(v1));

    return i;
  }

  int? TryGetSign(int index)
  {
    if(index < _matches.Count)
    {
      switch(_matches[index].AsString)
      {
        case "+": return +1;
        case "-": return -1;
      }
    }
    return null;
  }

  char GetOperator(int index)
  {
    if(index >= _matches.Count)
      throw new CalculatorException("Operator expected");

    string s = _matches[index].AsString;
    if(s.Length == 1)
    {
      char op = s[0];
      if("+-*/%^".IndexOf(op) >= 0)
        return op;
    }

    throw new CalculatorException("Operator expected instead of " + s);
  }

  double GetValue(int index)
  {
    if(index >= _matches.Count)
      throw new CalculatorException("Number expected");

    Token m = _matches[index];

    if(m.AsString == "(")
    {
      int i = CalculateFrom(index + 1);

      if(i != index + 2)
        throw new InvalidOperationException();

      if(i >= _matches.Count || _matches[i].AsString != ")")
        throw new CalculatorException("Missing closing brace");

      m = _matches[index + 1];
      _matches.Splice(index, 3, m);
    }

    if(m.AsNumber.HasValue)
      return m.AsNumber.Value;

    throw new CalculatorException("Number expected instead of " + m.AsString);
  }

  void SaveResult()
  {
    if(_isFirstStep)
      _isFirstStep = false;
    else _steps.Add(_matches.ToList());
  }

  static double PerformPointCalculation(char op, double x, double y)
  {
    switch(op)
    {
      case '*': return x * y;
      case '/': return x / y;
      case '%': return x % y;
      default: throw new InvalidOperationException();
    }
  }

  readonly static Regex _re = new(@"\d+(\.\d+)?|[A-Za-z]+|[+\-*/%^()]|[^\dA-Za-z+\-*/%^()\s]+", RegexOptions.CultureInvariant);
  readonly FloatFormatter _formatter;
  readonly List<Token> _matches = new();
  readonly List<IList<Token>> _steps = new();
  bool _isFirstStep;
}
