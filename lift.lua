local Monster = require('./monster')
local _initPosition = 122 -- vertical lift positon
local _xCoord = 120 -- horizontal lift position
local Lift = {
    stage = 0,
    currentMonster = nil,
    position = _initPosition
}

function Lift:new(obj, grid)
    assert(grid)
    obj = obj or {}
    obj.grid = grid
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Lift:draw()
    spr(21, _xCoord, self.position)
    --    print(self.currentMonster, _xCoord - 14, 90, 3)
end

function Lift:update()
    if self.currentMonster then
        self.currentMonster:setCoords(nil, _xCoord - 1, self.position - 8) --move monster with lift
    else
        self.stage = 1
    end

    self:addMonster() -- add monster when lift is empty
end

function Lift:addMonster()
    assert(self.grid)
    if self.stage == 1 then --descend

        if globals.i % 5 then
            self.position = self.position + 1
        end

        if self.position > 136 then -- below surface

            local currentMonster = Monster:new({}, self.grid) --assign new monster
            add(globals.monsters, currentMonster)
            self.currentMonster = currentMonster

            self.stage = 2
        end
    end

    if self.stage == 2 then -- lift

        if globals.i % 5 then
            self.position = self.position - 1
        end

        if self.position <= _initPosition then --lift is done and ready
            self.stage = 0
        end
    end
end

return Lift