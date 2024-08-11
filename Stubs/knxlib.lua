--- KNX Library stubs for LogicMachine
--- @author Alexander Volle <knx@avolle.com>
knxlib = {}

---
--- Ping a KNX device
---@param address string
---@return boolean
function knxlib.ping(address) end
---
--- Check if a KNX device is connected
---@param address string
---@return boolean
function knxlib.isconnected(address) end

---
--- Restart a KNX device
---@param address string
---@return boolean
function knxlib.restart(address) end

---
--- Encode a group address, from an integer address into a three-level address
---@param address string
---@return string|nil
function knxlib.encodega(address) end

---
--- Decode a group address, from a three-level address into an integer address
---@param address string
---@return string|nil
function knxlib.decodega(address) end

---
--- Encode an individual address, from an integer address into a three-level address
---@param address string
---@return string|nil
function knxlib.encodeia(address) end

---
--- Decode an individual address, from a three-level address into an integer address
---@param address string
---@return string|nil
function knxlib.decodeia(address) end

---
--- Get KNX stats from LogicMachine
---@return table<iptx, repeats, iprx, tprx, tptx>
function knxlib.getstats() end

---
--- Get KNX bus voltage of a specific address
---@param address string
---@return number
function knxlib.readbusvoltage(address) end
