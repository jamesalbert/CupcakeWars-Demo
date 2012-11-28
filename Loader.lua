--LEVEL 1
level_1 = os.execute("love /home/jbert/dev/Lua-Dev/game_dev/BoringStuff/LEVEL_1")
if level_1 == 0 then
    os.execute("love /home/jbert/dev/Lua-Dev/game_dev/BoringStuff/LEVEL_2")
end
