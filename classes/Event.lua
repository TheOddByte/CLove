--[[
    [API] Event
    @version 1.0, 2015-07-04
    @author TheOddByte
--]]


local Event = {
    events = {}
}




function Event.register( self, name, ... )

    self.events[name] = {
        ["key"]  = {};
        ["char"] = {};
        enabled  = false;
        isRepeat = isRepeat or false;
    }
    
    local e = {...}
    for i, v in ipairs( e ) do
        if type( v ) == "string" then
            if #v == 1 then
                self.events[name]["char"][v] = false;
            end
            
        elseif type( v ) == "number" then
            for key, value in pairs( keys ) do
                if v == value then
                    self.events[name]["key"][tostring( v )] = false;
                    break
                end
            end
        end
    end
    
end





local function isReleased( self, event )
    for e, keys in pairs( self.events[event] ) do
        for k, v in pairs( keys ) do
            if v == true then
                return false
            end
        end
    end
    return false
end 

local function isValid( self, event )
    for e, keys in pairs( self.events[event] ) do
        for k, v in pairs( keys ) do
            if v == false then
                return false
            end
        end
    end
    return true
end


function Event.handle( self, ... )

    local e, key = {...}
    if e[1] == "key" or e[1] == "char" or e[1] == "key_up" then
        key = tostring( e[2] )
    end
    
    if e[1] == "key" or e[1] == "char" then
        for k, v in pairs( self.events ) do
            if self.events[k][e[1]][key] ~= nil then
                self.events[k][e[1]][key] = true
            end
        end
    
    elseif e[1] == "key_up" then
        for k, v in pairs( self.events ) do
            if v[e[1]][key] ~= nil then
                self.events[k][e[1]][key] = false
            end
        end
    end
    
    
    for k, v in ipairs( self.events ) do
        if v.enabled then
            os.queueEvent( k )
        else
            if isValid( k ) then
                self.events[k].enabled = v.isRepeat
            else
                self.events[k].enabled = false;
            end
        end
    end
    
end
    

function Event.quit()
    CLove.Graphics.clear( "black" )
    error()
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
