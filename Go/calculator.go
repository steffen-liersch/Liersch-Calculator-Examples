/*--------------------------------------------------------------------------*\
::
::  Copyright © 2023 Steffen Liersch
::  https://www.steffen-liersch.de/
::
\*--------------------------------------------------------------------------*/

package main

import (
	"errors"
	"math"
	"regexp"
	"strings"
)

var re = regexp.MustCompile(`\d+(\.\d+)?|[A-Za-z]+|[+\-*/%^()]|[^\dA-Za-z+\-*/%^()\s]+`)
var minusOne = -1.0
var plusOne = +1.0

type Calculator struct {
	formatter   FloatFormatter
	matches     []Token
	steps       [][]Token
	isFirstStep bool
}

func CreateCalculator(formatter *FloatFormatter) *Calculator {
	f := formatter
	if f == nil {
		f = &FloatFormatter{}
	}

	return &Calculator{isFirstStep: true, formatter: *f}
}

func (x *Calculator) GetSteps() [][]Token {
	return x.steps
}

func (x *Calculator) Format(token Token) string {
	v := token.AsNumber
	if v == nil {
		return token.AsString
	}

	s := x.formatter.Format(*v)
	if *v < 0 {
		return "(" + s + ")"
	}
	return s
}

func (x *Calculator) CalculateAndFormat(expression string, stepPrefix string) []string {
	v, err := x.Calculate(expression)

	res := []string{}
	for _, step := range x.steps {
		s := ""
		for _, token := range step {
			s += x.Format(token)
		}
		res = append(res, s)
	}

	if v != nil {
		res = append(res, stepPrefix+x.formatter.Format(*v))
	}

	if err != nil {
		res = append(res, err.Error())
	}

	return res
}

func (x *Calculator) Calculate(expression string) (*float64, error) {
	x.isFirstStep = true
	x.steps = [][]Token{}
	x.matches = []Token{}

	var temp []string = re.FindAllString(expression, -1)
	c := len(temp)
	if c <= 0 {
		return nil, nil
	}

	for i := 0; i < c; i++ {
		x.matches = append(x.matches, *CreateTokenFromString(temp[i]))
	}

	_, err := x.calculateFrom(0)
	if err != nil {
		return nil, err
	}

	if len(x.matches) <= 0 {
		panic("Unexpected")
	}

	if len(x.matches) > 1 {
		return nil, errors.New("Operator expected instead of " + x.matches[1].AsString)
	}

	v := x.matches[0].AsNumber
	if v == nil {
		panic("Unexpected")
	}

	return v, nil
}

func (x *Calculator) calculateFrom(index int) (int, error) {
	i, err := x.resolve(index, "^", performPowerCalculation)
	if err == nil {
		i, err = x.resolve(index, "*/%", performPointCalculation)
		if err == nil {
			i, err = x.resolve(index, "+-", performLineCalculation)
		}
	}
	return i, err
}

func (x *Calculator) resolve(index int, operators string, fn func(string, float64, float64) float64) (int, error) {
	i := index
	sgn := x.tryGetSign(i)
	if sgn != nil {
		i++

		// Power operator has priority over sign
		if operators == "^" {
			sgn = nil
		}
	}

	v1, err := x.getValue(i)
	if err != nil {
		return 0, err
	}

	i++
	if sgn != nil {
		v1 *= *sgn
	}

	saved := false

	for i < len(x.matches) && x.matches[i].AsString != ")" {
		op, err := x.getOperator(i)
		if err != nil {
			return 0, err
		}

		v2, err := x.getValue(i + 1)
		if err != nil {
			return 0, err
		}

		i += 2

		if strings.Contains(operators, op) {
			v2 = fn(op, v1, v2)

			if !saved {
				saved = true
				x.saveResult()
			}

			z := 3
			if sgn != nil {
				z++
			}

			x.matches = spliceTokens(x.matches, i-z, z, *CreateTokenFromFloat(v2))
			i -= z - 1
		}

		v1 = v2
		sgn = nil
	}

	if sgn != nil {
		x.matches = spliceTokens(x.matches, index, 2, *CreateTokenFromFloat(v1))
	}

	return i, nil
}

func (x *Calculator) tryGetSign(index int) *float64 {
	if index < len(x.matches) {
		switch x.matches[index].AsString {
		case "+":
			return &plusOne
		case "-":
			return &minusOne
		}
	}

	return nil
}

func (x *Calculator) getOperator(index int) (string, error) {
	if index >= len(x.matches) {
		return "", errors.New("Operator expected")
	}

	s := x.matches[index].AsString
	if len(s) == 1 {
		if strings.Contains("+-*/%^", s) {
			return s, nil
		}
	}

	return "", errors.New("Operator expected instead of " + s)
}

func (x *Calculator) getValue(index int) (float64, error) {
	if index >= len(x.matches) {
		return 0, errors.New("Number expected")
	}

	var m Token = x.matches[index]
	if m.AsString == "(" {
		i, e := x.calculateFrom(index + 1)
		if e != nil {
			return 0, e
		}

		if i != index+2 {
			panic("Unexpected state")
		}

		if i >= len(x.matches) || x.matches[i].AsString != ")" {
			return 0, errors.New("Missing closing brace")
		}

		m = x.matches[index+1]
		x.matches = spliceTokens(x.matches, index, 3, m)
	}

	if m.AsNumber != nil {
		return *m.AsNumber, nil
	}

	return 0, errors.New("Number expected instead of " + m.AsString)
}

func (x *Calculator) saveResult() {
	if x.isFirstStep {
		x.isFirstStep = false
	} else {
		temp := make([]Token, len(x.matches))
		copy(temp, x.matches)
		x.steps = append(x.steps, temp)
	}
}

func performPowerCalculation(op string, x, y float64) float64 {
	return math.Pow(x, y)
}

func performPointCalculation(op string, x, y float64) float64 {
	switch op {
	case "*":
		return x * y
	case "/":
		return x / y
	case "%":
		return math.Mod(x, y)
	default:
		panic("Unexpected")
	}
}

func performLineCalculation(op string, x, y float64) float64 {
	switch op {
	case "+":
		return x + y
	case "-":
		return x - y
	default:
		panic("Unexpected")
	}
}

// Modifies the given array and returns a slice of it
func spliceTokens(list []Token, index, deleteCount int, replacement Token) []Token {
	res := &list

	if deleteCount > 1 {
		i := index + 1
		j := index + deleteCount
		c := len(list)
		for j < c {
			(*res)[i] = list[j] // Changes the given array or slice
			i++
			j++
		}

		d := c - deleteCount + 1
		if d > 0 {
			tmp := list[:d] // Get a slice
			res = &tmp
		}
	}

	(*res)[index] = replacement
	return *res
}
