--[[
    [API] Filesystem
    @version 1.0, 2015-06-20
    @author TheOddByte
--]]



local Filesystem = {}


assert( CLove ~= nil, "Framework not initialized" )
assert( CLove.Cryptography, "Cryptography needs to be loaded" )




--[[
    Gets all the files and sub-files from the supplied path,
    it defaults to root if a path hasn't been supplied.
    
    @param sPath,       string, "The path you want to list"
    @param ignorePaths, table,  "The paths you want to ignore"
    @return             table,  "It returns all the files found"
--]]
Filesystem.list = function( sPath, ignorePaths )
    sPath       = sPath or "/"
    ignorePaths = ignorePaths or {}

    local function isValid( path )
        for i, v in ipairs( ignorePaths ) do
            if path == v then
                return false
            end
        end
        return true
    end

    sPath = sPath or "/"
    local files = {}
    for _, name in ipairs( fs.list( sPath ) ) do
        local path = fs.combine( sPath, name )
        if isValid( path ) then
            if fs.isDir( path ) then
                local f = Filesystem.list( path, ignorePaths )
                for k, v in pairs( f ) do
                    files[k] = v
                end
            else
                files[path] = name
            end
        end
    end
    return files
end




--[[
    Compiles a folder into one single-executable file
    Note: For this to work the folder need a file
    called main in the root of it.
    
    @param sPath, string,  "The source-path"
    @param nPath, string,  "The output path"
    @return       boolean, "Returns whether or not it was successful"
--]]
Filesystem.compile = function( sPath, nPath )
end




--[[
    Gets the size of a file or a folder
    
    @param sPath, string, "The file or folder you want to get the size of"
    @return       number, "Returns the full size of a folder/file"
--]]
Filesystem.getSize = function( sPath )
    assert( type( sPath ) == "string", "string expected, got " .. type( sPath ), 2 )
    local size = 0
    if fs.isDir( sPath ) then
        for path, name in Filesystem.list( path ) do
            size = size + fs.getSize( path )
        end
    else
        return fs.getSize( path )
    end
end


--[[
    Appends data to a file
    
    @param path, string, "The file you want to append to"
    @param data, string, "The data you want to append to the file"
    @return      nil
--]]
Filesystem.append = function( path, data )
    assert( type( path ) == "string", "string expected, got " .. type( path ), 2 )
    assert( fs.exists( path ), "File does not exist", 2 )
    assert( not fs.isDir( path ), "Cannot open a directory", 2 )
    local file = assert( fs.open( path, "w" ), "Cannot open file for writing", 2 )
    file.writeLine( data )
    file.close()
end




--[[
    Writes data to a file
    
    @param path, string, "The file you want to write to"
    @param data, string, "The data you want to write to the file"
    @return      nil
--]]
Filesystem.write = function( path, data )
    assert( type( path ) == "string", "string expected, got " .. type( path ), 2 )
    assert( not fs.isDir( path ), "Cannot open a directory", 2 )
    local file = assert( fs.open( path, "w" ), "Cannot open file for writing", 2 )
    file.write( data )
    file.close()
end




--[[
    Same as Filesystem.write except it adds a new line
    
    @param path, string, "The file you want to write to"
    @param data, string, "The data you want to write to the file"
    @return      nil
--]]
Filesystem.writeLine = function( path, data )
    assert( type( path ) == "string", "string expected, got " .. type( path ), 2 )
    assert( not fs.isDir( path ), "Cannot open a directory", 2 )
    local file = assert( fs.open( path, "w" ), "Cannot open file for writing", 2 )
    file.writeLine( data )
    file.close()
end




--[[
    Gets the whole content of a file
    
    @param path, string, "The path of the file"
    @return      string
--]]
Filesystem.read = function( path )
    assert( fs.exists( path ), "File does not exist", 2 )
    assert( not fs.isDir( path ), "Cannot open a directory", 2 )
    local file = assert( fs.open( path, "r" ), "Cannot open file for reading", 2 )
    local data = file.readAll()
    file.close()
    return data
end




--[[
    Gets the whole cont of a file, but returns
    each line individually in a table.
    
    @param path, string, "The path of the file"
    @return      table
--]]
Filesystem.lines = function( path )
    assert( fs.exists( path ), "File does not exist", 2 )
    assert( not fs.isDir( path ), "Cannot open a directory", 2 )
  
    local lines = {}
    local file = assert( fs.open( path, "r" ), "Cannot open file for reading", 2 )
    for line in file.readLine do
        table.insert( lines, line )
    end
    file.close()
    return lines
end




--[[
    Saves a table to a file, can be encrypted
    with a key as well.
    
    @param path, string, "The path of the file"
    @param data, table,  "The table you want to save"
    @param key,  string, "This one is optional, if supplied it's used to encrypt the file"
    @return      nil
--]]
Filesystem.save = function( path, data, key )
    assert( not fs.isDir( path ), "Cannot open a directory", 2 )
    assert( type( data ) == "table", "table expected, got " .. type( data ), 2 )
    
    --# Check if the data should be encrypted
    if key and type( key ) == "string" then
        data = CLove.Cryptography.AES.encrypt( key, textutils.serialize( data ) )
        data = CLove.Cryptography.Base64.encode( data )
    else
        data = textutils.serialize( data )
    end
    Filesystem.writeLine( path, data )    
end




--[[
    Loads a table from a file, can be decrypted
    with a key as well.
    
    @param path, string, "The path of the file"
    @param key,  string, "This one is optional, if supplied it's used to decrypt the file"
    @return      nil
--]]
Filesystem.load = function( path, key )
    local data = Filesystem.read( path )

    if key and type( key ) == "string" then
        data = CLove.Cryptography.Base64.decode( data )
        data = CLove.Cryptography.AES.decrypt( key, data )
        data = textutils.unserialize( data )
    else
        data = textutils.unserialize( data )
    end
    return type( data ) == "table", data
end


--[[
    Packs all the files and folders into one single file
    
    @param sPath, string, "The source-path"
    @param nPath, string, "The path you want to save the pack to"
    @return       nil
--]]
Filesystem.pack = function( sPath, nPath )
    assert( fs.exists( sPath ), "Folder does not exist", 2 )
    assert( fs.isDir( sPath ), "Folder expected, got a file", 2 )
    assert( not fs.exists( nPath ), "File exists", 2 )
    local pack = {}
    for path, name in pairs( Filesystem.list( sPath ) ) do
        pack[path:gsub( sPath, "" )] = CLove.Cryptography.Base64.encode( Filesystem.read( path ) )
    end
    Filesystem.save( nPath, pack )
end


--[[
    Unpacks a pack file into the supplied path
    
    @param sPath, string, "The source path"
    @param nPath, string, "The path where you want to unpack to"
    @return       nil
--]]
Filesystem.unpack = function( sPath, nPath )
    assert( fs.exists( sPath ), "File does not exist", 2 )
    assert( not fs.isDir( sPath ), "Can not open a folder", 2 )
    
    local success, pack = Filesystem.load( sPath )
    if not success then
        error( "Failed to load table", 2 )
    end
    if not fs.exists( nPath ) then
        fs.makeDir( nPath )
    end
    
    for path, data in pairs( pack ) do
        Filesystem.write( fs.combine( nPath, path ), CLove.Cryptography.Base64.decode( data ) )
    end
end




return Filesystem
