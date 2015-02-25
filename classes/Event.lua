--[[
    [API] Event
    @version 1.0, 2015-02-22
    @author TheOddByte
--]]


local Event = {}




function Event.quit()
    error( "", 0 )
    CLove.Graphics.clear( "black" )
end



function Event.send( ... )
    local e = { ... }
    for i, v in ipairs( e ) do
        os.queueEvent( unpack( v ) )
    end
end


function Event.waitFor( event, func )
    local e
    repeat
        e = { os.pullEvent() }
    until e[1] == event
    return func( unpack( e ) )
end


function Event.sendKeys( ... )
    local e = { ... }
    for i, v in ipairs( e ) do
        if type( v ) ~= "number" and type( v ) ~= "string" then
            return false, "expected number/string, got " .. type( v )
        end
        os.queueEvent( type( v ) == "number" and "key" or "char", v )
    end
    return true
end


function Event.sendMouseClick( x, y, button )
    os.queueEvent( "mouse_click", button, x, y )
end


function Event.sendMouseScroll( x, y, button )
    os.queueEvent( "mouse_scroll", button, x, y )
end


return Event
