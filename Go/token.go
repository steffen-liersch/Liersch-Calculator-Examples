/*--------------------------------------------------------------------------*\
::
::  Copyright © 2023 Steffen Liersch
::  https://www.steffen-liersch.de/
::
\*--------------------------------------------------------------------------*/

package main

import (
	"fmt"
	"math"
	"strconv"
	"strings"
)

type Token struct {
	AsNumber *float64
	AsString string
}

func CreateTokenFromFloat(value float64) *Token {
	return &Token{AsNumber: &value, AsString: fmt.Sprintf("%g", value)}
}

func CreateTokenFromString(value string) *Token {
	var s string
	v, err := strconv.ParseFloat(value, 64)
	if err == nil {
		s = value
	} else {
		switch strings.ToUpper(value) {
		case "E":
			v = math.E
			s = "E"
		case "PI":
			v = math.Pi
			s = "PI"
		default:
			return &Token{AsNumber: nil, AsString: value}
		}
	}
	return &Token{AsNumber: &v, AsString: s}
}
