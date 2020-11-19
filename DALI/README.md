## DALI Diagnostics - Siemens Gateway
Tested on `Siemens KNX/DALI Gateway Twin plus N 141/21`

<hr>

Information retrieved with this class:
* Number of ECGs in group
* Number of inverters in group
* Whether any inverters are defective
* Number of defective lamps
* Number of defective ECGs
* Whether any emergency lamps are defective
* Whether any normal lamps are defective
* Whether any emergency ECGs are defective
* Whether any normal ECGs are defective

#### Installation of user script
1. Add new user script in LogicMachine. Name it `dali_siemens`
2. Copy & paste contents of `user.dali_siemens.lua` into the new user script
3. Save user script

#### Usage in event-based scripts
1. Create new event-based script and select the `group address` or `tag` that carries the diagnostic telegram
2. Copy & paste contents of `usage.dali_siemens.lua` into the new event-based script as a basis or create your own using the methods below

#### Usage in scheduled scripts
1. Same as with `event-based` scripts, except:
2. Replace `local value = event.datahex` with `local value = grp.find('1/1/1').datahex`

#### Methods 
 
```lua
require 'user.dali_siemens'

DALI = DALI_Siemens:new('81000015')

-- Return values with this example

-- ECG = 21
log(DALI:numberOfECGs())
-- Inverters = 0
log(DALI:numberOfInverters())
-- Defective inverter = false
log(DALI:defectiveInverter())
-- Defective lamps = 1
log(DALI:numberOfDefectiveLamps())
-- Defective ECGs = 0
log(DALI:numberOfDefectiveECGs())
-- Defective emergency lamp = false
log(DALI:emergencyLamp())
-- Defective normal lamp = false
log(DALI:normalLamp())
-- Defective emergency ECG = false
log(DALI:emergencyECG())
-- Defective normal ECG = true
log(DALI:normalECG())
```
