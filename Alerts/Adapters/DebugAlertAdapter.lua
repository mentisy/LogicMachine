--[[
 * Author: Alexander Volle <knx@avolle.com>
 * Created: 2024.11.05
 * Modified: Never
 *
 * SMTP Alert adapter class
 *
 * Used by Alerts class to log messages
]]

-- Table/Class container
DebugAlertAdapter = {}

--- Constructor method
---
---@param config table Configuration
--- - recipient: Recipient of alert - An email
--- - originator: Who sent the alert - An email
---@return void
function DebugAlertAdapter:new(config)
    local obj = {
        config = {
            alert = {
                recipient = config.recipient or 'debug-recipient',
                originator = config.originator or 'debug-originator',
            },
        },
    }
    self.__index = self
    self.wasAlertSent = false

    return setmetatable(obj, self)
end

--- Send alert adapter function. Handled by Alerts:send()
---
---@param message string The alert message.
---@return boolean
function DebugAlertAdapter:send(message)
    self.wasAlertSent = true

    return log("Originator: %s | Recipient: %s | Message: %s", self.config.alert.recipient, self.config.alert.originator, message)
end

--- Whether the debug was logged successfully
---
---@return boolean
function DebugAlertAdapter:wasSent()
    return self.wasAlertSent
end
