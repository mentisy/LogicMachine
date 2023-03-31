-- How to use the `user.debug` library

-- Add this constant to your script, to determine whether debug mode is on or off
local DEBUG = true -- Set to false if you don't want debug messages to log

-- Require the script
require 'user.debug'

-- Init debug class -- Uses the constant at the top of the script to determine debug mode
local Debug = DebugLib:new(DEBUG)

-- Write a log message if `DEBUG` is true
Debug:log("Debug is true. Send message to log")

-- Write a log message if `DEBUG` is true, AND a condition is true
Debug:logIf(true, "Debug is true, and condition is true. Send message to log")
Debug:logIf(false, "Debug is true, but condition is not. Do NOT send message to log")
