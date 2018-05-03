local Canon = {}
local _initRotation = 0.5
local _tankCoords = {
    x = 60,
    y = 116
}

function Canon:new(obj)
    obj = obj or {}
    obj.rotation = _initRotation
    obj.currentMonster = nil
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Canon:draw()
    -- draw canon circles
    --print(self.rotation, 64, 64, 13)

    for i = 2, 4 do
        local s = 18 -- sprite  nr
        local m = 0 -- margin for last circle
        if (i == 4) then
            s = 19 -- last canon sprite
            m = 0.5
        end
        spr(s, (5 + m) * i * (sin(self.rotation)) + _tankCoords.x, (5 + m) * i * cos(self.rotation) + _tankCoords.y)
    end

    --print(self.currentMonster, _tankCoords.x, _tankCoords.y, 14);
end

function Canon:update()
    --convert mouse x coord to rotation
    if (stat(32) > 17 and stat(32) < 79) then
        self.rotation = 1 / 128 * stat(32)
    end

    --update monster position
    if (self.currentMonster) then
        self.currentMonster:setCoords(nil, _tankCoords.x, _tankCoords.y) -- align monster to  the midle of the canon tank
    end

    if (btn(0, 0) and self.rotation > 0.27) then self.rotation = self.rotation - 0.005 end
    if (btn(1, 0) and self.rotation < 0.73) then self.rotation = self.rotation + 0.005 end

    if (btn(4, 0)) then
        self:fire()
    end
end

function Canon:mountMonster(this, monster)
    self.currentMonster = monster
end

function Canon:fire()
    if (self.currentMonster) then
        self.currentMonster:setTrajectory(nil, self.rotation)
        self.currentMonster = nil
    end
end

return Canon
