--[[
 * Author: Alexander Volle <knx@avolle.com>
 * Created: 2019.11.23
 * 
 * Dropbox API interface
 *
 * Facilitates uploading files to a Dropbox folder
 *
]]

require 'ssl.https'
require 'socket.ftp'
require 'json'

ssl.https.timeout = 15

Dropbox = {}

-- Create the Dropbox class
function Dropbox:new()
    local newObj = {}
    self.__index = self
    return setmetatable(newObj, self)
end

--[[
 * Constructor method
 *
 * @var object config
 * - Config properties
 * - - token: Dropbox Backup App token
 * - - sourcePath: Path to file to upload
 * - - destPath: Path to store uploaded file
 * - - filename: What name to give uploaded file. Include extension
 * - - ftpConfig: FTP credentials for fetching file
 * - - - ip: FTP IP
 * - - - username: FTP username
 * - - - password: FTP password
*
]]
function Dropbox:construct(config)

    self.headers = {}
    self.uploadUrl = 'https://content.dropboxapi.com/2/files/upload'
    self.config = {
        token = '',
        sourcePath = '',
        destPath = '/Apper/Logic Machine Backup/',
        filename = 'LogicMachine-backup.tar.gz',
        ftpConfig = {
            ip = "192.168.1.122",
            username = "user",
            password = "password",
        },
    }
    self.args = {
        path = nil,
        mode = "add",
        mute = false,
        autorename = true,
        strict_conflict = false,
    }
    self:mergeConfig(config)
end

--[[
 * Get config value from config key
 *
 * @var string key Config key to retrieve
 * @return mixed default Value to use if config key is not found/set
]]
function Dropbox:getConfig(key, default)
   
    if(self.config[key] == nil) then
        return default
    end
    
    return self.config[key]
end

--[[
 * Set config key
 *
 * @var string key Config key to set
 * @var mixed value Value to set provided key
]]
function Dropbox:setConfig(key, value)
   
    self.config[key] = value
end

--[[
 * Upload file method. Uploads file to Dropbox
]]
function Dropbox:uploadFile()
    
    local file = self:getFile()
    
    self:buildArgs()
    self:buildHeaders(file)
    
    local responseBody = {}
    
    local res, code, response_headers, status = ssl.https.request {
        
        url = self.uploadUrl,
        method = "POST",
        headers = self.headers,
        source = ltn12.source.string(file),
        sink = ltn12.sink.table(responseBody),
    }
    
    self.response = responseBody
    
    if(code == 200) then
        return true
    else
        return false
    end
end

--[[
 * Get file from FTP
]]
function Dropbox:getFile()
    
    local user = self:getConfig('ftpConfig')['user']
    local password = self:getConfig('ftpConfig')['password']
    local ip = self:getConfig('ftpConfig')['ip']
    local filename = self:getConfig("filename")
    
    -- ftp://user:password@ip/filename - ftp://user:password@192.168.2.121/backup.tar.gz
    local ftpFile = string.format("ftp://%s:%s@%s/%s", user, password, ip, filename)
    
    local file = socket.ftp.get(ftpFile)
    
    return file
end

--[[
 * Builds necessary arguments to provide Dropbox API request
]]
function Dropbox:buildArgs()
    
    local path = self:getConfig('destPath')
    local filename = self:getConfig('filename')
    
    self.args["path"] = path .. filename
end

--[[
 * Builds necessary headers to provide Dropbox API request
]]
function Dropbox:buildHeaders(file)
   
    self.headers = {
        ["Authorization"] = "Bearer " .. self:getConfig('token'),
    	["Content-Type"] = 'text/plain; charset=dropbox-cors-hack',
    	["Content-Length"] = string.len(file),
        ['Dropbox-API-Arg'] = json.encode(self.args),
    }
end

--[[
 * Get response from Dropbox API after attempting to upload file
]]
function Dropbox:getResponse()
   
    if(type(self.response) == 'table' and type(self.response[1]) ~= nil) then
        
        return json.decode(self.response[1])
    end
    
    return {}
end

--[[
 * Merge default config with user provided config.
 *
 * @param table config - User provided config
]]
function Dropbox:mergeConfig(config)
    
    for k, v in pairs(self.config) do
        if(config[k] == nil) then
            config[k] = v
        end
	end
    self.config = config
end
