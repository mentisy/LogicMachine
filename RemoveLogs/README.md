# Remove Logs
Script library that provides convenience methods for deleting log, alert and error records from specified scripts.

Could prove valuable when you want to declutter the log from noisy scripts while keeping other records.

### Usage
```lua
require 'user.remove_logs'

-- Remove all types of log (log, error, alert) records from many scripts.
LogRemover:removeAllScriptLogTypes({"Script #1", "Script #2"})

-- Delete log records (excluding error and alert) from many scripts.
LogRemover:deleteManyScriptLogs({"Script #1", "Script #2"})

-- Delete error records from many scripts.
LogRemover:deleteManyScriptErrors({"Script #1", "Script #2"})

-- Delete alert records from many scripts.
LogRemover:deleteManyScriptAlerts({"Script #1", "Script #2"})

-- Delete log records (excluding error and alert) from a single script.
LogRemover:deleteScriptLogs("Script #1")

-- Delete error records from a single script.
LogRemover:deleteScriptErrors("Script #1")

-- Delete alert records from a single script.
LogRemover:deleteScriptAlerts("Script #1")

-- Delete log records (excluding error and alert) that contain a specific phrase or word
LogRemover:deleteLogsWithPhrases({"Some log message", "Delete log that contain this"})

-- Delete error records that contain a specific phrase or word
-- You can pass just one phrase by putting it inside a table
LogRemover:deleteErrorsWithPhrases({"trigger"})

-- Delete alert records that contain a specific phrase or word
LogRemover:deleteAlertsWithPhrases({"content"})
```

### Installation
1. Copy contents from [user.remove_logs.lua](RemoveLogs/user.remove_logs.lua)
2. Add new library in user libraries in the scripting section of LogicMachine
3. Name that library `user.remove_logs`. You might add the description taken from the top of this page if you want.
4. Open the newly created library file and paste the contents
5. Save and close
6. Go to `Usage` above for how to use it.
