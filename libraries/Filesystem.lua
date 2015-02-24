--[[
    [API] Filesystem
    @version 1.0, 2015-02-22
    @author TheOddByte
    
    Special thanks to TheOriginalBIT for the Filesystem.list function, and the other ones that it uses
--]]



local Filesystem = {}


assert( CLove ~= nil, "Framework not initialized" )
assert( CLove.Cryptography, "Cryptography needs to be loaded" )


local function str_contains( str, seq ) 
  return (str:find( seq, 1 )) ~= nil
end

local function contains( ignore, line )
    if type( ignore ) == "table" then
        for _, v in pairs( ignore ) do
            if line == v or str_contains( line, v ) then
                return true
            end
        end
        return false
    end
    return str_contains( line, ignore )
end

local function yieldFileSystem(startPath, ignorePaths, debug)
  local fsList = fs.list(startPath)
  for _, file in ipairs(fsList) do
    local path = fs.combine(startPath, file)
    if not contains(ignorePaths, path) then
      if fs.isDir(path) then
        yieldFileSystem(path, ignorePaths, debug)
      else
        coroutine.yield(path, file)
      end
    elseif debug then
      print( "Ignoring: "..path )
    end
  end
end

Filesystem.list = function( path, ignore, debug )
    path = path or "/"
    ignore = ignore or {}
    debug = debug == true
    return coroutine.wrap(function()
        yieldFileSystem( path, ignore, debug )
    end)
end



Filesystem.compile = function( sPath, nPath )
    -- just a placeholder for now
end



Filesystem.compress = function( path )
    -- also a placeholder for now
end



Filesystem.append = function( path, data )
    assert( fs.exists( path ), "File does not exist", 2 )
    assert( not fs.isDir( path ), "Cannot open a directory", 2 )
    local file = assert( fs.open( path, "w" ), "Cannot open file for writing", 2 )
    file.writeLine( data )
    file.close()
end



Filesystem.write = function( path, data )
    assert( not fs.isDir( path ), "Cannot open a directory", 2 )
    local file = assert( fs.open( path, "w" ), "Cannot open file for writing", 2 )
    file.write( data )
    file.close()
end



Filesystem.writeLine = function( path, data )
    assert( not fs.isDir( path ), "Cannot open a directory", 2 )
    local file = assert( fs.open( path, "w" ), "Cannot open file for writing", 2 )
    file.writeLine( data )
    file.close()
end



Filesystem.read = function( path )
    assert( fs.exists( path ), "File does not exist", 2 )
    assert( not fs.isDir( path ), "Cannot open a directory", 2 )
    local file = assert( fs.open( path, "r" ), "Cannot open file for reading", 2 )
    local data = file.readAll()
    file.close()
    return data
end



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



Filesystem.save = function( path, data )
    assert( not fs.isDir( path ), "Cannot open a directory", 2 )
    assert( type( data ) == "table", "table expected, got " .. type( data ), 2 )
    local file = assert( fs.open( path, "w" ), "Cannot open file for writing", 2 )
    file.writeLine( textutils.serialize( data ) )
    file.close()
end



Filesystem.load = function( path )
    assert( fs.exists( path ), "File does not exist", 2 )
    assert( not fs.isDir( path ), "Cannot open a directory", 2 )
    local file = assert( fs.open( path, "r" ), "Cannot open file for reading", 2 )
    local data = textutils.unserialize( file.readAll() )
    file.close()
    return data
end



Filesystem.pack = function( sPath, nPath )
    assert( fs.exists( sPath ), "Folder does not exist", 2 )
    assert( fs.isDir( sPath ), "Folder expected, got a file", 2 )
    assert( not fs.exists( nPath ), "File exists", 2 )
    local pack = {}
    for path, name in Filesystem.list( sPath ) do
        pack[path:gsub( sPath, "" )] = CLove.Cryptography.Base64.encode( Filesystem.read( path ) )
    end
    Filesystem.save( nPath, pack )
end



Filesystem.unpack = function( sPath, nPath )
    assert( fs.exists( sPath ), "File does not exist", 2 )

    local pack = Filesystem.load( sPath )
    if not fs.exists( nPath ) then
        fs.makeDir( nPath )
    end
    
    for path, data in pairs( pack ) do
        Filesystem.write( fs.combine( nPath, path ), CLove.Cryptography.Base64.decode( data ) )
    end
end




return Filesystem
