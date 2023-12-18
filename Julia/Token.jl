#:----------------------------------------------------------------------------
#:
#:  Copyright © 2023 Steffen Liersch
#:  https://www.steffen-liersch.de/
#:
#:----------------------------------------------------------------------------

struct Token
  asnumber::Union{Number,Nothing}
  asstring::String
  Token(value::Number) = new(value, string(value))
  Token(value::String) = (x = parsetoken(value); new(x[2], x[1]))
end

function parsetoken(value::String)::Tuple{String,Union{Float64,Nothing}}
  v = tryparse(Float64, value)
  if v !== nothing
    return value, v
  end
  s = uppercase(value)
  if s == "E"
    return s, MathConstants.e
  elseif s == "PI"
    return s, MathConstants.pi
  else
    return s, nothing
  end
end

tostring(token::Token) = token.asstring
