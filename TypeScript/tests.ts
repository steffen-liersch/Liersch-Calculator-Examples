#!/usr/bin/env -S deno run

/*--------------------------------------------------------------------------*\
::
::  Copyright © 2023 Steffen Liersch
::  https://www.steffen-liersch.de/
::
\*--------------------------------------------------------------------------*/

export { runTests };
import { performTests } from './calculator-tests.ts';
import tests from '../Unit-Testing/tests.json' assert { type: 'json' };

function runTests(): boolean
{
  console.log();
  let ok = performTests(tests);
  console.log();
  return ok;
}

if(import.meta.main)
  Deno.exit(runTests() ? 0 : 1);
