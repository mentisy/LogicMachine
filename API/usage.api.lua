require 'user.api'

local data = {
    address = "1/1/1",
    value = true,
}

API:construct("https://LINK-TO-API-BASEURL.com")
local res, code, response_header = API:post('update.php', data)

if(code == 200) then
    log("API request successful")
else
    log("API request not successful")
end
