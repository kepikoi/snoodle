local Canon = {}

function Canon:new(obj)
    obj = obj or {}
    obj.rotation = 0.372
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Canon:draw()

    -- draw canon circles
    for i = 2, 4 do
        local s = 18 -- sprite  nr
        local m = 0 -- margin for last circle
        if (i == 4) then
            s = 19
            m = 0.2
        end
        spr(s, (-4 - m) * i * (cos(self.rotation) - sin(self.rotation)) + 62, (4 +  m) * i * ((sin(self.rotation) + cos(self.rotation))) + 116)
    end

    -- print('globals.rotation ' .. globals.rotation, 10, 10);
end

function Canon:update()
    --convert mouse x coord to rotation
    if (stat(32) > 17 and stat(32) < 79) then
        self.rotation = 1 / 128 * stat(32)
    end

    if (btn(0, 0) and self.rotation > 0.14) then self.rotation = self.rotation - 0.005 end
    if (btn(1, 0) and self.rotation < 0.61) then self.rotation = self.rotation + 0.005 end
end



return Canon
