/*--------------------------------------------------------------------------*\
::
::  Copyright © 2023 Steffen Liersch
::  https://www.steffen-liersch.de/
::
\*--------------------------------------------------------------------------*/

using System.Collections.Generic;

namespace Liersch.Calculator;

static class Extensions
{
  public static void Splice<T>(this List<T> list, int index, int deleteCount, T replacement)
  {
    int c = deleteCount - 1;
    if(c > 0)
      list.RemoveRange(index, c);
    list[index] = replacement;
  }
}
