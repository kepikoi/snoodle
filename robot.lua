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

function Robot:draw()
    local armsDistance = self:revolve(nil, 4)
    local monsterDistance = self:revolve(nil, 5)

    if self.currentMonster then
        self.currentMonster:setCoords(nil, monsterDistance.x - 2, monsterDistance.y)
    end

    spr(self.sprite, self.x, self.y) --body

    line(self.x + 3, self.y + 4, armsDistance.x + 3, armsDistance.y + 4, 11) --arm
    circ(armsDistance.x+3 , armsDistance.y+4, 1, 8) -- upper claw

    print(self.currentMonster, self.x-5, self.y-6, 4)

    if self.stage == 1 then
        if globals.i % _animSpeed == 0 then
            if self.direction < 0.5 then
                self.direction = self.direction + 0.05 -- run to canon
            else
                self.stage = 2
            end
        end
    end

    if self.stage == 2 then
        if globals.i % _animSpeed == 0 then
            if self.x > 65 then
                self.x = self.x - 2
            else
                self.direction = _initDirection --rotate back to lift
                self.canon:mountMonster(nil,self.currentMonster)
                self.currentMonster = nil

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
    if self.stage == 0 then
        self.currentMonster = monster
        self.stage = 1
    end
end

function Robot:update()
end

return Robot;