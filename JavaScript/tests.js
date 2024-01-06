#!/usr/bin/env node

/*--------------------------------------------------------------------------*\
::
::  Copyright © 2023-2024 Steffen Liersch
::  https://www.steffen-liersch.de/
::
\*--------------------------------------------------------------------------*/

export { runTests };
import { performTests } from './calculator-tests.js';
import { isDeno, isNode } from './environment.js';
import tests from '../Unit-Testing/tests.json' assert { type: 'json' };

function runTests()
{
  return performTests(tests);
}

if(isDeno())
{
  if(import.meta.main)
    Deno.exit(runTests() ? 0 : 1);
}
else if(isNode())
{
  let url = await import('node:url');
  if(import.meta.url == url.pathToFileURL(process.argv[1]).href)
    process.exit(runTests() ? 0 : 1);
}
