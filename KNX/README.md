# KNX Address Parser and Creator

## Usage

### Parse 1/2/3 into address parts
Use return value for retrieving parts
```lua
require 'user.knx_address'

local KnxAddress = Knx_Address:new()
local parts = KnxAddress:parse("1/2/3")
log(parts)
--[[ Logs
    {
        main = 1,
        middle = 2,
        sub = 3
    }
]]
```
or use get methods for retrieving parts
```lua
require 'user.knx_address'

local KnxAddress = Knx_Address:new()
KnxAddress:parse("1/2/3")
log(KnxAddress:getMainAddress()) -- Logs 1
log(KnxAddress:getMiddleAddress()) -- Logs 2
log(KnxAddress:getSubAddress()) -- Logs 3
```

### Create an address based on parts
```lua
require 'user.knx_address'

local KnxAddress = Knx_Address:new()
local address = KnxAddress:create(1, 2, 3)
log(address) -- Logs "1/2/3"
```
