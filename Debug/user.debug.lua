--[[
 * Author: Alexander Volle <postmaster@avolle.com>
 * Created: 2023.03.31
 * 
 * Debug class for writing to log when debug is activated.
 * Removes the need for doing conditionals at every debug log message
 *
]]

DebugLib = {}

--[[
 * Constructor method
 * 
 * @var boolean on - Whether debug mode is on
]]
function DebugLib:new(on)
    local newObj = {
    	on = on,
    }
    self.__index = self
    return setmetatable(newObj, self)
end

--[[
 * Log message if debug is on
 * 
 * @var string message - Message to log
]]
function DebugLib:log(message)
    if (self.on) then
        log(message)
    end
end

--[[
 * Log message if debug is on AND the given condition is true
 * 
 * @var boolean condition - Condition required to be true for the message to log
 * @var string message - Message to log
]]
function DebugLib:logIf(condition, message)
    if (self.on and condition) then
        log(message)
    end
end
