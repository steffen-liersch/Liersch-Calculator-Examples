#!/bin/bash

#:----------------------------------------------------------------------------
#:
#:  Copyright © 2023 Steffen Liersch
#:  https://www.steffen-liersch.de/
#:
#:----------------------------------------------------------------------------

pause() {
  read -p "[Press any key!] "
}

if [ ! -d "$JAVA_HOME/bin" ]; then echo 'Java not installed'; pause; exit 1; fi

base=$(readlink -f "$(dirname "$0")")

pushd "$base" > /dev/null
"$JAVA_HOME/bin/javac" -encoding utf8 -d "$base/_out/classes" @files-to-compile.txt
if [ $? -ne 0 ]; then echo 'Failed to compile'; popd; pause; exit 1; fi
popd > /dev/null

"$JAVA_HOME/bin/jar" -cfm "$base/_out/calculator.jar" "$base/manifest.txt" -C "$base/_out/classes" .
if [ $? -ne 0 ]; then echo 'Failed to create JAR file'; pause; exit 1; fi

"$JAVA_HOME/bin/java" -jar "$base/_out/calculator.jar" $@
if [ $? -ne 0 ]; then echo 'Failed to start'; pause; exit 1; fi

exit 0
