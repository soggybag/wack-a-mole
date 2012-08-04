
local M = {}
---------------------------------------------------


local audio_array = { {url="sounds/button-1.wav", id="a"}, 
					{url="sounds/button-7.wav",   id="b"},  
					{url="sounds/button-9.wav",   id="c"}, 
					{url="sounds/button-15.wav",  id=""}, 
					{url="sounds/button-17.wav",  id=""}, 
					{url="sounds/button-19.wav",  id=""}, 
					{url="sounds/button-37.wav",  id="down"}, 
					{url="sounds/button-41.wav",  id="up"} }
					
for i = 1, #audio_array, 1 do 
	audio_array[i].sound = audio.loadSound( audio_array[i].url )
end
---------------------------------------------------
local play_sound_at_index = function( index )
	audio.play( audio_array[index].sound )
end

M.play_sound_at_index = play_sound_at_index
---------------------------------------------------
local play_random_sound = function()
	play_sound_at_index( math.random(#audio_array) )
end 

M.play_random_sound = play_random_sound
---------------------------------------------------
local play_sound_by_id = function( id )
	for i = 1, #audio_array, 1 do 
		if audio_array[i].id == id then 
			play_sound_at_index( i )
			break
		end 
	end 
end 

M.play_sound_by_id = play_sound_by_id
---------------------------------------------------

---------------------------------------------------
return M
---------------------------------------------------