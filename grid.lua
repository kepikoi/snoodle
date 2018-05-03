local Grid = {}

function Grid:new()
    obj = obj or {}
    obj.threat = 0
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
          --  spr(4, o and x * 8 or x * 8 + 4, y * 8)
        end
    end
end

return Grid