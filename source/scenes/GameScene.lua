GameScene = {}
class("GameScene").extends(NobleScene)

GameScene.baseColor = Graphics.kColorBlack

local currentGoal

local snd = playdate.sound
local sequence
local time = 60 * 60
local gameIsOver = false
local menuItem

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

local w = math.random(1, playdateWidth - 130)
local h = math.random(1, playdateHeight - 100)
local score = 0

function GameScene:init()
	GameScene.super.init(self)
	GameScene:next()
	local crankTick = 0

	GameScene.inputHandler = {
		upButtonDown = function()
			if currentGoal == "Up" then
				GameScene:next()
			else
				GameScene:fail()
			end
		end,
		downButtonDown = function()
			if currentGoal == "Down" then
				GameScene:next()
			else
				GameScene:fail()
			end
		end,
		leftButtonDown = function()
			if currentGoal == "Left" then
				GameScene:next()
			else
				GameScene:fail()
			end
		end,
		rightButtonDown = function()
			if currentGoal == "Right" then
				GameScene:next()
			else
				GameScene:fail()
			end
		end,
		cranked = function(change, acceleratedChange)
			crankTick = crankTick + change
			if (crankTick > 30) then
				crankTick = 0
				if currentGoal == "Crank \nforward" then
					GameScene:next()
				else
					GameScene:fail()
				end
			elseif (crankTick < -30) then
				crankTick = 0
				if currentGoal == "Crank \nbackward" then
					GameScene:next()
				else
					GameScene:fail()
				end
			end
		end,
		AButtonDown = function()
			if currentGoal == "a" then
				GameScene:next()
			else
				GameScene:fail()
			end
		end,
		BButtonDown = function()
			if currentGoal == "b" then
				GameScene:next()
			else
				GameScene:fail()
			end
		end
	}

end

function GameScene:fail()
	player = newTrack('assets/sounds/fail')
	player:setVolume(1.0)
	player:play(1, 0)
	time = math.max(0, time -= 60)
end

function GameScene:next()
	time += 60

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

	currentGoal = difficultyValues[r] .. ""
end

function GameScene:enter()
	GameScene.super.enter(self)

	sequence = Sequence.new():from(0):to(100, 1.5, Ease.outBounce)
	sequence:start();
end

function GameScene:start()
	GameScene.super.start(self)
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

function GameScene:drawBackground()
	GameScene.super.drawBackground(self)

end

function GameScene:update()
	GameScene.super.update(self)

	Noble.Text.setFont(Noble.Text.FONT_LARGE)
	Noble.Text.draw(currentGoal, w, h)

	Noble.Text.draw(tostring(math.floor(time/60)), playdateWidth / 2, 10)

	playdate.graphics.setColor(playdate.graphics.kColorBlack);
	playdate.graphics.fillRect(0, 30, playdateWidth, 5)
	
	if time == 0 and gameIsOver == false then
		gameIsOver = true
		player = newTrack("assets/sounds/gameover")
		player:setVolume(1.0)
		player:play(1, 0)
		print("return to menu")
		Noble.transition(MenuScene, 1, Noble.TransitionType.DIP_WIDGET_SATCHEL)
		return
	end

	time = math.max(0, time - 1)

end

function GameScene:exit()
	GameScene.super.exit(self)

	Noble.Input.setCrankIndicatorStatus(false)
	sequence = Sequence.new():from(100):to(240, 0.25, Ease.inSine)
	sequence:start();
	local menu = playdate.getSystemMenu()
	menu:removeMenuItem(menuItem)
end

function GameScene:finish()
	GameScene.super.finish(self)
end