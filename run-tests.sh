#!/bin/bash

#:----------------------------------------------------------------------------
#:
#:  Copyright © 2023 Steffen Liersch
#:  https://www.steffen-liersch.de/
#:
#:----------------------------------------------------------------------------

main() {
  suffix='echo "Test failed"; popd > /dev/null; pause; exit 1'
  base=$(readlink -f "$(dirname "$0")")

  pushd "$base/Java" > /dev/null
  run mvn --quiet package || eval $suffix
  popd > /dev/null

  pushd "$base" > /dev/null

  run node --no-warnings "$base/JavaScript/tests.js" || eval $suffix
  run deno run "$base/JavaScript/tests.js" || eval $suffix
  run deno run "$base/TypeScript/tests.ts" || eval $suffix
  run dotnet test "$base/CSharp" || eval $suffix
  run julia "$base/Julia/Tests.jl" || eval $suffix
  run php "$base/PHP/tests.php" || eval $suffix
  run python3 "$base/Python/tests.py" || eval $suffix

  echo "All the tests performed were successful."
  popd > /dev/null
  pause
  exit 0
}

pause() {
  read -p "[Press any key!] "
}

run() {
  echo ================ Testing $1 ================
  echo

  which "$1" > /dev/null
  if [ $? -ne 0 ]; then echo "$1 is not installed"; echo; echo; return 0; fi

  echo "> $@"

  $@
  if [ $? -ne 0 ]; then return 1; fi

  echo
  return 0
}

main