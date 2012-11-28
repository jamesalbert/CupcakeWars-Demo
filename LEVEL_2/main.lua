require("AnAL")
hoc = require("hoc")

function make_cupcakes()
    --loading image
    cupcake = {}
    cupcake.x = screen.w*.5
    cupcake.y = screen.ground
    cupcake.last_y = cupcake.y
    cupcake.ground_y = screen.ground
    cupcake.width = 96
    cupcake.height = 96
    cupcake.walk = .1
    cupcake.xspeed = 0
    cupcake.yspeed = 0
    cupcake.jump = 180
    cupcake.sugar = 1000
    --walk forwards
    cupcake.right = {}
    cupcake.right.walk = love.graphics.newImage( "cup_right_walk.png" )
    cupcake.right.length = 3
    --walk backwards
    cupcake.left = {}
    cupcake.left.walk = love.graphics.newImage( "cup_left_walk.png" )
    cupcake.left.length = 3
    --------
    --hoc --
    --------
    cupcake.wafer = wafer.collide:addRectangle(cupcake.x, cupcake.y, cupcake.width, cupcake.height)
    cupcake.boost = first.collide:addRectangle(cupcake.x, cupcake.y, cupcake.width, cupcake.height)
    cupcake.back = back.collide:addRectangle(cupcake.x, cupcake.y, cupcake.width, cupcake.height)
    cupcake.front = front.collide:addRectangle(cupcake.x, cupcake.y, cupcake.width, cupcake.height)
    cupcake.enemy = enemy.collide:addRectangle(cupcake.x, cupcake.y, cupcake.width, cupcake.height)
    cupcake.hook = new_hook.collide:addRectangle(cupcake.x, cupcake.y, cupcake.width, cupcake.height)
    cupcake.test = test.collide:addRectangle(cupcake.x, cupcake.y, cupcake.width, cupcake.height)
    --------
    --Anal--
    --------
    --walk forwards animation
    cupcake.right.animation = newAnimation(cupcake.right.walk, cupcake.width, cupcake.height, cupcake.walk, cupcake.right.length)
    cupcake.right.animation:setMode("loop")
    --walk backwards animation
    cupcake.left.animation = newAnimation(cupcake.left.walk, cupcake.width, cupcake.height, cupcake.walk, cupcake.left.length)
    cupcake.left.animation:setMode("loop")
end

function pre_heat_oven(self, x, y, oven)
    self = {}
    self.x = x
    self.y = y
    self.image = love.graphics.newImage( oven )
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
    return self
end

function close_oven(self, x, y, w, h)
    self = {}
    self.x = x
    self.y = y
    self.w = w
    self.h = h
    self.collide = hoc(100, open)
    self.perim = self.collide:addRectangle(self.x, self.y, self.w, self.h)
    return self
end

function burn_brownees()
end

function hook(self, x, y)
    self = {}
    self.x = x
    self.y = 0
    self.speed = 0
    self.image = love.graphics.newImage( "hook.png" )
    self.w = self.image:getWidth()
    self.h = self.image:getHeight()
    self.collide = hoc(100, open, drop)
    self.perim = self.collide:addRectangle( x, self.y, self.w, self.h )
    return self
end

function kiss(self, x, y, w, h)
    self = {}
    self.x = x
    self.y = y
    self.w = w
    self.h = h
    self.image = love.graphics.newImage( "kiss.png" )
    self.collide = hoc(100, open)
    self.collision_count = 0
    self.perim = self.collide:addRectangle(x, y, w, h)
    return self
end

function test_barrier(self, x, y)
    self = {}
    self.x = x
    self.y = y
    self.image = love.graphics.newImage("wafer.png")
    self.w = self.image:getWidth()
    self.h = self.image:getHeight()
    self.collide = hoc(100, open, close)
    self.perim = self.collide:addRectangle( x, y, self.w, self.h )
    return self
end

function platform(self, x, y)
    self = {}
    self.image = love.graphics.newImage( "wafer.png" )
    self.x = x
    self.y = screen.h*.90
    self.w = self.image:getWidth()
    self.h = self.image:getHeight()
    self.collide = hoc(100, open, close)
    self.perim = self.collide:addRectangle(x, self.y, self.w, self.h)
    return self
end

function drop()
    if cupcake.y < cupcake.ground_y then
        cupcake.yspeed = 5
    else
        cupcake.yspeed = 0
        cupcake.y = screen.ground
    end
--    cupcake.y = cupcake.ground_y
end

function donut(self, x, y)
    self = {}
    self.x = x
    self.y = screen.ground
    self.speed = 1
    self.frame = {}
    self.frame.w = 96
    self.frame.h = 96
    self.frame.delay = .1
    self.frame.amount = 3
    self.image = love.graphics.newImage( "donut.png" )
    self.w = self.image:getWidth()
    self.h = self.image:getHeight()
    self.collide = hoc(100, open)
    self.perim = self.collide:addRectangle(x, self.y, self.frame.w, self.frame.h)
    self.walk = newAnimation(self.image, self.frame.w, self.frame.h, self.frame.delay, self.frame.amount)
    self.walk:setMode("loop")
    return self
