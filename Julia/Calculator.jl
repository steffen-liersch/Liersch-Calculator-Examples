#:----------------------------------------------------------------------------
#:
#:  Copyright © 2023 Steffen Liersch
#:  https://www.steffen-liersch.de/
#:
#:----------------------------------------------------------------------------

include("CalculatorException.jl")
include("FloatFormatter.jl")
include("Token.jl")

re = r"\d+(\.\d+)?|[A-Za-z]+|[+\-*/%^()]|[^\dA-Za-z+\-*/%^()\s]+"

mutable struct Calculator
  _format::Function
  _matches::Vector{Token}
  _steps::Vector{Vector{Token}}
  _isfirststep::Bool
  Calculator(format::Union{Function,Nothing}=nothing) = new(
    format !== nothing ? format : FloatFormatter(), [], [], false)
end

function format(calculator::Calculator, token::Token)::String
  v = token.asnumber
  if v === nothing
    return token.asstring
  end

  s = calculator._format(v)
  return v < 0 ? '(' * s * ')' : s
end

function calculateandformat!(calculator::Calculator, expression::String, stepprefix::String="= ")::Vector{String}
  v::Union{Number,Nothing} = nothing
  e::Union{String,Nothing} = nothing
  try
    v = calculate!(calculator, expression)
  catch x
    # Don't handle unexpected errors!
    if !isa(x, CalculatorException)
      rethrow()
    end
    e = x.message
  end

  res = String[]
  for x in calculator._steps
    push!(res, stepprefix * join(map(x -> format(calculator, x), x)))
  end

  if v !== nothing
    push!(res, stepprefix * calculator._format(v))
  end

  if e !== nothing
    push!(res, e)
  end

  return res
end

function calculate!(calculator::Calculator, expression::String)::Union{Number,Nothing}
  if expression === nothing
    throw(ArgumentError("Argument expected: expression"))
  end

  calculator._isfirststep = true
  empty!(calculator._steps)
  empty!(calculator._matches)

  for x in eachmatch(re, expression)
    push!(calculator._matches, Token(string(x.match)))
  end

  if isempty(calculator._matches)
    return nothing
  end

  _calculatefrom!(calculator, 1)

  if isempty(calculator._matches)
    error()
  end

  if length(calculator._matches) > 1
    throw(CalculatorException("Operator expected instead of " * calculator._matches[2].asstring))
  end

  m::Token = calculator._matches[1]
  if m.asnumber === nothing
    error()
  end

  return m.asnumber
end

function _calculatefrom!(calculator::Calculator, index::Int)::Int
  _resolve!(calculator, index, "^", (op, x, y) -> x^y)
  _resolve!(calculator, index, "*/%", _performpointcalculation)
  return _resolve!(calculator, index, "+-", (op, x, y) -> op == '+' ? x + y : x - y)
end

function _resolve!(calculator::Calculator, index::Int, operators::String, fn::Function)::Int
  i = index
  sgn = _trygetsign(calculator, i)
  if sgn !== nothing
    i += 1

    # Power operator has priority over sign
    if operators == "^"
      sgn = nothing
    end
  end

  v1 = _getvalue!(calculator, i)
  i += 1
  if sgn !== nothing
    v1 *= sgn
  end

  saved = false

  while i <= length(calculator._matches) && calculator._matches[i].asstring != ")"
    op = _getoperator(calculator, i)
    v2 = _getvalue!(calculator, i + 1)
    i += 2

    if findfirst(op, operators) !== nothing
      v2 = fn(op, v1, v2)

      if !saved
        saved = true
        _saveresult!(calculator)
      end

      z = sgn !== nothing ? 4 : 3
      _splice!(calculator._matches, i - z, z, Token(v2))
      i -= z - 1
    end

    v1 = v2
    sgn = nothing
  end

  if sgn !== nothing
    _splice!(calculator._matches, index, 2, Token(v1))
  end

  return i
end

function _trygetsign(calculator::Calculator, index::Int)::Union{Int,Nothing}
  if index <= length(calculator._matches)
    s = calculator._matches[index].asstring
    if s == "+"
      return +1
    elseif s == "-"
      return -1
    end
  end
  return nothing
end

function _getoperator(calculator::Calculator, index::Int)::Char
  if index > length(calculator._matches)
    throw(CalculatorException("Operator expected"))
  end

  m::String = calculator._matches[index].asstring
  if length(m) == 1
    op::Char = m[1]
    if findfirst(op, "+-*/%^") !== nothing
      return op
    end
  end

  throw(CalculatorException("Operator expected instead of " * m))
end

function _getvalue!(calculator::Calculator, index::Int)::Number
  if index > length(calculator._matches)
    throw(CalculatorException("Number expected"))
  end

  m::Token = calculator._matches[index]

  if m.asstring == "("
    i = _calculatefrom!(calculator, index + 1)

    if i != index + 2
      error()
    end

    if i > length(calculator._matches) || calculator._matches[i].asstring != ")"
      throw(CalculatorException("Missing closing brace"))
    end

    m = calculator._matches[index+1]
    _splice!(calculator._matches, index, 3, m)
  end

  if m.asnumber !== nothing
    return m.asnumber
  end

  throw(CalculatorException("Number expected instead of " * m.asstring))
end

function _saveresult!(calculator::Calculator)::Nothing
  if calculator._isfirststep
    calculator._isfirststep = false
  else
    push!(calculator._steps, copy(calculator._matches))
  end
  return nothing
end

function _performpointcalculation(op::Char, x::Number, y::Number)::Number
  if op == '*'
    return x * y
  elseif op == '/'
    return x / y
  elseif op == '%'
    return x % y
  end
  error()
end

function _splice!(list::Vector{Token}, index::Int, deletecount::Int, replacement::Token)::Nothing
  c = deletecount - 2
  if c >= 0
    deleteat!(list, index:index+c)
  end
  list[index] = replacement
  return nothing
end
