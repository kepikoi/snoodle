local Lift = {}
local _initPosition = 122 -- vertical lift positon
local _xCoord = 120 -- horizontal lift position
local Monster = require('./monster')

function Lift:new(obj)
    obj = obj or {}
    obj.position = _initPosition
    obj.isSlidingDown = false
    obj.isSlidingUp = false
    obj.currentMonster = nil
    obj.robot = nil
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Lift:draw()
    spr(21, _xCoord, self.position)
end

function Lift:update()
    self:animate()
    if self.currentMonster then
        self.currentMonster:setCoords(nil, _xCoord - 1, self.position - 8)
    end
end

function Lift:addMonster(this, monsters)
    local currentMonster = Monster:new()
    add(monsters,self.currentMonster)
    self.currentMonster = currentMonster

    self.isSlidingDown = true
end

function Lift:registerRobot(this, robot)
    self.robot = robot
end


function Lift:animate()

    if (self.isSlidingDown) then
        self.robot:grabMonster(nil, self.currentMonster)
        self.currentMonster = nil

        if globals.i % 5 then
            self.position = self.position + 1
        end

        if self.position > 136 then
            self.isSlidingDown = false
            self.isSlidingUp = true
            self.currentMonster = Monster:new()
        end
    end
    if (self.isSlidingUp) then
        if globals.i % 5 then
            self.position = self.position - 1
        end

        if self.position <= _initPosition then
            self.isSlidingDown = false
            self.isSlidingUp = false
        end
    end
end

return Lift