--[[
 * Author: Alexander Volle <knx@avolle.com>
 * Created: 2023.07.22
 * Updated: Never
 * 
 * Log remover class for removing logs, errors and alerts from the LogicMachine database.
 * Enables you to remove the clutter from these log types without removing important information.
 *
 * There's methods for removing all types of logs (log, alert, error) from specific script names,
 * or specific types from specific script names.
 * There's also methods for removing log (including alert and error) that contains
 * specific words or phrases.
]]

-- Init object
LogRemover = {}

--[[
 * Remove all log records, including errors and alerts that were made from specific scripts.
 * 
 * @param table scriptNames - A table of scripts to remove logs, errors and alerts for
 * @return int - Number of affected rows (deleted logs, errors and alerts)
]]
function LogRemover:removeAllScriptLogTypes(scriptNames)
    local isTable = type(scriptNames) == 'table'
    assert(isTable, 'Parameter `scriptNames` must be table')
    local affected = 0
    for _, script in ipairs(scriptNames) do
        affected = affected + self:deleteScriptLogs(script)
        affected = affected + self:deleteScriptErrors(script)
        affected = affected + self:deleteScriptAlerts(script)
    end
    
    return affected
end

--[[
 * Remove only log records that were made from specific scripts.
 * 
 * @param table scriptNames - A table of scripts to remove logs for
 * @return int - Number of affected rows (deleted logs)
]]
function LogRemover:deleteManyScriptLogs(scriptNames)
    local isTable = type(scriptNames) == 'table'
    assert(isTable, 'Parameter `scriptNames` must be table')
    local affected = 0
    for _, script in ipairs(scriptNames) do
        affected = affected + self:deleteScriptLogs(script)
    end
    
    return affected
end

--[[
 * Remove only error records that were made from specific scripts.
 * 
 * @param table scriptNames - A table of scripts to remove errors for
 * @return int - Number of affected rows (deleted errors)
]]
function LogRemover:deleteManyScriptErrors(scriptNames)
    local isTable = type(scriptNames) == 'table'
    assert(isTable, 'Parameter `scriptNames` must be table')
    local affected = 0
    for _, script in ipairs(scriptNames) do
        affected = affected + self:deleteScriptErrors(script)
    end
    
    return affected
end

--[[
 * Remove only alert records that were made from specific scripts.
 * 
 * @param table scriptNames - A table of scripts to remove alerts for
 * @return int - Number of affected rows (deleted alerts)
]]
function LogRemover:deleteManyScriptAlerts(scriptNames)
    local isTable = type(scriptNames) == 'table'
    assert(isTable, 'Parameter `scriptNames` must be table')
    local affected = 0
    for _, script in ipairs(scriptNames) do
        affected = affected + self:deleteScriptAlerts(script)
    end
    
    return affected
end

--[[
 * Remove only log records that were made from a specific script.
 * 
 * @param string scriptName - String of script to remove logs for
 * @return int - Number of affected rows (deleted logs)
]]
function LogRemover:deleteScriptLogs(scriptName)
    return self:_deleteScriptLog('logs', scriptName)
end

--[[
 * Remove only error records that were made from a specific script.
 * 
 * @param string scriptName - String of script to remove errors for
 * @return int - Number of affected rows (deleted errors)
]]
function LogRemover:deleteScriptErrors(scriptName)
    return self:_deleteScriptLog('errors', scriptName)
end

--[[
 * Remove only alert records that were made from a specific script.
 * 
 * @param string scriptName - String of script to remove alerts for
 * @return int - Number of affected rows (deleted alerts)
]]
function LogRemover:deleteScriptAlerts(scriptName)
    return self:_deleteScriptLog('alerts', scriptName)
end

--[[
 * INTERNAL FUNCTION: Remove certain logtype with certain script name
 * 
 * @param string logType - Either log, alert or errors
 * @param string scriptName - String of script to remove log type for
 * @return int - Number of affected rows (deleted log types)
]]
function LogRemover:_deleteScriptLog(logType, scriptName)
    assert(
        logType == 'logs' or logType == 'alerts' or logType == 'errors', 
        'Log type must be one of these: logs, alerts, errors'
    )
    assert(type(scriptName) == 'string', 'Parameter `scriptName` must be string')
    
    return db:query("DELETE FROM ? WHERE scriptname = ?", logType, scriptName)
end
