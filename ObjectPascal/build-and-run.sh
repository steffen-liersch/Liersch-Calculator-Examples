#!/bin/bash

#:----------------------------------------------------------------------------
#:
#:  Copyright © 2023-2024 Steffen Liersch
#:  https://www.steffen-liersch.de/
#:
#:----------------------------------------------------------------------------

pause() {
  read -p "[Press any key!] "
}

which fpc > /dev/null
if [ $? -ne 0 ]; then echo "Free Pascal not installed"; pause; exit 1; fi

base=$(readlink -f "$(dirname "$0")")
exe=$base
target=$base/_out
[ ! -d "$target" ] && mkdir "$target"

fpc "-FE$exe" "-FU$target" "$base/Program.dpr"
if [ $? -ne 0 ]; then pause; exit 1; fi
"$exe/Program" $@
