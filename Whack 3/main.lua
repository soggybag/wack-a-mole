-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar )


local storyboard = require "storyboard"

-- storyboard.purgeOnSceneChange = true

-- load scenetemplate.lua
storyboard.gotoScene( "home" )

-- Add any objects that should appear on all scenes below (e.g. tab bar, hud, etc.):


-- Ideas:
-- Musical Level - Moles make sounds when tapped
-- Moles popup in an order that makes a tune
-- End of level moles all pop up and make their sound
-- Moles pop up to form chord sounds