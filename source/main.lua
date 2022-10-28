import 'libraries/noble/Noble'

import 'utilities/Utilities'

import 'scenes/SplashScene'
import 'scenes/MenuScene'
import 'scenes/GameScene'
import 'scenes/TutorialScene'

pd = playdate
gfx = pd.graphics

Noble.Settings.setup({
	-- Difficulty = "Uh Oh",
	singlePlayerHighScore = 0,
	twoPlayerHighScore = 0,
	perfectHighScore = 0,
	singlePlayerTutorial = false,
	twoPlayerTutorial = false,
	perfectTutorial = false
})

-- Noble.GameData.setup({
-- 	Score = 0
-- })

Noble.showFPS = false

Noble.new(SplashScene, 1.5, Noble.TransitionType.CROSS_DISSOLVE)