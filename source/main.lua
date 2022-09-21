import 'libraries/noble/Noble'

import 'utilities/Utilities'

import 'scenes/MenuScene'
import 'scenes/GameScene'
import 'scenes/MarathonScene'

Noble.Settings.setup({
	Difficulty = "Uh Oh"
})

Noble.GameData.setup({
	Score = 0
})

Noble.showFPS = false

Noble.new(MenuScene, 1.5, Noble.TransitionType.CROSS_DISSOLVE)