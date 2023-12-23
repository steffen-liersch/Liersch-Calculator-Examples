/*--------------------------------------------------------------------------*\
::
::  Copyright © 2023 Steffen Liersch
::  https://www.steffen-liersch.de/
::
\*--------------------------------------------------------------------------*/

export { isDeno, isNode };

function isDeno() { return globalThis?.Deno; }
function isNode() { return globalThis?.process?.versions?.node; }
