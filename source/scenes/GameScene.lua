GameScene = {}
class("GameScene").extends(NobleScene)

GameScene.baseColor = Graphics.kColorBlack

local snd = playdate.sound
local sequence

local difficultyValues = {"a", "b", "Up", "Down", "Left", "Right", "Crank \nforward", "Crank \nbackward"}

local currentTrack = 1

function newTrack(file)
	return playdate.sound.sampleplayer.new(file)
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

function GameScene:init()
	GameScene.super.init(self)
	next()
	local crankTick = 0

	GameScene.inputHandler = {
		upButtonDown = function()
			if currentGoal == "Up" then
				next()
			end
		end,
		downButtonDown = function()
			if currentGoal == "Down" then
				next()
			end
		end,
		leftButtonDown = function()
			if currentGoal == "Left" then
				next()
			end
		end,
		rightButtonDown = function()
			if currentGoal == "Right" then
				next()
			end
		end,
		cranked = function(change, acceleratedChange)
			crankTick = crankTick + change
			if (crankTick > 30) then
				crankTick = 0
				if currentGoal == "Crank \nforward" then
					next()
				end
			elseif (crankTick < -30) then
				crankTick = 0
				if currentGoal == "Crank \nbackward" then
					next()
				end
			end
		end,
		AButtonDown = function()
			if currentGoal == "a" then
				next()
			end
		end,
		BButtonDown = function()
			if currentGoal == "b" then
				next()
			end
		end
	}

end

function next()
	if currentTrack > 3 then
		currentTrack = 1
	end

	player = tracks[currentTrack]
	player:setVolume(1.0)
	player:play(1, 0)
	currentTrack += 1

	score += 1
	w = 20 + math.random(1, playdateWidth - 110)
	h = 35 + math.random(1, playdateHeight - 65)
	local r = math.random(1, #difficultyValues)

	currentGoal = difficultyValues[r]
	print(currentGoal)
end

function GameScene:enter()
	GameScene.super.enter(self)

	sequence = Sequence.new():from(0):to(100, 1.5, Ease.outBounce)
	sequence:start();

end

function GameScene:start()
	GameScene.super.start(self)

	Noble.Input.setCrankIndicatorStatus(false)
end

function GameScene:drawBackground()
	GameScene.super.drawBackground(self)

end

function GameScene:update()
	GameScene.super.update(self)

	Noble.Text.setFont(Noble.Text.FONT_LARGE)
	Noble.Text.draw(currentGoal, w, h)

	Noble.Text.draw(tostring(score), playdateWidth / 2, 10)

	playdate.graphics.setColor(playdate.graphics.kColorBlack);
	playdate.graphics.fillRect((playdateWidth / 2) - 45, 30, 100, 5)
end

function GameScene:exit()
	GameScene.super.exit(self)

	Noble.Input.setCrankIndicatorStatus(false)
	sequence = Sequence.new():from(100):to(240, 0.25, Ease.inSine)
	sequence:start();
end

function GameScene:finish()
	GameScene.super.finish(self)
end