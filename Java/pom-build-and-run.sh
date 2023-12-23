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

which mvn > /dev/null
if [ $? -ne 0 ]; then echo 'Mavon utility "mvn" not installed'; pause; exit 1; fi
if [ ! -d "$JAVA_HOME/bin" ]; then echo 'Java not installed'; pause; exit 1; fi

base=$(readlink -f "$(dirname "$0")")

pushd "$base" > /dev/null
mvn --quiet package
if [ $? -ne 0 ]; then echo 'Failed to start'; popd; pause; exit 1; fi
popd > /dev/null

"$JAVA_HOME/bin/java" -jar "$base/target/calculator-1.0-SNAPSHOT.jar" $@
if [ $? -ne 0 ]; then echo 'Failed to start'; pause; exit 1; fi

exit 0
