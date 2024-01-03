#!/usr/bin/env node

/*--------------------------------------------------------------------------*\
::
::  Copyright © 2023-2024 Steffen Liersch
::  https://www.steffen-liersch.de/
::
\*--------------------------------------------------------------------------*/

export { runUI, runWithArgs };
import { createPortablePrompt } from './prompt.js';
import { isDeno, isNode } from './environment.js';
import { Calculator } from './calculator.js';

async function runUI()
{
  let pp = await createPortablePrompt();
  try
  {
    console.log();
    console.log('Liersch Calculator (JavaScript)');
    console.log('==================');
    console.log();

    console.log('Copyright © 2023-2024 Steffen Liersch');
    console.log('https://www.steffen-liersch.de/');
    console.log();

    let calculator = new Calculator();

    let exitState = 0;
    while(true)
    {
      let s = await pp.prompt('?');

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
  finally
  {
    pp.close();
  }
}

function runWithArgs(args)
{
  let calculator = new Calculator();
  for(let a of args)
  {
    let x = calculator.calculateAndFormat(a, '');
    let c = x.length;
    console.log(c > 0 ? x[c - 1] : '');
  }
}

if(isDeno())
{
  if(import.meta.main)
  {
    if(Deno.args.length > 0)
      runWithArgs(Deno.args);
    else await runUI();
  }
}
else if(isNode())
{
  let url = await import('node:url');
  if(import.meta.url == url.pathToFileURL(process.argv[1]).href)
  {
    if(process.argv.length > 2)
      runWithArgs(process.argv.slice(2));
    else await runUI();
  }
}
