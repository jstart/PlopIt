MenuScene = {}
class("MenuScene").extends(NobleScene)

MenuScene.baseColor = Graphics.kColorBlack

local background
local menu
local sequence

function newTrack(file)
	return playdate.sound.fileplayer.new(file)
end

local bgMusic = newTrack('assets/sounds/puzzleitnes')

-- local difficultyValues = {"Wow", "Uh Oh", "*#$#%@!"}

function MenuScene:init()
	MenuScene.super.init(self)

	background = Graphics.image.new("assets/images/background1")
	timedTitle = "Timed Mode - High Score: " .. tostring(Noble.Settings.get("timerHighScore"))
	marathonTitle = "Marathon Mode - High Score: " .. tostring(Noble.Settings.get("marathonHighScore"))
	menu = Noble.Menu.new(false, Noble.Text.ALIGN_LEFT, false, Graphics.kColorWhite, 4,6,0, Noble.Text.FONT_LARGE)

	menu:addItem(timedTitle, function() Noble.transition(GameScene, 1, Noble.TransitionType.DIP_TO_BLACK) end)
	menu:addItem(marathonTitle, function() Noble.transition(MarathonScene, 1, Noble.TransitionType.DIP_TO_BLACK) end)
	-- menu:addItem(
	-- 	"Difficulty",
	-- 	function()
	-- 		local oldValue = Noble.Settings.get("Difficulty")
	-- 		local newValue = math.ringInt(table.indexOfElement(difficultyValues, oldValue)+1, 1, 3)
	-- 		Noble.Settings.set("Difficulty", difficultyValues[newValue])
	-- 		menu:setItemDisplayName("Difficulty", "Difficulty: " .. difficultyValues[newValue])
	-- 	end,
	-- 	nil,
	-- 	"Difficulty: " .. Noble.Settings.get("Difficulty")
	-- )

	local crankTick = 0

	MenuScene.inputHandler = {
		upButtonDown = function()
			menu:selectPrevious()
		end,
		downButtonDown = function()
			menu:selectNext()
		end,
		cranked = function(change, acceleratedChange)
			crankTick = crankTick + change
			if (crankTick > 30) then
				crankTick = 0
				menu:selectNext()
			elseif (crankTick < -30) then
				crankTick = 0
				menu:selectPrevious()
			end
		end,
		AButtonDown = function()
			menu:click()
		end
	}

end

function MenuScene:enter()
	MenuScene.super.enter(self)

	sequence = Sequence.new():from(0):to(100, 1.0, Ease.outBounce)
	sequence:start();

end

function MenuScene:start()
	MenuScene.super.start(self)
	bgMusic:setVolume(0.4)
	bgMusic:play(0)

	menu:activate()
	-- Noble.Input.setCrankIndicatorStatus(true)
end

-- function MenuScene:drawBackground()
-- 	MenuScene.super.drawBackground(self)

-- 	background:draw(0, 0)
-- end

function MenuScene:update()
	MenuScene.super.update(self)
	Noble.Text.setFont(Noble.Text.FONT_LARGE)

	gfx.setColor(gfx.kColorBlack);
	Noble.Text.draw("Plop  It", 10, 10)

	Graphics.setDitherPattern(0.2, Graphics.image.kDitherTypeScreen)
	Graphics.fillRoundRect(0, (sequence:get()*0.75), pd.display.getWidth(), pd.display.getHeight(), 15)
	menu:draw(30, sequence:get()-15 or 100-15)

end

function MenuScene:exit()
	MenuScene.super.exit(self)

	-- Noble.Input.setCrankIndicatorStatus(false)
	sequence = Sequence.new():from(100):to(240, 0.25, Ease.inSine)
	sequence:start();

end

function MenuScene:finish()
	MenuScene.super.finish(self)
end