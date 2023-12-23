/*--------------------------------------------------------------------------*\
::
::  Copyright © 2023 Steffen Liersch
::  https://www.steffen-liersch.de/
::
\*--------------------------------------------------------------------------*/

package de.steffen_liersch.calculator;

@FunctionalInterface
interface Function3<T1, T2, T3, T4>
{
  T4 apply(T1 t, T2 u, T3 s);
}
