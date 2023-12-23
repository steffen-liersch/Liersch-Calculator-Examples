/*--------------------------------------------------------------------------*\
::
::  Copyright © 2023 Steffen Liersch
::  https://www.steffen-liersch.de/
::
\*--------------------------------------------------------------------------*/

export { performTests };
import { Calculator } from './calculator.ts';
import { FloatFormatter } from './float-formatter.ts';

interface Test
{
  name: string;
  expression: string[];
  output: string[];
}

function performTests(tests: Test[]): boolean
{
  let testCount = 0;
  let errorCount = 0;
  let calculator = new Calculator(new FloatFormatter(16));
  for(let test of tests)
  {
    console.log('Test: ' + test.name);
    let array = Array.isArray(test.expression) ? test.expression : [test.expression];
    for(let expr of array)
    {
      let lines = calculator.calculateAndFormat(expr, '');
      if(!assertEqual(test.output, lines))
        errorCount++;
      testCount++;
    }
  }
  console.log(`=> ${testCount} tests completed with ${errorCount} errors`);
  return errorCount <= 0;
}

function assertEqual(expected: string[], actual: string[]): boolean
{
  if(!Array.isArray(expected)) throw Error('Array expected (1)');
  if(!Array.isArray(actual)) throw Error('Array expected (2)');

  let c1 = expected.length;
  let c2 = actual.length;
  if(c1 != c2)
  {
    console.error('Assertion failed: Arrays with different lengths', expected, actual);
    return false;
  }

  for(let i = 0; i < c1; i++)
  {
    if(expected[i] != actual[i])
    {
      console.error('Assertion failed', expected[i], actual[i]);
      return false;
    }
  }

  return true;
}
