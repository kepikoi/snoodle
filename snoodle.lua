--snoodle
--by kepikoi
Canon = require('./canon')
Lift = require('./lift')
Robot = require('./robot')
Grid = require('./grid')

function _init()
    --    poke(0x5f2d, 1) --mouse support

    globals.i = 0
    globals.monsters = {}

    canon = Canon:new();
    lift = Lift:new({}, globals.monsters);
    robot = Robot:new();
    grid = Grid:new();

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


    canon:draw()
    lift:draw()

    for m in all(globals.monsters) do
        m:draw()
    end

    robot:draw()
    grid:draw()

end

