--[[
 * Author: Alexander Volle <knx@avolle.com>
 * Created: 2024.11.05
 * Modified: Never
 *
 * MessageBird Alert adapter class
 *
 * Used by Alerts class to send alerts through MessageBird API service
]]

--[[
This adapter requires the MessageBird alert class. You can find it here:
https://github.com/mentisy/LogicMachine/tree/main/MessageBird
]]
require 'user.messagebird'

-- Table/Class container
MessageBirdAlertAdapter = {}

--- Constructor method
---
---@param config table Configuration
--- - recipient: Recipient of alert - An email
--- - originator: Who sent the alert - An email
--- - token: The MessageBird API token
---@return void
function MessageBirdAlertAdapter:new(config)
    local obj = {
        config = {
            alert = {
                recipient = config.recipient,
                originator = config.originator,
            },
            token = config.token,
        },
        messagebird = Messagebird:new(config.token, config.originator)
    }
    self.__index = self
    self.wasAlertSent = false

    return setmetatable(obj, self)
end

--- Send alert adapter function. Handled by Alerts:send()
---
---@param message string The alert message.
---@return table MessageBird API response
function MessageBirdAlertAdapter:send(message)
    self.wasAlertSent = false
    local recipient = self.config.alert.recipient
    local feedback = self.messagebird:sendSms(recipient, message)
    if (not feedback.error) then
        self.wasAlertSent = true
    end

    return feedback
end

--- Whether the SMS was sent successfully
---
---@return boolean
function MessageBirdAlertAdapter:wasSent()
    return self.wasAlertSent
end
