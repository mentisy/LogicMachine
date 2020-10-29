--[[
 * Author: Alexander Volle <alexander.volle@caverion.com>
 * Created: 2019.11.23
 * 
 * Script to send date and time to the respective group addresses.
 * Helps keep displays and gateways updated with the correct time.
 *
]]

-----------------------------
------- Configuration -------
-----------------------------

local DATE = 'DATE' -- Tag for date group address
local TIME = 'TIME' -- Tag for time group address

-----------------------------
----- End Configuration -----
-----------------------------

-- get current data as table
now = os.date('*t')
 
-- system week day starts from sunday, convert it to knx format
wday = now.wday == 1 and 7 or now.wday - 1
 
-- time table
time = {
    day = wday,
    hour = now.hour,
    minute = now.min,
    second = now.sec,
}
 
-- date table
date = {
    day = now.day,
    month = now.month,
    year = now.year,
}
 
-- write to bus
local dateAddress = grp.tag(DATE)
local timeAddress = grp.tag(TIME)

dateAddress:write(date, dt.date)
timeAddress:write(time, dt.time)
