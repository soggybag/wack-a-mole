


local M = {}


local hole_back_image_url = "images/mole_hole_back.png"
local hole_front_image_url = "images/mole_hole_front.png"
local mole_sprite_sheet_url = "images/Alien_32_Red_3.png"

local pop_speed = 1000

------------------------------------------------
-- Image Sheet settings
------------------------------------------------
local image_sheet_width = 332
local image_sheet_height = 398
local image_sheet_tile_width = 66
local image_sheet_tile_height = 66
local image_sheet_tile_count = 30
------------------------------------------------

local mole_sprite_sequence_data = {
				{ name="a", start=1, count=10, time=600, loopCount=0 },
				{ name="b", start=11, count=10, time=600, loopCount=0 },
				{ name="c", start=21, count=10, time=600, loopCount=0 }
			}

local options = {}
	options.width = image_sheet_tile_width
	options.height = image_sheet_tile_height
	options.numFrames = image_sheet_tile_count
	options.sheetContentWidth = image_sheet_width
	options.sheetContentHeight = image_sheet_height
	
local thing_sheet = graphics.newImageSheet( mole_sprite_sheet_url, options )






local function mole_down( mole )
	print( "mole down" )
	local event = {name="moleDown", target=mole}
	mole.mole_group:dispatchEvent( event ) 
end


-----------------------------------------------------------------------------------------
-- Handle tapping moles
-----------------------------------------------------------------------------------------
local function touch_mole( event )
	local phase = event.phase
	local mole = event.target
	
	if phase == "began" and mole.unwhacked then  
		mole.unwhacked = false
		transition.cancel( mole.trans_up )
		transition.cancel( mole.trans_down )
		mole:play()
		mole.trans_down = transition.to( mole, {delay=pop_speed, 
								y=60, 
								time=pop_speed, 
								transition=easing.outExpo,
								onComplete=mole_down} )
								
		local event = {name="whack", target=mole}
		mole.mole_group:dispatchEvent( event )
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






local function reset_mole( mole )
	print( "**** mole factory reset mole", mole.trans_up, mole.trans_down )
	if mole.trans_up ~= nil then 
		transition.cancel( mole.trans_up )
	end
	if mole.trans_down then 
		transition.cancel( mole.trans_down )
	end
	mole.y = 60
end 





-----------------------------------------------------------------------------------------
-- This function shows a random mole
-----------------------------------------------------------------------------------------
local show_a_mole = function( mole ) 
	local seq_number = math.random( 1, 3 )
	
	mole.id = seq_number
	
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
	mole.trans_up = transition.to( mole, {y=-35, time=pop_speed, transition=easing.outExpo})
	mole.trans_down = transition.to( mole, {y=60, 
											time=pop_speed, 
											delay=pop_speed, 
											transition=easing.outExpo,
											onComplete=mole_down} )

end 
-----------------------------------------------------------------------------------------








-----------------------------------------------------------------------------------------
-- This function makes mole holes.
-----------------------------------------------------------------------------------------
-- Here we make a group and three elements: background, Alien and foreground and combine
-- them in a group. This group unit is one mole hole. 
local make_mole_hole = function()
	-- make elements
	local mole_group = display.newGroup()	-- Container group
	local hole_back = display.newImageRect( hole_back_image_url, 80, 21 )
	local hole_front = display.newImageRect( hole_front_image_url, 80, 109 )
			
	local mole_sprite = display.newSprite( thing_sheet, mole_sprite_sequence_data )
	
	-- Position elements inside of group. 
	hole_back.y = 10
	mole_sprite.y = 60
	hole_front.y = 56
	
	-- Assemble elements into group
	mole_group:insert( hole_back ) 
	mole_group:insert( mole_sprite )
	mole_group:insert( hole_front )
	
	mole_sprite.mole_group = mole_group
	
	-- Give each mole a variable to determine when it is unwhacked. 
	mole_sprite.unwhacked = true
	
	-- Add touch event to the mole
	mole_sprite:addEventListener( "touch", touch_mole )
	-- This event will block touches when the mole is behind the foreground
	hole_front:addEventListener( "touch", touch_front )
	
	-- 
	function mole_group.show_mole()
		show_a_mole( mole_sprite )
	end
	
	function mole_group.reset()
		reset_mole( mole_sprite )
	end
	
	-- Return the mole. This function acts as a factory. 
	return mole_group
end 

M.make_mole_hole = make_mole_hole
-----------------------------------------------------------------------------------------

local set_pop_speed = function( speed ) 
	pop_speed = speed
end 

M.set_pop_speed = set_pop_speed

local get_pop_speed = function( speed ) 
	return pop_speed
end 
M.get_pop_speed = get_pop_speed



return M