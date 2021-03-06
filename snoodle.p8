pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
globals = {}
--------------sub-module-C:\Users\autod\OneDrive\Dokumente\pico8\carts\snoodle\canon.lua---------------------
m42f75baf20d2ed1098fe910e9182122a = function()
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

end
m42f75baf20d2ed1098fe910e9182122a = m42f75baf20d2ed1098fe910e9182122a()
--------------sub-module-C:\Users\autod\OneDrive\Dokumente\pico8\carts\snoodle\monster.lua---------------------
mebfe0a8595bbbc9dd2c88f55e7316bd7 = function()
    local _initSpeed = 2 --default flying speed

local Monster = {
    x = -64,
    y = -64,
    alterSprite = false, -- show alternative sprite for animation
    direction = nil,
    speed = 0,
    spriteCoolDown = rnd(40),
    lastCell = nil,
    isDropped = false
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
    spr(self.alterSprite and self.sprite + 1 or self.sprite, self.x, self.y)
    --    circ(self.x+4,self.y+4,4,self.sprite) --debug
    --    circ(self.x+4,self.y+4,0,10) --debug
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

    if (self.direction and not self.isDropped) then --when flying
        self.speed = _initSpeed --enable flying

        if (self.x <= 0 or self.x >= 119) then
            self.direction = 1 - self.direction --bounce of walls
        end

       self.grid:checkPosition(nil, self) -- check collision and align monster to cell
    end

    --  if (not self.direction) then  --when stopped and aligned inside cell
    -- end

    if (self.isDropped) then --fall down when dropped
        --self.lastCell.monster = nil
        self.speed = _initSpeed * 2
        self.direction = 0
    end


    self.x = self.x + sin(self.direction) * self.speed
    self.y = self.y + cos(self.direction) * self.speed

    if self.y > 128 then del(globals.monsters, self) end --remove monster from memory
end

function Monster:setCoords(this, x, y)
    self.x = x
    self.y = y
end

function Monster:registerGrid(this, grid)
    self.grid = grid
end

return Monster

end
mebfe0a8595bbbc9dd2c88f55e7316bd7 = mebfe0a8595bbbc9dd2c88f55e7316bd7()
--------------sub-module-C:\Users\autod\OneDrive\Dokumente\pico8\carts\snoodle\lift.lua---------------------
mb0de3a3ccbdbdd0e0742cda2d8b4752d = function()
    local Monster = mebfe0a8595bbbc9dd2c88f55e7316bd7
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
end
mb0de3a3ccbdbdd0e0742cda2d8b4752d = mb0de3a3ccbdbdd0e0742cda2d8b4752d()
--------------sub-module-C:\Users\autod\OneDrive\Dokumente\pico8\carts\snoodle\robot.lua---------------------
meaad72aeae06ceb1154d27f2099820e1 = function()
    local _initPos = 110 -- init  x coord
local _initDirection = 0 -- init arm position
local _yCoord = 115 -- robots permament vertical coord
local _animSpeed = 1 -- higher is slower
local Robot = {
    x = _initPos,
    y = _yCoord,
    sprite = 20,
    direction = _initDirection,
    stage = 0,
    currentMonster = nil,
    canon = nil,
    lift = nil,
    armsDistance = nil,
    monsterDistance = nil
}
function Robot:new(obj)
    obj = obj or {}
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
end
meaad72aeae06ceb1154d27f2099820e1 = meaad72aeae06ceb1154d27f2099820e1()
--------------sub-module-C:\Users\autod\OneDrive\Dokumente\pico8\carts\snoodle\grid.lua---------------------
m0a253bbb1f61064d2cf908778f24fca5 = function()
    local _neighbors = { -16, -15, -1, 1, 15, 16 }
local Grid = {
    threat = 8,
    cells = {}
}

--populate cells
for y = 0, 13 do
    local o = y % 2 == 0 and true or false
    for x = 0, 15 do
        if (x == 15 and not o) then
            break --skip last cell at even lines
        end
        local cell = {
            monster = nil,
            threat = false
        }
        if (o) then
            cell.x = x * 8
        else
            cell.x = x * 8 + 4
        end
        cell.y = y * 8
        assert(cell.x, tostr(cell.x))
        assert(cell.y, tostr(cell.y))
        add(Grid.cells, cell)
    end
end

function Grid:new(obj)
    obj = obj or {}
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Grid:update()
    for i = 1, ceil(self.threat * 15.5) do
        assert(self.cells[i], 'no cell ' .. i)
        self.cells[i].threat = true
    end
end

function Grid:isConnectedToCeil(this, cell)
    local neighbors = { cell } --collect all neighbors of cell
    repeat
        local nuMatches = {}
        for cell in all(self.cells) do
            if not get(neighbors, cell) then --skip cells that are matches
                if cell.monster then
                    for match in all(neighbors) do
                        if self:isPopulatedNeighbor(nil, cell, match) then
                            add(nuMatches, cell)
                            break -- nuMatch found. Break comparing with existing matches to prevent duplicates and continue with next cell.
                        end
                    end
                end
            end
        end

        for nuMatch in all(nuMatches) do
            --assert(get(matches, nuMatch), 'duplicate match found')
            add(neighbors, nuMatch)
        end
    until #nuMatches == 0

    for neighbor in all(neighbors) do -- find if some of the neighbors are connected to the ceiling
        for n in all({ -16, -15 }) do --check top neighbor positions of cell if their cells are a threat (ceiling)
            local potentialThreatCell = self.cells[get(self.cells, neighbor) + n]
            if (potentialThreatCell) then
                if potentialThreatCell.threat == true then --some neighbor is connected to ceiling
                    return true
                end
            end
        end
    end

    return false
end

function Grid:draw()
    for i = 1, #self.cells do
        local cell = self.cells[i]
        --        spr(63, cell.x, cell.y)  --debug
    end

    for x = 0, 16 do --draw threat ceiling
        for y = 0, self.threat - 1 do
            spr(22, x * 8 - 1, y * 8)
        end
    end
end

function Grid:findCellForMonster(monster)
    local y = flr((monster.y + 4) / 8) + 1
    local o = y % 2 == 1
    local x = o and flr((monster.x + 4) / 8) + 1 or flr((monster.x + 4) / 8)
    --    print(x .. ' ' .. y, monster.x, monster.y + 8, 7)
    --    flip()
    if x == 0 and not o then
        x = 1 -- fix for first cell on odd rows
    end
    local n = ceil((y - 1) * 15.5 + x)
    if (n <= 217) then
        local cell = self.cells[n]
        return cell
    end
    return nil
end

function Grid:checkPosition(this, monster)
    local cell = self:findCellForMonster(monster)
    if (cell) then --if monster inside valid cell
        if (cell.monster or cell.threat) then -- next cell cannot be populated, populate last cell
            fitMonsterInsideCell(monster, monster.lastCell)
            self:dropMatchingCells(nil, monster.lastCell) -- mark isDropped when matching neighbors
        else
            monster.lastCell = cell --remember last cell of monster and continue travel
        end
    end
end

function Grid:dropAll()
    for cell in all(self.cells) do
        if cell.monster then
            -- drop disconnected monsters
            local isConnected = self:isConnectedToCeil(nil, cell)
            if (not isConnected) then
                cell.monster.isDropped = true -- drop if cell is not connected to ceiling or populated cell
                cell.monster = nil
            end
        end
    end
end

function fitMonsterInsideCell(monster, cell)
    cell.monster = monster --set monster cell
    monster.x = cell.x --align to cell
    monster.y = cell.y
    monster.speed = 0
    monster.direction = nil
end

--returns table index for value
function get(table, value)
    for i = 1, #table do
        if table[i] == value then
            return i
        end
    end
    return nil
end

--returns if table conains given value
function contains(table, value)
    for v in all(table) do
        if v == value then return true
        end
        return false
    end
end

--returns true if cell is a neighbor of candidate cell are populated with same monster
function Grid:isMatchingNeighbor(this, cell, candidate)
    return self:isNeighbor(nil, cell, candidate, self:getMatchingNeighbors(nil, cell))
end

--returns true if cell & candidate are neighbors populated with monsters
function Grid:isPopulatedNeighbor(this, cell, candidate)
    return self:isNeighbor(nil, cell, candidate, self:getPopulatedNeighborCells(nil, cell))
end

-- returns if cell is neighbor to candidate from all neighbors
function Grid:isNeighbor(this, cell, candidate, neighbors)
    for neighbor in all(neighbors) do
        if neighbor == candidate then return true
        end
    end
    return false
end

--return all populated and matching neighbor cells
function Grid:getMatchingNeighbors(this, cell)
    assert(cell.monster)
    local neighborCells = self:getPopulatedNeighborCells(nil, cell)
    local matches = {}
    for neighborCell in all(neighborCells) do
        if neighborCell.monster.sprite == cell.monster.sprite then
            add(matches, neighborCell)
        end
    end
    return matches
end

--returns a table with all neighbor cells with a monster for  cell
function Grid:getPopulatedNeighborCells(this, cell)
    local neighborCells = self:getNeighborCells(nil, cell)
    local populatedNeighborCells = {}
    for neighborCell in all(neighborCells) do
        if neighborCell.monster then
            add(populatedNeighborCells, neighborCell)
        end
    end
    return populatedNeighborCells
end

--returns alls neighbor cells
function Grid:getNeighborCells(this, cell)
    assert(cell)
    local neighborCells = {}
    for neighborIndex in all(_neighbors) do
        local cellIndex = get(self.cells, cell)
        if cellIndex then
            local neighborIndex = cellIndex + neighborIndex
            local neighborCell = self.cells[neighborIndex]
            if neighborCell then
                add(neighborCells, neighborCell)
            end
        end
    end

    return neighborCells
end

function Grid:dropMatchingCells(this, cell)
    local matches = { cell }
    repeat
        local nuMatches = {}
        for cell in all(self.cells) do
            if not get(matches, cell) then --skip cells that are matches
                if cell.monster then
                    for match in all(matches) do
                        if self:isMatchingNeighbor(nil, cell, match) then
                            add(nuMatches, cell)
                            break -- nuMatch found. Break comparing with existing matches to prevent duplicates and continue with next cell.
                        end
                    end
                end
            end
        end

        for nuMatch in all(nuMatches) do
            --assert(get(matches, nuMatch), 'duplicate match found')
            add(matches, nuMatch)
        end
    until #nuMatches == 0

    --print(#matches,43,67,9)

    if #matches >= 3 then
        for cell in all(matches) do
            cell.monster.isDropped = true
            cell.monster = nil
        end
        self:dropAll()  --check and drop disconnected cells
    end
end

return Grid
end
m0a253bbb1f61064d2cf908778f24fca5 = m0a253bbb1f61064d2cf908778f24fca5()

--------------root-module---------------------
--snoodle
--by kepikoi
Canon = m42f75baf20d2ed1098fe910e9182122a
Lift = mb0de3a3ccbdbdd0e0742cda2d8b4752d
Robot = meaad72aeae06ceb1154d27f2099820e1
Grid = m0a253bbb1f61064d2cf908778f24fca5

function _init()
    --    poke(0x5f2d, 1) --mouse support

    globals.i = 0
    globals.monsters = {}

    grid = Grid:new();
    canon = Canon:new();
    lift = Lift:new({}, grid);
    robot = Robot:new();

    --    lift:registerRobot(nil, robot);
    robot:registerCanon(nil, canon);
    robot:registerLift(nil, lift);

    -- init first monster
    lift:addMonster();

    --eanble cheats
    globals.cheats = {}
end

--append value to table while retaining max table entries. oldest value will be removed on insertion when table is full
function tableAppend(table, value, max)
    if (#table > max - 1) then
        del(table, table[1])
    end
    add(table, value)
end

function tableToString(table)
    local s = ''
    for k in all(table) do
        s = s .. k
    end
    return s
end

function listenToCheats()

    if (tableToString(globals.cheats) == 'uuddlrlrba') then
        sfx(33)
    end

    if (btnp(2, 0)) then tableAppend(globals.cheats, 'u', 10) end
    if (btnp(3, 0)) then tableAppend(globals.cheats, 'd', 10) end
    if (btnp(0, 0)) then tableAppend(globals.cheats, 'l', 10) end
    if (btnp(1, 0)) then tableAppend(globals.cheats, 'r', 10) end
    if (btnp(4, 0)) then tableAppend(globals.cheats, 'b', 10) end
    if (btnp(5, 0)) then tableAppend(globals.cheats, 'a', 10) end
end

function _update60()
    -- iterate i counter
    globals.i = globals.i + 1

    for m in all(globals.monsters) do
        m:update()
    end

    canon:update()
    lift:update()
    robot:update()
    grid:update()

    if (globals.cheats) then
        listenToCheats()
    end
end

function _draw()
    cls()

    -- draw bg map
    map(0, 0, 0, 0, 128, 128, 0)

    --draw bounds
    line(0, 0, 0, 127, 1)
    line(127, 0, 127, 127, 1)

    grid:draw()

    canon:draw()
    lift:draw()

    for m in all(globals.monsters) do
        m:draw()
    end

    robot:draw()

    print('cpu:' .. stat(1) .. '% ram:' .. stat(0), 0, 0, 7)

end


__gfx__
000000003bbbbbb33bbbbbb30888888008888880001111000011110070707007700707070001200000012000009aaa00009aaa00095555900955559000000000
00000000b33bb33bb33bb33b0288882002288220011111100111111007cccc7007cccc7060122206601d2d0605aaaaa005aaaaa05cc55cc55c1551c500000000
00700700b77bb77bb72bb27b8228822882c88c2811d71d71117717717cc2c2c07cc2c2c7562d2d655627276509555550095555505c155c155cc55cc500000000
00077000b72b327bbbbb3bbb88c88c8888c88c8811771771117d1d710cc6c6c70cc6c6c001d72720012222209a55a55a9a55a55a055757500557575000000000
000770003bb33bb3bbb33bbb888998888889988811115111111151117cdcccc00cccccc702222220022222209aaaaaaa9aaaaaaa00dd7d0000dd7d0000000000
007007003222222332222223281616222816162211188111111111110ccddc077ccddc001222222212161612098888a009aaaaa00dddddd00dddddd000000000
00000000322882233b2222b30855550008111100018008100188881007ccc07007ccc0702221112222111112098778a0098888a00d2222dd0dd22ddd00000000
0000000003b88b3003bbbb30028888200255552000188100001111007070700770070707221222222222222200988a00009aaa000dd22dd00d2222d000000000
056666000566660000000000000000000077700076f7766404040050000000000000000000000000000000000000000000000000000000000000000000000000
06666660066666600056500000499f0007ccc7000f77665540000904000000000000000000000000000000000000000000000000000000000000000000000000
0665656006656560056f65000499aaf07ccccc700f77665004404550000000000000000000000000000000000000000000000000000000000000000000000000
066060600660606006f7f6000499aaa000efe0000f77665090045000000000000000000000000000000000000000000000000000000000000000000000000000
0666566006665660056f650004999a900defed000f77665004004404000000000000000000000000000000000000000000000000000000000000000000000000
056606500566065000565000024999400defed000f77665000000040000000000000000000000000000000000000000000000000000000000000000000000000
005666000056660000000000002494000d000d000f77665005400455000000000000000000000000000000000000000000000000000000000000000000000000
00065600000656000000000000000000ddb0ddb00f77665000090040000000000000000000000000000000000000000000000000000000000000000000000000
0000000055555555055500f666005550055505550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000550555055000f6cccc660005500050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000055555555500fcc0000cc6005500050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000005550555555fc00000000c655550555050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000555555550fc0000000000c60005000500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000555550550fc0000000000c60005000500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000050555555fc000000000000c6055505550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000055555555fc000000000000c6500050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010010050005000fc000000000000c6000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005555550
1010010055055505fc000000000000c7000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050000005
10010120005000500fc0000000000c70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050000005
020100107777777776c0000000000c77000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050000005
0000001066666666666c00000000c666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050000005
00020010666666666666cc0000cc6666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050000005
0010001066666666666666cccc666666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050000005
20100010666666666666666666666666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005555550
__map__
3a3a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2424242424242422232424242424242400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3131313131313132333131313131310000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1616161616161616161616160000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1616161616161600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0006000000000000001605010050200501b03019530185200e240135500d2500c2600e5601852016550185001a5001e5002e00033000370000200002000020000200001000010000100001000010000100001000
