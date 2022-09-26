import 'libraries/noble/Noble'

import 'utilities/Utilities'

import 'scenes/MenuScene'
import 'scenes/GameScene'
import 'scenes/MarathonScene'

pd = playdate
gfx = pd.graphics

Noble.Settings.setup({
	-- Difficulty = "Uh Oh",
	timerHighScore = 0,
	marathonHighScore = 0
})

-- Noble.GameData.setup({
-- 	Score = 0
-- })

Noble.showFPS = false

Noble.new(MenuScene, 1.5, Noble.TransitionType.CROSS_DISSOLVE)