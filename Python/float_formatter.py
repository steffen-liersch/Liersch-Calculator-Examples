#:----------------------------------------------------------------------------
#:
#:  Copyright © 2023 Steffen Liersch
#:  https://www.steffen-liersch.de/
#:
#:----------------------------------------------------------------------------

class FloatFormatter:
  def __init__(self, format: str = '{:G}'):
    self._format = format

  def format(self, value: float) -> str:
    return self._format.format(value)
