require("AnAL")
hoc = require("hoc")

function make_cupcakes()
    --loading image
    cupcake = {}
    cupcake.x = screen.w*.5
    cupcake.y = screen.h*.8
    cupcake.last_y = cupcake.y
    cupcake.ground_y = cupcake.y
    cupcake.width = 32
    cupcake.height = 32
    cupcake.walk = .1
    cupcake.xspeed = 0
    cupcake.yspeed = 0
    cupcake.jump = 60
    cupcake.sugar = 0
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
    cupcake.waffer = waffer.collide:addRectangle(cupcake.x, cupcake.y, cupcake.width, cupcake.height)
    cupcake.boost = first.collide:addRectangle(cupcake.x, cupcake.y, cupcake.width, cupcake.height)
    cupcake.back = back.collide:addRectangle(cupcake.x, cupcake.y, cupcake.width, cupcake.height)
    cupcake.enemy = enemy.collide:addRectangle(cupcake.x, cupcake.y, cupcake.width, cupcake.height)
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
    self.collide = hoc(100, close)
    self.perim = self.collide:addRectangle(self.x, self.y, self.w, self.h)
    return self
end

function burn_brownees()
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

function platform(self, x, y)
    self = {}
    self.image = love.graphics.newImage( "waffer.png" )
    self.x = x
    self.y = y
    self.w = self.image:getWidth()
    self.h = self.image:getHeight()
    self.collide = hoc(100, crunch, uncrunch)
    self.perim = self.collide:addRectangle(x, y, self.w, self.h)
    return self
end

function donut(self, x, y)
    self = {}
    self.x = x
    self.y = y
    self.speed = 1
    self.frame = {}
    self.frame.w = 32
    self.frame.h = 32
    self.frame.delay = .1
    self.frame.amount = 3
    self.image = love.graphics.newImage( "donut.png" )
    self.w = self.image:getWidth()
    self.h = self.image:getHeight()
    self.collide = hoc(100, kill)
    self.perim = self.collide:addRectangle(x, y, self.frame.w, self.frame.h)
    self.walk = newAnimation(self.image, self.frame.w, self.frame.h, self.frame.delay, self.frame.amount)
    self.walk:setMode("loop")
    return self
end

function kill()
    cupcake.image = love.graphics.newImage("squashed.png")
end

function controls()
    if love.keyboard.isDown('d') then
        return 'd'
    elseif love.keyboard.isDown('a') then
        return 'a'
    end
end

function crunch()
    cupcake.y = waffer.y - cupcake.height
end

function uncrunch()
    cupcake.y = cupcake.ground_y
end

function open(dt, collider, collidee)
    first.image = love.graphics.newImage("sugar.png")
    if first.collision_count == 1 then
        first.image = love.graphics.newImage("clear.png")
        cupcake.sugar = cupcake.sugar + 1
    elseif first.collision_count >= 5 then
        first.image = love.graphics.newImage("clear.png")
    end
    first.collision_count = first.collision_count + 1
end

function close()
    screen.x = 0
    cupcake.x = screen.w/2
    cupcake.speed = 0
end

function sugar_count()
    love.graphics.print(cupcake.sugar, cupcake.x-200, 40)
end

function love.load()
    screen = {}
    screen.w = love.graphics.getWidth()
    screen.h = love.graphics.getHeight()
    screen.x = 0
    screen.y = 0
    screen.speed = 0
    --collision
    back = close_oven(back, 0, 0, (screen.w/2)-100, screen.h)
    --boost = hoc(100, open)
    oven = pre_heat_oven(oven, 0, 0, "oven.png")
    first = kiss(first, 100, 160, 32, 32)
    waffer = platform(waffer, 400, 250)
    enemy = donut(enemy, 500, 240)
    make_cupcakes()
end

function love.update(dt)
    cupcake.waffer:moveTo(cupcake.x+(cupcake.width/2), cupcake.y+(cupcake.height/2))
    cupcake.boost:moveTo(cupcake.x+(cupcake.width/2), cupcake.y+(cupcake.height/2))
    cupcake.back:moveTo(cupcake.x+(cupcake.width/2), cupcake.y+(cupcake.height/2))
    cupcake.enemy:moveTo(cupcake.x+(cupcake.width/2), cupcake.y+(cupcake.height/2))
    enemy.perim:moveTo(enemy.x+(enemy.frame.w/2), enemy.y+(enemy.frame.h/2))
    waffer.perim:moveTo(waffer.x+(waffer.w/2), waffer.y+(waffer.h/2))
    waffer.collide:update(dt)
    first.collide:update(dt)
    enemy.collide:update(dt)
    enemy.x = enemy.x - enemy.speed
    cupcake.right.animation:update(dt)
    cupcake.left.animation:update(dt)
    enemy.walk:update(dt)
    if cupcake.y == cupcake.last_y - cupcake.jump then
        cupcake.yspeed = 5
    elseif cupcake.y == cupcake.last_y and cupcake.yspeed == 5 then
        cupcake.yspeed = 0
    end
end

function love.draw()
--    cupcake.right.animation:draw(cupcake.x, cupcake.y)
    screen.x = screen.x + (cupcake.xspeed*-1)
    love.graphics.translate(screen.x, screen.y)
    love.graphics.draw(oven.image, oven.x, oven.y, 0, 1, 1)
    love.graphics.draw(waffer.image, waffer.x, waffer.y)
    love.graphics.draw(first.image, first.x, first.y)
    cupcake.x = cupcake.x + cupcake.xspeed
    cupcake.y = cupcake.y + cupcake.yspeed
    key = controls()
    --moving left
    if key == 'd' then
        cupcake.xspeed = 3
        cupcake.right.animation:draw(cupcake.x, cupcake.y)
    end
    --moving right
    if key == 'a' then
        cupcake.xspeed = -3
        cupcake.left.animation:draw(cupcake.x, cupcake.y)
    end
    if key == nil then
        cupcake.xspeed = 0
        cupcake.right.animation:seek(2)
        cupcake.right.animation:draw(cupcake.x, cupcake.y)
    end
    --waffer.perim:draw("line")
    --cupcake.perim:draw("line")
    --first.perim:draw("line")
    --back.perim:draw("line")
    --cupcake.back:draw("fill")
    enemy.walk:draw(enemy.x, enemy.y)
    --enemy.perim:draw("line")
    --cupcake.enemy:draw("line")
    sugar_count()

end

function love.keypressed( key )
    if key == ' ' and cupcake.yspeed == 0 then
        cupcake.last_y = cupcake.y
        cupcake.yspeed = -5
    end
end
