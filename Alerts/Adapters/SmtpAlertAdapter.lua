--[[
 * Author: Alexander Volle <knx@avolle.com>
 * Created: 2024.11.05
 * Modified: Never
 *
 * SMTP Alert adapter class
 *
 * Used by Alerts class to send alerts through SMTP
]]

-- Requires SMTP from built-in library
require 'socket.smtp'

-- Table/Class container
SmtpAlertAdapter = {}

--- Constructor method
---
---@param config table Configuration
--- - recipient: Recipient of alert - An email
--- - originator: Who sent the alert - An email
--- - server: The SMTP server to use
--- - username: SMTP username
--- - password: SMTP password
--- - subject: Your email subject - Defaults to LM Alert
--- - port: SMTP port - Defaults to 465
--- - secure: Secure transaction method - Defaults to sslv23
---@return void
function SmtpAlertAdapter:new(config)
    local obj = {
        config = {
            alert = {
                recipient = config.recipient,
                originator = config.originator,
            },
            server  = config.server,
            username = config.username,
            password = config.password,
            subject = config.subject or "LM Alert",
            port = config.port or 465,
            secure = config.secure or "sslv23",
        },
    }
    self.__index = self
    self.wasAlertSent = false

    return setmetatable(obj, self)
end

--- Send alert adapter function. Handled by Alerts:send()
---
---@param message string The alert message.
---@return table SMTP response
function SmtpAlertAdapter:send(message)
    settings = {
        server = self.config.server,
        port = self.config.port,
        secure = self.config.secure,
        user = self.config.username,
        password = self.config.password,
    }
    self.wasAlertSent = false
    settings.source = socket.smtp.message {
        headers = {
            from = self.config.originator,
            to = self.confg.recipient,
            subject = self.config.subject,
        },
        body = message,
    }

    local response, error = smtp.send(settings)
    if (not error) then
        self.wasAlertSent = true
    end

    return {
        response = response,
        error = error,
    }
end

--- Whether the email was sent successfully
---
---@return boolean
function SmtpAlertAdapter:wasSent()
    return self.wasAlertSent
end
