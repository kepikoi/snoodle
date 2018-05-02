local Lift = {}
local _initPosition = 122 -- vertical lift positon
local _xCoord = 120 -- horizontal lift position
local Monster = require('./monster')
local firstMonster = Monster:new()
add(globals.monsters, firstMonster)

function Lift:new(obj,monsters)

    local firstMonster = Monster:new()
    add(monsters, firstMonster)

    obj = obj or {}
    obj.position = _initPosition
    obj.stage = 0
    obj.currentMonster = firstMonster
    obj.robot = nil
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Lift:draw()
    spr(21, _xCoord, self.position)
    print(self.currentMonster, _xCoord - 14, 90, 3)
end

function Lift:update()
    self:animate()
    if self.currentMonster then
        self.currentMonster:setCoords(nil, _xCoord - 1, self.position - 8)
    end
end

function Lift:addMonster()
    if (self.robot.stage == 0) then
           self.stage = 1
    end
end

function Lift:registerRobot(this, robot)
    self.robot = robot
end

function Lift:animate()

    if self.stage == 1 then   --descend
        self.robot:grabMonster(nil, self.currentMonster)
        self.currentMonster  = nil

        if globals.i % 5 then
            self.position = self.position + 1
        end

        if self.position > 136 then -- below surface

            local currentMonster = Monster:new() --assign new monster
            add(globals.monsters, currentMonster)
            self.currentMonster = currentMonster

            self.stage = 2
        end
    end

    if self.stage == 2 then -- lift




        if globals.i % 5 then
            self.position = self.position - 1
        end

        if self.position <= _initPosition then
            self.stage = 0
        end
    end
end

return Lift