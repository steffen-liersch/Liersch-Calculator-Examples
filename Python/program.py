#!/usr/bin/env python3

#:----------------------------------------------------------------------------
#:
#:  Copyright © 2023 Steffen Liersch
#:  https://www.steffen-liersch.de/
#:
#:----------------------------------------------------------------------------

import sys
from typing import List
from calculator import Calculator


def run_ui() -> None:
  print()
  print('Liersch Calculator (Python)')
  print('==================')
  print()

  print('Copyright © 2023 Steffen Liersch')
  print('https://www.steffen-liersch.de/')
  print()

  calculator = Calculator()

  exit_state = 0
  while True:
    s = input('? ').strip()

    if len(s) > 0:
      for x in calculator.calculate_and_format(s):
        print(x)
      exit_state = 0
    else:
      if exit_state > 0:
        break

      print('Press [Enter] again to exit.')
      exit_state += 1

    print()


def run_with_args(args: List[str]) -> None:
  calculator = Calculator()
  for a in args:
    x = calculator.calculate_and_format(a, "")
    print(x[-1] if len(x) > 0 else "")


if __name__ == '__main__':
  c = len(sys.argv)
  if c > 1:
    run_with_args(sys.argv[1:])  # Ignore the first element, which is the script name.
  else: run_ui()
