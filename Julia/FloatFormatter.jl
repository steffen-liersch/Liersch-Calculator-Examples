#:----------------------------------------------------------------------------
#:
#:  Copyright © 2023 Steffen Liersch
#:  https://www.steffen-liersch.de/
#:
#:----------------------------------------------------------------------------

using Printf

function FloatFormatter(format::String="%G")::Function

  # The Printf.sprintf macro cannot be used here because
  # it can only be called with a string literal for the
  # format parameter and not with a variable.

  return function (value)
    return Printf.format(Printf.Format(format), value)
  end

end
