--snoodle
--by kepikoi
Canon = require('./canon')
Lift = require('./lift')
Robot = require('./robot')

function _init()
    canon = Canon:new();
    lift = Lift:new();
    robot = Robot:new();
    monsters = {}

    lift:registerRobot(nil, robot);

    --    poke(0x5f2d, 1) --mouse support
    globals.i = 0

    -- add first monster
    lift:addMonster(nil, monsters);
end

function _update60()
    -- iterate i counter
    globals.i = globals.i + 1

    listenControls();

    canon:update()
    lift:update()
    robot:update()
end

function _draw()
    cls()

    -- draw bg map
    map(0, 0, 0, 0, 128, 128, 0)

    canon:draw()
    lift:draw()
    robot:draw()

    for m in all(monsters) do
        m:animate()
    end
end

function listenControls()

    if (btn(4, 0)) then
        lift:addMonster(monsters)
    end
end