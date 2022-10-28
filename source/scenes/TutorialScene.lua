TutorialScene = {}
class("TutorialScene").extends(NobleScene)

TutorialScene.baseColor = Graphics.kColorBlack

local sequence

function TutorialScene:init()
	TutorialScene.super.init(self)

	TutorialScene.inputHandler = {
		AButtonDown = function()
			TutorialScene:continue()
		end,
		BButtonDown = function()
			TutorialScene:continue()
		end
	}

end

function TutorialScene:enter()
	TutorialScene.super.enter(self)

	sequence = Sequence.new():from(0):to(100, 1.5, Ease.outBounce)
	sequence:start();

	tutorialBanter:setVolume(0.6)
	tutorialBanter:play(1)
end

function TutorialScene:start()
	TutorialScene.super.start(self)
end

function TutorialScene:drawBackground()
	TutorialScene.super.drawBackground(self)
end

function TutorialScene:continue()
	TutorialScene:saveTutorialState()
	Noble.transition(GameScene, 1, Noble.TransitionType.DIP_TO_BLACK)
end

function TutorialScene:update()
	TutorialScene.super.update(self)

	Noble.Text.setFont(Noble.Text.FONT_LARGE)
	local text = ""
	if gameMode == "singlePlayer" then
		text = "60 seconds\n\nMiss: -5 points\n          -1 second\n\nGood luck!"
	elseif gameMode == "twoPlayer" then
		text = "When you see *PASS*, PASS it!\n\n60 seconds\n\nMiss: -5 points\n          -1 second\n\nGood luck!"
	elseif gameMode == "perfect" then
		text = "Miss a single button,\n\n*GAME OVER*\n\nGood luck!"
	end
	Noble.Text.draw(text, (playdateWidth / 2), 10, Noble.Text.ALIGN_CENTER)
	Noble.Text.draw("Press", playdateWidth/2 - 75, playdateHeight/2 + 40 + 15)

	local font = gfx.getSystemFont(gfx.font.kVariantNormal)
	local buttonImage = font:getGlyph("Ⓐ")
	buttonImage:drawScaled(playdateWidth/2, playdateHeight/2 + 15, 5)
end

function TutorialScene:saveTutorialState()
	Noble.Settings.set(gameMode.."Tutorial", true)
end

function TutorialScene:exit()
	TutorialScene.super.exit(self)
	tutorialBanter:setVolume(0)
end

function TutorialScene:finish()
	TutorialScene.super.finish(self)
end