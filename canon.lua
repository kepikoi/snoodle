local canon = {
    draw = function()
        --current snood in canon
        spr(1, 60, 116)

        for i = 2, 4 do
            local s = 18
            if (i == 4) then
                s = 19
            end
            spr(s, -4 * i * (cos(globals.rotation) - sin(globals.rotation)) + 62, 4 * i * ((sin(globals.rotation) + cos(globals.rotation))) + 116)
        end

       -- print('globals.rotation ' .. globals.rotation, 10, 10);
    end,
    update = function()

        --convert mouse x coord to rotation
        if (stat(32) > 17 and stat(32) < 79) then
            globals.rotation = 1 / 128 * stat(32)
            lastMouseCoord = stat(32)
        end

        if (btn(0, 0) and globals.rotation > 0.14) then globals.rotation = globals.rotation - 0.005 end
        if (btn(1, 0) and globals.rotation < 0.61) then globals.rotation = globals.rotation + 0.005 end
    end
}

return canon
