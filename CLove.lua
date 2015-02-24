--[[
    [Framework] CLove
    @version 1.0, 2015-02-22
    @author TheOddByte
    
    Todo:
        CLove.Network
        CLove.Buffer
        CLove.Colors
        CLove.Object
        CLove.Audio
--]]



--# It's important that some libraries are loaded before others
local libraries = {
    "Cryptography";
    "Filesystem";
    "Colors";
    "Graphics";
    "Event";
}

function load( self, path )
    for _, name in ipairs( libraries ) do
        assert( fs.exists( fs.combine( path, name ) ), "Missing library: " .. name, 2 )
        self[name] = assert( dofile( fs.combine( path, name ) ), "Failed to load library: " .. name, 2 )
    end
end
