--snoodle
--by kepikoi
Canon = require('./canon')
Lift = require('./lift')
Robot = require('./robot')

function _init()
    --    poke(0x5f2d, 1) --mouse support

    globals.i = 0
    globals.monsters = {}

    canon = Canon:new();
    lift = Lift:new({},globals.monsters);
    robot = Robot:new();

    lift:registerRobot(nil, robot);
    robot:registerCanon(nil, canon);

    -- init first monster
    lift:addMonster();
end

function _update60()
    -- iterate i counter
    globals.i = globals.i + 1

    listenControls();

    for m in all(globals.monsters) do
        m:update()
    end

    canon:update()
    lift:update()
    robot:update()
end

function _draw()
    cls()

    -- draw bg map
    map(0, 0, 0, 0, 128, 128, 0)

    print(#globals.monsters, 0, 0, 8)

    canon:draw()
    lift:draw()

    for m in all(globals.monsters) do
        m:draw()
    end

    robot:draw()
end

function listenControls()
    if (btn(4, 0)) then
        canon:fire()
        lift:addMonster()
    end
end