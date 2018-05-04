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
end

function Grid:draw()
    for i = 1, #self.cells do
        local cell = self.cells[i]
        if cell.active then
            --            rectfill(cell.x, cell.y, cell.x + 8, cell.y + 8, 8) --debug
        end
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
    for cell in all(self.cells) do
        cell.active = false --debug: active cell marker
    end
    if (cell) then --if monster inside valid cell
        cell.active = true --debug: mark active cell
        if (cell.monster or cell.threat) then
            fitMonsterInsideCell(monster, monster.lastCell)
            self:checkDrop(self, monster.lastCell)
        else
            monster.lastCell = cell --remember last cell of monster and continue travel
        end
    end
end

function fitMonsterInsideCell(monster, cell)
    assert(monster and cell)
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
end

function Grid:checkDrop(this, cell, chain)
    local chain = chain or {cell}

    for n in all(_neighbors) do
        local cellI = get(self.cells, cell)
        if not cellI then return end

        local neighborI = cellI + n
        local neighborCell = self.cells[neighborI]
        if (neighborCell and neighborCell.monster) then
            if cell.monster.sprite == neighborCell.monster.sprite then
                add(chain, neighborCell)
                --                self:checkDrop(self, neighborCell, chain)
            end
        end
    end
    print(#chain, 14, 14, 7)
    flip()

    if #chain >= 3 then
        for cell in all(chain) do
            cell.monster.sprite = 16
        end
    end
end

return Grid