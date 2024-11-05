# Alerts

Alerts class for sending alerts through various channels, using adapters that are uniform in usage.
The container class of `Alerts` exposes one specific function (`Alerts::send()`) to send alerts, but
each adapter will handle the `send` function call in a way that is unique to each alert channel.

This way, the container class `Alerts` works the same no matter what adapter is provided. It just
needs different configuration passed to it, depending on the adapter class used.

You only need to create the user script for the container class `Alerts` and the adapter you want
to use for alerts. For instance, you can start out with the `DebugAlertAdapter` and work your way up
to the actual adapter you want to use in production.

## Adapters

These adapters are currently accessible through this library:
* **Debug:** Used for debugging. Will simply log the alert
* **SMTP:** Used to send emails through SMTP server (email)
* **MessageBird:** Used to send SMS through MessageBird's API service
* **API:** Used to send alerts through any API you want

But you can create your own adapters that requires these functions to work:
* `Adapter:new(config)` - Constructs the adapter class. Takes the config required for it to work as argument
* `Adapter:send(message)` - Process of sending the alert. Takes the alert message as argument
* `Adapter:wasSent()` - A way to tell if the alert was successfully sent. Takes no argument

See an adapter already created in order to create your custom adapter. If you've created your own adapter,
and want to share it, please create a pull request and it'll be validated before added. All adapters must be
named with the `AlertAdapter` suffix.

### Usage - In scheduled script or event script
#### SMTP Adapter
```lua
require 'user.Alerts' -- Require contained class
require 'user.SmtpAlertAdapter' -- Require adapter

-- Create adapter - This adapter sends SMS through MessageBird API service
local smtpAlertAdapter = SmtpAlertAdapter:new({
    recipient = "alert@example.org", 
    originator = "Project Something",
    server = "127.0.0.1",
    username = "your-username@example.org",
    password = "your-password",
    subject = "LM Alert", -- Optional - Set to `LM Alert` as default
    port = 465, -- Optional - Set to `465` as default
    secure = "sslv23", -- Optional - Set to `sslv23` as default
})

-- Initialize the alerts class. Sets adapter through the config
local alerts = Alerts:new({adapter = smtpAlertAdapter})
-- Send alert. Returns whether the email was successfully sent
local success = alerts:send("Your message")
-- Optionally, if you want to see the ACTUAL response from SMTP server, use this function
local result = alerts:getResult()

-- Optionally, log out for debugging purposes
log({
    success = success,
    result = result,
})

```
#### MessageBird Adapter
This adapter requires the [MessageBird](https://github.com/mentisy/LogicMachine/tree/main/MessageBird) class.
```lua
require 'user.Alerts' -- Require contained class
require 'user.MessageBirdAlertAdapter' -- Require adapter

-- Create adapter - This adapter sends SMS through MessageBird API service
local messageBirdAlertAdapter = MessageBirdAlertAdapter:new({
    recipient = "4799887766", 
    originator = "LM SMS", 
    token = "some-token",
})

-- Initialize the alerts class. Sets adapter through the config
local alerts = Alerts:new({adapter = messageBirdAlertAdapter})
-- Send alert. Returns whether the SMS was successfully sent
local success = alerts:send("Your message")
-- Optionally, if you want to see the ACTUAL response from MessageBird API, use this function
local result = alerts:getResult()

-- Optionally, log out for debugging purposes
log({
    success = success,
    result = result,
})
```

#### API Adapter
```lua
require 'user.Alerts' -- Require contained class
require 'user.ApiAlertAdapter' -- Require adapter

-- Create adapter - This adapter sends SMS through MessageBird API service
local apiAlertAdapter = ApiAlertAdapter:new({
    recipient = "4799887766", 
    originator = "LM SMS", 
    token = "some-token",
})

-- Initialize the alerts class. Sets adapter through the config
local alerts = Alerts:new({adapter = apiAlertAdapter})
-- Send alert. Returns whether the API deemed alert to be successfully sent
local success = alerts:send("Your message")
-- Optionally, if you want to see the ACTUAL response from the API, use this function
local result = alerts:getResult()

-- Optionally, log out for debugging purposes
log({
    success = success,
    result = result,
})
```

#### Debug Adapter
```lua
require 'user.Alerts' -- Require contained class
require 'user.DebugAlertAdapter' -- Require adapter

-- Create adapter - This adapter just logs the message. For debugging purposes
local debugAdapter = DebugAlertAdapter:new({recipient = "Alexander", originator = "LM"})

-- Initialize the alerts class. Sets adapter through the config
local alerts = Alerts:new({adapter = debugAdapter})
-- Send alert.
alerts:send("Your message")
```

### Using DebugAdapter conditionally - Changing adapter on the fly
If you are either creating or working on an existing scheduled or event script, you
may want to avoid sending actual alerts to services/people. You can then set the adapter you
want to use in production, but then conditionally replace the adapter with the `DebugAdapter`.
This shows how you can change the adapter you wish to use on the fly.

**Example**:
```lua

local DEBUG = true -- Debug constant. Set this to true if you would like to log alerts instead of actually sending

require 'user.Alerts' -- Require contained class
require 'user.MessageBirdAlertAdapter' -- Require actual adapter
require 'user.DebugAlertAdapter' -- Require debug adapter

local RECIPIENT = "4799887766"
local ORIGINATOR = "LM SMS"

-- Create actual adapter - This adapter sends SMS through MessageBird API service
local messageBirdAlertAdapter = MessageBirdAlertAdapter:new({
    recipient = RECIPIENT, 
    originator = ORIGINATOR, 
    token = "some-token",
})
-- Create debug adapter
local debugAlertAdapter = DebugAlertAdapter:new({
    recipient = RECIPIENT,
    originator = ORIGINATOR,
})

-- Initialize the alerts class. Sets adapter through the config
local alerts = Alerts:new({adapter = messageBirdAlertAdapter})

-- If in debug mode, set adapter as debugAlertAdapter
if (DEBUG) then
    Alerts:setAdapter(debugAlertAdapter)
end

-- Send alert. Returns whether the SMS was successfully sent
local success = alerts:send("Your message")
-- Optionally, if you want to see the ACTUAL response from MessageBird API, use this function
local result = alerts:getResult()

-- Optionally, log out for debugging purposes
log({
    success = success,
    result = result,
})
```
