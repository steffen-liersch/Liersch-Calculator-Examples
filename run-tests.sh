#!/bin/bash

#:----------------------------------------------------------------------------
#:
#:  Copyright © 2023-2024 Steffen Liersch
#:  https://www.steffen-liersch.de/
#:
#:----------------------------------------------------------------------------

main() {
  base=$(readlink -f "$(dirname "$0")")


  pushd "$base/Go" > /dev/null
  try go test || error
  popd > /dev/null


  pushd "$base/Java" > /dev/null
  try mvn --quiet package || error
  popd > /dev/null


  pushd "$base" > /dev/null

  check fpc && { run "$base/ObjectPascal/build-and-test.sh" --nowait || error; }

  try node --no-warnings "$base/JavaScript/tests.js" || error
  try deno run "$base/JavaScript/tests.js" || error
  try deno run "$base/TypeScript/tests.ts" || error
  try dotnet test "$base/CSharp" || error
  try julia "$base/Julia/Tests.jl" || error
  try php "$base/PHP/tests.php" || error
  try python3 "$base/Python/tests.py" || error

  popd > /dev/null


  echo "All the tests performed were successful."
  pause
  exit 0
}

try() {
  check $1 || return 0
  run $@
}

run() {
  echo "> $@"
  echo
  $@
  [ $? -ne 0 ] && return 1

  echo
  return 0
}

check() {
  echo ================ Testing $1 ================
  echo

  which "$1" > /dev/null
  if [ $? -ne 0 ]; then echo "$1 is not installed"; echo; echo; return 1; fi
  return 0
}

error() {
  popd > /dev/null
  echo "Test failed"
  pause
  exit 1
}

pause() {
  read -p "[Press any key!] "
}

main