#!/usr/bin/env julia

#:----------------------------------------------------------------------------
#:
#:  Copyright © 2023-2024 Steffen Liersch
#:  https://www.steffen-liersch.de/
#:
#:----------------------------------------------------------------------------

#=
  import Pkg; Pkg.add("JSON")   # Install the package
  import Pkg; Pkg.rm("JSON")    # Remove the package
=#

include("CalculatorTests.jl")
include("Helpers.jl")

using JSON

function runtests()::Bool
  n = joinpath(dirname(@__FILE__), "../Unit-Testing/tests.json")
  tests = JSON.parsefile(n)
  return performtests(tests)
end

if isentrypoint(@__FILE__)
  exit(runtests() ? 0 : 1)
end
