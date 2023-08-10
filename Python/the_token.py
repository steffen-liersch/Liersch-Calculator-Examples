#:----------------------------------------------------------------------------
#:
#:  Copyright © 2023 Steffen Liersch
#:  https://www.steffen-liersch.de/
#:
#:----------------------------------------------------------------------------

import math


class Token:
  @property
  def as_number(self): return self._as_number

  @property
  def as_string(self): return self._as_string

  @classmethod
  def from_float(cls, value: float):
    return cls(value, '{:.16G}'.format(value))

  @classmethod
  def from_str(cls, value: str):
    try:
      v = float(value)
    except ValueError:
      match value.upper():
        case 'E': v = math.e
        case 'PI': v = math.pi
        case _: v = None
    return cls(v, value)

  # Constructor for private use
  def __init__(self, as_number: float | None, as_string: str):
    self._as_number = as_number
    self._as_string = as_string
