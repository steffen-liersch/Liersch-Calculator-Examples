/*--------------------------------------------------------------------------*\
::
::  Copyright © 2023 Steffen Liersch
::  https://www.steffen-liersch.de/
::
\*--------------------------------------------------------------------------*/

export { CalculatorError, Calculator };
import { CalculatorError } from './calculator-error.js';
import { FloatFormatter } from './float-formatter.js';
import { Token } from './token.js';

class Calculator
{
  get steps() { return this._steps; }

  constructor(formatter)
  {
    this._formatter = formatter ?? new FloatFormatter();
  }

  format(token)
  {
    let v = token.asNumber;
    if(v == null)
      return token.asString;

    let s = this._formatter.format(v);
    return v < 0 ? '(' + s + ')' : s;
  }

  calculateAndFormat(expression, stepPrefix = '= ')
  {
    let v = null;
    let e = '';
    try
    {
      v = this.calculate(expression);
    }
    catch(x)
    {
      if(!(x instanceof CalculatorError))
        throw x; // Don't handle unexpected errors!
      e = x.message;
    }

    let res = this._steps.map(x =>
      stepPrefix + x.map(x => this.format(x)).join('')
    );

    if(v != null)
      res.push(stepPrefix + this._formatter.format(v));

    if(e)
      res.push(e);

    return res;
  }

  calculate(expression)
  {
    if(expression == null)
      throw Error('Value expected for expression');

    this._isFirstStep = true;
    this._steps = [];
    this._matches = [];

    let temp = expression.matchAll(Calculator._re);
    for(let m of temp)
      this._matches.push(new Token(m[0]));

    if(this._matches.length <= 0)
      return null;

    this._calculateFrom(0);

    if(this._matches.length <= 0)
      throw Error();

    if(this._matches.length > 1)
      throw new CalculatorError('Operator expected instead of ' + this._matches[1].asString);

    if(this._matches[0].asNumber == null)
      throw Error();

    return this._matches[0].asNumber;
  }

  _calculateFrom(index)
  {
    this._resolve(index, '^', (_, x, y) => x ** y);
    this._resolve(index, '*/%', Calculator._performPointCalculation);
    return this._resolve(index, '+-', (op, x, y) => op == '+' ? x + y : x - y);
  }

  _resolve(index, operators, fn)
  {
    let i = index;
    let sgn = this._tryGetSign(i);
    if(sgn)
    {
      i++;

      // Power operator has priority over sign
      if(operators == '^')
        sgn = null;
    }

    let v1 = this._getValue(i++);
    if(sgn)
      v1 *= sgn;

    let saved = false;

    while(i < this._matches.length && this._matches[i].asString != ')')
    {
      let op = this._getOperator(i++);
      let v2 = this._getValue(i++);

      if(operators.indexOf(op) >= 0)
      {
        v2 = fn(op, v1, v2);

        if(!saved)
        {
          saved = true;
          this._saveResult();
        }

        let z = sgn ? 4 : 3;
        this._matches.splice(i - z, z, new Token(v2));
        i -= z - 1;
      }

      v1 = v2;
      sgn = null;
    }

    if(sgn)
      this._matches.splice(index, 2, new Token(v1));

    return i;
  }

  _tryGetSign(index)
  {
    if(index < this._matches.length)
    {
      switch(this._matches[index].asString)
      {
        case '+': return +1;
        case '-': return -1;
      }
    }
    return null;
  }

  _getOperator(index)
  {
    if(index >= this._matches.length)
      throw new CalculatorError('Operator expected');

    let s = this._matches[index].asString;
    if(s.length == 1 && '+-*/%^'.indexOf(s) >= 0)
      return s;

    throw new CalculatorError('Operator expected instead of ' + s);
  }

  _getValue(index)
  {
    if(index >= this._matches.length)
      throw new CalculatorError('Number expected');

    let m = this._matches[index];

    if(m.asString == '(')
    {
      let i = this._calculateFrom(index + 1);

      if(i != index + 2)
        throw Error();

      if(i >= this._matches.length || this._matches[i].asString != ')')
        throw new CalculatorError('Missing closing brace');

      m = this._matches[index + 1];
      this._matches.splice(index, 3, m);
    }

    if(m.asNumber != null)
      return m.asNumber;

    throw new CalculatorError('Number expected instead of ' + m);
  }

  _saveResult()
  {
    if(this._isFirstStep)
      this._isFirstStep = false;
    else this._steps.push([...this._matches]);
  }

  static _performPointCalculation(op, x, y)
  {
    switch(op)
    {
      case '*': return x * y;
      case '/': return x / y;
      case '%': return x % y;
      default: throw Error();
    }
  }

  static _re = /\d+(\.\d+)?|[A-Za-z]+|[+\-*/%^()]|[^\dA-Za-z+\-*/%^()\s]+/g;
  _formatter;
  _matches = [];
  _steps = [];
  _isFirstStep = false;
}
