local canon = {
    draw = function()
        --current snood in canon
        spr(1, 60, 116)
        print('mouse: ' .. stat(32) .. ' ' .. globals.rotation);

        for i=2,4 do
            local s = 18
            if(i==4) then
                s = 19
            end
            spr(s,-4*i*(cos(globals.rotation)-sin(globals.rotation))+62,4*i*((sin(globals.rotation)+cos(globals.rotation)))+116)

        end

    end,
    update = function()

        --get mouse x coord
        if (stat(32) > 17 and stat(32) < 79) then
            globals.rotation = 1/128*stat(32)
        end
    end
}

return canon