end

function kill()
    cupcake.sugar = cupcake.sugar - 1
    if cupcake.sugar <= 0 then
        cupcake.image = love.event.quit()
    end
end

function controls()
    if love.keyboard.isDown('d') then
        cupcake.xspeed = 6
        cupcake.right.animation:draw(cupcake.x, cupcake.y)
    elseif love.keyboard.isDown('a') then
        cupcake.xspeed = -6
        cupcake.left.animation:draw(cupcake.x, cupcake.y)
    else --if love.keyboard.isDown('nil') then
        cupcake.xspeed = 0
        cupcake.right.animation:seek(2)
        cupcake.right.animation:draw(cupcake.x, cupcake.y)
    end
end

function ground(self)
    self = {}
    self.x = 0
    self.y = screen.h*.91
    self.w = oven.width
    self.h = oven.height
    self.collide = hoc(100, open)
    self.perim  = self.collide:addRectangle(self.x, self.y, self.w, self.h)
    return self
end

function crunch()
    cupcake.y = wafer.y - cupcake.height
    cupcake.yspeed = 0
    cupcake.xspeed = cupcake.xspeed * .20
end

function uncrunch()
    cupcake.y = cupcake.ground_y
    cupcake.xspeed = cupcake.xspeed * 5
end

function open(dt, collider, collidee)
    if collidee == first.perim or collider == first.perim then
        first.image = love.graphics.newImage("sugar.png")
        if first.collision_count == 1 then
            first.image = love.graphics.newImage("clear.png")
            cupcake.sugar = cupcake.sugar + 1
        elseif first.collision_count >= 5 then
            first.image = love.graphics.newImage("clear.png")
        end
        first.collision_count = first.collision_count + 1
    elseif collidee == new_hook.perim or collider == new_hook.perim then
        cupcake.yspeed = 0
        cupcake.y = new_hook.y + (new_hook.h-18)
        if new_hook.y <= -160 then
            new_hook.speed = -5
        elseif new_hook.y >= 0 then
            new_hook.speed = 5
        end
    elseif collidee == back.perim or collider == back.perim then
        screen.speed = 0
        cupcake.xspeed = 0
        cupcake.x = cupcake.x+1
        screen.x = screen.x-1
    elseif collidee == front.perim or collider == front.perim then
        screen.speed = 0
        cupcake.xspeed = 0
        love.event.quit()
    elseif collidee == enemy.perim or collider == enemy.perim then
        cupcake.sugar = cupcake.sugar - 1
        if cupcake.sugar <= 0 then
            love.event.quit()
        end
    elseif collidee == wafer.perim or collider == wafer.perim then
        cupcake.y = wafer.y - cupcake.height
        cupcake.yspeed = 0
        cupcake.xspeed = cupcake.xspeed * .20
    elseif collidee == grass.perim or collider == grass.perim then
        cupcake.y = cupcake.ground_y-cupcake.h
    elseif collidee == test.perim or collider == test.perim then
        --cupcake.y = screen.h*.8 - ( test.y + cupcake.height )
        cupcake.y = test.y - cupcake.height
        if love.keyboard.isDown(' ') then
            cupcake.y = cupcake.y - 150
            cupcake.yspeed = -15
        else
            cupcake.yspeed = 0
        end

    end
end

function close(dt, collider, collidee)
    if collider == wafer.perim or collidee == wafer.perim then
        cupcake.y = cupcake.ground_y
        cupcake.xspeed = cupcake.xspeed * 5
    elseif collider == test.perim or collidee == test.perim then
        if cupcake.x + cupcake.width < test.x or cupcake.x > test.x + test.w then
            cupcake.yspeed = -15
        end
    end
    --elseif collider == wafer.perim or collidee == wafer
    --screen.speed = 0
    --cupcake.xspeed = 0
    --cupcake.x = cupcake.x+1
    --screen.x = screen.x-1
end

function sugar_count()
    love.graphics.print(cupcake.sugar, cupcake.x-200, 40)
end

function load_collisions()
    first = kiss(first, 100, 160, 96, 96)
    wafer = platform(wafer, 800, 270)
    enemy = donut(enemy, 500, 240)
    new_hook = hook(new_hook, 800, 0)
    grass = ground(grass)
    test = test_barrier(test, 800, 270)
end

function load_screen_dimensions()
    screen = {}
    screen.w = love.graphics.getWidth()
    screen.h = love.graphics.getHeight()
    screen.x = 0
    screen.y = 0
    screen.ground = screen.h*.75
    screen.speed = 0
end

