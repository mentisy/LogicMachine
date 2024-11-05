--[[
 * Author: Alexander Volle <knx@avolle.com>
 * Created: 2024.11.05
 * Modified: Never
 *
 * SMTP Alert adapter class
 *
 * Used by Alerts class to send alerts through any API service
]]

-- Requires from built-in libraries
require 'ssl.https'
require 'ltn12'
require 'json'

-- Table/Class container
ApiAlertAdapter = {}

--- Constructor method
---
---@param config table Configuration
--- - recipient: Recipient of alert - An email
--- - originator: Who sent the alert - An email
--- - token: The API token (can be nil)
--- - url: The API url
---@return void
function ApiAlertAdapter:new(config)
    local obj = {
        config = {
            alert = {
                recipient = config.recipient,
                originator = config.originator,
            },
            token = config.token,
            url  = config.url,
        },
    }
    self.__index = self
    self.wasAlertSent = false

    return setmetatable(obj, self)
end

--- Send alert adapter function. Handled by Alerts:send()
---
---@param message string The alert message.
---@return table API response
function ApiAlertAdapter:send(message)
    local payload = {
        config = self.config,
        message = message,
    }
    self.wasAlertSent = false

    local body, code, headers = ssl.https.request {
        url = self.config.url,
        method = 'POST',
        source = ltn12.source.string(json.encode(payload)),
    }

    if (self:requestOk(code)) then
        self.wasAlertSent = true
    end

    return {
        body = body,
        code = code,
        headers = headers,
    }
end

--- Whether the API alert was sent successfully
---
---@return boolean
function ApiAlertAdapter:wasSent()
    return self.wasAlertSent
end

--[[
 * Check if request code is "OK"
 *
 * @var int code Returned code from response
 *
 * @return bool Whether response code is considered "OK"
]]
function ApiAlertAdapter:requestOk(code)
    return code >= 200 and code <= 299
end
