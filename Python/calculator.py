#:----------------------------------------------------------------------------
#:
#:  Copyright © 2023 Steffen Liersch
#:  https://www.steffen-liersch.de/
#:
#:----------------------------------------------------------------------------

import math
import re
from typing import Callable, List
from calculator_exception import CalculatorException
from float_formatter import FloatFormatter
from the_token import Token


class Calculator:
  @property
  def steps(self) -> List[List[Token]]:
    return self._steps

  def __init__(self, formatter: FloatFormatter | None = None):
    self._formatter = formatter or FloatFormatter()
    self._matches: List[Token] = []
    self._steps: List[List[Token]] = []
    self._is_first_step = False

  def format(self, token: Token) -> str:
    v = token.as_number
    if v is None:
      return str(token.as_string)

    s = self._formatter.format(v)
    return '(' + s + ')' if v < 0 else s

  def calculate_and_format(self, expression: str, step_prefix: str = '= ') -> List[str]:
    v = None
    e = None
    try:
      v = self.calculate(expression)
    except CalculatorException as x:
      e = str(x)

    res: List[str] = []
    for step in self._steps:
      res.append(step_prefix + ''.join(map(lambda x: self.format(x), step)))

    if v is not None:
      res.append(step_prefix + self._formatter.format(v))

    if e is not None:
      res.append(e)

    return res

  def calculate(self, expression: str) -> float | None:
    if type(expression) != str:
      raise ValueError('String expected for expression')

    self._is_first_step = True
    self._steps = []
    self._matches = []

    for x in re.finditer(self._re, expression):
      self._matches.append(Token.from_str(x.group(0)))

    if len(self._matches) <= 0:
      return None

    self._calculate_from(0)

    if len(self._matches) <= 0:
      raise RuntimeError()

    if len(self._matches) > 1:
      raise CalculatorException('Operator expected instead of ' + self._matches[1].as_string)

    v = self._matches[0].as_number
    if v is None:
      raise RuntimeError()

    return v

  def _calculate_from(self, index: int) -> int:
    self._resolve(index, '^', lambda _, x, y: math.pow(x, y))
    self._resolve(index, '*/%', self._perform_point_calculation)
    return self._resolve(index, '+-', lambda op, x, y: x + y if op == '+' else x - y)

  def _resolve(self, index: int, operators: str, fn: Callable[[str, float, float], float]) -> int:
    i = index
    sgn = self._try_get_sign(i)
    if sgn:
      i += 1

      # Power operator has priority over sign
      if operators == '^':
        sgn = None

    v1 = self._get_value(i)
    i += 1
    if sgn:
      v1 *= sgn

    saved = False

    while i < len(self._matches) and self._matches[i].as_string != ')':
      op = self._get_operator(i)
      v2 = self._get_value(i + 1)
      i += 2

      if operators.find(op) >= 0:
        v2 = fn(op, v1, v2)

        if not saved:
          saved = True
          self._save_result()

        z = 4 if sgn else 3
        self._splice(self._matches, i - z, z, Token.from_float(v2))
        i -= z - 1

      v1 = v2
      sgn = None

    if sgn:
      self._splice(self._matches, index, 2, Token.from_float(v1))

    return i

  def _try_get_sign(self, index: int) -> int | None:
    if index < len(self._matches):
      match self._matches[index].as_string:
        case '+': return +1
        case '-': return -1
        case _: return None
    return None

  def _get_operator(self, index: int) -> str:
    if index >= len(self._matches):
      raise CalculatorException('Operator expected')

    s = self._matches[index].as_string
    if len(s) == 1:
      op = s[0]
      if '+-*/%^'.find(op) >= 0:
        return op

    raise CalculatorException('Operator expected instead of ' + s)

  def _get_value(self, index: int) -> float:
    if index >= len(self._matches):
      raise CalculatorException('Number expected')

    m = self._matches[index]

    if m.as_string == '(':
      i = self._calculate_from(index + 1)

      if i != index + 2:
        raise RuntimeError()

      if i >= len(self._matches) or self._matches[i].as_string != ')':
        raise CalculatorException('Missing closing brace')

      m = self._matches[index + 1]
      self._splice(self._matches, index, 3, m)

    if m.as_number is not None:
      return m.as_number

    raise CalculatorException('Number expected instead of ' + m.as_string)

  def _save_result(self) -> None:
    if self._is_first_step:
      self._is_first_step = False
    else: self._steps.append(list(self._matches))

  @staticmethod
  def _perform_point_calculation(op: str, x: float, y: float) -> float:
    match op:
      case '*': return x * y
      case '/': return x / y
      case '%': return x % y
      case _: raise RuntimeError()

  @staticmethod
  def _splice(source: List[Token], index: int, delete_count: int, replacement: Token) -> None:
    del source[index:index + delete_count - 1]
    source[index] = replacement

  # _re is a static field
  _re = re.compile(r'\d+(\.\d+)?|[A-Za-z]+|[+\-*/%^()]|[^\dA-Za-z+\-*/%^()\s]+')
