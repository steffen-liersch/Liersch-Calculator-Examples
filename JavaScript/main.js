/*--------------------------------------------------------------------------*\
::
::  Copyright © 2023 Steffen Liersch
::  https://www.steffen-liersch.de/
::
\*--------------------------------------------------------------------------*/

export { };
import { Calculator } from './calculator.js';
import { performTests } from './calculator-tests.js';

function startUI()
{
  let calculator = new Calculator();

  let lb = document.querySelector('#result');
  let tb = document.querySelector('#editor');

  tb.oninput = () =>
    lb.innerText = calculator.calculateAndFormat(tb.value).join('\n');

  tb.onkeydown = e =>
  {
    switch(e.key)
    {
      case 'Enter':
        e.preventDefault();
        tb.select();
        break;

      case 'Escape':
        e.preventDefault();
        tb.value = '';
        lb.innerText = calculator.calculateAndFormat(tb.value).join('\n');
        tb.select();
        break;
    }
  };

  lb.innerText = calculator.calculateAndFormat(tb.value).join('\n');
  tb.select();
  tb.focus();
}

function startTests()
{
  if(!/^(http|https):/.test(location.href))
    console.error('Unit tests work only if the page was loaded via HTTP or HTTPS');
  else
  {
    let u = 'tests.json';
    fetch(u)
      .catch(x => console.error('Failed to fetch ' + u, x))
      .then(x =>
      {
        if(x.status != 200)
          console.error('Failed to fetch ' + u + ': ' + x.statusText);
        else
        {
          x.json()
            .catch(x => console.error('Failed to perform tests', x))
            .then(performTests);
        }
      });
  }
}

if(typeof document == 'undefined')
  throw Error('Script only works in a web browser');

startUI();
startTests();
