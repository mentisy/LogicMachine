--[[
 * Author: Alexander Volle <knx@avolle.com>
 * Created: 2024.11.05
 * Modified: Never
 *
 * Alert container class
 *
 * Facilitates sending alerts through custom Adapter classes.
]]

-- Table/Class container
Alerts = {}

--- Constructor method
---
---@param config table Configuration
--- - adapter: The adapter you wish to use for alerts. Empty config can be used if you wish to set adapter later.
---@return void
function Alerts:new(config)
    local obj = {
        config = {
            adapter = config.adapter or nil, -- Adapter for sending alerts
        },
    }
    self.__index = self
    self.result = nil

    return setmetatable(obj, self)
end

--- Set adapter on the fly.
---
---@param adapter function The adapter you wish to use for alerts.
---@return void
function Alerts:setAdapter(adapter)
    self.config.adapter = adapter
end

--- Send alert through the adapter.
---
---@param message string The alert message.
---@return boolean Whether the alert was successfully sent
function Alerts:send(message)
    assert(self.config.adapter ~= nil, "Alerts library requires an adapter to be set.")
    assert(type(self.config.adapter["send"]) == "function", "Alert adapter requires a `send` method.")

    self.result = self.config.adapter:send(message)

    return self.config.adapter:wasSent()
end

--- Get actual result from adapter
--- While the Alerts:send function will return a boolean value, through Alerts:getResult you can retrieve the actual
--- value that the Alert Adapter returns. API response, SMTP response, etc.
---
---@return table|string|number|nil Returned value from adapter send process
function Alerts:getResult()
    return self.result
end
