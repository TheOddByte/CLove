--[[
    [Object] Textbox
    @version ---, 2015-02-24
    @author TheOddByte
--]]


local Textbox = {}



Textbox.new = function() 
    local texbox = {}
    return setmetatable( textbox, Textbox )
end



function Textbox:draw() end



function Textbox:handle( ... )
    local e = { ... }
end



return Textbox
