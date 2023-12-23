#!/bin/bash

#:----------------------------------------------------------------------------
#:
#:  Copyright © 2023 Steffen Liersch
#:  https://www.steffen-liersch.de/
#:
#:----------------------------------------------------------------------------

args=("$@")

main() {
  suffix='popd > /dev/null; exit 0'
  base=$(readlink -f "$(dirname "$0")")

  pushd "$base" > /dev/null

  run node "$base/JavaScript/program.js" && eval $suffix
  run deno run "$base/JavaScript/program.js" && eval $suffix
  run deno run "$base/TypeScript/program.ts" && eval $suffix
  run python3 "$base/Python/program.py" && eval $suffix
  run php "$base/PHP/program.php" && eval $suffix
  run julia "$base/Julia/Program.jl" && eval $suffix
  run dotnet run --project "$base/CSharp/Calculator" && eval $suffix

  echo "The program could not be started because no suitable runtime environment is installed."
  popd > /dev/null
  pause
  exit 1
}

pause() {
  read -p "[Press any key!] "
}

run() {
  which "$1" > /dev/null
  if [ $? -ne 0 ]; then return 1; fi
  run_no_check $@
}

run_no_check() {
  if [ -z "$args" ]; then
    echo
    echo "> $@"
  fi

  $@ "${args[@]}"
  return 0
}

main
