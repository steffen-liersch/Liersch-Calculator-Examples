#:----------------------------------------------------------------------------
#:
#:  Copyright © 2023 Steffen Liersch
#:  https://www.steffen-liersch.de/
#:
#:----------------------------------------------------------------------------

function isentrypoint(scriptpath::String)::Bool
  f = abspath(PROGRAM_FILE)
  return (f == scriptpath) || basename(f) == "run_debugger.jl"
end
