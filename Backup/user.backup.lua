--[[
 * Author: Alexander Volle <knx@avolle.com>
 * Created: 2019.11.23
 * 
 * Backup class for generating and preparing a complete Logic Machine backup file
 * compressed in a tar zip file
 *
]]


Backup = {}

-- Create the Backup class
function Backup:new()
    local newObj = {}
    self.__index = self
    return setmetatable(newObj, self)
end

--[[
 * Constructor method
 * 
 * @var string project Set project name so it can be inserted into the filename
]]
function Backup:construct(project)
    self.project = project
end

--[[
 * Generate method
 *
 * Create and compress a backup file and store it in the ftp folder
 *
 * @return bool True if file is created and False if not created
]]
function Backup:generate()
    
    -- Generate filename
    local filename = self:_generateName()
    
    -- Specify path to save backup file
    local path = '/home/ftp/' .. filename
    
    -- Execute internal backup script and package it to the save path
    os.execute('sh /lib/genohm-scada/web/general/backup.sh')
	os.execute('cd /lib/genohm-scada/storage && tar -c -z -f "' .. path .. '" ./')
    
    if(io.exists(path) == false) then
        return false
    end
    
    self._filename = filename
    self._path = path
    return true
end

--[[
 * Generate Name method
 *
 * Created a filename based on the project property and datetime
 *
 * @return string Generated filename
]]
function Backup:_generateName()
    
    -- name = LogicMachine-PROJECT-2019-11-22_15-30.tar.gz
    local name = "LogicMachine-%s%s.tar.gz"

    local project = ""
    
    if(type(self.project) == 'string' and string.len(self.project) > 0) then
        project = self.project .. "-"
    end
    
    return string.format(name, project, os.date('%Y-%m-%d_%H-%M'))
    
end

--[[
 * Get Path method
 *
 * Returns the path where the backup file is stored
 *
 * @return string path
]]
function Backup:getPath()
   
    return self._path
end

--[[
 * Get Filename method
 *
 * Returns the generated filename
 *
 * @return string filename
]]
function Backup:getFilename()
   
    return self._filename
end

--[[
 * Remove method
 *
 * Removes the generated backup file
 *
 * @return bool True if file no longer exists (has been deleted). False if opposite
]]
function Backup:remove()
   
    os.remove(self._path)
    if(io.exists(self._path)) then
        return false
    end
    
    return true
end
