--[[
 * Author: Alexander Volle <knx@avolle.com>
 * Created: 2020.03.10
 * 
 * Alert class
 * Send email to alert of events
 *
]]

Alert = {}

-- Create the Alert class
function Alert:new()
    local newObj = {}
    self.__index = self
    return setmetatable(newObj, self)
end

--[[
 * Constructor method
 * 
 * @var string username Username of Google Email account
 * @var string password Passord of Google Email account
]]
function Alert:construct(username, password)
    
    self.username = username
    self.password = password
    self.from = "<"..username..">"
    self.subject = "Alert LogicMachine"
    self.message = ""
end

--[[
 * Set email message/body
 *
 * @var string message
]]
function Alert:setMessage(message)
    self.message = message
end

--[[
 * Set email subject
 *
 * @var string subject
]]
function Alert:setSubject(subject)
    self.subject = subject
end

--[[
 * Send email to provided recipient
 *
 * @var string recipient Email recipient
 *
 * @return bool True if email was sent without error. False otherwise
]]
function Alert:send(recipient)
    
    recipient = "<"..recipient..">"
    
    local settings = {
        from = self.from,
        rcpt = recipient,
        user = self.username,
        password = self.password,
        server = "smtp.gmail.com",
        port = 465,
        secure = "sslv23",
    }
    
    local smtp = require("socket.smtp")
    
    settings.source = smtp.message {
        
        headers = {
            from = self.from,
            to = recipient,
            subject = self.subject,
        },
        body = self.message,
    }
    
    local r, e = smtp.send(settings)
    
    if(e) then
        
        return false
    end
    
    return true
end
