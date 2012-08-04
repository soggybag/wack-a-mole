----------------------------------------------------------------------------------
--
-- Mole game level_2.lua
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


-----------------------------------------------------------------------------------------
-- Declare some variables 
-----------------------------------------------------------------------------------------
local mole_factory = require( "mole_factory" )

local score_text
local background
local return_button

local mole_array = {}
local score = 0

local show_a_mole
local update_score
local popup_sound_array = {}
local touch_sound_array = {}
local sound_channels = {}

local show_mole
-----------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------
-- Set up score text.
----------------------------------------------------------------------------------------

-- Call this method to update the score. 
function update_score( )
	score = score + 10
	score_text.text = score 
	score_text:setReferencePoint( display.TopRightReferencePoint )
	score_text.x = display.contentWidth - 5
end 
-----------------------------------------------------------------------------------------
local function tap_return( event ) 
	storyboard.gotoScene( "home" )
end 

local function on_mole( event )
	print( "***** mole down *****" )
	show_mole()
end 

local function on_whack( event )
	print( "mole whacked" )
end

function show_mole()
	local n = math.random( 1, #mole_array )
	local mole = mole_array[n]
	
	mole.show_mole()
end 

-----------------------------------------------------------------------------------------
-- Called when the scene's view does not exist:
function scene:createScene( event )
	print( "Create Scene" )
	local group = self.view
	
	mole_array = {}
	
	background = display.newRect( 0, 0, display.contentWidth, display.contentHeight )
	background:setFillColor( 179, 178, 161 )
	
	-- Create a text field for the score. 
	score_text = display.newText( "0", 5, 0, native.systemFont, 24 )
	score_text:setReferencePoint( display.TopRightReferencePoint ) -- Align it to the top right
	score_text.x = display.contentWidth - 5					-- Position it in the top right
	
	
	-----------------------------------------------------------------------------------------
	-- Make sounds 
	-----------------------------------------------------------------------------------------
	--[[
	popup_sound_array[1] = audio.loadSound( "sounds/button-37.wav" )
	popup_sound_array[2] = audio.loadSound( "sounds/button-41.wav" )
	popup_sound_array[3] = audio.loadSound( "sounds/button-17.wav" )
	
	touch_sound_array[1] = audio.loadSound( "sounds/button-1.wav" )
	touch_sound_array[2] = audio.loadSound( "sounds/button-7.wav" )
	touch_sound_array[3] = audio.loadSound( "sounds/button-9.wav" )
	]]
	-----------------------------------------------------------------------------------------
	
	
	return_button = display.newRoundedRect( 0, 0, 40, 40, 8 )
	return_button:setFillColor( 90, 90, 80 )
	return_button.x = 25
	return_button.y = 25
		
	
	group:insert( background )
	for i = 0, 5, 1 do 
		local mole = mole_factory.make_mole_hole()
		mole.x = ( display.contentCenterX - 100 ) + ( ( i % 3 ) * 100 )
		mole.y = ( display.contentCenterY - 0 ) + ( math.floor( i / 3 ) * 100 ) 
		
		mole:addEventListener( "moleDown", on_mole )
		mole:addEventListener( "whack", on_whack )
		
		table.insert( mole_array, mole ) 
		group:insert( mole )
	end
	group:insert( return_button )
	group:insert( score_text )
end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	
	return_button:addEventListener( "tap", tap_return )
	show_mole()
end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	
	print( "exit scene" )
	
	return_button:removeEventListener( "tap", tap_return )
	
	for i = 1, #mole_array, 1 do 
		local mole = mole_array[i]
		mole.reset()
	end
	
	--[[
	for i = 1, #sound_channels, 1 do 
		local channel = sound_channels[i]
		audio.stop( channel )
	end 
	
	for i = 1, #popup_sound_array, 1 do 
		audio.dispose( popup_sound_array[i] )
	end 
	
	for i = 1, #touch_sound_array, 1 do
		audio.dispose( touch_sound_array[i] )
	end 
	]]
	
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
	local group = self.view
	
	print( "destroy scene" )
	
	-- Doesn't quite remove the moles????
	for i = 1, #mole_array, 1 do 
		local mole = mole_array[i]
		mole:removeEventListener( "moleDown", on_mole )
		mole:removeEventListener( "whack", on_whack )
		display.remove( mole )
		mole = nil
	end
	mole_array = nil
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