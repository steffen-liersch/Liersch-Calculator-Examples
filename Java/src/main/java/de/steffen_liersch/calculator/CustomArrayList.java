/*--------------------------------------------------------------------------*\
::
::  Copyright © 2023 Steffen Liersch
::  https://www.steffen-liersch.de/
::
\*--------------------------------------------------------------------------*/

package de.steffen_liersch.calculator;

import java.util.ArrayList;

class CustomArrayList<T> extends ArrayList<T>
{
  public void splice(int index, int deleteCount, T replacement)
  {
    if(deleteCount > 0)
      removeRange(index, index + deleteCount - 1);
    set(index, replacement);
  }
}
