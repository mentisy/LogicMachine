-- Input tag. Which presence values to evaluate
local input = "KORRIDOR_1ETG_BLUE_INPUT"

-- Output tag. Which relays to send evaluated value to
local output = "KORRIDOR_1ETG_BLUE_OUTPUT"

-- Whether to update the API listing corridor overview
local updateAPI = true
-----------------------------------------------------------------
--------------------- END OF PARAMETERS -------------------------
-----------------------------------------------------------------

require 'user.corridor'

Corridor:evaluate(input, output, updateAPI)
