/*--------------------------------------------------------------------------*\
::
::  Copyright © 2023-2024 Steffen Liersch
::  https://www.steffen-liersch.de/
::
\*--------------------------------------------------------------------------*/

package main

import (
	"encoding/json"
	"io/ioutil"
	"path/filepath"
	"runtime"
)

func runTests() bool {
	_, file, _, ok := runtime.Caller(0)
	if !ok {
		panic("No caller information")
	}

	n := filepath.Join(filepath.Dir(file), "../Unit-Testing/tests.json")
	data, err := ioutil.ReadFile(n)
	if err != nil {
		panic(err)
	}

	var tests []test
	if err := json.Unmarshal(data, &tests); err != nil {
		panic(err)
	}

	return performTests(tests)
}
