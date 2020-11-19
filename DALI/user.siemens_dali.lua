--[[
 * Author: Alexander Volle <knx@avolle.com>
 * Created: 2020.11.18
 *
 * DALI Siemens Gateway diagnostic
 *
 * Analyze DALI group diagnostic message
 *
]]

DALI_Siemens = {}

--[[
 * Create the DALI Siemens class
 *
 * @param string value - Hex telegram value
]]
function DALI_Siemens:new(value)
    local newObj = {
        value = self:_hex2Bin(value),
        map = {
            numberOfECGs = {27, 32},
            numberOfInverters = {19, 24},
            defectiveInverter = {17, 17},
            numberOfDefectiveLamps = {11, 16},
            emergencyLamp = {10, 10},
            normalLamp = {9, 9},
            numberOfDefectiveECGs = {3, 8},
            emergencyECG = {2, 2},
            normalECG = {1, 1},
        },
    }
    self.__index = self

    return setmetatable(newObj, self)
end

--[[
 * Returns the number of ECGs in the group
 *
 * @return integer
]]
function DALI_Siemens:numberOfECGs()
    local binary = string.sub(self.value, self.map.numberOfECGs[1], self.map.numberOfECGs[2])

    return self:_bin2Dec(binary)
end

--[[
 * Returns the number of inverters in the group
 *
 * @return integer
]]
function DALI_Siemens:numberOfInverters()
    local binary = string.sub(self.value, self.map.numberOfInverters[1], self.map.numberOfInverters[2])

    return self:_bin2Dec(binary)
end

--[[
 * Returns whether any defective inverters are in the group
 *
 * @return integer
]]
function DALI_Siemens:defectiveInverter()
    local binary = string.sub(self.value, self.map.defectiveInverter[1], self.map.defectiveInverter[2])

    return self:_bin2Dec(binary)
end

--[[
 * Returns the number of defective lamps in the group
 *
 * @return integer
]]
function DALI_Siemens:numberOfDefectiveLamps()
    local binary = string.sub(self.value, self.map.numberOfDefectiveLamps[1], self.map.numberOfDefectiveLamps[2])

    return self:_bin2Dec(binary)
end

--[[
 * Returns whether any emergency lamps are defective in the group
 *
 * @return integer
]]
function DALI_Siemens:emergencyLamp()
    local binary = string.sub(self.value, self.map.emergencyLamp[1], self.map.emergencyLamp[2])

    return self:_bin2Dec(binary)
end

--[[
 * Returns whether any normal lamps are defective in the group
 *
 * @return integer
]]
function DALI_Siemens:normalLamp()
    local binary = string.sub(self.value, self.map.normalLamp[1], self.map.normalLamp[2])

    return self:_bin2Dec(binary)
end

--[[
 * Returns the number of defective ECGs in the group
 *
 * @return integer
]]
function DALI_Siemens:numberOfDefectiveECGs()
    local binary = string.sub(self.value, self.map.numberOfDefectiveECGs[1], self.map.numberOfDefectiveECGs[2])

    return self:_bin2Dec(binary)
end

--[[
 * Returns whether any emergency ECGs are defective in the group
 *
 * @return integer
]]
function DALI_Siemens:emergencyECG()
    local binary = string.sub(self.value, self.map.emergencyECG[1], self.map.emergencyECG[2])

    return self:_bin2Dec(binary)
end

--[[
 * Returns whether any normal ECGs are defective in the group
 *
 * @return integer
]]
function DALI_Siemens:normalECG()
    local binary = string.sub(self.value, self.map.normalECG[1], self.map.normalECG[2])

    return self:_bin2Dec(binary)
end

--[[
 * Returns an object of the diagnostic attributes
 *
 * @return object
]]
function DALI_Siemens:toObject()
    return {
        numberOfECGs = self:numberOfECGs(),
        numberOfInverters = self:numberOfInverters(),
        defectiveInverter = self:defectiveInverter(),
        numberOfDefectiveLamps = self:numberOfDefectiveLamps(),
        emergencyLamp = self:emergencyLamp(),
        normalLamp = self:normalLamp(),
        numberOfDefectiveECGs = self:numberOfDefectiveECGs(),
        emergencyECG = self:emergencyECG(),
        normalECG = self:normalECG(),
    }
end

--[[
 * Convert hex value to binary value
 *
 * @param string hex - Hex value
 * @return string
]]
function DALI_Siemens:_hex2Bin(hex)
    local hexBinMap = {
        ['0'] = '0000',
        ['1'] = '0001',
        ['2'] = '0010',
        ['3'] = '0011',
        ['4'] = '0100',
        ['5'] = '0101',
        ['6'] = '0110',
        ['7'] = '0111',
        ['8'] = '1000',
        ['9'] = '1001',
        ['A'] = '1010',
        ['B'] = '1011',
        ['C'] = '1100',
        ['D'] = '1101',
        ['E'] = '1110',
        ['F'] = '1111',
    }

    local bin = ""

    local len = string.len(hex)
    for i = 1, len do
        bin = bin .. hexBinMap[string.upper(string.sub(hex, i, i))]
    end

    return bin
end

--[[
 * Convert binary value to decimal value
 *
 * @param string bin - Binary value
 * @return integer
]]
function DALI_Siemens:_bin2Dec(bin)

    local sum = 0
    local len = string.len(bin)
    local ex = len - 1

    for i = 1, len do
        b = string.sub(bin, i, i)
        if b == "1" then
            sum = sum + 2^ex
        end
        ex = ex - 1
    end

    return tonumber(sum)
end
