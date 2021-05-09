--
-- Created with IntelliJ IDEA.
-- User: Alexander Volle
-- Date: 09.05.2021
-- Time: 21.51
--
-- KNX Address Class
--
-- A class to parse and create KNX addresses strings
--

Knx_Address = {}

-- Create the KNX Address class
function Knx_Address:new()
    local newObj = {
        address = nil,
        parts = {
            main = nil,
            middle = nil,
            sub = nil,
        },
    }
    self.__index = self

    return setmetatable(newObj, self)
end


--[[
 * Parse a KNX address string into address parts
 *
 * @param string address KNX addresses to parse
 *
 * @return array address parts
]]
function Knx_Address:parse(address)
    local parts = string.split(address, '/')
    self.parts.main = parts[1]
    self.parts.middle = parts[2]
    self.parts.sub = parts[3]

    return self.parts
end

--[[
 * Get Main address (X/x/x)
 *
 * @return number Main address
]]
function Knx_Address:getMainAddress()
    return self.parts.main
end

--[[
 * Get Middle address (x/X/x)
 *
 * @return number Middle address
]]
function Knx_Address:getMiddleAddress()
    return self.parts.middle
end

--[[
 * Get sub address (x/x/X)
 *
 * @return number Sub address
]]
function Knx_Address:getSubAddress()
    return self.parts.sub
end


--[[
 * Create a KNX address string from address parts
 *
 * @param string|number main KNX Main address number
 * @param string|number middle KNX Middle address number
 * @param string|number sub KNX Sub address number
 *
 * @return string created KNX Address
]]
function Knx_Address:create(main, middle, sub)
    return string.format("%s/%s/%s", main, middle, sub)
end
