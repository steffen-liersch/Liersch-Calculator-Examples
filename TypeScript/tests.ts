#!/usr/bin/env -S deno run

/*--------------------------------------------------------------------------*\
::
::  Copyright © 2023-2024 Steffen Liersch
::  https://www.steffen-liersch.de/
::
\*--------------------------------------------------------------------------*/

export { runTests };
import { performTests } from './calculator-tests.ts';
import tests from '../Unit-Testing/tests.json' with { type: 'json' };

function runTests(): boolean
{
  return performTests(tests);
}

if(import.meta.main)
  Deno.exit(runTests() ? 0 : 1);
