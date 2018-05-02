local Monster = {}
function Monster:new(obj)
    obj = obj or {}
    obj.sprite = 1 + flr(rnd(7)) * 2
    obj.x = 0
    obj.y = 0
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Monster:draw()
    spr(self.sprite, self.x, self.y)
    print(self.x..' '..self.y,self.x,self.y,10)
end

function Monster:update()
end

function Monster:setCoords(this,x,y)
    self.x = x
    self.y = y
end

return Monster
