--[[
    [Library] Graphics
    @version 1.0, 2015-02-23
    @author TheOddByte
--]]



local Graphics = {}

local w, h = term.getSize()

assert( CLove.Text   ~= nil, "Text class not loaded", 0 )
assert( CLove.Colors ~= nil, "Colors class not loaded", 0 )


Graphics.setColor = function( color )
    assert( type( color ) == "number" or type( color ) == "string", "string/number expected, got " .. type( color ), 2 )
    assert( CLove.Colors.isValid( color ), "invalid color", 2 )
    term.setTextColor( type( color ) == "number" and color or colors[color] )
end



Graphics.setBackgroundColor = function( color )
    assert( type( color ) == "number" or type( color ) == "string", "string/number expected, got " .. type( color ), 2 )
    assert( CLove.Colors.isValid( color ), "invalid color", 2 )
    term.setBackgroundColor( type( color ) == "number" and color or colors[color] )
end



Graphics.write = function( text, x, y, limit, align, color, background )
    assert( type( tostring( text ) ) == "string", "string/number expected, got " .. type( text ), 2 )
    assert( type( x ) == "number" and type( y ) == "number", "numbers expected, got " .. type( x ) .. "," .. type( y ), 2 )
    assert( align == nil or type( limit ) == "number", "number expected, got " .. type( limit ), 2 )
    
    if color then
        Graphics.setColor( color )
    end
    if background then
        Graphics.setBackgroundColor( background )
    end
    
    text = tostring( text )
    if align then
        assert( type( align ) == "string", "string expected, got " .. type( align ), 2 )
        assert( align == "center" or align == "right" or align == "left", "Invalid alignment: " .. align, 2 )
        local width = x + limit - 1
        if #text <= width then
            if align == "center" then
                term.setCursorPos( math.ceil( (( x+limit )-#text)/2 ), y )
            elseif align == "right" then
                term.setCursorPos( (limit-#text) + 1, y )
            elseif align == "left" then
                term.setCursorPos( x, y )
            end
            term.write( text )
        else
            local lines = CLove.Text.wrap( text, width )
            for i = 1, #lines do
                if (y+i)-1 > h then
                    repeat
                        y = y - 1
                    until (y+i)-1 == h
                    term.scroll( 1 )
                end
                if align == "center" then
                    term.setCursorPos( math.ceil( (( x+limit )-#lines[i])/2), (y+i)-1 )
                elseif align == "right" then
                    term.setCursorPos( (limit - #lines[i]) + 1, (y+i)-1 )
                elseif align == "left" then
                    term.setCursorPos( x, (y+i)-1 )
                end
                term.write( lines[i] )
            end
        end
    else
        term.setCursorPos( x, y )
        term.write( text )
    end
end



Graphics.clear = function( background )
    assert( background == nil or CLove.Colors.isValid( background ), "invalid color", 2 )
    if background then
        Graphics.setBackgroundColor( background )
    end
    term.setCursorPos( 1, 1 )
    term.clear()
end



Graphics.line = function( x1, y1, x2, y2, color )
    local dx, dy = x2-x1, y2-y1
    
    if color then
        Graphics.setBackgroundColor( color )
    end
    
    Graphics.write( " ", x1, y1 )
    if (dx ~= 0) then
        local m = dy / dx;
        local b = y1 - m*x1;
        dx = x2 > x1 and 1 or -1
        while x1 ~= x2 do
            x1 = x1 + dx
            y1 = math.floor( m*x1 + b + 0.5);
            Graphics.write( " ", x1, y1 )
        end
    end
end



Graphics.rectangle = function( mode, x, y, width, height, background )
    assert( mode == "fill" or mode == "line", "invalid mode", 2 )
    
    if background then
        Graphics.setBackgroundColor( background )
    end
    
    local line = string.rep( " ", width )
    if mode == "fill" then
        for i = 1, height do
            Graphics.write( line, x, (y-1)+i )
        end
    else
        for i = 1, height do
            if i == 1 or i == height then
                Graphics.write( line, x, (y-1)+i )
            else
                Graphics.write( " ", x, (y-1)+i )
                Graphics.write( " ", x + width - 1, (y-1)+i )
            end
        end
    end
end



Graphics.circle = function( mode, x, y, radius, background )
    assert( mode == "fill" or mode == "line", "invalid mode", 2 )
    if background then
        Graphics.setBackgroundColor( background )
    end
    local radStep = 1/(1.5*radius)
    for angle = 1, math.pi+radStep, radStep do
        local pX = math.cos( angle ) * radius * 1.5
        local pY = math.sin( angle ) * radius
        for i=-1,1,2 do
            for j=-1,1,2 do
                Graphics.write( " ", x + i*pX, y + j*pY )
            end
        end
    end
end



Graphics.triangle = function( mode, x1, y1, x2, y2, x3, y3 )
    assert( mode == "fill" or mode == "line", "invalid mode", 2 )
end



Graphics.drawImage = function( image, x, y, sx, sy )
end



return Graphics
