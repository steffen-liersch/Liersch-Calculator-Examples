/*--------------------------------------------------------------------------*\
::
::  Copyright © 2023 Steffen Liersch
::  https://www.steffen-liersch.de/
::
\*--------------------------------------------------------------------------*/

package main

import (
	"testing"
)

func TestCalculator(t *testing.T) {
	if !runTests() {
		t.Fail()
	}
}
