#:----------------------------------------------------------------------------
#:
#:  Copyright © 2023 Steffen Liersch
#:  https://www.steffen-liersch.de/
#:
#:----------------------------------------------------------------------------

include("Calculator.jl")
include("FloatFormatter.jl")
include("Helpers.jl")

function performtests(tests)::Bool
  testcount = 0
  errorcount = 0
  calculator = Calculator(FloatFormatter("%.16G"))
  for test in tests
    println("Test: " * test["name"])
    array = isa(test["expression"], Array) ? test["expression"] : [test["expression"]]
    for expr in array
      lines = calculateandformat!(calculator, expr, "")
      if !assertequal(test["output"], lines)
        errorcount += 1
      end
      testcount += 1
    end
  end
  println("=> $testcount tests completed with $errorcount errors")
  return errorcount <= 0
end

function assertequal(expected::Vector, actual::Vector)::Bool
  c1 = length(expected)
  c2 = length(actual)
  if c1 != c2
    println("Assertion failed: Arrays with different lengths")
    return false
  end

  for i in 1:c1
    if expected[i] != actual[i]
      println("Assertion failed: $(expected[i]) != $(actual[i])")
      return false
    end
  end

  return true
end
