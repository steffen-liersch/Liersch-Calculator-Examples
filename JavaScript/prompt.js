/*--------------------------------------------------------------------------*\
::
::  Copyright © 2023 Steffen Liersch
::  https://www.steffen-liersch.de/
::
\*--------------------------------------------------------------------------*/

export { createPortablePrompt };
import { isDeno, isNode } from './environment.js';

class DenoPrompt
{
  initialize()
  {
    // Nothing to do here
  }

  prompt(message)
  {
    return globalThis.prompt(message);
  }

  close()
  {
    // Nothing to do here
  }
}

class NodePrompt
{
  async initialize()
  {
    let mod = await import('node:readline/promises');
    this._io = mod.createInterface({
      input: process.stdin,
      output: process.stdout,
    });
  }

  async prompt(message)
  {
    return await this._io.question(message + ' ');
  }

  close()
  {
    this._io.close();
  }
}

async function createPortablePrompt()
{
  let res;
  if(isDeno())
    res = new DenoPrompt();
  else if(isNode())
    res = new NodePrompt();
  else throw Error('Unsupported environment');

  await res.initialize();
  return res;
}
