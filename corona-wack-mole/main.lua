-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------


-- Hide the Status bar
display.setStatusBar( display.HiddenStatusBar )

-- Import sprite, we'll use this for the mole/alien images
require "sprite"


-----------------------------------------------------------------------------------------
-- Declare some variables 
-----------------------------------------------------------------------------------------
local score_text

local mole_array = {}
local score = 0

local show_a_mole
local update_score
-----------------------------------------------------------------------------------------







-----------------------------------------------------------------------------------------
-- Add background
-----------------------------------------------------------------------------------------
local background = display.newImageRect( "Wack-Back.png", 320, 480 )
background.x = display.contentCenterX
background.y = display.contentCenterY
-----------------------------------------------------------------------------------------









-----------------------------------------------------------------------------------------
-- Handle tapping moles
-----------------------------------------------------------------------------------------
local function touch_mole( event )
	local phase = event.phase
	local mole = event.target
	
	if phase == "began" and mole.unwhacked then  
		mole.unwhacked = false
		transition.cancel( mole.transition_1 )
		transition.cancel( mole.transition_2 )
		
		mole:play()
		
		transition.to( mole, {delay=1000, y=60, time=1000, transition=easing.outExpo, onComplete=show_a_mole} )
		
		update_score()
	end
end 

-- Since the moles can be touched through covering image we need this function to handle 
-- taps on the that image. 
local function touch_front( event )
	-- Use this to capture touch events that happen on the mask covering the alien.
	-- Returning false here prevents the touch from passing through to the image below.
	return true
end
-----------------------------------------------------------------------------------------







------------------------------------------------
-- Image Sheet settings
------------------------------------------------
local image_sheet_width = 332
local image_sheet_height = 398
local image_sheet_tile_width = 66
local image_sheet_tile_height = 66
local image_sheet_tile_count = 30
------------------------------------------------
local options = {}
options.width = image_sheet_tile_width
options.height = image_sheet_tile_height
options.numFrames = image_sheet_tile_count
options.sheetContentWidth = image_sheet_width
options.sheetContentHeight = image_sheet_height

local thing_sheet = graphics.newImageSheet( "Alien_32_Red_3.png", options )
-----------------------------------------------------------------------------------------








-----------------------------------------------------------------------------------------
-- This function makes mole holes.
-----------------------------------------------------------------------------------------
-- Here we make a group and three elements: background, Alien and foreground and combine
-- them in a group. This group unit is one mole hole. 
local function make_mole_hole()
	-- make elements
	local mole_group = display.newGroup()	-- Container group
	local hole_back = display.newImageRect( "mole_hole_back.png", 80, 21 )
	local hole_front = display.newImageRect( "mole_hole_front.png", 80, 109 )
	local sequenceData = {
				{ name="a", start=1, count=10, time=600, loopCount=0 },
				{ name="b", start=11, count=10, time=600, loopCount=0 },
				{ name="c", start=21, count=10, time=600, loopCount=0 }
			}
	local alien_sprite = display.newSprite( thing_sheet, sequenceData )
	
	-- Position elements inside of group. 
	hole_back.y = 10
	alien_sprite.y = 60
	hole_front.y = 56
	
	-- Assemble elements into group
	mole_group:insert( hole_back ) 
	mole_group:insert( alien_sprite )
	mole_group:insert( hole_front )
	
	-- Give each mole a variable to determine when it is unwhacked. 
	alien_sprite.unwhacked = true
	
	-- Add touch event to the mole
	alien_sprite:addEventListener( "touch", touch_mole )
	-- This event will block touches when the mole is behind the foreground
	hole_front:addEventListener( "touch", touch_front )
	
	-- Add the moles to an array so we can organize them
	table.insert( mole_array, alien_sprite )
	
	-- Return the mole. This function acts as a factory. 
	return mole_group
end 


-- Make three moles using the function above
local mole_1 = make_mole_hole()
local mole_2 = make_mole_hole()
local mole_3 = make_mole_hole()

-- Position the moles
mole_1.x = display.contentCenterX
mole_1.y = display.contentCenterY

mole_2.x = display.contentCenterX - 100
mole_2.y = display.contentCenterY

mole_3.x = display.contentCenterX + 100
mole_3.y = display.contentCenterY
-----------------------------------------------------------------------------------------











-----------------------------------------------------------------------------------------
-- This function shows a random mole
-----------------------------------------------------------------------------------------
function show_a_mole() 
	local n = math.random( 1, #mole_array ) 
	local mole = mole_array[n]
	
	local seq_number = math.random( 1, 3 )
    
    local seq = ""
    if seq_number == 1 then 
    	seq = "a"
    elseif seq_number == 2 then 
    	seq = "b"
    else 
    	seq = "c"
    end
    
    mole:setSequence( seq )
	
	-- This mole is just appearing so it hasn't been whacked yet.
	mole.unwhacked = true
	
	-- Animate the mole to popup and move back down.
	mole.transition_1 = transition.to( mole, {y=-35, time=1000, transition=easing.outExpo})
	mole.transition_2 = transition.to( mole, {y=60, time=1000, delay=1000, transition=easing.outExpo, onComplete=show_a_mole} )
end 

-- Show the first mole.
show_a_mole()
-----------------------------------------------------------------------------------------








-----------------------------------------------------------------------------------------
-- Set up score text.
-----------------------------------------------------------------------------------------
-- Create a text field for the score. 
score_text = display.newText( "0", 5, 0, native.systemFont, 24 )
score_text:setReferencePoint( display.TopRightReferencePoint ) -- Align it to the top right
score_text.x = display.contentWidth - 5					-- Position it in the top right

-- Call this method to update the score. 
function update_score( )
	score = score + 10
	score_text.text = score 
	score_text:setReferencePoint( display.TopRightReferencePoint )
	score_text.x = display.contentWidth - 5
end 
-----------------------------------------------------------------------------------------