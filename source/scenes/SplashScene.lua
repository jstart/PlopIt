SplashScene = {}
class("SplashScene").extends(NobleScene)

SplashScene.baseColor = Graphics.kColorBlack

bgMusic = newTrack('assets/sounds/puzzleitnes')
bopIt = newTrack('assets/sounds/Bop')
banter = newTrack('assets/sounds/Banter_16')
tutorialBanter = newTrack('assets/sounds/Banter_56')

function SplashScene:init()
	SplashScene.super.init(self)

	SplashScene.inputHandler = {
		AButtonDown = function()
			Noble.transition(MenuScene, 1, Noble.TransitionType.DIP_WIDGET_SATCHEL)
		end
	}
end

function SplashScene:enter()
	SplashScene.super.enter(self)

	sequence = Sequence.new():from(0):to(playdateHeight, 1.0, Ease.outBounce)
	sequence:start();
end

function SplashScene:start()
	SplashScene.super.start(self)
	bgMusic:setVolume(0.4)
	bgMusic:play(0)
	
	bopIt:setVolume(0.6)
	bopIt:play(1)
	-- bopIt:setFinishCallback(nextSound)
end

function nextSound(...)
	
	bopIt:setFinishCallback(nil)
end

function SplashScene:update()
	SplashScene.super.update(self)

	local background = gfx.image.new("assets/images/logo.png")
	background:drawCentered(playdateWidth/2,playdateHeight/2)

	gfx.setColor(Graphics.kColorBlack)
	gfx.setPattern({0xFF, 0xFF, 0xF7, 0xEF, 0xDF, 0xBF, 0x7F, 0xFF})
	gfx.drawRect(0,0,playdateWidth, playdateHeight)
	Noble.Text.setFont(Noble.Text.FONT_LARGE)

	gfx.setColor(gfx.kColorBlack);
	Noble.Text.draw("Press Ⓐ", 10, playdateHeight - 50)
end

function SplashScene:exit()
	SplashScene.super.exit(self)
	bopIt:setVolume(0)
	sequence = Sequence.new():from(100):to(240, 0.25, Ease.inSine)
	sequence:start();
end

function SplashScene:finish()
	SplashScene.super.finish(self)
end
