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



-------------------------------------------------------------------
-- Monitor memory usage
-------------------------------------------------------------------
local mem_text = display.newText( "", 10, 50, native.systemFont, 14 )
mem_text:setTextColor( 255, 0, 0 )
mem_text.x = display.contentCenterX

local monitorMem = function()
    collectgarbage()
    
    -- print( "MemUsage: " .. collectgarbage("count") )
	local str = "MemUsage: " .. math.round( collectgarbage("count") )
    local textMem = math.round( system.getInfo( "textureMemoryUsed" ) / 1000000 )
    
    -- print( "TexMem:   " .. textMem )
    str = str .. "\n Tex:" .. textMem
    mem_text.text = str
end

Runtime:addEventListener( "enterFrame", monitorMem )
------------------------------------------------------------------