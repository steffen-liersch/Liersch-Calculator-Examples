/*--------------------------------------------------------------------------*\
::
::  Copyright © 2023 Steffen Liersch
::  https://www.steffen-liersch.de/
::
\*--------------------------------------------------------------------------*/

package main

import "fmt"

type test struct {
	Name       string   `json:"name"`
	Expression []string `json:"expression"`
	Output     []string `json:"output"`
}

func performTests(tests []test) bool {
	testCount := 0
	errorCount := 0
	calculator := CreateCalculator(CreateFloatFormatter("%G"))
	for _, test := range tests {
		fmt.Printf("Test: %s\n", test.Name)
		for _, expr := range test.Expression {
			lines := calculator.CalculateAndFormat(expr, "")
			if !assertEqual(test.Output, lines) {
				errorCount++
			}
			testCount++
		}
	}
	fmt.Printf("=> %d tests completed with %d errors\n", testCount, errorCount)
	return errorCount <= 0
}

func assertEqual(expected []string, actual []string) bool {
	c1 := len(expected)
	c2 := len(actual)
	if c1 != c2 {
		fmt.Println("Assertion failed: Arrays with different lengths", expected, actual)
		return false
	}

	for i := 0; i < c1; i++ {
		if expected[i] != actual[i] {
			fmt.Println("Assertion failed", expected[i], actual[i])
			return false
		}
	}

	return true
}
