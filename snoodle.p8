pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
globals = {}
--------------sub-module-C:\Users\autod\OneDrive\Dokumente\pico8\carts\snoodle\canon.lua---------------------
m42f75baf20d2ed1098fe910e9182122a = function()
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

end
m42f75baf20d2ed1098fe910e9182122a = m42f75baf20d2ed1098fe910e9182122a()

--------------root-module---------------------
--snoodle
--by kepikoi

function _init()
    canon = m42f75baf20d2ed1098fe910e9182122a
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
__gfx__
000000003bbbbbb33bbbbbb30888888008888880001111000011110070707007700707070001200000012000009aaa00009aaa00095555900955559000000000
00000000b33bb33bb33bb33b0288882002288220011111100111111007cccc7007cccc7060122206601d2d0605aaaaa005aaaaa05cc55cc55c1551c500000000
00700700b77bb77bb72bb27b8228822882c88c2811d71d71117717717cc2c2c07cc2c2c7562d2d655627276509555550095555505c155c155cc55cc500000000
00077000b72b327bbbbb3bbb88c88c8888c88c8811771771117d1d710cc6c6c70cc6c6c001d72720012222209a55a55a9a55a55a055757500557575000000000
000770003bb33bb3bbb33bbb888998888889988811115111111151117cdcccc00cccccc702222220022222209aaaaaaa9aaaaaaa00dd7d0000dd7d0000000000
007007003222222332222223281616222816162211188111111111110ccddc077ccddc001222222212161612098888a009aaaaa00dddddd00dddddd000000000
00000000322882233b2222b30855550008111100018008100188881007ccc07007ccc0702221112222111112098778a0098888a00d2222dd0dd22ddd00000000
0000000003b88b3003bbbb30028888200255552000188100001111007070700770070707221222222222222200988a00009aaa000dd22dd00d2222d000000000
05666600056666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
06666660066666600056500000499f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0669696006696960056f65000499aaf0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
066666600666666006f7f6000499aaa0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0666566006665660056f650004999a90000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
05666650056666500056500002499940000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00655600006556000000000000249400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00066000000660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000006666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000066cccc660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000006cc0000cc6000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000006c00000000c600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000006c0000000000c60000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000006c0000000000c60000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000006c000000000000c6000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000006c000000000000c6000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
10100100000000006c000000000000c6000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
10100100000000006c000000000000c6000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
100101200000000006c0000000000c60000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
020100107777777776c0000000000c67000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000001066666666676c00000000c676000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00020010555558855556cc0000cc6885000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0010001058855555588566cccc665555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
20100010555588585555886666558858000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
0000000000000022230000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3131313131313132333131313131313100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
