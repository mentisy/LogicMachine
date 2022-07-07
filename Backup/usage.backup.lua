require 'user.backup'
require 'user.dropbox'


local project = "PROJECT_NAME" -- Project name
local token = "DROPBOX_APP_TOKEN" -- Dropbox App token

local ftpConfig = {
    user = 'ftp_user',
    password = 'ftp_password',
    ip = '127.0.0.1',
}

-- Base map is prepended to path automatically based on the Dropbox App used
local destPath = "/" .. project .. "/"

Backup:construct(project)

if(Backup:generate()) then

    -- Get path to the saved backup file
    local sourcePath = Backup:getPath();
    -- Get filename for the saved backup file
    local filename = Backup:getFilename()

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
