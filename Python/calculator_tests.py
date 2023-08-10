#:----------------------------------------------------------------------------
#:
#:  Copyright © 2023 Steffen Liersch
#:  https://www.steffen-liersch.de/
#:
#:----------------------------------------------------------------------------

from typing import Any, List
from calculator import Calculator
from float_formatter import FloatFormatter


def perform_tests(tests: Any) -> bool:
  test_count = 0
  error_count = 0
  calculator = Calculator(FloatFormatter('{:.16G}'))
  for test in tests:
    print('Test: ' + test['name'])
    array = test['expression'] if type(test['expression']) == list else [test['expression']]
    for expr in array:
      lines = calculator.calculate_and_format(expr, '')
      if not assert_equal(test['output'], lines):
        error_count += 1
      test_count += 1
  print(f'=> {test_count} tests completed with {error_count} errors')
  return error_count <= 0


def assert_equal(expected: List[str], actual: List[str]) -> bool:
  if type(expected) != list: raise ValueError('Array expected (1)')
  if type(actual) != list: raise ValueError('Array expected (2)')

  c1 = len(expected)
  c2 = len(actual)
  if c1 != c2:
    print('Assertion failed: Arrays with different lengths', expected, actual)
    return False

  ok = all([a == b for a, b in zip(actual, expected)])
  if not ok:
    print('Assertion failed')
    return False

  return True
