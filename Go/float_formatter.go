/*--------------------------------------------------------------------------*\
::
::  Copyright © 2023 Steffen Liersch
::  https://www.steffen-liersch.de/
::
\*--------------------------------------------------------------------------*/

package main

import "fmt"

type FloatFormatter struct {
	_format string
}

func CreateFloatFormatter(format string) *FloatFormatter {
	return &FloatFormatter{_format: format}
}

func (x *FloatFormatter) Format(value float64) string {
	f := x._format
	if f == "" {
		f = "%.6g"
	}
	return fmt.Sprintf(f, value)
}
