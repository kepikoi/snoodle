local _neighbors = { -16, -15, -1, 1, 15, 16 }
local Grid = {
    threat = 6,
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

    for cell in all(self.cells) do
        if cell.monster then
            -- drop disconnected monsters
            local isConnected = false
            for neighborCell in all(self:getNeighborCells(nil, cell)) do
                if (neighborCell.threat or neighborCell.monster) then --is connected, do not drop
                    isConnected = true
                end
            end
            if (not isConnected) then
                cell.monster.isDropped = true -- drop if cell is not connected to ceiling or populated cell
                cell.monster = nil
            end
        end
    end
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

--checks if cell is a matching neighbor of candidate cell
function Grid:isMatchingNeighbor(this, cell, candidate)
    local matchingNeighbors = self:getMatchingNeighbors(nil, cell)
    for matchingNeighbor in all(matchingNeighbors) do
        if matchingNeighbor == candidate then return true
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
    --    if cell.monster then
    --        local i = (i or 0) + 1
    --        assert(i < 100, 'iteration loop at ' .. i)
    --        assert(cell)
    --        local chain = chain or {}
    --        add(chain, cell) -- add curent cell to chain
    --
    --        for neighborCell in all(self:getPopulatedNeighborCells(nil, cell)) do
    --            if (not get(chain, neighborCell)) then --cell exists and not already in chain
    --                assert(cell.monster)
    --                assert(neighborCell and neighborCell.monster)
    --                if cell.monster.sprite == neighborCell.monster.sprite then --if same monster type
    --                    self:checkDrop(self, neighborCell, chain, i)
    --                end
    --            end
    --        end
    --
    --        print(#chain, 14, 14, 7)
    --        flip()
    --
    --        if #chain >= 3 then
    --            for cell in all(chain) do
    --                cell.monster.isDropped = true
    --                cell.monster = nil
    --            end
    --        end
    --    end

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
    end
end

return Grid