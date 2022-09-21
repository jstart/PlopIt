MarathonScene = {}
class("MarathonScene").extends(NobleScene)

MarathonScene.baseColor = Graphics.kColorBlack

local menuItem
local snd = playdate.sound
local sequence

local difficultyValues = {"a", "b", "Up", "Down", "Left", "Right", "Crank \nforward", "Crank \nbackward"}

local currentTrack = 1

function newTrack(file)
	player = snd.sampleplayer.new(file)
	return player
end

local tracks =
{
	newTrack('assets/sounds/CongaHi'),
	newTrack('assets/sounds/CongaMid'),
	newTrack('assets/sounds/CongaLow')
}

local currentGoal

local w = math.random(1, playdateWidth - 130)
local h = math.random(1, playdateHeight - 100)
local score = 0

function MarathonScene:init()
	MarathonScene.super.init(self)
	MarathonScene:next()
	score = 0
	local crankTick = 0

	MarathonScene.inputHandler = {
		upButtonDown = function()
			if currentGoal == "Up" then
				MarathonScene:next()
			else
				MarathonScene:fail()
			end
		end,
		downButtonDown = function()
			if currentGoal == "Down" then
				MarathonScene:next()
			else
				MarathonScene:fail()
			end
		end,
		leftButtonDown = function()
			if currentGoal == "Left" then
				MarathonScene:next()
			else
				MarathonScene:fail()
			end
		end,
		rightButtonDown = function()
			if currentGoal == "Right" then
				MarathonScene:next()
			else
				MarathonScene:fail()
			end
		end,
		cranked = function(change, acceleratedChange)
			crankTick = crankTick + change
			if (crankTick > 30) then
				crankTick = 0
				if currentGoal == "Crank \nforward" then
					MarathonScene:next()
				else
					MarathonScene:fail()
				end
			elseif (crankTick < -30) then
				crankTick = 0
				if currentGoal == "Crank \nbackward" then
					MarathonScene:next()
				else
					MarathonScene:fail()
				end
			end
		end,
		AButtonDown = function()
			if currentGoal == "a" then
				MarathonScene:next()
			else
				MarathonScene:fail()
			end
		end,
		BButtonDown = function()
			if currentGoal == "b" then
				MarathonScene:next()
			else
				MarathonScene:fail()
			end
		end
	}

end

function MarathonScene:fail()
	player = newTrack('assets/sounds/fail')
	player:setVolume(1.0)
	player:play(1, 0)
	score = math.max(0, score -= 1)
end

function MarathonScene:next()
	if currentTrack > 3 then
		currentTrack = 1
	end

	player = tracks[currentTrack]
	player:setVolume(1.0)
	player:play(2, 0)
	currentTrack += 1

	score += 1
	w = 20 + math.random(1, playdateWidth - 110)
	h = 35 + math.random(1, playdateHeight - 65)
	local r = math.random(1, #difficultyValues)

	currentGoal = difficultyValues[r]
	-- print(currentGoal)
end

function MarathonScene:enter()
	MarathonScene.super.enter(self)

	sequence = Sequence.new():from(0):to(100, 1.5, Ease.outBounce)
	sequence:start();

end

function MarathonScene:start()
	MarathonScene.super.start(self)

	Noble.Input.setCrankIndicatorStatus(false)
	local menu = playdate.getSystemMenu()

	menuItem, error = menu:addMenuItem("Menu", function()
		Noble.transition(MenuScene, 1, Noble.TransitionType.DIP_WIDGET_SATCHEL)
		gameIsOver = true
		player = newTrack("assets/sounds/gameover")
		player:setVolume(1.0)
		player:play(1, 0)
	end)
end

function MarathonScene:drawBackground()
	MarathonScene.super.drawBackground(self)

end

function MarathonScene:update()
	MarathonScene.super.update(self)

	Noble.Text.setFont(Noble.Text.FONT_LARGE)
	Noble.Text.draw(currentGoal, w, h)

	Noble.Text.draw(tostring(score), playdateWidth / 2, 10)

	playdate.graphics.setColor(playdate.graphics.kColorBlack);
	playdate.graphics.fillRect(0, 30, playdateWidth, 5)
end

function MarathonScene:exit()
	MarathonScene.super.exit(self)

	Noble.Input.setCrankIndicatorStatus(false)
	sequence = Sequence.new():from(100):to(240, 0.25, Ease.inSine)
	sequence:start();
	local menu = playdate.getSystemMenu()
	menu:removeMenuItem(menuItem)
end

function MarathonScene:finish()
	MarathonScene.super.finish(self)
end