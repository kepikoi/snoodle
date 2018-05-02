--snoodle
--by kepikoi

function _init()
    canon = require('./canon')
    poke(0x5f2d, 1) --mouse support
    globals.currentSnood = 0
    globals.rotation = 90
end

function _update60()
    canon.update()
end

function _draw()
    cls()
    map(0,0,0,0,128,128,0)
    canon.draw()
end