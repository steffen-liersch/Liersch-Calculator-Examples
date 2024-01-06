#!/usr/bin/env python3

#:----------------------------------------------------------------------------
#:
#:  Copyright © 2023-2024 Steffen Liersch
#:  https://www.steffen-liersch.de/
#:
#:----------------------------------------------------------------------------

import json
import os
import sys
from calculator_tests import perform_tests


def run_tests() -> bool:
  n = os.path.join(os.path.dirname(__file__), '../Unit-Testing/tests.json')
  with open(n) as f:
    tests = json.load(f)
  return perform_tests(tests)


if __name__ == '__main__':
  sys.exit(0 if run_tests() else 1)
