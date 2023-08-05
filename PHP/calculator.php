<?php /*--------------------------------------------------------------------*\
::
::  Copyright © 2023 Steffen Liersch
::  https://www.steffen-liersch.de/
::
\*--------------------------------------------------------------------------*/

namespace Liersch\Calculator;

require_once dirname(__FILE__) . '/calculator-exception.php';
require_once dirname(__FILE__) . '/float-formatter.php';
require_once dirname(__FILE__) . '/token.php';

use \InvalidArgumentException;
use \UnexpectedValueException;

final class Calculator
{
  public function getSteps(): array
  {
    return $this->steps;
  }

  public function __construct(FloatFormatter|null $formatter = null)
  {
    $this->formatter = $formatter ?? new FloatFormatter();
  }

  public function format(Token $token): string
  {
    $v = $token->asNumber;
    if ($v === null)
      return $token->asString;

    $s = $this->formatter->format($v);
    return $v < 0 ? '(' . $s + ')' : $s;
  }

  public function calculateAndFormat(string $expression, string $stepPrefix = '= '): array
  {
    $v = null;
    $e = null;
    try
    {
      $v = $this->calculate($expression);
    }
    catch (CalculatorException $x) // Don't handle unexpected errors!
    {
      $e = $x->getMessage();
    }

    $res = [];
    foreach ($this->steps as $steps)
    {
      $temp = array_map(fn($x) => $this->format($x), $steps);
      $res[] = implode('', $temp);
    }

    if ($v !== null)
      $res[] = $stepPrefix . $this->formatter->format($v);

    if ($e !== null)
      $res[] = $e;

    return $res;
  }

  public function calculate(string $expression): float|null
  {
    if ($expression === null)
      throw new InvalidArgumentException('Unexpected expression');

    $this->isFirstStep = true;
    $this->steps = [];
    $this->matches = [];

    preg_match_all($this->re, $expression, $temp, PREG_SET_ORDER);
    $c = count($temp);
    if ($c <= 0)
      return null;

    for ($i = 0; $i < $c; $i++)
      $this->matches[] = new Token($temp[$i][0]);

    $this->calculateFrom(0);

    if (count($this->matches) <= 0)
      throw new UnexpectedValueException();

    if (count($this->matches) > 1)
      throw new CalculatorException('Operator expected instead of ' . $this->matches[1]->asString);

    $m = $this->matches[0];
    if ($m->asNumber === null)
      throw new UnexpectedValueException();

    return $m->asNumber;
  }

  private function calculateFrom(int $index): int
  {
    $this->resolve($index, '^', fn($op, $x, $y) => $x ** $y);
    $this->resolve($index, '*/%', array(__CLASS__, 'performPointCalculation'));
    return $this->resolve($index, '+-', fn($op, $x, $y) => $op == '+' ? $x + $y : $x - $y);
  }

  private function resolve(int $index, string $operators, callable $fn): int
  {
    $i = $index;
    $sgn = $this->tryGetSign($i);
    if ($sgn)
    {
      $i++;

      // Power operator has priority over sign
      if ($operators == '^')
        $sgn = null;
    }

    $v1 = $this->getValue($i++);
    if ($sgn)
      $v1 *= $sgn;

    $saved = false;

    while ($i < count($this->matches) && $this->matches[$i]->asString != ')')
    {
      $op = $this->getOperator($i++);
      $v2 = $this->getValue($i++);

      $p = strpos($operators, $op);
      if ($p !== false && $p >= 0)
      {
        $v2 = $fn($op, $v1, $v2);

        if (!$saved)
        {
          $saved = true;
          $this->saveResult();
        }

        $z = $sgn ? 4 : 3;
        array_splice($this->matches, $i - $z, $z, array(new Token($v2)));
        $i -= $z - 1;
      }

      $v1 = $v2;
      $sgn = null;
    }

    if ($sgn)
      array_splice($this->matches, $index, 2, array(new Token($v1)));

    return $i;
  }

  private function tryGetSign(int $index): int|null
  {
    if ($index < count($this->matches))
    {
      switch ($this->matches[$index]->asString)
      {
        case '+':
          return +1;

        case '-':
          return -1;
      }
    }
    return null;
  }

  private function getOperator(int $index): string
  {
    if ($index >= count($this->matches))
      throw new CalculatorException('Operator expected');

    $m = $this->matches[$index]->asString;
    if (strlen($m) == 1)
    {
      $op = $m[0];
      $i = strpos('+-*/%^', $op);
      if ($i !== false && $i >= 0)
        return $op;
    }

    throw new CalculatorException('Operator expected instead of ' . $m);
  }

  private function getValue(int $index): float
  {
    if ($index >= count($this->matches))
      throw new CalculatorException('Number expected');

    $m = $this->matches[$index];

    if ($m->asString == '(')
    {
      $i = $this->calculateFrom($index + 1);

      if ($i != $index + 2)
        throw new UnexpectedValueException();

      if ($i >= count($this->matches) || $this->matches[$i]->asString != ')')
        throw new CalculatorException('Missing closing brace');

      $m = $this->matches[$index + 1];
      array_splice($this->matches, $index, 3, array($m));
    }

    if ($m->asNumber !== null)
      return $m->asNumber;

    throw new CalculatorException('Number expected instead of ' . $m->asString);
  }

  private function saveResult(): void
  {
    if ($this->isFirstStep)
      $this->isFirstStep = false;
    else
      $this->steps[] = $this->matches;
  }

  private static function performPointCalculation(string $op, float $x, float $y): float
  {
    switch ($op)
    {
      case '*':
        return $x * $y;

      case '/':
        return $x / $y;

      case '%':
        return $x % $y;

      default:
        throw new UnexpectedValueException();
    }
  }

  private string $re = '/\d+(\.\d+)?|[A-Za-z]+|[+\-*\/%^()]|[^\dA-Za-z+\-*\/%^()\s]+/';
  private FloatFormatter $formatter;
  private array $matches = [];
  private array $steps = [];
  private bool $isFirstStep;
}
