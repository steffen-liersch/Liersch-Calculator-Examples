#!/usr/bin/env -S deno run

/*--------------------------------------------------------------------------*\
::
::  Copyright © 2023 Steffen Liersch
::  https://www.steffen-liersch.de/
::
\*--------------------------------------------------------------------------*/

export { runUI, runWithArgs };
import { Calculator } from './calculator.ts';

function runUI(): void
{
  console.log();
  console.log('Liersch Calculator (TypeScript)');
  console.log('==================');
  console.log();

  console.log('Copyright © 2023 Steffen Liersch');
  console.log('https://www.steffen-liersch.de/');
  console.log();

  let calculator = new Calculator();

  let exitState = 0;
  while(true)
  {
    let s = prompt('?');

    if(s)
    {
      for(let x of calculator.calculateAndFormat(s))
        console.log(x);
      exitState = 0;
    }
    else
    {
      if(exitState > 0)
        break;

      console.log('Press [Enter] again to exit.');
      exitState++;
    }

    console.log();
  }
}

function runWithArgs(args: string[]): void
{
  let calculator = new Calculator();
  for(let a of args)
  {
    let x = calculator.calculateAndFormat(a, '');
    let c = x.length;
    console.log(c > 0 ? x[c - 1] : '');
  }
}

if(import.meta.main)
{
  if(Deno.args.length > 0)
    runWithArgs(Deno.args);
  else runUI();
}
