local value = event.getvalue()
local address = event.dst

local message = ""

if value == true then
    message = "Fancoil " .. address .. " gikk INN i alarm.\nDato/Tid: " .. os.date()
else
    message = "Fancoil " .. address .. " gikk UT av alarm.\nDato/Tid: " .. os.date()
end

local username = 'GMAIL_USERNAME'
local password = 'GMAIL_PASSWORD'

require("user.alert")

Alert:construct(username, password)

Alert:setSubject("Alert Fancoil")
Alert:setMessage(message)

Alert:send("RECIPIENT@receive.com")
