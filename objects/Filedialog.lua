--[[
    [Object] Filedialog
    @version 1.0, 2015-02-25
    @author TheOddByte
--]]



local Filedialog = {}
Filedialog.__index = Filedialog



Filedialog.new = function( x, y, width, height, title, path )
end



function Filedialog:draw()
end


--[[
    This should return a table
    local result = Filedialog:handle( os.pullEvent() )
    if result and result.ok then
        print( "Path: " .. result.file.path )
        print( "Name: " .. result.file.name )
        print( "Size: " .. result.file.size )
        print( "Code: " .. result.file.content )
    end
--]]
function Filedialog:handle( ... )
end



--[[
    Example usage
    local w, h = term.getSize()
    local filedialog = Filedialog.new( 1, 1, w, h, "Find some file", "/" )
    while true do
        filedialog:draw()
        local result = filedialog:handle( os.pullEvent() )
        if result then
            if result.ok then
                -- Do something
            elseif result.cancel then
                -- Do something
            end
        end
    end
--]]

return Filedialog
