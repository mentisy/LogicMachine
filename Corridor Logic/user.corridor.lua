--[[
 * Author: Alexander Volle <knx@avolle.com>
 * Created: 2020.03.09
 * 
 * Corridor lighting control class
 * Enables corridor lighting to remain on should one of the offices or meeting rooms be occupied.
 * Can further be used to keep stairwell lighting on should one of the corridors be occupied (either directly 
 * or indirectly through occupied offices)
 *
]]

Corridor = {}

-- Create the corridor class
function Corridor:new()
    local newObj = {}
    self.__index = self
    return setmetatable(newObj, self)
end

--[[
 * Evaluate method
 * 
 * @var string input TAG to check for occupied rooms
 * @var string output TAG to send occupied status
 * @var bool update Whether to update the API
]]
function Corridor:evaluate(input, output, updateAPI)
   
    -- Get all group addresses sending on/off in rooms by input tag
    local inputAddresses = grp.tag(input)   
    
    -- Default value for output tag (addresses) is false
    local status = false
    
    -- Loop through input addresses by tag and check if any are on (occupied)
    -- If any are occupied, then set status true and break out of loop
    for _, address in ipairs(inputAddresses) do
        
        if address.value == true then
            status = true
            break
        end
    end
    
    -- Prepare for data sending to external corridor display (API)
    local data = {}
    local changed = false
    
    -- Write status to output tag (addresses)
    local outputAddresses = grp.tag(output)
    for _, address in ipairs(outputAddresses) do
        -- Only send status if different from existing value
        if address.value ~= status then
            grp.write(address.address, status, dt.bool)
            table.insert(data, {address = address.address, value = status})
            changed = true
        end
    end
    
    if changed and updateAPI then
        
        require 'user.api'
        API:construct("API_BASEURL")
        API:post('update.php', data)
    end
    
    return nil
end
