#!/bin/bash

#:----------------------------------------------------------------------------
#:
#:  Copyright © 2023-2024 Steffen Liersch
#:  https://www.steffen-liersch.de/
#:
#:----------------------------------------------------------------------------

arg1=$1

pause() {
  read -p "[Press any key!] "
}

error() {
  [ "$arg1" != "--nowait" ] && pause
  exit 1
}

which fpc > /dev/null
if [ $? -ne 0 ]; then echo "Free Pascal not installed"; error; fi

base=$(readlink -f "$(dirname "$0")")
exe=$base
target=$base/_out
[ ! -d "$target" ] && mkdir "$target"

fpc "-FE$exe" "-FU$target" "$base/Tests.pas"
[ $? -ne 0 ] && error

"$exe/Tests"
[ $? -ne 0 ] && error

exit 0
