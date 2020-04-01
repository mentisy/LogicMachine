--[[
 * Author: Alexander Volle <knx@avolle.com>
 * Created: 2020.03.09
 * 
 * API class for retrieving or sending data to/from an API
 *
 * Extremely basic API with only POST method so far
 *
]]
API = {}

-- Create the API class
function API:new()
    local newObj = {}
    self.__index = self
    return setmetatable(newObj, self)
end

--[[
 * Construct method
 *
 * @var string baseUrl The url which is the base url for the API to use
 * Eg. baseUrl = "https://someAPI.com/
 *
]]
function API:construct(baseUrl)
    self.baseUrl = baseUrl
    self.timeout = 15
end

--[[
 * Post method
 * 
 * @var string uri URI to send data to (appended to baseUrl)
 * @var obj data Data to send to request (object, which will be transformed to JSON)
]]
function API:post(uri, data)
    
    local socketurl = require('socket.url')
    local https = require('ssl.https')
    require 'json'
    
    local fullUri = self.baseUrl .. uri
    
    local data = json.encode(data)
    local form_data = 'data=' .. socketurl.escape(data)
    https.TIMEOUT = self.timeout
    local res, code, response_header = https.request(fullUri, form_data)
    
    return res, code, response_header
end
