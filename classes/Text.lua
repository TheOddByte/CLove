--[[
    [Class] Text
    @version 1.0, 2015-02-25
    @author TheOddByte
--]]



local Text = {}




Text.wrap = function( text, width )
    local lines, line = {}, ""
    for word in text:gmatch( "%S+" ) do 
        if #line + #word + 1 <= width then 
            line = line ~= "" and line .. " " .. word or word
        else
            if #line ~= "" then
                table.insert( lines, line )
                line = ""
            end
            if #word > width then
                table.insert( lines, word:sub( 1, width ) )
                local x1, x2, str = width + 1, width*2, "" 
                repeat
                    x1 = x1 > #word and #word or x1
                    x2 = x2 > #word and #word or x2
                    if x2 ~= #word then
                        table.insert( lines, word:sub( x1, x2 ) )
                        x1 = x1 + width <= #word and x1 + width or #word
                        x2 = x2 + width <= #word and x2 + width or #word
                    end
                    if x2 == #word then
                        line = line .. word:sub( x1, x2 )
                    end
                until x2 == #word
            else
                line = word
            end
        end
    end
    if #line <= width and line ~= "" then
        table.insert( lines, line )
    end
    for i = #lines, 1, -1 do
        if lines[i] == "" then
            table.remove( lines, i )
        end
    end
    return lines
end



Text.split = function( text )
    local words = {}
    for word in text:gmatch( "%S+" ) do
        table.insert( words, word )
    end
    return words
end


return Text
