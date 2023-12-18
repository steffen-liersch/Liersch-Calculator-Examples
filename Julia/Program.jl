#:----------------------------------------------------------------------------
#:
#:  Copyright © 2023 Steffen Liersch
#:  https://www.steffen-liersch.de/
#:
#:----------------------------------------------------------------------------

include("Calculator.jl")
include("Helpers.jl")

function runui()::Nothing
  println()
  println("Liersch Calculator (Julia)")
  println("==================")
  println()

  println("Copyright © 2023 Steffen Liersch")
  println("https://www.steffen-liersch.de/")
  println()

  calculator = Calculator()

  exitstate = 0
  while true
    print("? ")

    s = readline()
    s = strip(s)

    if !isempty(s)
      for x in calculateandformat!(calculator, string(s))
        println(x)
      end
      exitstate = 0
    else
      if exitstate > 0
        break
      end

      println("Press [Enter] again to exit.")
      exitstate += 1
    end

    println()
  end
  return nothing
end

function runwithargs(args::Vector{String})::Nothing
  calculator = Calculator()
  for a in args
    x = calculateandformat!(calculator, a, "")
    println(isempty(x) ? "" : last(x))
  end
  return nothing
end

if isentrypoint(@__FILE__)
  if !isempty(ARGS)
    runwithargs(ARGS)
  else
    runui()
  end
end
