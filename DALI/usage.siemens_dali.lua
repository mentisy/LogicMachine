require 'user.dali_siemens'

-- Ideally you'd get this value from an event, but below are some example diagnostic values
local value = event.datahex

--local value = "81000015" -- This value has 21 ECGS, but 1 normal ECG is defective
--local value = "0000002B" -- This value has 43 ECGS, and neither lamp nor ECG is defective
--local value = "00000001" -- This value has 1 ECG, and neither lamp nor ECG is defective

DALI = DALI_Siemens:new(value)

-- Get total ECGs
local totalECGs = DALI:numberOfECGs()
-- Get total amount of defective lamps
local defectiveLamps = DALI:numberOfDefectiveLamps()
-- Get total amount of defective ECGs
local defectiveECGs = DALI:numberOfDefectiveECGs()

local error = false

log("There are " .. totalECGs .. " ECGs in this group")

if (defectiveLamps > 0) then
    error = true
    log("Oh no, " .. defectiveLamps .. " lamps are defective.")
end
if(defectiveECGs > 0) then
    error = true
    log("Oh no, " .. defectiveECGs .. " ECGs are defective.")
end

if (not error) then
    log("All is well")
end