local Grid = {
    threat = 0
}

function Grid:new(obj)
    obj = obj or {}
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Grid:update()
end

function Grid:draw()

    for y = 0, 13 do
        local o = y % 2 == 0 and true or false
        for x = 0, 15 do
            if (x == 15 and not o) then
                break
            end
            spr(63, o and x * 8 or x * 8 + 4, y * 8)
        end
    end
end

function Grid:checkPosition(this,monster)
    circ(monster.x,monster.y,0,10)
end

return Grid