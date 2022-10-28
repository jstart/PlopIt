GameScene = {}
class("GameScene").extends(NobleScene)
GameScene.baseColor = Graphics.kColorBlack

-- goals = {"Ⓐ", "Ⓑ", "⬆️", "⬇️", "⬅️", "➡️", "🎣"}--"🎣 \n   backward"
goals = {"Ⓐ", "Ⓑ", "⬆️", "⬇️", "⬅️", "➡️", "🎣", "pass"}

-- 🟨 ⊙ 🔒 🎣 ✛ ⬆️ ➡️ ⬇️ ⬅️

tracks =
{
	newTrack('assets/sounds/CongaHi'),
	newTrack('assets/sounds/CongaMid'),
	newTrack('assets/sounds/CongaLow')
}

gameOver = newTrack("assets/sounds/gameover")
local passIt = newTrack('assets/sounds/pass')

local sequence
local gameOverSequence = Sequence.new():from(0):to(1,1.0,"outQuad"):callback(function() GameScene:gameOverTransition() end)

local currentGoal
local currentGoalIndex
local time = 30*60
local delay = 30
local gameIsOver = false
local menuItem

local currentTrack = 1

local w = math.random(1, playdateWidth - 120)
local h = 30 + math.random(1, playdateHeight - 130)

local score = 0

local fail = false
local failTime = 0
local isPassing = false
local passDelay = 0

local oopsImage
local passImage

function GameScene:init(gameMode)
	GameScene.super.init(self)
	oopsImage = gfx.image.new("assets/images/oops.png")
	passImage = gfx.image.new("assets/images/pass.png")

	local menu = pd.getSystemMenu()
	menuItem, error = menu:addMenuItem("Menu", function()
		GameScene:gameOver()
	end)

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
			-- if (crankTick > 30) then
			-- 	crankTick = 0
				GameScene:check(7)
			-- elseif (crankTick < -30) then
			-- 	crankTick = 0
			-- end
		end
	}

end

function GameScene:check(index)
	if isPassing then
		return
	end
	local goal = goals[index]
	if currentGoal == goal then
		GameScene:next()
	else
		GameScene:fail()
	end
end

function GameScene:fail()
	if delay > 0 then
		print("delay catch")
		return
	else
		delay = 30
	end

	if gameMode == "perfect" then
		GameScene:gameOver()
	end

	failTime = 30
	fail = true
	local player = newTrack('assets/sounds/fail')
	player:setVolume(1.0)
	player:play(1, 0)
	time = math.max(0, time -= 30)
	score -= 5
end

function GameScene:next()
	if fail == true then return end

	if currentGoalIndex == 7 then
		delay = 30
	end

	local r = math.random(1, #goals)
	if r == 8 and currentGoalIndex == 8 then
		GameScene:next()
		return
	end

	if r == 7 and currentGoalIndex == 7 and delay > 0 then
		print("catch") return
	end
	if r == 7 and delay > 0 then
		print("catch") return
	end

	if currentTrack > 3 then currentTrack = 1 end

	local player = tracks[currentTrack]
	player:setVolume(1.0)
	player:play(2, 0)
	currentTrack += 1

	score += 1

	playdate.setMenuImage(oopsImage, 100)
	GameScene:saveHighScore()
	w = 20 + math.random(1, playdateWidth - 120)
	h = 30 + math.random(1, playdateHeight - 130)

	if gameMode == "twoPlayer" then
		if r == 8 and isPassing == false then
			isPassing = true
			passDelay = 60
			if passDelay == 60 and not passIt:isPlaying() then
				passIt:setVolume(0.5)
				passIt:play()
				print(r, currentGoalIndex)
				print("pass it")
			end
			currentGoalIndex = r
			return
		end
	end	

	currentGoalIndex = r
	currentGoal = goals[r] .. ""
	print("current", currentGoal)
end

function GameScene:restart()
	time = 30*60
	score = 0
	gameIsOver = false
	fail = false

	goals = {"Ⓐ", "Ⓑ", "⬆️", "⬇️", "⬅️", "➡️", "🎣"}
	local r = math.random(1, #goals)

	if gameMode == "twoPlayer" then
		table.insert(goals, "pass")
	end

	currentGoal = goals[r] .. ""
	currentGoalIndex = r
end

function GameScene:enter()
	GameScene.super.enter(self)
	GameScene:restart()

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
	gameOverSequence.update()
	GameScene:renderTopUI()

	if time == 0 or score < 0 and gameIsOver == false then
		if gameMode == "perfect" then return end
		GameScene:gameOver()
	end

	if passDelay == 1 then
		passDelay = 0
		isPassing = false
		GameScene:next()
	end
	GameScene:updateTimes()

	gfx.setColor(gfx.kColorWhite);
	if fail or gameIsOver then
		oopsImage:drawCentered(playdateWidth/2,playdateHeight/2)
		return
	else
		GameScene:drawCurrentGoal()
	end

	-- gfx.setLineWidth(5)
	-- if currentGoal == "Crank \nforward" or currentGoal gfx== "Crank \nbackward" then
	-- 	gfx.drawRoundRect(w-17, h-17, 120, 50, 15)
	-- else
	-- 	gfx.drawRoundRect(w-17, h-17, 90, 50, 15)
	-- end
end

function GameScene:renderTopUI()
	if gameMode == "perfect" then
		Noble.Text.setFont(Noble.Text.FONT_LARGE)
		Noble.Text.draw("Score: " .. tostring(math.max(0, score)), (playdateWidth / 2) - 40, 10)
		return
	end
	Noble.Text.setFont(Noble.Text.FONT_LARGE)
	gfx.setColor(gfx.kColorBlack);
	Noble.Text.draw("Time: " .. tostring(math.floor(time/30)), (playdateWidth / 2) - 40, 10)
	Noble.Text.draw("Score: " .. tostring(math.max(0, score)), 10, 10)
	gfx.fillRect(0, 30, playdateWidth, 5)
end

function GameScene:drawCurrentGoal()
	if isPassing then
		passImage:drawCentered(playdateWidth/2,playdateHeight/2)
		return
	end
	local font = gfx.getSystemFont(gfx.font.kVariantNormal)
	local goalImage = font:getGlyph(currentGoal)
	if goalImage ~= nil then
		goalImage:drawScaled(w, h, 5)
	end
end

function GameScene:updateTimes()
	time = math.max(0, time - 1)
	delay = math.max(0, delay - 1)
	passDelay = math.max(0, passDelay - 1)
	failTime = math.max(0, failTime - 1)

	fail = failTime > 0
	isPassing = passDelay > 0
end

function GameScene:saveHighScore()
	local highScoreKey = gameMode.."HighScore"
	local currentHighScore = Noble.Settings.get(highScoreKey)
	Noble.Settings.set(highScoreKey, math.max(score, currentHighScore))
end

function GameScene:gameOver()
	gameIsOver = true
	fail = true
	gameOverSequence:start()
end

function GameScene:gameOverTransition()
	if not Noble.isTransitioning then
		Noble.transition(MenuScene, 2, Noble.TransitionType.DIP_WIDGET_SATCHEL)
		gameOver:setVolume(1.0)
		gameOver:play(1, 0)
	end
end

function GameScene:exit()
	GameScene.super.exit(self)
	Noble.Input.setCrankIndicatorStatus(false)
	sequence = Sequence.new():from(100):to(240, 0.25, Ease.inSine)
	sequence:start();

	GameScene:saveHighScore()
end

function GameScene:finish()
	GameScene.super.finish(self)
	fail = false

	local menu = pd.getSystemMenu()
	menu:removeMenuItem(menuItem)
end