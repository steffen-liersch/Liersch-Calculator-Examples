#:----------------------------------------------------------------------------
#:
#:  Copyright © 2023 Steffen Liersch
#:  https://www.steffen-liersch.de/
#:
#:----------------------------------------------------------------------------

class CalculatorException(Exception):
  def __init__(self, message: str):
    super().__init__(message)
