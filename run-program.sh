#!/bin/bash

#:----------------------------------------------------------------------------
#:
#:  Copyright © 2023-2024 Steffen Liersch
#:  https://www.steffen-liersch.de/
#:
#:----------------------------------------------------------------------------

args=("$@")

main() {
  suffix='popd > /dev/null; exit 0'
  base=$(readlink -f "$(dirname "$0")")


  pushd "$base" > /dev/null

  try node "$base/JavaScript/program.js" && eval $suffix
  try deno run "$base/JavaScript/program.js" && eval $suffix
  try deno run "$base/TypeScript/program.ts" && eval $suffix
  try python3 "$base/Python/program.py" && eval $suffix
  try php "$base/PHP/program.php" && eval $suffix
  try julia "$base/Julia/Program.jl" && eval $suffix
  try dotnet run --project "$base/CSharp/Calculator" && eval $suffix

  which fpc > /dev/null && run "$base/ObjectPascal/build-and-run.sh" && eval $suffix
  [ -d "$JAVA_HOME/bin" ] && run "$base/Java/build-and-run.sh" && eval $suffix

  popd > /dev/null


  pushd "$base/Go" > /dev/null
  try go run . && eval $suffix
  popd > /dev/null


  echo "The program could not be started because no suitable runtime environment is installed."
  pause
  exit 1
}

try() {
  which "$1" > /dev/null
  [ $? -ne 0 ] && return 1
  run $@
}

run() {
  if [ -z "$args" ]; then
    echo
    echo "> $@"
  fi

  $@ "${args[@]}"
  return 0
}

pause() {
  read -p "[Press any key!] "
}

main
