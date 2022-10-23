SplashScene = {}
class("SplashScene").extends(NobleScene)

SplashScene.baseColor = Graphics.kColorBlack

bgMusic = newTrack('assets/sounds/puzzleitnes')

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
end


function SplashScene:update()
	SplashScene.super.update(self)

	background = playdate.graphics.image.new("assets/images/logo.png")
	background:drawCentered(playdateWidth/2,playdateHeight/2)

	playdate.graphics.setColor(Graphics.kColorBlack)
	playdate.graphics.setPattern({0xFF, 0xFF, 0xF7, 0xEF, 0xDF, 0xBF, 0x7F, 0xFF})
	playdate.graphics.drawRect(0,0,playdateWidth, playdateHeight)
	Noble.Text.setFont(Noble.Text.FONT_LARGE)

	gfx.setColor(gfx.kColorBlack);
	Noble.Text.draw("Press A", 10, playdateHeight - 50)
end

function SplashScene:exit()
	SplashScene.super.exit(self)

	sequence = Sequence.new():from(100):to(240, 0.25, Ease.inSine)
	sequence:start();
end

function SplashScene:finish()
	SplashScene.super.finish(self)
end
