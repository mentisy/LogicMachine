--[[
 * Author: Alexander Volle <knx@avolle.com>
 * Created: 2019.11.23
 *
 * MessageBird API Interface
 *
 * Uses MessageBird to send sms messages etc.
 *
]]

Messagebird = {}

-- Create Messagebird class
function Messagebird:new()
    local newObj = {}
    self.__index = self
    return setmetatable(newObj, self)
end

--[[
 * Constructor method
 *
 * @var string token Token from Messagebird
 * @var string originator Who the message is from
]]
function Messagebird:construct(token, originator)
    
    self.token = token
    self.originator = originator
    self.baseUrl = "https://rest.messagebird.com/"
    
    local http = require "socket.http"
    self.request = require('ssl.https').request
    self.ltn12 = require("ltn12")
    self.json = require('json')
    self.headers = {
        Authorization = "AccessKey "..token
	}
end

--[[
 * Get balance method
 *
 * @return object containing the currency and amount
]]
function Messagebird:getBalance()
    
    local body, code, headers, response = self:requestUrl("GET", "balance")
    
    return {
        currency = response.type,
        amount = response.amount
    }
end

--[[
 * Send SMS method
 *
 * @var string recipient Phone number to receive message
 * @var string message Message body
 *
 * @return object containing error (bool) and response
]]
function Messagebird:sendSms(recipient, message)
    
    local escape = require('socket.url').escape
    local body = string.format('recipients=%s&originator=%s&body=%s', escape(recipient), escape(self.originator), escape(message))
    local body, code, headers, response = self:post("messages", body)
    
    if self:requestOk(code) then
        
        return { error = false, response = response }
    end
    
    return { error = code, response = response }
end

--[[
 * Send POST request to Messagebird API
 *
 * @var string url Request url to Messagebird API
 * @var string data Request body
 *
 * @return body, code, headers, response
]]
function Messagebird:post(url, data)
    
    local body = data
    self.headers["body"] = body
    self.headers["Content-Type"] = "application/x-www-form-urlencoded"
    self.headers["Content-Length"] = string.len(body)
    
    local body, code, headers, response = self:requestUrl("POST", url)
    
    return body, code, headers, response
end

--[[
 * Send request to Messagebird API
 *
 * @var string method Which method to use in request (e.g. GET, POST, etc)
 * @var string url Request url to Messagebird API
 *
 * @return body, code, headers, response
]]
function Messagebird:requestUrl(method, url)
    
	local response = {}
        
    local body, code, headers = self.request{
        method = method,
        url = self.baseUrl .. url,
        headers = self.headers,
        source = self.ltn12.source.string(self.headers.body),
        sink = self.ltn12.sink.table(response),
	}
    
    response = self.json.decode(response[1])
    
    return body, code, headers, response
end


--[[
 * Check if request code is "OK"
 *
 * @var int code Returned code from response
 *
 * @return bool Whether response code is considered "OK"
]]
function Messagebird:requestOk(code)
    return code >= 200 or code <= 299
end
