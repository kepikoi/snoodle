local Monster = {}
local _speed = 0.3 --higher is faster
function Monster:new(obj)
    obj = obj or {}
    obj.sprite = 1 + flr(rnd(7)) * 2
    obj.x = 0
    obj.y = 0
    obj.distance = 0
    obj.direction = nil
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Monster:draw()
    spr(self.sprite, self.x, self.y)

--    if (self.direction) then
--        print(self.x .. ' ' .. self.y .. " " .. self.direction, self.x - 3, self.y - 6, 10)
--    end
end

function Monster:update()
    if (self.direction) then
        self.x = self.x + sin(self.direction) * self.distance
        self.y = self.y + cos(self.direction) * self.distance
        self.distance = self.distance + _speed
    end

    if (distance == 100) then
        remove(globals.monsters, self)
    end
end

function Monster:setCoords(this, x, y)
    --    print("set coords"..x.." "..y,x,y,12)
    --    flip()
    self.x = x
    self.y = y
end

function Monster:setTrajectory(this, direction)
    self.direction = direction
end

return Monster
