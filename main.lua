-- LÖVE 0.10.2
function love.load()
    local joysticks = love.joystick.getJoysticks()
    joystick = joysticks[1]
 
    position = {x = 400, y = 300}
    speed = 300
    deadzone=0.15
    angle=0
    shipsize=8
    bulletSpeed = 500
    bulletlife=2
	bullets = {}
	maxbullets=1000
	bulletdelay=0.2
	delay=0
end
 
 function math.sign(x)
   if x<0 then
     return -1
   elseif x>0 then
     return 1
   else
     return 0
   end
end

function love.update(dt)
    if not joystick then return end
    -- Axes for my DS3 controller running XBOX drivers with SCP server on windows.
    leftX, leftY,  trigger, rightX, rightY = joystick:getAxes()
    if math.abs(leftX)<deadzone and math.abs(leftY)<deadzone then
    	leftX=0
    	leftY=0
    end
    if math.abs(rightX)<deadzone and math.abs(rightY)<deadzone then
    	rightX=0
    	rightY=0
    end

    if rightX == 0 and rightY == 0 then
    	angle=angle
    else
        angle=math.atan2(rightY, rightX)
    end
    position.x = position.x + speed * dt * leftX
    position.y = position.y + speed * dt * leftY
    delay = delay + dt
    if joystick.isGamepadDown(joystick, "rightshoulder") and #bullets<maxbullets and delay>bulletdelay then
    	delay=0
    	local bulletDx = bulletSpeed * math.cos(angle)
        local bulletDy = bulletSpeed * math.sin(angle)
        table.insert(bullets, {x = position.x, y = position.y, dx = bulletDx, dy = bulletDy,age=0})
    end
    for i=#bullets,1,-1 do
    	v=bullets[i]
		v.x = v.x + (v.dx * dt)
		v.y = v.y + (v.dy * dt)
		v.age=v.age+dt
		if v.age>bulletlife then
			table.remove(bullets, i)
		end
	end
end

function drawShip()
	love.graphics.line(position.x-math.cos(angle+1)*shipsize,position.y-math.sin(angle+1)*shipsize , position.x+math.cos(angle)*shipsize, position.y+math.sin(angle)*shipsize)
    love.graphics.line(position.x-math.cos(angle-1)*shipsize,position.y-math.sin(angle-1)*shipsize , position.x+math.cos(angle)*shipsize, position.y+math.sin(angle)*shipsize)
    love.graphics.line(position.x-math.cos(angle-1)*shipsize,position.y-math.sin(angle-1)*shipsize , position.x-math.cos(angle)*shipsize, position.y-math.sin(angle)*shipsize)
    love.graphics.line(position.x-math.cos(angle+1)*shipsize,position.y-math.sin(angle+1)*shipsize , position.x-math.cos(angle)*shipsize, position.y-math.sin(angle)*shipsize)
end
 
function love.draw()
	--love.graphics.print(leftX .. " " .. leftY,0,0)
	--love.graphics.print(rightX .. " " .. rightY,0,20)
	--love.graphics.print(position.x .. " " .. position.y,0,500)
    --love.graphics.circle("fill", position.x, position.y, 20)
    --love.graphics.line(position.x-math.cos(angle)*6,position.y-math.sin(angle)*6 , position.x+math.cos(angle)*6, position.y+math.sin(angle)*6)
    drawShip()
    for i,v in ipairs(bullets) do
		love.graphics.circle("fill", v.x, v.y, 3)
	end
end

-- function love.gamepadpressed( joystick, rightshoulder )
--     local bulletDx = bulletSpeed * math.cos(angle)
-- 	local bulletDy = bulletSpeed * math.sin(angle)
-- 	table.insert(bullets, {x = position.x, y = position.y, dx = bulletDx, dy = bulletDy,age=0})
-- end

-- function love.keypressed(key)
-- 	if key == "f" then
-- 		love.window.setFullscreen(true)
-- 	end
-- end


