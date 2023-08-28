#!/bin/bash

#:----------------------------------------------------------------------------
#:
#:  Copyright © 2023 Steffen Liersch
#:  https://www.steffen-liersch.de/
#:
#:----------------------------------------------------------------------------

pause(){
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

suffix='echo "Test failed"; popd; pause; exit 1'
base=$(readlink -f "$(dirname "$0")")

pushd "$base/CSharp/Calculator.Tests"
run dotnet test || eval $suffix
popd

pushd "$base"

run php "$base/PHP/tests.php" || eval $suffix
run python3 "$base/Python/tests.py" || eval $suffix

echo "All the tests performed were successful."
popd
pause
exit 0
