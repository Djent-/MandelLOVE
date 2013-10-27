-- http://processing.org/examples/mandelbrot.html

function love.load()
	key = 0
	mult = 23.8
	xmin = -3
	ymin = -1.25
	w = 5
	h = 2.5
	iters = 100
	step1 = 0.105
	step2 = 0.180
	step3 = 0.362
	step4 = 0.65
	xmax = xmin + w
	ymax = ymin + h
	love.graphics.setMode(1280,720)
	love.graphics.setBackgroundColor(255,255,255)
	dx = (xmax - xmin) / love.graphics.getWidth()
	dy = (ymax - ymin) / love.graphics.getHeight()
	mandelbrot()
	love.draw()
	love.graphics.setColor(255,255,255)
	love.graphics.print("mult = " .. mult,10,10)
	love.graphics.present()
end

function love.run()

    math.randomseed(os.time())
    math.random() math.random()

    if love.load then love.load(arg) end

    local dt = 0

    -- Main loop time.
    while true do
        -- Process events.
        if love.event then
            love.event.pump()
            for e,a,b,c,d in love.event.poll() do
                if e == "quit" then
                    if not love.quit or not love.quit() then
                        if love.audio then
                            love.audio.stop()
                        end
                        return
                    end
                end
                love.handlers[e](a,b,c,d)
            end
        end

        -- Update dt, as we'll be passing it to update
        if love.timer then
            love.timer.step()
            dt = love.timer.getDelta()
        end

        -- Call update and draw
        if love.update then love.update(dt) end -- will pass 0 if love.timer is disabled
        if love.graphics then
            --love.graphics.clear()
            --if love.draw then love.draw() end
        end

        if love.timer then love.timer.sleep(0.001) end
        --if love.graphics then love.graphics.present() end

    end

end

function love.draw()
	addToCanvas()
end

function love.update(dt)
	if love.keyboard.isDown("-") then
		if love.timer.getTime() - key > .1 then
			mult = mult - .1
			key = love.timer.getTime()
			love.graphics.setColor(255,255,255)
			love.graphics.print("LOADING", 640, 360)
			love.graphics.present()
			mandelbrot()
			love.draw()
			love.graphics.setColor(255,255,255)
			love.graphics.print("mult = " .. mult, 10,10)
			love.graphics.present()
		end
	elseif love.keyboard.isDown("=") and love.keyboard.isDown("rshift") then
		if love.timer.getTime() - key > .1 then
			mult = mult + .1
			key = love.timer.getTime()
			love.graphics.setColor(255,255,255)
			love.graphics.print("LOADING", 640, 360)
			love.graphics.present()
			mandelbrot()
			addToCanvas()
			love.graphics.setColor(255,255,255)
			love.graphics.print("mult = " .. mult,10,10)
			love.graphics.present()
		end
	end
end

function addToCanvas()
	for v = 0, #pixels do
		love.graphics.setColor(pixels[v][1],pixels[v][2],pixels[v][3])
		love.graphics.point(ZtoXandY(v))
	end
end

function ZtoXandY(z)
	local x,y = 0,0
	while z > 1281 do z = z - 1281; y = y + 1 end
	x = z
	return x-1, y
end

function mandelbrot()
	pixels = {}
	y = ymin
	local d = 0
	for o = 0, love.graphics.getHeight() do
		x = xmin
		for p = 0, love.graphics.getWidth() do
			local a = x
			local b = y
			local n = 0
			while n < iters do
				aa = a^2
				bb = b^2
				t = 2*a*b
				a = a^2 - b^2 + x
				b = t + y
				if aa + bb > 16 then
					break
				end
				n = n + 1
			end
			if n == iters then
				pixels[d] = {0,0,0}
				d = d + 1
			else
				if n >= 0 and n < iters*step1 then
					pixels[d] = {(n*mult-2) % 255,0,0}
				elseif n >= iters*step1 and n < iters*step2 then
					pixels[d] = {255-((n*mult-2) % 255),(n*mult) % 255,0}
				elseif n >= iters*step2 and n < iters*step3 then
					pixels[d] = {0,(n*mult) % 255,0}
				elseif n >= iters*step3 and n < iters*step4 then
					pixels[d] = {0,0,(n*mult) % 255}
				else
					pixels[d] = {(n*mult) % 255,0,(n*mult) % 255}
				end
				d = d + 1
			end
			x = x + dx
		end
		y = y + dy
	end
end