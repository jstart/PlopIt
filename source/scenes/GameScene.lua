GameScene = {}
class("GameScene").extends(NobleScene)

GameScene.baseColor = Graphics.kColorBlack
local sequence

local currentGoal
local time = 30*60
local delay = 30
local gameIsOver = false
local menuItem

local currentTrack = 1

local w = math.random(1, playdateWidth - 130)
local h = math.random(1, playdateHeight - 100)
local score = 0

local fail = false
local failTime = 0

function GameScene:init()
	GameScene.super.init(self)
	local crankTick = 0

	GameScene.inputHandler = {
		AButtonDown = function()
			GameScene:check(1)
		end,
		BButtonDown = function()
			GameScene:check(2)
		end,
		upButtonDown = function()
			GameScene:check(3)
		end,
		downButtonDown = function()
			GameScene:check(4)
		end,
		leftButtonDown = function()
			GameScene:check(5)
		end,
		rightButtonDown = function()
			GameScene:check(6)
		end,
		cranked = function(change, acceleratedChange)
			crankTick = crankTick + change
			if (crankTick > 30) then
				crankTick = 0
				GameScene:check(7)
			elseif (crankTick < -30) then
				crankTick = 0
				GameScene:check(8)
			end
		end
	}

end

function GameScene:check(index)
	local goal = goals[index]
	if currentGoal == goal then
		GameScene:next()
	else
		GameScene:fail()
	end
end

function GameScene:fail()
	failTime = 30
	fail = true
	print(fail)
	if delay > 0 then
		print("delay catch")
		return
	else
		delay = 30
	end
	player = newTrack('assets/sounds/fail')
	player:setVolume(1.0)
	player:play(1, 0)
	time = math.max(0, time -= 30)
	score -= 5
end

function GameScene:next()
	time += 30

	if currentTrack > 3 then
		currentTrack = 1
	end

	if fail == true then
		return
	end

	player = tracks[currentTrack]
	player:setVolume(1.0)
	player:play(2, 0)
	currentTrack += 1

	score += 1
	GameScene:saveHighScore()
	w = 20 + math.random(1, playdateWidth - 120)
	h = 40 + math.random(1, playdateHeight - 65)
	local r = math.random(1, #goals)

	currentGoal = goals[r] .. ""
end

function GameScene:enter()
	GameScene.super.enter(self)

	GameScene:next()
	score = 0
	gameIsOver = false
	fail = false
	print(fail)
	sequence = Sequence.new():from(0):to(100, 1.5, Ease.outBounce)
	sequence:start();
end

function GameScene:start()
	GameScene.super.start(self)
	Noble.Input.setCrankIndicatorStatus(false)

	local menu = pd.getSystemMenu()

	menuItem, error = menu:addMenuItem("Menu", function()
		Noble.transition(MenuScene, 1, Noble.TransitionType.DIP_WIDGET_SATCHEL)
		gameIsOver = true

		gameOver:setVolume(1.0)
		gameOver:play(1, 0)
	end)
end

function GameScene:drawBackground()
	GameScene.super.drawBackground(self)
end

function GameScene:update()
	GameScene.super.update(self)
	Noble.Text.setFont(Noble.Text.FONT_LARGE)

	-- if score > 20 then
	-- 	Noble.Text.setFont(Noble.Text.FONT_MEDIUM)
	-- end
	-- if score > 40 then
	-- 	Noble.Text.setFont(Noble.Text.FONT_SMALL)
	-- end

	gfx.setColor(gfx.kColorWhite);
	if fail == true then
		Noble.Text.draw("OOPS", (playdateWidth / 2), (playdateHeight / 2))
	else
		Noble.Text.draw(currentGoal, w, h)
	end
	Noble.Text.draw(currentGoal, w, h)

	Noble.Text.setFont(Noble.Text.FONT_LARGE)
	gfx.setColor(gfx.kColorBlack);
	-- gfx.setLineWidth(5)
	-- if currentGoal == "Crank \nforward" or currentGoal == "Crank \nbackward" then
	-- 	gfx.drawRoundRect(w-17, h-17, 120, 50, 15)
	-- else
	-- 	gfx.drawRoundRect(w-17, h-17, 90, 50, 15)
	-- end

	Noble.Text.draw("Time: " .. tostring(math.floor(time/30)), (playdateWidth / 2) - 40, 10)
	Noble.Text.draw("Score: " .. tostring(math.max(0, score)), 10, 10)

	gfx.fillRect(0, 30, playdateWidth, 5)

	if time == 0 or score < 0 and gameIsOver == false then
		gameIsOver = true
		if not Noble.isTransitioning then
			Noble.transition(MenuScene, 1, Noble.TransitionType.DIP_WIDGET_SATCHEL)
			player = newTrack("assets/sounds/gameover")
			player:setVolume(1.0)
			player:play(1, 0)
		end
	end

	time = math.max(0, time - 1)
	delay = math.max(0, delay - 1)

	failTime = math.max(0, failTime - 1)
	fail = failTime > 0
end

function GameScene:saveHighScore()
	currentHighScore = Noble.Settings.get("timerHighScore")
	Noble.Settings.set("timerHighScore", math.max(score, currentHighScore))
end

function GameScene:exit()
	GameScene.super.exit(self)
	fail = false
	Noble.Input.setCrankIndicatorStatus(false)
	sequence = Sequence.new():from(100):to(240, 0.25, Ease.inSine)
	sequence:start();

	local menu = pd.getSystemMenu()
	menu:removeMenuItem(menuItem)

	GameScene:saveHighScore()
end

function GameScene:finish()
	GameScene.super.finish(self)
end