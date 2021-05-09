local live = "MESSAGEBIRD_LIVE_TOKEN"
local test = "MESSAGEBIRD_TEST_TOKEN" -- Not required. Only for testing

local originator = "SENDING_PHONE_NUMBER" -- Include country code prepended, but not 00 or +

local isTesting = false -- Whether in test mode or live mode

require 'user.messagebird'

local useToken = live
if isTesting == true then
    useToken = test
end

Messagebird:new(useToken, originator)

local sms = Messagebird:sendSms("RECIPIENT_PHONE_NUMBER", "Some random SMS message")

if sms.error == false then
    if(sms.response.recipients.totalDeliveryFailedCount > 0) then
        alert(string.format("SMS to %s failed with body: %s", sms.response.recipients.totalDeliveryFailedCount, sms.response.body))
    else
        local verb = "were"
        if sms.response.recipients.totalSentCount == 1 then
            verb = "was"
        end
        log(string.format("%s SMS %s sent with body: %s", sms.response.recipients.totalSentCount, verb, sms.response.body))
    end
end
