MenuScene = {}
class("MenuScene").extends(NobleScene)

MenuScene.baseColor = Graphics.kColorBlack

local menu
local sequence

-- local difficultyValues = {"Wow", "Uh Oh", "*#$#%@!"}
local x = 0
local y = 150
local right = true

function MenuScene:init()
	MenuScene.super.init(self)

	local timedTitle = "Timed Mode - High Score: " .. tostring(Noble.Settings.get("timerHighScore"))
	-- local twoPlayerTitle = "2 Player - High Score: " .. tostring(Noble.Settings.get("twoHighScore"))
	local marathonTitle = "Marathon Mode - High Score: " .. tostring(Noble.Settings.get("marathonHighScore"))
	menu = Noble.Menu.new(false, Noble.Text.ALIGN_LEFT, false, Graphics.kColorWhite, 4,6,0, Noble.Text.FONT_LARGE)

	menu:addItem(timedTitle, function() Noble.transition(GameScene, 1, Noble.TransitionType.DIP_TO_BLACK) end)
	-- menu:addItem(twoPlayerTitle, function() Noble.transition(GameScene, 1, Noble.TransitionType.DIP_TO_BLACK) end)
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

	sequence = Sequence.new():from(0):to(200, 1.0, Ease.outBounce)
	sequence:start();
end

function MenuScene:start()
	MenuScene.super.start(self)
	if not bgMusic:isPlaying() then
		bgMusic:play(0)
	end

	menu:activate()
	-- Noble.Input.setCrankIndicatorStatus(true)
end


function MenuScene:update()
	MenuScene.super.update(self)
	-- Noble.Text.setFont(Noble.Text.FONT_LARGE)

	-- gfx.setColor(gfx.kColorBlack);
	-- Noble.Text.draw("Plop  It", 10, 10)
	-- Graphics.setDitherPattern(0.2, Graphics.image.kDitherTypeScreen)
	Graphics.fillRoundRect(0, (sequence:get()*0.75), pd.display.getWidth(), pd.display.getHeight(), 15)
	menu:draw(30, sequence:get()-15 or 100-15)

	for col=1,18 do
		for row=1,12 do
			-- playdate.graphics.drawRect(0+(col*20),50 + y,15,15)
		end
	end

	for row=1,6 do
		rectY = math.max((row*20),10)
		Noble.Text.draw("🟨 ⊙ 🔒 🎣 ✛ ⬆️ ➡️ ⬇️ ⬅️ ✛ 🎣 🔒 ⊙ 🟨", 10 + x, rectY)
	end
	-- x += 5
	if x == 10 then
		right = false
	elseif x == 0 then
		right = true
	end
	
	if right then
		x += 0.5
	else
		x -= 0.5
	end
end

function MenuScene:exit()
	MenuScene.super.exit(self)

	sequence = Sequence.new():from(100):to(240, 0.25, Ease.inSine)
	sequence:start();
end

function MenuScene:finish()
	MenuScene.super.finish(self)
end
