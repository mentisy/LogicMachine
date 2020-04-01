require 'user.dropbox'

local project = "TEST PROJECT"
local token = "DROPBOX_TOKEN"

local ftpConfig = {
    user = 'ftp',
    password = 'password',
    ip = '192.168.2.122',
}

-- Base map will be prepended by the Dropbox App
local destPath = "/" .. project .. "/"

Backup:construct(project)

if(Backup:generate()) then
    
    -- Get path to the saved backup file
    local sourcePath = '/home/ftp/SOMEFILE.txt'
    -- Get filename for the saved backup file
    local filename = 'SOMEFILE.txt'
    
    -- Initialize Dropbox class
    Dropbox:construct ({
        token = token,
        sourcePath = sourcePath,
        destPath = destPath,
        filename = filename,
        ftpConfig = ftpConfig,
    })
    
    -- Attempt to upload file to Dropbox
    if(Dropbox:uploadFile()) then
        
        local message = "Uploaded backup file. "
        local response = Dropbox:getResponse()
        
        -- Verify that the file size responded back by Dropbox is more than 0 byte (as a type of verification check)
        if(response['size'] > 0) then
            message = message .. "Verified backup file larger than 0 byte."
        end
        
        log(message)
    	Backup:remove()
    else
    	Backup:remove()
        error("Couldn't upload backup file") 
    end
end
