----------------------------------------------------------------------------------
--
-- scenetemplate.lua
--
----------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

----------------------------------------------------------------------------------
-- 
--	NOTE:
--	
--	Code outside of listener functions (below) will only be executed once,
--	unless storyboard.removeScene() is called.
-- 
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

local button_array
local mole_sounds = require( "mole_sounds" )


local function on_tap( event ) 
	local button = event.target
	storyboard.gotoScene( "level_" .. button.id )
end 


-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view

	button_array = {}
	
	for i = 1, 3, 1 do 
		local button = display.newRect( 0, 0, 60, 60 )
		group:insert( button )
		button.x = 32 + ( i * 65 )
		button.y = 300
		
		button.id = i
		
		table.insert( button_array, button )
	end 
	
end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	
	for i = 1, #button_array, 1 do 
		local button = button_array[i]
		button:addEventListener( "tap", on_tap )
	end 
	
	mole_sounds.play_random_sound() 
	
end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	
	for i = 1, #button_array, 1 do 
		local button = button_array[i]
		button:removeEventListener( "tap", on_tap )
	end 
	
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
	local group = self.view
	
	-----------------------------------------------------------------------------
	
	--	INSERT code here (e.g. remove listeners, widgets, save state, etc.)
	
	-----------------------------------------------------------------------------
	
end


---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

---------------------------------------------------------------------------------

return scene