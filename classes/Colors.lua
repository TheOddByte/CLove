--[[
    [Library] Colors
    @version 1.0, 2015-02-23
    @author TheOddByte
--]]



local Colors = {}



--[[
    Checks if the number/string is a valid color
    
    @param color, string/number, "The color you want to check"
    @return       boolean,       "Returns true if valid, false if not"
--]]
Colors.isValid = function( color )
    assert( type( color ) == "number" or type( color ) == "string", "string/number expected, got " .. type( color ), 2)
    for name, value in pairs( colors ) do
        if type( color ) == "string" then
            if color == name then
                return true
            end
        else
            if color == value then
                return true
            end
        end
    end
    return false
end


--[[
    Gets the name of a color, should only be supplied with a number
    
    @param color, number, "The color you want to get the name of"
    @return       string, "Returns the name of the color"
--]]
Colors.getName = function( color )
    assert( type( color ) == "number", "number expected, got " .. type( color ), 2 )
    if Colors.isValid( color ) then
        for name, value in pairs( colors ) do
            if value == color then
                return name
            end
        end
    else
        error( "Invalid color value", 2 )
    end
end


--[[
    Gets the value of a color
    
    @param color, string, "The color name"
    @return       number, "The value of the color"
--]]
Colors.getValue = function( color )
    assert( type( color ) == "string", "string expected, got " .. type( color ), 2 )
    if Colors.isValid( color )
        return colors[color]
    else
        error( "invalid color", 2 )
    end
end



return Colors
