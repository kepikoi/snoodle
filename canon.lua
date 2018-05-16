local _initRotation = 0.5
local _initA = 1
local Canon = {
    x = 60,
    y = 116,
    a = _initA, --accelaration
    currentMonster = nil,
    rotation = _initRotation
}

function Canon:new(obj)
    obj = obj or {}
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Canon:draw()
    --    print(self.a, 64, 64, 13)
local maxi = 10 -- max cannon segments
    -- draw canon circles
    for i = 2, maxi do
        local s = 18 -- sprite  nr
        local m = 2 -- margin for each circle
        if (i == maxi) then
            s = 19 -- last canon sprite
            m = 2.5 -- las circle margin
        end
        spr(s,  m * i *  (sin(self.rotation)) + self.x, m * i * cos(self.rotation) + self.y)
    end

    --print(self.currentMonster, self.x, self.y, 14);
end

function Canon:update()
    --convert mouse x coord to rotation
    if (stat(32) > 17 and stat(32) < 79) then
        self.rotation = 1 / 128 * stat(32)
    end

    --update monster position
    if (self.currentMonster) then
        self.currentMonster:setCoords(nil, self.x, self.y) -- align monster to  the midle of the canon tank
    end

    if (btn(0, 0)) then
        self.rotation = self.rotation > 0.27 and self.rotation - 0.001 * self.a or 0.27
    end
    if (btn(1, 0)) then
        self.rotation = self.rotation < 0.73 and self.rotation + 0.001 * self.a or 0.73
    end

    if (not btn(0, 0) and not btn(1, 0)) then
        self.a = _initA --reset canon rotation when released buttons
    else
        self.a = self.a < 20 and self.a + 0.33 or 20 --acclerate canon rotation when holding button
    end

    if (btn(4, 0)) then
        self:fire()
    end
end

function Canon:mountMonster(this, monster)
    self.currentMonster = monster
end

function Canon:fire()
    if (self.currentMonster) then
        self.currentMonster.direction = self.rotation
        self.currentMonster = nil
    end
end

return Canon
