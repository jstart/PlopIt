MarathonScene = {}
class("MarathonScene").extends(NobleScene)

MarathonScene.baseColor = Graphics.kColorBlack

local menuItem
local sequence

goals = {"a", "b", "Up", "Down", "Left", "Right", "Crank \nforward", "Crank \nbackward"}

local currentTrack = 1

tracks =
{
	newTrack('assets/sounds/CongaHi'),
	newTrack('assets/sounds/CongaMid'),
	newTrack('assets/sounds/CongaLow')
}

gameOver = newTrack("assets/sounds/gameover")

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
			MarathonScene:check("Up")
		end,
		downButtonDown = function()
			MarathonScene:check("Down")
		end,
		leftButtonDown = function()
			MarathonScene:check("Left")
		end,
		rightButtonDown = function()
			MarathonScene:check("Right")
		end,
		cranked = function(change, acceleratedChange)
			crankTick = crankTick + change
			if (crankTick > 30) then
				crankTick = 0
				MarathonScene:check("Crank \nforward")
			elseif (crankTick < -30) then
				crankTick = 0
				MarathonScene:check("Crank \nbackward")
			end
		end,
		AButtonDown = function()
			MarathonScene:check("a")
		end,
		BButtonDown = function()
			MarathonScene:check("b")
		end
	}

end

function MarathonScene:check(goal)
	if currentGoal == goal then
		MarathonScene:next()
	else
		MarathonScene:fail()
	end
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
	local r = math.random(1, #goals)

	currentGoal = goals[r]
end

function MarathonScene:enter()
	MarathonScene.super.enter(self)

	sequence = Sequence.new():from(0):to(100, 1.5, Ease.outBounce)
	sequence:start();
end

function MarathonScene:start()
	MarathonScene.super.start(self)

	Noble.Input.setCrankIndicatorStatus(false)
	local menu = pd.getSystemMenu()

	menuItem, error = menu:addMenuItem("Menu", function()
		Noble.transition(MenuScene, 1, Noble.TransitionType.DIP_WIDGET_SATCHEL)
		gameIsOver = true

		gameOver:setVolume(1.0)
		gameOver:play(1, 0)
	end)
end

function MarathonScene:drawBackground()
	MarathonScene.super.drawBackground(self)
end

function MarathonScene:update()
	MarathonScene.super.update(self)

	Noble.Text.setFont(Noble.Text.FONT_LARGE)

	if score > 20 then
		Noble.Text.setFont(Noble.Text.FONT_MEDIUM)
	end
	if score > 40 then
		Noble.Text.setFont(Noble.Text.FONT_SMALL)
	end
	Noble.Text.draw(currentGoal, w, h)

	Noble.Text.setFont(Noble.Text.FONT_LARGE)
	Noble.Text.draw("Score: " .. tostring(score), (playdateWidth / 2) - 40, 10)

	gfx.setColor(gfx.kColorBlack);
	gfx.fillRect(0, 30, playdateWidth, 5)
end

function MarathonScene:saveHighScore()
	currentHighScore = Noble.Settings.get("marathonHighScore")
	Noble.Settings.set("marathonHighScore", math.max(score, currentHighScore))
end

function MarathonScene:exit()
	MarathonScene.super.exit(self)

	Noble.Input.setCrankIndicatorStatus(false)
	sequence = Sequence.new():from(100):to(240, 0.25, Ease.inSine)
	sequence:start();

	local menu = pd.getSystemMenu()
	menu:removeMenuItem(menuItem)

	MarathonScene:saveHighScore()
end

function MarathonScene:finish()
	MarathonScene.super.finish(self)
end