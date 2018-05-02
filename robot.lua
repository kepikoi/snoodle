local Robot = {}
local _initPos = 110 -- init  x coord
local _initDirection = 0 -- init arm position
local _yCoord = 115 -- robots permament vertical coord
local _animSpeed = 1
function Robot:new(obj)
    obj = obj or {}
    obj.sprite = 20
    obj.x = _initPos
    obj.y = _yCoord
    obj.direction = _initDirection
    obj.stage = 0
    obj.currentMonster = nil
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Robot:draw()
    local endArmX = 4 * cos(self.direction) + self.x + 3;
    local endArmY = 4 * sin(self.direction) + self.y + 4;

    print(self.x .. ' ' .. _initPos, 33, 11, 11)

    if self.currentMonster then
        self.currentMonster:draw(nil, endArmX + 2, endArmY + 2)
    end

    spr(self.sprite, self.x, self.y) --body

    line(self.x + 3, self.y + 4, endArmX, endArmY, 11) --arm
    circ(endArmX , endArmY, 1, 8) -- upper claw

    --    print(self.direction, 33, 22, 4)

    if self.stage == 1 then
        if globals.i % _animSpeed  == 0 then
            if self.direction < 0.5 then
                self.direction = self.direction + 0.05
            else
                self.stage = 2

            end
        end
    end

    if self.stage == 2 then
        if globals.i % _animSpeed == 0 then
            if self.x > 64 then
                self.x = self.x - 2
            else
                self.direction = _initDirection
                self.stage = 3
            end
        end
    end

    if self.stage == 3 then
        if globals.i % _animSpeed == 0 then
            if self.x < _initPos then
                self.x = self.x + 3
            else
                self.stage = 0
            end
        end
    end
end


function Robot:grabMonster(this, monster)
    self.currentMonster = monster
    self.stage = 1
end

function Robot:update()
end

return Robot;