function update_cupcake_perimeters()
    cupcake.wafer:moveTo(cupcake.x+(cupcake.width/2), cupcake.y+(cupcake.height/2))
    cupcake.boost:moveTo(cupcake.x+(cupcake.width/2), cupcake.y+(cupcake.height/2))
    cupcake.back:moveTo(cupcake.x+(cupcake.width/2), cupcake.y+(cupcake.height/2))
    cupcake.enemy:moveTo(cupcake.x+(cupcake.width/2), cupcake.y+(cupcake.height/2))
    cupcake.hook:moveTo(cupcake.x+(cupcake.width/2), cupcake.y+(cupcake.height/2))
    cupcake.front:moveTo(cupcake.x+(cupcake.width/2), cupcake.y+(cupcake.height/2))
    cupcake.test:moveTo(cupcake.x+(cupcake.width/2), cupcake.y+(cupcake.height/2))
end

function update_cupcake_position()
    cupcake.x = cupcake.x + cupcake.xspeed
    cupcake.y = cupcake.y + cupcake.yspeed
end

function update_cupcake_animations(dt)
    cupcake.right.animation:update(dt)
    cupcake.left.animation:update(dt)
end

function update_enemy_perimeters()
    enemy.perim:moveTo(enemy.x+(enemy.frame.w/2), enemy.y+(enemy.frame.h/2))
end

function update_enemy_position()
    enemy.x = enemy.x - enemy.speed
end

function update_enemy_animations(dt)
    enemy.walk:update(dt)
end

function update_wafer_perimeters()
    wafer.perim:moveTo(wafer.x+(wafer.w/2), wafer.y+(wafer.h/2))
end

function update_hook_perimeters()
    new_hook.perim:moveTo(new_hook.x+(new_hook.w/2), new_hook.y+(new_hook.h/2))
end

function update_hook_position()
    new_hook.y = new_hook.y - new_hook.speed
end

function update_collisions(dt)
    --first.collide:update(dt)
    --wafer.collide:update(dt)
    --new_hook.collide:update(dt)
    --enemy.collide:update(dt)
    back.collide:update(dt)
    front.collide:update(dt)
    grass.collide:update(dt)
    test.collide:update(dt)
end

function handle_jump_event()
    if cupcake.y <= screen.ground - cupcake.jump - ( cupcake.y - screen.ground ) and cupcake.yspeed ~= 0 then
        cupcake.yspeed = 15
    elseif cupcake.y >= screen.ground and cupcake.yspeed == 15 then
        cupcake.yspeed = 0
    end
end

function handle_hook_swing()
    if new_hook.y <= -160 then
        new_hook.speed = -10
    elseif new_hook.y >= 0 then
        new_hook.speed = 10
    end
end

function hello_world()
    love.graphics.draw(oven.image, oven.x, oven.y, 0, 1, 1)
end

function move_screen()
    screen.x = screen.x + (cupcake.xspeed*-1)
    love.graphics.translate(screen.x, screen.y)
end

function draw_characters()
    --love.graphics.draw(wafer.image, wafer.x, wafer.y)
    --love.graphics.draw(first.image, first.x, first.y)
    --love.graphics.draw(new_hook.image, new_hook.x, new_hook.y)
    --enemy.walk:draw(enemy.x, enemy.y)
    love.graphics.draw(test.image, test.x, test.y)
    love.graphics.draw(test.image, test.x+300, test.y)
    love.graphics.draw(test.image, test.x+900, test.y)
end

function grid_mode()
    --wafer.perim:draw("line")
    --cupcake.wafer:draw("line")
    --first.perim:draw("line")
    back.perim:draw("line")
    front.perim:draw("line")
    cupcake.test:draw("line")
    test.perim:draw("line")
    --cupcake.back:draw("line")
    --enemy.perim:draw("line")
    --cupcake.enemy:draw("line")
    --new_hook.perim:draw("line")
    --grass.perim:draw("line")

end

function set_level_borders()
    back = close_oven(back, 0, 0, (screen.w/2), screen.h)
    front = close_oven(front, oven.width-(screen.w/2), 0, (screen.w/2), screen.h)
end

------------------------------------------
------------LOVE FUNCTIONS----------------
------------------------------------------

function love.load()
    load_screen_dimensions()
    oven = pre_heat_oven(oven, 0, 0, "oven.png")
    load_collisions()
    set_level_borders()
    make_cupcakes()
end

function love.update(dt)
    update_cupcake_perimeters()
    update_enemy_perimeters()
    update_enemy_position()
    update_wafer_perimeters()
    update_collisions(dt)
    update_cupcake_animations(dt)
    update_enemy_animations(dt)
    update_hook_perimeters()
    update_hook_position()
    handle_jump_event()
    handle_hook_swing()
end

function love.draw()
--    cupcake.right.animation:draw(cupcake.x, cupcake.y)
    move_screen()
    hello_world()
    draw_characters()
    update_cupcake_position()
    controls()
    --grid_mode()
    sugar_count()
end

function love.keypressed( key )
    if key == ' ' and cupcake.yspeed == 0 then
        cupcake.last_y = cupcake.y
        cupcake.yspeed = -20
    elseif key == 'q' then
        love.event.quit()
    end
end
