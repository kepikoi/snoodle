local Robot = {}
local _initPos = 110 -- init  x coord
local _initDirection = 0 -- init arm position
local _yCoord = 115 -- robots permament vertical coord
local _animSpeed = 1 -- higher is slower
function Robot:new(obj)
    obj = obj or {}
    obj.sprite = 20
    obj.x = _initPos
    obj.y = _yCoord
    obj.direction = _initDirection
    obj.stage = 0
    obj.currentMonster = nil
    obj.canon = nil
    obj.lift = nil
    obj.armsDistance = nil
    obj.monsterDistance = nil
    setmetatable(obj, self)
    self.__index = self
    return obj
end

--revolve object around robot
function Robot:revolve(this, distance)
    return {
        x = distance * cos(self.direction) + self.x;
        y = distance * sin(self.direction) + self.y;
    }
end

function Robot:registerCanon(this, canon)
    self.canon = canon
end

function Robot:registerLift(this, lift)
    self.lift = lift
end

function Robot:draw()

    spr(self.sprite, self.x, self.y) --body

    line(self.x + 3, self.y + 4, self.armsDistance.x + 3, self.armsDistance.y + 4, 11) --arm
    circ(self.armsDistance.x + 3, self.armsDistance.y + 4, 1, 8) -- upper claw

    --    print(self.currentMonster, self.x-5, self.y-6, 4)
end

function Robot:grabMonster()
    self.currentMonster = self.lift.currentMonster
    self.lift.currentMonster = nil
    self.stage = 1
end

function Robot:update()

    if (self.stage == 0 and not self.canon.currentMonster and self.lift.currentMonster) then
        self:grabMonster()
    end

    self.armsDistance = self:revolve(nil, 5)
    self.monsterDistance = self:revolve(nil, 9)

    if self.currentMonster then
        self.currentMonster:setCoords(nil, self.monsterDistance.x - 2, self.monsterDistance.y) -- transport monster
    end

    if self.stage == 1 then -- rotate to canon
        if globals.i % _animSpeed == 0 then
            if self.direction < 0.48 then
                self.direction = self.direction + 0.05
            else
                self.stage = 2
            end
        end
    end

    if self.stage == 2 then -- run to canon
        if globals.i % _animSpeed == 0 then
            if self.x > 65 then
                self.x = self.x - 2
            else
                self.direction = _initDirection --rotate back to lift
                self.canon:mountMonster(nil, self.currentMonster)
                self.currentMonster = nil

                self.stage = 3
            end
        end
    end

    if self.stage == 3 then --return to lift
        if globals.i % _animSpeed == 0 then
            if self.x < _initPos then
                self.x = self.x + 3
            else
                self.stage = 0
            end
        end
    end
end

return Robot;