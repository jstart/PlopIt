import 'libraries/noble/Noble'

import 'utilities/Utilities'

import 'scenes/MenuScene'
import 'scenes/GameScene'

Noble.Settings.setup({
	Difficulty = "Uh Oh"
})

Noble.GameData.setup({
	Score = 0
})

Noble.showFPS = true

Noble.new(MenuScene, 1.5, Noble.TransitionType.CROSS_DISSOLVE)