local _initSpeed = 2 --default flying speed
local Monster = {
    x = -64,
    y = -64,
    alterSprite = false, -- show alternative sprite for animation
    direction = nil,
    speed = 0,
    spriteCoolDown = rnd(40),
    lastCell = nil
}
function Monster:new(obj, grid)
    assert(grid, 'monster requires grid instance')
    obj = obj or {}
    obj.grid = grid
    obj.sprite = 1 + flr(rnd(7)) * 2, --sprite determines monster type
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Monster:draw()
--    spr(self.alterSprite and self.sprite + 1 or self.sprite, self.x, self.y)
    circ(self.x+4,self.y+4,4,self.sprite) --debug
    circ(self.x+4,self.y+4,0,10) --debug
end

function Monster:animateFace()
    self.spriteCoolDown = self.spriteCoolDown - 1
    if (self.spriteCoolDown < 0) then
        self.alterSprite = not self.alterSprite --periodically change sprite
        self.spriteCoolDown = rnd(40)
    end
end

function Monster:update()

    self:animateFace();

    if (self.direction) then
        self.speed = _initSpeed --enable flying

        if (self.x <= 0 or self.x >= 119) then
            self.direction = 1 - self.direction --bounce of walls
        end

        self.x = self.x + sin(self.direction) * self.speed
        self.y = self.y + cos(self.direction) * self.speed

        self.grid:checkPosition(nil, self)
    end
end

function Monster:setCoords(this, x, y)
    self.x = x
    self.y = y
end

function Monster:registerGrid(this, grid)
    self.grid = grid
end

return Monster
