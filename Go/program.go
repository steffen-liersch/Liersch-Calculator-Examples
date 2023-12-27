/*--------------------------------------------------------------------------*\
::
::  Copyright © 2023 Steffen Liersch
::  https://www.steffen-liersch.de/
::
\*--------------------------------------------------------------------------*/

package main

import (
	"bufio"
	"fmt"
	"os"
	"strings"
)

func runUI() {
	fmt.Println()
	fmt.Println("Liersch Calculator (Go)")
	fmt.Println("==================")
	fmt.Println()

	fmt.Println("Copyright © 2023 Steffen Liersch")
	fmt.Println("https://www.steffen-liersch.de/")
	fmt.Println()

	reader := bufio.NewReader(os.Stdin)
	calculator := CreateCalculator(nil)

	exitState := 0
	for {
		fmt.Print("? ")

		s, err := reader.ReadString('\n')
		if err != nil {
			panic(err)
		}

		s = strings.TrimSpace(s)

		if len(s) > 0 {
			for _, x := range calculator.CalculateAndFormat(s, "= ") {
				fmt.Println(x)
			}
			exitState = 0
		} else {
			if exitState > 0 {
				break
			}

			fmt.Println("Press [Enter] again to exit.")
			exitState++
		}

		fmt.Println()
	}
}

func runWithArgs(args []string) {
	calculator := CreateCalculator(nil)
	for _, a := range args {
		x := calculator.CalculateAndFormat(a, "")
		c := len(x)
		if c > 0 {
			fmt.Print(x[c-1])
		}
		fmt.Println()
	}
}

func main() {
	fmt.Println(os.Args)
	if len(os.Args) > 1 {
		runWithArgs(os.Args[1:])
	} else {
		runUI()
	}
}
