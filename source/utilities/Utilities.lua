-- Put your utilities and other helper functions here.
-- The "Utilities" table is already defined in "noble/Utilities.lua."
-- Try to avoid name collisions.

playdateWidth = 400
playdateHeight = 240

function newTrack(file)
	return playdate.sound.fileplayer.new(file)
end
