MarathonScene = {}
class("MarathonScene").extends(NobleScene)

MarathonScene.baseColor = Graphics.kColorBlack

local menuItem
local sequence
local gameIsOver
-- goals = {"a", "b", "Up", "Down", "Left", "Right", "Crank \nforward", "Crank \nbackward"}
-- goals = {"a", "B", "⬆", "⬇", "⬅", "rIgHt", "Crank \nforward", "Crank \n⬅"} --🔙↩︎➡
goals = {"a", "b", "⬆️", "⬇️", "⬅️", "➡️", "🎣 \n   forward", "🎣 \n   backward"}

-- 🟨 ⊙ 🔒 🎣 ✛ ⬆️ ➡️ ⬇️ ⬅️
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

local gameIsOver = false
local fail = false
local failTime = 0

function MarathonScene:init()
	MarathonScene.super.init(self)
	MarathonScene:next()
	score = 0
	local crankTick = 0

	MarathonScene.inputHandler = {
		AButtonDown = function()
			MarathonScene:check(1)
		end,
		BButtonDown = function()
			MarathonScene:check(2)
		end,
		upButtonDown = function()
			MarathonScene:check(3)
		end,
		downButtonDown = function()
			MarathonScene:check(4)
		end,
		leftButtonDown = function()
			MarathonScene:check(5)
		end,
		rightButtonDown = function()
			MarathonScene:check(6)
		end,
		cranked = function(change, acceleratedChange)
			crankTick = crankTick + change
			if (crankTick > 30) then
				crankTick = 0
				MarathonScene:check(7)
			elseif (crankTick < -30) then
				crankTick = 0
				MarathonScene:check(8)
			end
		end
	}

end

function MarathonScene:check(index)
	local goal = goals[index]
	if currentGoal == goal then
		MarathonScene:next()
	else
		MarathonScene:fail()
	end
end

function MarathonScene:fail()
	failTime = 60
	fail = true
	player = newTrack('assets/sounds/fail')
	player:setVolume(1.0)
	player:play(1, 0)
	score = score -= 5
end

function MarathonScene:next()
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
	w = 20 + math.random(1, playdateWidth - 110)
	h = 35 + math.random(1, playdateHeight - 65)
	local r = math.random(1, #goals)

	currentGoal = goals[r]
end

function MarathonScene:enter()
	MarathonScene.super.enter(self)

	score = 0
	gameIsOver = false
	fail = false

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

	-- if score > 20 then
	-- 	Noble.Text.setFont(Noble.Text.FONT_MEDIUM)
	-- elseif score > 40 then
	-- 	Noble.Text.setFont(Noble.Text.FONT_SMALL)
	-- end

	print(score, gameIsOver)
	if score < 0 and gameIsOver == false then
		gameIsOver = true
		fail = false
		if not Noble.isTransitioning then
			Noble.transition(MenuScene, 1, Noble.TransitionType.DIP_WIDGET_SATCHEL)
			player = newTrack("assets/sounds/gameover")
			player:setVolume(1.0)
			player:play(1, 0)
		end
	end

	if fail == true then
		Noble.Text.draw("OOPS", (playdateWidth / 2), (playdateHeight / 2))
	else
		Noble.Text.draw(currentGoal, w, h)
	end

	Noble.Text.setFont(Noble.Text.FONT_LARGE)
	Noble.Text.draw("Score: " .. tostring(math.max(0, score)), (playdateWidth / 2) - 40, 10)

	gfx.setColor(gfx.kColorBlack);
	gfx.fillRect(0, 30, playdateWidth, 5)

	failTime = math.max(0, failTime - 1)
	fail = failTime > 0
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