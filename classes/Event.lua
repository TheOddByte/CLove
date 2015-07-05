--[[
    [Class] Event
    @version 1.1, 2015-07-05
    @author TheOddByte
--]]



local Event = {
    events   = {};
    keys     = {
        isRepeat = true;
    }
}


for k, v in pairs( keys ) do
    Event.keys[k] = false
end




---------------------------------------------
-------------[ Local Functions ]-------------
---------------------------------------------
-- Ignore these functions, as they're only --
-- used for other functions and I don't    --
-- believe you need them                   --
---------------------------------------------
local function isReleased( self, event )
    for k, v in pairs( self.events[event]["keys"] ) do
        if v == true then
            return false
        end
    end
    return true
end 

local function isValid( self, event )
    for k, v in pairs( self.events[event]["keys"] ) do
        if v == false then
            return false
        end
    end
    return true
end




--[[
    Registers a custom event that will be pulled
    when certain keys are down, you can change it
    so that it repeats the event until the keys
    are released
    
    @param self,  table,  "Self-explainatory"
    @param name,  string, "The event name"
    @param _keys, table,  "The keys that needs to be pressed"
    @param ...,   ...,    "The parameters that will be returned"
    @return       nil
--]]
function Event.register( self, name, _keys, ... )

    assert( type( self ) == "table", "table expected, got " .. type( self ), 2 )
    assert( type( name ) == "string", "string expected, got " .. type( name ), 2 )
    assert( type( _keys ) == "table", "table expected, got " .. type( _keys ), 2 )
    
    self.events[name] = {
        ["keys"]   = {};
        enabled    = false;
        parameters = {...};
        isRepeat   = isRepeat or false;
    }
    
    for i, v in ipairs( _keys ) do
        if type( v ) == "string" then
            if #v == 1 then
                v = v:lower()
                for _name, value in pairs( keys ) do
                    if v == _name then
                        self.events[name]["keys"][_name] = false;
                        break
                    end
                end
            end
            
        elseif type( v ) == "number" then
            for key, value in pairs( keys ) do
                if v == value then
                    self.events[name]["keys"][keys.getName( v )] = false;
                    break
                end
            end
        end
    end
end




--[[
    Handles custom events and repeating keys
    
    @param self, table, "Self-explainatory"
    @param ...,         "The parameters from the os.pullEvent call"
--]]
function Event.handle( self, ... )

    local e = {...}
    
    local key = keys.getName( e[2] )
    
    if e[1] == "key" then
        --# Handle custom events
        for k, v in pairs( self.events ) do
            if self.events[k]["keys"][key] ~= nil then
                self.events[k]["keys"][key] = true
                break
            end
        end
        
        --# Handle repeat, prevent it from being repeated all the time( if isRepeat is false )
        if not self.keys.isRepeat then
            for k, v in pairs( self.keys ) do
                for key, value in pairs( keys ) do
                    if k == key then
                        if v then
                            return nil
                        else
                            self.keys[k] = true
                        end
                    end
                end
            end
        end
    
    elseif e[1] == "key_up" then
        --# Handle custom events
        for k, v in pairs( self.events ) do
            if self.events[k]["keys"][key] ~= nil then
                self.events[k]["keys"][key] = false
                break
            end
        end
        
        --# Handle repeat
        if not self.keys.isRepeat then
            for k, v in pairs( self.keys ) do
                for key, value in pairs( keys ) do
                    if k == key then
                        self.keys[k] = false
                    end
                end
            end
        end
        
    end
    
    for k, v in pairs( self.events ) do
        if v.enabled then
            if v.isRepeat then
                if isValid( self, k ) then
                    return k, unpack( v.parameters )
                end
            else
                if not v.eventSent then
                    self.events[k].eventSent = true
                    self.events[k].enabled   = false
                    return k, unpack( v.parameters )
                end
            end
        
        else
            if not v.eventSent then
                if isValid( self, k ) then
                    self.events[k].enabled = true
                end
            
            else
                if isReleased( self, k ) then
                    self.events[k].eventSent = false
                end
            end
        end
    end
    
    return unpack( e )
end




--[[
    Sets if keys should be repeated or not
    
    @param self, table,   "Self-explainatory"
    @param bool, boolean, "Sets whether or not the keys should be repeated"
    @return      nil
--]]
function Event.setKeyRepeat( self, bool )
    assert( type( bool ) == "boolean", "boolean expected, got " .. type( bool ), 2 )
    self.keys.isRepeat   = bool
end



    
--[[
    Quits the running program
--]]
function Event.quit()
    CLove.Graphics.clear( "black" )
    error()
end




--[[
    Queues multiple events
    
    @param, ..., string(s), "The events you want to send"
    @return      nil
--]]
function Event.send( ... )
    local e = { ... }
    for i, v in ipairs( e ) do
        os.queueEvent( unpack( v ) )
    end
end




--[[
    Waits for a specific event, then sends
    the parameters to the function specified
    
    @param event, string, "The event you want to wait for"
    @param func,  string, "The function you want to call"
    @return       ...,    "Returns what the function returns"
--]]
function Event.waitFor( event, func )
    local e
    repeat
        e = { os.pullEvent() }
    until e[1] == event
    return func( unpack( e ) )
end




--[[
    Queues multiple keys to be pulled
    
    @param ..., string(s)/number(s), "The keys you want to send"
    @return     nil
--]]
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

--[[
    Queues a mouse click to be pulled
    
    @param x,      number, "The x coordinate"
    @param y,      number, "The y coordinate"
    @param button, number, "The mouse button"
--]]
function Event.sendMouseClick( x, y, button )
    os.queueEvent( "mouse_click", button, x, y )
end




--[[
    Queues a mouse scroll to be pulled
    
    @param x,      number, "The x coordinate"
    @param y,      number, "The y coordinate"
    @param button, number, "The mouse button"
--]]
function Event.sendMouseScroll( x, y, button )
    os.queueEvent( "mouse_scroll", button, x, y )
end


return Event
