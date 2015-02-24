--[[
    [Library] Colors
    @version 1.0, 2015-02-23
    @author TheOddByte
--]]



local Colors = {}


Colors.isValid = function( color )
    assert( type( color ) == "number" or type( color ) == "string", "string/number expected, got " .. type( color ), 2)
    for name, value in pairs( colors ) do
        if type( color ) == "string" then
            if color == name then
                return true
            end
        else
            if color == v then
                return true
            end
        end
    end
    return false
end


Colors.getName = function( color )
    assert( type( color ) == "number", "number expected, got " .. type( color ), 2 )
    for name, value in pairs( colors ) do
        if value == color then
            return name
        end
    end
end


Colors.getValue = function( color )
    assert( type( color ) == "string", "string expected, got " .. type( color ), 2 )
    if Colors.isValid( color )
        return colors[color]
    else
        error( "invalid color", 2 )
    end
end



return Colors
