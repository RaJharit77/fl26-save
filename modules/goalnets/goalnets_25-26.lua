--[[
goalnets_module.lua (Version 0.5 - Alpha)
Author: Ficabre

FEATURES:
- Automatic game version detection to support multiple patches (PES21, PES20, FL24, FL25, FL26, UML, VirtuaRed...)
- Hierarchy for goalnet presets: Stadium > Competition > Team > Default.
- Support for multiple presets per entry (stadium, competition, or team) 
- In-game preset switching via Sider overlay (PageUp/PageDown keys).
- Overlay display showing the current goalnet preset that is selected and also source and name of the preset.
--]]

local Goalnets = {}

local sider_path
local current_preset_info = { name = "Default", source = "N/A" }
local current_available_presets = {}
local current_preset_index = 1
local KEY_PREVIOUS = 0x21 -- Page Up
local KEY_NEXT = 0x22     -- Page Down
local temporary_message = ""
local message_timer = 0

--- ==================================================================================================
-- PATCH/GAME DATABASE
--- ==================================================================================================

--- Database of addresses for different game patches
local patch_data = {
    ["SP_Football_Life"] = {
        signature_address = 0x0000000143517458,
        signature_value = "\x00\x00\xc0\x40",
        addresses = {
            netbounce    = 0x0000000143517450, netmovement  = 0x000000014351745C,
            netphysics   = 0x00000001435174A0, net3d        = 0x0000000143517458,
            netshape     = 0x000000014351748C, netpattern   = 0x0000000142aa253e,
            goalnetcolor = 0x0000000142aa25be, n_of_strings = 0x0000000142b66bc8,
            rod_position = 0x0000000142b66c48,
        }
    },
    ["PES2021_1"] = {
        signature_address = 0x0000000143525558,
        signature_value = "\x00\x00\xc0\x40",
        addresses = {
            netbounce    = 0x0000000143525550, netmovement  = 0x000000014352555C,
            netphysics   = 0x00000001435255A0, net3d        = 0x0000000143525558,
            netshape     = 0x000000014352558C, netpattern   = 0x0000000142aaddbe,
            goalnetcolor = 0x0000000142aade3e, n_of_strings = 0x0000000142b72ca8,
            rod_position = 0x0000000142b72d28,
        }
    },
    ["PES2021_2"] = {
        signature_address = 0x000000014351f518, 
        signature_value = "\x00\x00\xc0\x40",   
        addresses = {
            netbounce    = 0x000000014351f510, netmovement  = 0x000000014351f51C,
            netphysics   = 0x000000014351f560, net3d        = 0x000000014351f518,
            netshape     = 0x000000014351f54c, netpattern   = 0x0000000142aa93be,
            goalnetcolor = 0x0000000142aa943e, n_of_strings = 0x0000000142b6df18,
            rod_position = 0x0000000142b6df98,
        }
    },
	["PES2020"] = {
		signature_address = 0x00000001434a6558, 
		signature_value = "\x00\x00\xc0\x40",  
		addresses = {
			netbounce    = 0x00000001434a6550, netmovement  = 0x00000001434a655C,
			netphysics   = 0x00000001434a65A0, net3d        = 0x00000001434a6558,
			netshape     = 0x00000001434a658c, netpattern   = 0x0000000142a4777e,
			goalnetcolor = 0x0000000142a477fe, n_of_strings = 0x0000000142b0a498,
			rod_position = 0x0000000142b0a548,
		}
	},
}

-- This variable will hold the active set of addresses after detection.
local active_addresses = nil


local net_bounce = {
  
   nbOriginal = ("\xca\xc8\xc8\x3d\x33\x33\x73\x3f"),
   nbItaly = 	("\x29\x5c\x0f\x3d\x1d\x0f\x79\x3f"),
   nbBrasil = 	("\x29\x5c\x0f\x3d\x5d\x6d\x79\x3f"),
   nbFrance = 	("\x29\x5c\x0f\x3d\x1e\x0f\x70\x3f"),
   nbSpain = 	("\x29\x5c\x0f\x3d\x00\x00\x7f\x3f"),
   nbSmall = 	("\xcd\xcc\xcc\x3d\xd9\xce\x7f\x3f"),
   nbFIFA = 	("\x8f\xc2\xf5\x3c\x00\x00\x80\x3f"),
   nbFIFA2 =	("\xcd\xcc\xcc\x3d\x33\x33\x73\x3f"),
   nbFIFA3 = 	("\xcd\xcc\xcc\x3d\x00\x00\x80\x3f"),
   
 -- New Values: nbOriginal (S = Stiff - higher number less Stiff ; B = Bouncy - higher number more bouncy) 
 
   nbStiff = 	("\x00\x00\x00\x3c\x33\x33\x75\x3f\x00\x00\x00\x42\x00\x00\x00\x39"),  
	

	nbT1 = ("\x29\x5c\x0f\x3d\xcd\xcc\x4c\x3f"), 
	nbT2 = ("\x29\x5c\x0f\x3d\x33\x33\x59\x3f"), 
	nbT3 = ("\x29\x5c\x0f\x3d\x66\x66\x66\x3f"), 
	nbT4 = ("\x29\x5c\x0f\x3d\x9a\x99\x73\x3f"),
	nbT5 = ("\x29\x5c\x0f\x3d\x00\x00\x7a\x3f"), 
	nbT6 = ("\x29\x5c\x0f\x3d\x33\x33\x7c\x3f"), 
	nbT7 = ("\x29\x5c\x0f\x3d\x8f\xc2\x7c\x3f"), 
	nbT8 = ("\x29\x5c\x0f\x3d\x1f\x85\x7d\x3f"), 
	nbT9 = ("\x29\x5c\x0f\x3d\xcd\xcc\x7e\x3f"),
	nbT10 = ("\x29\x5c\x0f\x3d\x00\x00\x80\x3f"), 
	nbT11 = ("\x29\x5c\x0f\x3d\xd7\x07\x80\x3f"), 
	

	nbOT1 = ("\xca\xc8\xc8\x3d\xcd\xcc\x4c\x3f"), 
	nbOT2 = ("\xca\xc8\xc8\x3d\x33\x33\x59\x3f"), 
	nbOT3 = ("\xca\xc8\xc8\x3d\x66\x66\x66\x3f"), 
	nbOT4 = ("\xca\xc8\xc8\x3d\x9a\x99\x73\x3f"), 
	nbOT5 = ("\xca\xc8\xc8\x3d\x00\x00\x7a\x3f"), 
	nbOT6 = ("\xca\xc8\xc8\x3d\x33\x33\x7c\x3f"), 
	nbOT7 = ("\xca\xc8\xc8\x3d\x8f\xc2\x7c\x3f"), 
	nbOT8 = ("\xca\xc8\xc8\x3d\x1f\x85\x7d\x3f"), 
	nbOT9 = ("\xca\xc8\xc8\x3d\xcd\xcc\x7e\x3f"), 
	nbOT10 = ("\xca\xc8\xc8\x3d\x00\x00\x80\x3f"), 
	nbOT11 = ("\xca\xc8\xc8\x3d\xd7\x07\x80\x3f"), 


	-- LOW netbounce 
   nb4 = ("\x29\x5c\x2f\x3e\xcd\xcc\x5c\x3f"),
   nb5 = ("\x8f\xc2\xf5\x3c\xcd\xcc\x79\x3f"),
   nb6 = ("\xcd\xcd\xce\x3f\x40\x40\x79\x3f"),
   nb7 = ("\x29\x5c\x0f\x3d\x20\x20\x79\x3f"),
   nb8 = ("\x29\x5c\x0f\x3d\x40\x40\x75\x3f"),	
   nb8T = ("\x29\x5c\x0f\x3d\x40\x40\x75\x3f\xcf\xcf\xcf\x20"),	
	-- MEDIUM netbounce 
   nb9 = ("\x8f\x5c\xf5\x3d\x35\x35\x79\x3f"),
   nb10 = ("\x29\x4c\x0f\x3d\x30\x30\x79\x3f"),
   nb15 = ("\xcd\xcc\xcc\x3d\x33\x33\x7c\x3f"),	
	-- HIGH netbounce  
   nb17 = ("\x29\x5c\x0f\x3d\x80\x80\x7c\x3f"),
   nb18 = ("\x00\x00\x00\x41\x00\x00\x79\x3f"),
   nb19 = ("\xcd\xcc\xcc\x3d\x72\xf9\x79\x3f"),
   nb1920 = ("\x29\x5c\x0f\x3d\x57\xaa\x7a\x3f"),
   nb20 = ("\x29\x5c\x0f\x3d\x50\x50\x7c\x3f"),
   nb2021 = ("\x29\x5c\x0f\x3d\x43\x3d\x7d\x3f"), 
   nb21 = ("\x29\x5c\x0f\x3d\x1b\x0d\x80\x3f"),
   nb2122 = ("\x29\x5c\x0f\x3d\x13\x0a\x80\x3f"), 
   nb22 = ("\x3a\x42\x66\x41\x00\x00\x7f\x3f"),


   nbx =  ("\xcd\xcc\x4c\x3e\x7a\x97\x7f\x3f"),
   


   nbMed1 = ("\x29\x5c\x0f\x3d\x50\x50\x68\x3f"),
   nbMed2 = ("\xca\xc8\xc8\x3d\x35\x35\x75\x3f"),

   nbHigh1 = ("\x3a\x42\x66\x41\x40\x40\x7c\x3f"),

   
   nbTest =  ("\x2f\x5c\x0f\x41\x6f\x12\x7a\x3f"),
 
	nbVeryStiff = 	  ("\x00\x00\x80\x3f\x33\x33\x73\x3f"),
	nbVeryBouncy = 	  ("\x80\x80\x20\x3f\x33\x33\x73\x3f"),
	nbQuickResponse = ("\xca\xc8\xc8\x3f\x33\x33\x73\x3f"),
	nbSlowResponse =  ("\xca\xc8\x80\x3f\x33\x33\x73\x3f"),
	nbHeavyNet = 	  ("\x00\x00\x00\x40\x33\x33\x73\x3f"),
	nbLight = 		  ("\x80\x80\x80\x3f\x33\x33\x73\x3f"),
	nbMidLow = 		  ("\xca\xc8\xc8\x3d\x33\x33\x79\x3f"),

	-- Very Low Bounce (Almost No Bounce)
	nbVeryLow1 = ("\xd0\xd0\xd0\x3d\x05\x05\x30\x3f"),
	nbVeryLow2 = ("\x9f\xc3\xf6\x3c\x0a\x0a\x35\x3f"), 
	nbVeryLow3 = ("\xcb\xc9\xc9\x3d\x22\x22\x10\x3f"),

	-- Low Bounce
	nbLow4 =  ("\x28\x5b\x8e\x3f\xcd\xcb\x4b\x3f"),
	nbLow5 =  ("\xcc\xcb\xcb\x3d\xc9\xcb\x4b\x3f"),
	nbLow6 =  ("\x28\x5b\x2e\x3e\xcd\xcb\x5b\x3f"),
	nbLow7 =  ("\x8e\xc1\xf4\x3c\xcd\xcb\x78\x3f"),

	-- Medium Bounce
	nbMed3 = ("\x8e\x5b\xf4\x3d\x34\x34\x78\x3f"),
	nbMed4 = ("\x28\x5b\x0e\x3d\x3f\x3f\x78\x3f"),
	nbMed5 = ("\x18\x5b\x0e\x3d\x14\x14\x78\x3f"),
	nbMed6 = ("\x28\x4b\x0e\x3d\x2f\x2f\x78\x3f"),
	nbMed7 = ("\x28\x4b\x0e\x3d\x2f\x2f\x78\x3f\xc9\xc9\xc9\x99"),
	nbMed8 = ("\x28\x4b\x0e\x3a\x2f\x2f\x71\x3f\x33\x33\x79\x3c"),


	-- High Bounce
	nbHigh4 = ("\x28\x5b\x0e\x3d\x7f\x7f\x7b\x3f"),
	nbHigh5 = ("\xff\xff\xff\x40\xff\xff\x78\x3f"), 
	nbHigh6 = ("\xcc\xcb\xcb\x3d\x71\xf8\x78\x3f"),
	nbHigh7 = ("\x28\x5b\x0e\x3d\x4f\x4f\x7b\x3f"),


	-- Very High Bounce (Extreme)
	nbVeryHigh1 = ("\x27\x5a\x0e\x3d\x90\x90\x7f\x3f\x99\x99\x99\x39"),
	nbVeryHigh2 = ("\x40\x44\x68\x42\x10\x10\x7e\x3f"),
	nbVeryHigh3 = ("\x30\x5d\x10\x3d\x20\x10\x7f\x3f"),
	nbVeryHigh4 = ("\x27\x5a\x0e\x3d\x90\x90\x7a\x3f\x99\x99\x99\x3c"),
	
	UltraLowBounce = ("\x29\x5c\x0f\x3d\x10\x10\x40\x3f"),
	MidLowBounce = ("\x29\x5c\x0f\x3d\x80\x80\x60\x3f"),
	MidHighBounce = ("\x29\x5c\x0f\x3d\x00\x00\x7e\x3f"),

   nbOriginalBT = ("\x48\x59\x9e\x3c\x00\x00\x7e\x3f"),
   nbOriginalB1 = ("\x0c\xd9\xa3\x3d\x00\x00\x7e\x3f"),
   nbOriginalT = ("\x00\x00\x20\x41\x00\x00\x7e\x3f"),
   nbOriginalT2 = ("\x00\x00\x80\x3e\xff\xff\x7e\x3f"),
   nbOriginalT3 = ("\x00\x00\x80\x3e\xcc\xcd\x7f\x3f\x99\x99\x99\x3f"),
   nbOriginalTest = ("\x00\x00\x80\x3e\xcc\xcd\x7f\x3f\x99\x99\x99\x3a"),
   

	nb006_1 = ("\xcd\xcc\x84\x3d\xcd\xcc\x4c\x3f"), 
	nb006_2 = ("\xcd\xcc\x84\x3d\x33\x33\x59\x3f"), 
	nb006_3 = ("\xcd\xcc\x84\x3d\x66\x66\x66\x3f"), 
	nb006_4 = ("\xcd\xcc\x84\x3d\x9a\x99\x73\x3f"), 
	nb006_5 = ("\xcd\xcc\x84\x3d\x00\x00\x7a\x3f"), 
	nb006_6 = ("\xcd\xcc\x84\x3d\x33\x33\x7c\x3f"), 
	nb006_7 = ("\xcd\xcc\x84\x3d\x8f\xc2\x7c\x3f"), 
	nb006_8 = ("\xcd\xcc\x84\x3d\x1f\x85\x7d\x3f"), 
	nb006_9 = ("\xcd\xcc\x84\x3d\xcd\xcc\x7e\x3f"), 
	nb006_10 = ("\xcd\xcc\x84\x3d\x00\x00\x80\x3f"), 
	nb006_11 = ("\xcd\xcc\x84\x3d\xd7\x07\x80\x3f"), 
	

	nb01_1 = ("\x7b\x14\x77\x3c\xcd\xcc\x4c\x3f"), 
	nb01_2 = ("\x7b\x14\x77\x3c\x33\x33\x59\x3f"), 
	nb01_3 = ("\x7b\x14\x77\x3c\x66\x66\x66\x3f"), 
	nb01_4 = ("\x7b\x14\x77\x3c\x9a\x99\x73\x3f"), 
	nb01_5 = ("\x7b\x14\x77\x3c\x00\x00\x7a\x3f"),
	nb01_6 = ("\x7b\x14\x77\x3c\x33\x33\x7c\x3f"),
	nb01_7 = ("\x7b\x14\x77\x3c\x8f\xc2\x7c\x3f"),
	nb01_8 = ("\x7b\x14\x77\x3c\x1f\x85\x7d\x3f"),
	nb01_9 = ("\x7b\x14\x77\x3c\xcd\xcc\x7e\x3f"), 
	nb01_10 = ("\x7b\x14\x77\x3c\x00\x00\x80\x3f"), 
	

	nb02_1 = ("\xcd\xcc\xcc\x3e\xcd\xcc\x4c\x3f"),
	nb02_2 = ("\xcd\xcc\xcc\x3e\x33\x33\x59\x3f"),
	nb02_3 = ("\xcd\xcc\xcc\x3e\x66\x66\x66\x3f"), 
	nb02_4 = ("\xcd\xcc\xcc\x3e\x9a\x99\x73\x3f"), 
	nb02_5 = ("\xcd\xcc\xcc\x3e\x00\x00\x7a\x3f"),
	nb02_6 = ("\xcd\xcc\xcc\x3e\x33\x33\x7c\x3f"), 
	nb02_7 = ("\xcd\xcc\xcc\x3e\x8f\xc2\x7c\x3f"), 
	nb02_8 = ("\xcd\xcc\xcc\x3e\x1f\x85\x7d\x3f"), 
	nb02_9 = ("\xcd\xcc\xcc\x3e\xcd\xcc\x7e\x3f"), 
	nb02_10 = ("\xcd\xcc\xcc\x3e\x00\x00\x80\x3f"), 
	

	nb03_1 = ("\xb8\x1e\x97\x3e\xcd\xcc\x4c\x3f"), 
	nb03_2 = ("\xb8\x1e\x97\x3e\x33\x33\x59\x3f"), 
	nb03_3 = ("\xb8\x1e\x97\x3e\x66\x66\x66\x3f"), 
	nb03_4 = ("\xb8\x1e\x97\x3e\x9a\x99\x73\x3f"), 
	nb03_5 = ("\xb8\x1e\x97\x3e\x00\x00\x7a\x3f"), 
	nb03_6 = ("\xb8\x1e\x97\x3e\x33\x33\x7c\x3f"),
	nb03_7 = ("\xb8\x1e\x97\x3e\x8f\xc2\x7c\x3f"), 
	nb03_8 = ("\xb8\x1e\x97\x3e\x1f\x85\x7d\x3f"), 
	nb03_9 = ("\xb8\x1e\x97\x3e\xcd\xcc\x7e\x3f"), 
	nb03_10 = ("\xb8\x1e\x97\x3e\x00\x00\x80\x3f"), 
	
	
	nb05_1 = ("\x00\x00\x00\x3f\xcd\xcc\x66\x3f"),
	nb05_2 = ("\x00\x00\x00\x3f\x7b\x14\x69\x3f"),
	nb05_3 = ("\x00\x00\x00\x3f\x8f\xc2\x6b\x3f"),
	nb05_4 = ("\x00\x00\x00\x3f\xa4\x70\x6e\x3f"),
	nb05_5 = ("\x00\x00\x00\x3f\xb8\x1e\x71\x3f"),
	nb05_6 = ("\x00\x00\x00\x3f\xcc\xcc\x74\x3f"),
	nb05_7 = ("\x00\x00\x00\x3f\xe1\x7a\x77\x3f"),
	nb05_8 = ("\x00\x00\x00\x3f\xf6\x28\x7a\x3f"),
	nb05_9 = ("\x00\x00\x00\x3f\x0a\xd7\x7c\x3f"),
	nb05_10 = ("\x00\x00\x00\x3f\x1f\x85\x7f\x3f"),
	
	nb07_1 = ("\x33\x33\x33\x3f\xcd\xcc\x66\x3f"),
	nb07_2 = ("\x33\x33\x33\x3f\x7b\x14\x69\x3f"),
	nb07_3 = ("\x33\x33\x33\x3f\x8f\xc2\x6b\x3f"),
	nb07_4 = ("\x33\x33\x33\x3f\xa4\x70\x6e\x3f"),
	nb07_5 = ("\x33\x33\x33\x3f\xb8\x1e\x71\x3f"),
	nb07_6 = ("\x33\x33\x33\x3f\xcc\xcc\x74\x3f"),
	nb07_7 = ("\x33\x33\x33\x3f\xe1\x7a\x77\x3f"),
	nb07_8 = ("\x33\x33\x33\x3f\xf6\x28\x7a\x3f"),
	nb07_9 = ("\x33\x33\x33\x3f\x0a\xd7\x7c\x3f"),
	nb07_10 = ("\x33\x33\x33\x3f\x1f\x85\x7f\x3f"),
	
	
	nb075_1 = ("\x00\x00\x40\x3f\xcd\xcc\x66\x3f"),
	nb075_2 = ("\x00\x00\x40\x3f\x7b\x14\x69\x3f"),
	nb075_3 = ("\x00\x00\x40\x3f\x8f\xc2\x6b\x3f"),
	nb075_4 = ("\x00\x00\x40\x3f\xa4\x70\x6e\x3f"),
	nb075_5 = ("\x00\x00\x40\x3f\xb8\x1e\x71\x3f"),
	nb075_6 = ("\x00\x00\x40\x3f\xcc\xcc\x74\x3f"),
	nb075_7 = ("\x00\x00\x40\x3f\xe1\x7a\x77\x3f"),
	nb075_8 = ("\x00\x00\x40\x3f\xf6\x28\x7a\x3f"),
	nb075_9 = ("\x00\x00\x40\x3f\x0a\xd7\x7c\x3f"),
	nb075_10 = ("\x00\x00\x40\x3f\x1f\x85\x7f\x3f"),

	nb08_1 = ("\xcd\xcc\x4c\x3f\xcd\xcc\x66\x3f"),
	nb08_2 = ("\xcd\xcc\x4c\x3f\x7b\x14\x69\x3f"),
	nb08_3 = ("\xcd\xcc\x4c\x3f\x8f\xc2\x6b\x3f"),
	nb08_4 = ("\xcd\xcc\x4c\x3f\xa4\x70\x6e\x3f"),
	nb08_5 = ("\xcd\xcc\x4c\x3f\xb8\x1e\x71\x3f"),
	nb08_6 = ("\xcd\xcc\x4c\x3f\xcc\xcc\x74\x3f"),
	nb08_7 = ("\xcd\xcc\x4c\x3f\xe1\x7a\x77\x3f"),
	nb08_8 = ("\xcd\xcc\x4c\x3f\xf6\x28\x7a\x3f"),
	nb08_9 = ("\xcd\xcc\x4c\x3f\x0a\xd7\x7c\x3f"),
	nb08_10 = ("\xcd\xcc\x4c\x3f\x1f\x85\x7f\x3f"),

	nb085_1 = ("\x33\x33\x59\x3f\xcd\xcc\x66\x3f"),
	nb085_2 = ("\x33\x33\x59\x3f\x7b\x14\x69\x3f"),
	nb085_3 = ("\x33\x33\x59\x3f\x8f\xc2\x6b\x3f"),
	nb085_4 = ("\x33\x33\x59\x3f\xa4\x70\x6e\x3f"),
	nb085_5 = ("\x33\x33\x59\x3f\xb8\x1e\x71\x3f"),
	nb085_6 = ("\x33\x33\x59\x3f\xcc\xcc\x74\x3f"),
	nb085_7 = ("\x33\x33\x59\x3f\xe1\x7a\x77\x3f"),
	nb085_8 = ("\x33\x33\x59\x3f\xf6\x28\x7a\x3f"),
	nb085_9 = ("\x33\x33\x59\x3f\x0a\xd7\x7c\x3f"),
	nb085_10 = ("\x33\x33\x59\x3f\x1f\x85\x7f\x3f"),
	

	nbNormal1 = ("\xf7\xff\xaa\xbf\x00\x00\x7c\x3f"),
	nbNormal2 = ("\xf7\xff\xbf\xcb\x00\x00\x7c\x3f"),
	nbNormal3 = ("\xf7\xff\xbf\xbf\x00\x00\x80\x3f"),	
}

--//================================================================================================================================================================//
-- Goalnets movement
--//================================================================================================================================================================//

local movement = {

   Original =   ("\x00\x00\x80\x3f\x9a\x99\x99\x3f\x00\x00\x20\x41\x00\x00\x48\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3e\xcd\xcc\xcc\x3d\xcd\xcc\x4c\x3d\x00\x00\x80\x3e"),
   OriginalS1 = ("\x00\x00\x80\x3c\x9a\x99\x99\x3f\x00\x00\x20\x41\x00\x00\x48\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3e\xcd\xcc\xcc\x3d\xcd\xcc\x4c\x3d\x00\x00\x7a\x3e"),
   OriginalS2 = ("\x00\x00\x80\x3a\x9a\x99\x99\x3f\x00\x00\x20\x41\x00\x00\x48\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3e\xcd\xcc\xcc\x3d\xcd\xcc\x4c\x3d\x00\x00\x77\x3e"),
   
   
	Original2 = 	("\x00\x00\x80\x3f\x9a\x99\x99\x3f\x00\x00\x20\x41\x00\x00\x48\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3e\xcd\xcc\xcc\x3d\xcd\xcc\x4c\x3d\x00\x00\x80\x3c"),


	-- Stops ball almost immediately (Larger number less bounce)
	Deadstop = ("\x0a\xd7\xa3\x3c\x9a\x99\x99\x3f\x00\x00\x70\x41\x00\x00\x16\x43\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3e\xcd\xcc\xcc\x3d\x0a\xd7\xa3\x3d\x00\x00\x80\x3e"),
	Deadstop1 = ("\x0a\xd7\xa3\x3c\x9a\x99\x99\x3f\x00\x00\x70\x41\x00\x00\x16\x43\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3e\xcd\xcc\xcc\x3d\x0a\xd7\xa3\x3d\x00\x00\x50\x40"),
	Deadstop2 = ("\x0a\xd7\xa3\x3c\x9a\x99\x99\x3f\x00\x00\x70\x41\x00\x00\x16\x43\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3e\xcd\xcc\xcc\x3d\x0a\xd7\xa3\x3d\x00\x00\x80\x42"),
	Deadstop3 = ("\x0a\xd7\xa3\x3c\x9a\x99\x99\x3f\x00\x00\x70\x41\x00\x00\x16\x43\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3e\xcd\xcc\xcc\x3d\x0a\xd7\xa3\x3d\x00\x00\x80\x45"),


	WhippyCorners = ("\x66\x66\x66\x3f\x9a\x99\x99\x3f\x00\x00\x60\x40\x00\x00\x8c\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\xb3\x3e\x8f\xc2\x75\x3d\xcd\xcc\x4c\x3d\x00\x00\x00\x3f"),
	WhippyCorners_Lite = ("\x33\x33\x33\x3f\x9a\x99\x99\x3f\x00\x00\x80\x40\x00\x00\x70\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\x9a\x99\x99\x3e\x0a\xd7\x23\x3d\x29\x5c\x0f\x3d\xcd\xcc\xcc\x3e"),
	WhippyCorners_Lite2 = ("\x52\xb8\x1e\x3f\x00\x00\x20\x41\x00\x00\x80\x3f\x17\xb7\xd1\x38\x6f\x12\x83\x3a\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x1f\x85\x6b\x3f\x0a\xd7\xa3\x3e\x8f\xc2\x75\x3d\x8f\xc2\xf5\x3c\x29\x5c\x8f\x40"),


	ElasticFade = ("\x9a\x99\x19\x3f\x9a\x99\x99\x3f\x00\x00\x10\x41\x00\x00\x34\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\x9a\x99\x59\x3e\x29\x5c\x8f\x3d\x0a\xd7\x23\x3d\x33\x33\xb3\x3f"),
	CornerSnap_Lite = ("\xcd\xcc\x0c\x3f\x9a\x99\x99\x3f\x00\x00\xc0\x40\x00\x00\x82\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\x29\x5c\x8f\x3e\xcd\xcc\x4c\x3d\x29\x5c\x0f\x3d\xcd\xcc\xcc\x3f"),
	NetWave = ("\x8f\xc2\xf5\x3e\x9a\x99\x99\x3f\x00\x00\x00\x41\x00\x00\x6e\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3e\x8f\xc2\x75\x3d\x0a\xd7\x23\x3d\xab\xaa\xaa\x3f"),
	PulseReturn = ("\xab\xaa\xaa\x3f\x9a\x99\x99\x3f\x00\x00\x40\x41\x00\x00\x70\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\x0a\xd7\xa3\x3e\xcd\xcc\x4c\x3d\x29\x5c\x0f\x3d\x29\x5c\x8f\x3f"),
	BalancedPro = ("\x33\x33\xb3\x3e\x00\x00\x20\x41\x00\x00\x80\x3f\x17\xb7\xd1\x38\x6f\x12\x83\x3a\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\x00\x00\x80\x3e\x0a\xd7\xa3\x3d\xec\x51\x38\x3d\x71\x3d\x8a\x3f"),


	DampedPro = ("\x66\x66\x66\x3f\x9a\x99\x99\x3f\x00\x00\x38\x41\x00\x00\x34\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\xec\x51\x38\x3e\x8f\xc2\xf5\x3d\x8f\xc2\x75\x3d\xae\x47\x61\x3e"),
	CornerSlack = ("\x66\x66\x86\x3f\x33\x33\x93\x3f\x00\x00\x10\x41\x00\x00\x50\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\x29\x5c\x8f\x3e\xec\x51\xb8\x3d\x0a\xd7\x23\x3d\x71\x3d\x8a\x3e"), 
	QuickCradle = ("\x00\x00\xa0\x3f\x9a\x99\x99\x3f\x00\x00\x48\x41\x00\x00\x5c\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\xae\x47\x61\x3e\x29\x5c\x8f\x3d\x8f\xc2\xf5\x3c\x8f\xc2\x80\x3f"), 
	RippleFade = ("\xcd\xcc\x8c\x3f\x00\x00\xa0\x3f\x00\x00\x08\x41\x00\x00\x40\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\x9a\x99\x99\x3e\x8f\xc2\x75\x3d\x42\x60\xe5\x3c\xb8\x1e\x85\x3e"), 
	ShockAbsorb = ("\x9a\x99\x59\x3f\xcd\xcc\x8c\x3f\x00\x00\x50\x41\x00\x00\x68\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\x0a\xd7\x23\x3e\xae\x47\xe1\x3d\xae\x47\x61\x3d\xcd\xcc\x4c\x3e"), 
	TopTautBottomLoose = ("\x33\x33\x93\x3f\x9a\x99\x99\x3f\x00\x00\x20\x41\x00\x00\x70\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x08\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\x8f\xc2\x75\x3e\x0a\xd7\xa3\x3d\x0a\xd7\x23\x3d\xe1\x7a\x94\x3e"), 
	CornerBreath = ("\x00\x00\x80\x3f\xf6\x28\x9c\x3f\x00\x00\x20\x41\x00\x00\x54\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\x71\x3d\x8a\x3e\xcd\xcc\xcc\x3d\x8f\xc2\x75\x3d\x29\x5c\x8f\x3e"), 
	LateSettle = ("\x9a\x99\x99\x3f\x9a\x99\x99\x3f\x00\x00\x00\x41\x00\x00\x38\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\x0a\xd7\xa3\x3e\xec\x51\x38\x3d\x0a\xd7\xa3\x3c\x00\x00\x00\x40"), 
	SpringTension = ("\x3d\x0a\x97\x3f\x9a\x99\x99\x3f\x33\x33\x43\x41\x00\x00\x64\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\xcd\xcc\x4c\x3e\xb8\x1e\x05\x3e\x29\x5c\x8f\x3d\x1f\x85\x6b\x3e"), 
	WindSway = ("\x71\x3d\x8a\x3f\x9a\x99\x99\x3f\xcd\xcc\x1c\x41\x00\x00\x44\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\xec\x51\xb8\x3e\xae\x47\x61\x3d\x8f\xc2\xf5\x3c\x33\x33\xb3\x3e"),  
	HardSnap = ("\x33\x33\x73\x3f\x9a\x99\x99\x3f\x00\x00\x58\x41\x00\x00\x6c\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\x7b\x14\x2e\x3e\x29\x5c\x0f\x3e\x9a\x99\x99\x3d\x3d\x0a\x57\x3e"),  


	HardSnap2 = ("\x33\x33\x73\x3f\x9a\x99\x99\x3f\x00\x00\x58\x41\x00\x00\x6c\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\x7b\x14\x2e\x3e\x29\x5c\x0f\x3e\x9a\x99\x99\x3d\x3d\x0a\x20\x40"),  
	WindSway2 = ("\x71\x3d\x8a\x3f\x9a\x99\x99\x3f\xcd\xcc\x1c\x41\x00\x00\x44\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\xec\x51\xb8\x3e\xae\x47\x61\x3d\x8f\xc2\xf5\x3c\x33\x33\x00\x40"),
	CornerSlack2 = ("\x66\x66\x86\x3f\x33\x33\x93\x3f\x00\x00\x10\x41\x00\x00\x50\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\x29\x5c\x8f\x3e\xec\x51\xb8\x3d\x0a\xd7\x23\x3d\x71\x3d\x8a\x40"),
	RippleFade2 = ("\xcd\xcc\x8c\x3f\x00\x00\xa0\x3f\x00\x00\x08\x41\x00\x00\x40\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\x9a\x99\x99\x3e\x8f\xc2\x75\x3d\x42\x60\xe5\x3c\xb8\x1e\x85\x40"), 


	HardSnap3_2 = ("\x33\x33\x73\x3f\x9a\x99\x99\x3f\x00\x00\x58\x41\x00\x00\x6c\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\x7b\x14\x2e\x3e\x29\x5c\x0f\x3e\x9a\x99\x99\x3d\xcd\xcc\x4c\x40"),
	HardSnap6_0 = ("\x33\x33\x73\x3f\x9a\x99\x99\x3f\x00\x00\x58\x41\x00\x00\x6c\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\x7b\x14\x2e\x3e\x29\x5c\x0f\x3e\x9a\x99\x99\x3d\x00\x00\xc0\x40"),

	WindSway2_4 = ("\x71\x3d\x8a\x3f\x9a\x99\x99\x3f\xcd\xcc\x1c\x41\x00\x00\x44\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\xec\x51\xb8\x3e\xae\x47\x61\x3d\x8f\xc2\xf5\x3c\x9a\x99\x19\x40"),
	WindSway3_0 = ("\x71\x3d\x8a\x3f\x9a\x99\x99\x3f\xcd\xcc\x1c\x41\x00\x00\x44\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\xec\x51\xb8\x3e\xae\x47\x61\x3d\x8f\xc2\xf5\x3c\x00\x00\x40\x40"),


	CornerSlack4_8 = ("\x66\x66\x86\x3f\x33\x33\x93\x3f\x00\x00\x10\x41\x00\x00\x50\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\x29\x5c\x8f\x3e\xec\x51\xb8\x3d\x0a\xd7\x23\x3d\x9a\x99\x99\x40"),
	CornerSlack7_0 = ("\x66\x66\x86\x3f\x33\x33\x93\x3f\x00\x00\x10\x41\x00\x00\x50\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\x29\x5c\x8f\x3e\xec\x51\xb8\x3d\x0a\xd7\x23\x3d\x00\x00\xe0\x40"),

	RippleFade5_0 = ("\xcd\xcc\x8c\x3f\x00\x00\xa0\x3f\x00\x00\x08\x41\x00\x00\x40\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\x9a\x99\x99\x3e\x8f\xc2\x75\x3d\x42\x60\xe5\x3c\x00\x00\xa0\x40"),
	RippleFade6_5 = ("\xcd\xcc\x8c\x3f\x00\x00\xa0\x3f\x00\x00\x08\x41\x00\x00\x40\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\x9a\x99\x99\x3e\x8f\xc2\x75\x3d\x42\x60\xe5\x3c\x00\x00\xd0\x40"),

	-- Tried to replicate FC26 goalnet phyics
	FC26 = ("\x33\x33\xb3\x3f\x66\x66\xa6\x3f\x00\x00\x18\x41\x00\x00\x78\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\x7b\x14\xae\x3e\xcd\xcc\x4c\x3d\xcd\xcc\xcc\x3c\x52\xb8\x9e\x3e"),
	FC26_2 = ("\x33\x33\xb3\x3f\x66\x66\xa6\x3f\x00\x00\x18\x41\x00\x00\x78\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\x27\x31\xc8\x3e\x7b\x14\x2e\x3d\x7b\x14\xae\x3c\x2b\x87\xb6\x3e"),
	FC26_3 = ("\x33\x33\xb3\x3f\x66\x66\xa6\x3f\x00\x00\x18\x41\x00\x00\x78\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\x7b\x14\xae\x3e\xcd\xcc\x4c\x3d\xcd\xcc\xcc\x3c\x00\x00\x00\x40"),
	FC26_4 = ("\x33\x33\xb3\x3f\x66\x66\xa6\x3f\x00\x00\x18\x41\x00\x00\x78\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\x7b\x14\xae\x3e\xcd\xcc\x4c\x3d\xcd\xcc\xcc\x3c\x00\x00\x40\x40"),
	FC26_5 = ("\x33\x33\xb3\x3f\x66\x66\xa6\x3f\x00\x00\x18\x41\x00\x00\x78\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\x7b\x14\xae\x3e\xcd\xcc\x4c\x3d\xcd\xcc\xcc\x3c\x00\x00\x80\x40"),
	FC26_6 = ("\x33\x33\xb3\x3f\x66\x66\xa6\x3f\x00\x00\x18\x41\x00\x00\x78\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\x7b\x14\xae\x3e\xcd\xcc\x4c\x3d\xcd\xcc\xcc\x3c\x00\x00\x80\x41"),
	FC26_7 = ("\x33\x33\xb3\x3f\x66\x66\xa6\x3f\x00\x00\x18\x41\x00\x00\x78\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\x7b\x14\xae\x3e\xcd\xcc\x4c\x3d\xcd\xcc\xcc\x3c\x00\x00\xc0\x41"),
	FC26_8 = ("\x33\x33\xb3\x3f\x66\x66\xa6\x3f\x00\x00\x18\x41\x00\x00\x78\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\x7b\x14\xae\x3e\xcd\xcc\x4c\x3d\xcd\xcc\xcc\x3c\x00\x00\x00\x42"),


	DampedPro_Lite = ("\x66\x66\x66\x3f\x9a\x99\x99\x3f\x00\x00\x38\x41\x00\x00\x34\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\x08\xac\x1c\x3e\xdf\x4f\x0d\x3e\xdf\x4f\x8d\x3d\xee\x7c\x3f\x3e"),
	CornerSlack_Lite = ("\x66\x66\x86\x3f\x33\x33\x93\x3f\x00\x00\x10\x41\x00\x00\x50\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\x46\xb6\x73\x3e\xcf\xf7\xd3\x3d\x7f\x6a\x3c\x3d\x0c\x02\x6b\x3e"),
	QuickCradle_Lite = ("\x00\x00\xa0\x3f\x9a\x99\x99\x3f\x00\x00\x48\x41\x00\x00\x5c\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\xee\x7c\x3f\x3e\x2f\xdd\xa4\x3d\xdf\x4f\x0d\x3d\x60\xe5\x50\x3e"),
	RippleFade_Lite = ("\xcd\xcc\x8c\x3f\x00\x00\xa0\x3f\x00\x00\x08\x41\x00\x00\x40\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\x5c\x8f\x82\x3e\xdf\x4f\x8d\x3d\x26\xe4\x03\x3d\xd3\x4d\x62\x3e"),
	ShockAbsorb_Lite = ("\x9a\x99\x59\x3f\xcd\xcc\x8c\x3f\x00\x00\x50\x41\x00\x00\x68\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\x96\x43\x0b\x3e\x37\x89\x01\x3e\x37\x89\x81\x3d\x7b\x14\x2e\x3e"),
	FC26_Lite = ("\x33\x33\xb3\x3f\x66\x66\xa6\x3f\x00\x00\x18\x41\x00\x00\x78\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\xcf\xf7\x93\x3e\x1f\x85\x6b\x3d\x1f\x85\xeb\x3c\x79\xe9\x86\x3e"),
	TopTautBottomLoose_Lite = ("\x33\x33\x93\x3f\x9a\x99\x99\x3f\x00\x00\x20\x41\x00\x00\x70\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x08\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\x60\xe5\x50\x3e\x7f\x6a\xbc\x3d\x7f\x6a\x3c\x3d\x7f\x6a\x7c\x3e"),
	CornerBreath_Lite = ("\x00\x00\x80\x3f\xf6\x28\x9c\x3f\x00\x00\x20\x41\x00\x00\x54\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\x0c\x02\x6b\x3e\x1f\x85\xeb\x3d\xdf\x4f\x8d\x3d\x46\xb6\x73\x3e"),
	LateSettle_Lite = ("\x9a\x99\x99\x3f\x9a\x99\x99\x3f\x00\x00\x00\x41\x00\x00\x38\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\x96\x43\x8b\x3e\xcf\xf7\x53\x3d\x7f\x6a\xbc\x3c\xb2\x9d\x8f\x3e"),
	SpringTension_Lite = ("\x3d\x0a\x97\x3f\x9a\x99\x99\x3f\x33\x33\x43\x41\x00\x00\x64\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\x7b\x14\x2e\x3e\x87\x16\x19\x3e\x2f\xdd\xa4\x3d\x27\x31\x48\x3e"),
	WindSway_Lite = ("\x71\x3d\x8a\x3f\x9a\x99\x99\x3f\xcd\xcc\x1c\x41\x00\x00\x44\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\x08\xac\x9c\x3e\x37\x89\x81\x3d\xdf\x4f\x0d\x3d\xec\x51\x98\x3e"),
	HardSnap_Lite = ("\x33\x33\x73\x3f\x9a\x99\x99\x3f\x00\x00\x58\x41\x00\x00\x6c\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\xcf\xf7\x13\x3e\x2f\xdd\x24\x3e\xd7\xa3\xb0\x3d\xb4\xc8\x36\x3e"),

	DampedPro_XL = ("\x66\x66\x66\x3f\x9a\x99\x99\x3f\x00\x00\x38\x41\x00\x00\x34\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\xcf\xf7\x53\x3e\x60\xe5\xd0\x3d\x60\xe5\x50\x3d\x37\x89\x81\x3e"),
	CornerSlack_XL = ("\x66\x66\x86\x3f\x33\x33\x93\x3f\x00\x00\x10\x41\x00\x00\x50\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\x2f\xdd\xa4\x3e\x08\xac\x9c\x3d\x96\x43\x0b\x3d\xdb\xf9\x9e\x3e"),
	QuickCradle_XL = ("\x00\x00\xa0\x3f\x9a\x99\x99\x3f\x00\x00\x48\x41\x00\x00\x5c\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\x37\x89\x81\x3e\x46\xb6\x73\x3d\x60\xe5\xd0\x3c\xdf\x4f\x8d\x3e"),
	RippleFade_XL = ("\xcd\xcc\x8c\x3f\x00\x00\xa0\x3f\x00\x00\x08\x41\x00\x00\x40\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\xd7\xa3\xb0\x3e\x60\xe5\x50\x3d\x38\xf8\xc2\x3c\x87\x16\x99\x3e"),
	ShockAbsorb_XL = ("\x9a\x99\x59\x3f\xcd\xcc\x8c\x3f\x00\x00\x50\x41\x00\x00\x68\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\x7f\x6a\x3c\x3e\xee\x7c\xbf\x3d\xee\x7c\x3f\x3d\x1f\x85\x6b\x3e"),
	TopTautBottomLoose_XL = ("\x33\x33\x93\x3f\x9a\x99\x99\x3f\x00\x00\x20\x41\x00\x00\x70\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x08\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\xdf\x4f\x8d\x3e\x96\x43\x8b\x3d\x96\x43\x0b\x3d\x83\xc0\xaa\x3e"),
	CornerBreath_XL = ("\x00\x00\x80\x3f\xf6\x28\x9c\x3f\x00\x00\x20\x41\x00\x00\x54\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\xdb\xf9\x9e\x3e\x7b\x14\xae\x3d\x60\xe5\x50\x3d\x2f\xdd\xa4\x3e"),
	LateSettle_XL = ("\x9a\x99\x99\x3f\x9a\x99\x99\x3f\x00\x00\x00\x41\x00\x00\x38\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\x7f\x6a\xbc\x3e\x08\xac\x1c\x3d\x96\x43\x8b\x3c\xd3\x4d\xc2\x3e"),
	SpringTension_XL = ("\x3d\x0a\x97\x3f\x9a\x99\x99\x3f\x33\x33\x43\x41\x00\x00\x64\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\x1f\x85\x6b\x3e\xd3\x4d\xe2\x3d\x46\xb6\x73\x3d\x8b\x6c\x87\x3e"),
	WindSway_XL = ("\x71\x3d\x8a\x3f\x9a\x99\x99\x3f\xcd\xcc\x1c\x41\x00\x00\x44\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\xcf\xf7\xd3\x3e\xee\x7c\x3f\x3d\x60\xe5\xd0\x3c\x7b\x14\xce\x3e"),
	HardSnap_XL = ("\x33\x33\x73\x3f\x9a\x99\x99\x3f\x00\x00\x58\x41\x00\x00\x6c\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\x27\x31\x48\x3e\x46\xb6\xf3\x3d\x5c\x8f\x82\x3d\xc7\x4b\x77\x3e"),


--Old movements (less control)
   Bouncy =  ("\x00\x00\x80\x35\x9a\x99\x99\x3f\x00\x00\x20\x40\x00\x00\x48\x42\x70\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3e\xcd\xcc\xcc\x3a\xcd\xcc\x4c\x3d\x00\x00\x99\x41"),
   Bouncy2 = ("\x00\x00\x80\x3f\x9a\x99\x99\x3f\x00\x00\x20\x40\x00\x00\x48\x42\x70\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3e\xcd\xcc\xcc\x3a\xcd\xcc\x4c\x3d\x00\x00\x80\x41"),
   Bouncy3 = ("\x66\x66\x66\x3f\x9a\x99\x99\x3f\x00\x00\x20\x41\x00\x00\x48\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3e\xcd\xcc\xcc\x39\xcd\xcc\x4c\x3f\x00\x00\x80\x3e"),

   EPL =  ("\x00\x00\x80\x39\x9a\x99\x99\x3f\x00\x00\x20\x41\x00\x00\x48\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3e\xcd\xcc\xcc\x3d\xcd\xcc\x4c\x3d\x00\x00\x80\x3f"),
   EPL2 = ("\x00\x00\x80\x3a\x00\x00\x00\x43\x00\x00\x20\x41\x00\x00\x48\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3e\xcd\xcc\xcc\x3d\xcd\xcc\x4c\x3d\x00\x00\x80\x80"),
   EPL3 = ("\x00\x00\x48\x3a\x9a\x99\x99\x43\xcd\xcc\x4c\x3b\x17\xb7\xd1\x38\x6f\x12\x83\x3a\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\x9a\x99\x99\x3e\xcd\xcc\x0c\x40\x0a\xd7\xa3\x3c\x00\x00\x80\x3f"),
   EPL4 = ("\x89\x20\x40\x10\x80\x80\x89\x42\x00\x00\x21\x40\x17\xb7\xd1\x38\x6f\x12\x83\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\x9a\x99\x99\x3e\xcd\x29\x4c\x80\x0a\xd7\xa3\x3c\x00\x00\x99\x99\xca\xcc\x4c\x3d"),
   EPL5 = ("\x00\x00\x89\x3a\x9a\x99\x99\x3f\x00\x00\x21\x40\x17\xb7\xd1\x38\x6f\x12\x83\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\x9a\x99\x99\x3e\xcd\x29\x4c\x80\x0a\xd7\xa3\x3c\x00\x00\x80\x3e"),
   EPL6 = ("\x00\x00\x80\x39\x3a\x42\x66\x41\x00\x00\x20\x41\x00\x00\x48\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3e\xcd\xcc\xcc\x3d\xcd\xcc\x4c\x3d\x00\x00\x80\x3f"), 
   EPL7 = ("\x00\x00\x80\x3a\x66\x66\x86\x40\x00\x00\x48\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3e\xcd\xcc\xcc\x3d\xcd\xcc\x4c\x3d\x00\x00\x80\x3a"),
   EPL8 = ("\xcd\xcd\xce\x00\x40\x40\x79\x3f\x00\x00\x48\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3e\xcd\xcc\xcc\x3d\xcd\xcc\x4c\x3d\x00\x00\x80\x3a"),
   EPL9 = ("\x00\x00\x80\x00\x00\x00\x00\x43\x00\x00\x20\x41\x00\x00\x48\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3e\xcd\xcc\xcc\x3d\xcd\xcc\x4c\x3d\x00\x00\x80\x80"),
    
   Porto =  ("\x00\x00\x80\x3b\x66\x66\x86\x40\x00\x00\x20\x41\x00\x00\x48\x42\x6f\x12\x83\x3f\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3e\xcd\xcc\xcc\x3d\xcd\xcc\x4c\x3d\x00\x00\x80\x3e"),
   Italy =  ("\x66\x66\x66\x3b\x9a\x99\x99\x3f\x00\x00\x20\x41\x00\x00\x48\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3e\xcd\xcc\xcc\x39\xcd\xcc\x4c\x3f\x00\x00\x79\x35"),
   Italy2 = ("\x66\x66\x66\x3b\x00\x00\x00\x00\x00\x00\x20\x41\x00\x00\x48\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3e\xcd\xcc\xcc\x39\xcd\xcc\x4c\x3f\x00\x00\x79\x35"),
   Italy3 = ("\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x20\x41\x00\x00\x48\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3e\xcd\xcc\xcc\x3d\xcd\xcc\x4c\x3d\x00\x00\x80\x3e"),
   France = ("\x20\x20\x40\x3a\x9a\x99\x99\x3f\x20\x20\x20\x40\x48\x48\x48\x41\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3e\xcd\xcc\xcc\x3d\xcd\xcc\x4c\x3d\x00\x00\x7c\x3e"),
   Spain =  ("\x00\x00\x89\x3c\x9a\x99\x99\x3f\x00\x00\x20\x40\x00\x00\x48\x42\x70\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3e\xcd\xcc\xcc\x3f\xcd\xcc\x5c\x3d\x00\x00\x80\x3f"),	
   Spain2 = ("\x00\x00\x40\x3b\x00\x00\x80\x3f\x00\x00\x20\x41\x00\x00\x48\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3e\xcd\xcc\xcc\x3d\xcd\xcc\x4c\x3d\x00\x00\x80\x3e"),	
   Small =  ("\x00\x00\x80\x00\x00\x00\x00\x80\x00\x00\x20\x40\x00\x00\x45\x40\x6f\x12\x83\x3c\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3e\xcd\xcc\xcc\x3d\xcd\xcc\x4c\x3d\x00\x00\x80\x80"),

   FIFA1 =   ("\x29\x5c\x0f\x9a\x99\x99\x3f\x3f\x17\xb7\xd1\x41\x00\x00\x48\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3e\xcd\xcc\xcc\x3d\xcd\xcc\x4c\x3d\x00\x00\x80\x3e"),
   FIFA2 =  ("\x00\x00\xc0\x3c\x00\x00\x80\x3f\x00\x00\x20\x41\x00\x00\x48\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3e\xcd\xcc\xcc\x3d\xcd\xcc\x4c\x3d\x00\x00\x80\x3e"),
   FIFA3 =  ("\x00\x00\xc0\x3d\x00\x00\x80\x3f\x00\x00\x20\x41\x00\x00\x48\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3e\xcd\xcc\xcc\x3d\xcd\xcc\x4c\x3d\x00\x00\x80\x3e"),
   FIFA4 =  ("\x00\x00\xc0\x3d\x00\x00\x80\x3d\x00\x00\x20\x41\x00\x00\x45\x43\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3e\xcd\xcc\xcc\x3d\xcd\xcc\x4c\x3d\x00\x00\x80\x3e"),
   FIFA5 =  ("\x00\x00\xc0\x3d\x00\x00\x80\x3d\x00\x00\x20\x41\x00\x00\x42\x44\x6c\x13\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3e\xcd\xcc\xcc\x3d\xcd\xcc\x4c\x3d\x00\x00\x80\x3e"),

 
-- NXT =  ("\x00\x00\x40\x3d\x9a\x99\x99\x3d\x00\x00\x20\x41\x00\x00\x48\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3e\xcd\xcc\xcc\x3d\xcd\xcc\x4c\x3d\x00\x00\x80\x3e"),
   NXT2 = ("\x66\x66\x86\x3c\x66\x66\x66\x3c\x00\x00\x20\x41\x00\x00\x48\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\xf0\x41\x47\x03\x80\x3f\x62\x10\x80\x3f\x9a\x99\x99\x3e\xae\x47\xe1\x3d\xcd\xcc\x0c\x3f\x9a\x99\x99\x3e"),
   NXT3 = ("\x66\x66\x86\x3b\x66\x66\x66\x3b\x00\x00\x20\x41\x00\x00\x48\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\xf0\x41\x47\x03\x80\x3f\x62\x10\x80\x3f\x9a\x99\x99\x3e\xae\x47\xe1\x3d\xcd\xcc\x0c\x3f\x9a\x99\x99\x3e"),	
   NXT4 = ("\x00\x00\x40\x3b\x9a\x99\x99\x3b\x00\x00\x20\x41\x00\x00\x48\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3e\xcd\xcc\xcc\x3d\xcd\xcc\x4c\x3d\x00\x00\x80\x3e"),
   NXT6 = ("\x00\x00\x20\x3c\x00\x00\x20\x41\x00\x00\x80\x3f\x17\xb7\xd1\x38\x6f\x12\x83\x3a\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\x00\x00\x80\x3e\xcd\xcc\xcc\x3d\xcd\xcc\x4c\x3d\x00\x00\x80\x3e"),
   NXT7 = ("\x00\x00\x99\x3c\x00\x00\x20\x41\x00\x00\x80\x3f\x17\xb7\xd1\x38\x6f\x12\x83\x3a\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\x00\x00\x80\x3e\xcd\xcc\xcc\x3d\xcd\xcc\x4c\x3d\x00\x00\x80\x3e"),
   NXT8 = ("\x29\x5c\x0f\x3d\x00\x00\x20\x41\x00\x00\x80\x3f\x17\xb7\xd1\x38\x6f\x12\x83\x3a\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\x00\x00\x80\x3e\xcd\xcc\xcc\x3d\xcd\xcc\x4c\x3d\x00\x00\x80\x3e"),	
   NXT9 = ("\x00\x00\x40\x3c\x00\x00\x80\x3f\x00\x00\x20\x41\x00\x00\x48\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3e\xcd\xcc\xcc\x3d\xcd\xcc\x4c\x3d\x00\x00\x80\x3e"),
   NXT10 =("\x00\x00\x40\x3a\x00\x00\x80\x3c\x00\x00\x20\x41\x00\x00\x48\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3e\xcd\xcc\xcc\x3d\xcd\xcc\x4c\x3d\x00\x00\x80\x3e"),
 --NXT6 (greater number = more bouncy net)
   NXTOg = 	("\x00\x00\x20\x3c\x00\x00\x20\x41\x00\x00\x80\x3f"),
   NXTB1 = 	("\x00\x00\x20\x3d\x00\x00\x20\x41\x00\x00\x80\x3f"),
   NXTB2 = 	("\x00\x00\x20\x3f\x00\x00\x20\x41\x00\x00\x80\x3f"),
   NXTB3 = 	("\x00\x00\x20\x80\x00\x00\x20\x41\x00\x00\x80\x3f"),
   NXTB4 = 	("\x00\x00\x20\x99\x00\x00\x20\x41\x00\x00\x80\x3f"),

 
 --Original (new test values)  
   Og =   ("\x00\x00\x80\x3f\x9a\x99\x99\x3f\x00\x00\x20\x41"),
   OgS1 = ("\x00\x00\x80\x3c\x9a\x99\x99\x3f\x00\x00\x20\x41"),
   OgS2 = ("\x00\x00\x80\x3a\x9a\x99\x99\x3f\x00\x00\x20\x41"),   
   
 -- More Firm, Less Bounce
   Firm = 	("\x12\x12\x60\x3c\x00\x00\x20\x41\x00\x00\x75\x3f"),
   Firm2 =  ("\x00\x00\x00\x30\x00\x00\x20\x41\x00\x00\x75\x3f"),
   Firm3 =  ("\x05\x10\x45\x3a\x00\x00\x20\x41\x00\x00\x78\x3f"), 
   Firm4 =  ("\x12\x12\x60\x3d\x00\x00\x20\x41\x00\x00\x75\x3f"),
   Firm5 =  ("\x25\x25\x50\x3d\x00\x00\x10\x41\x00\x00\x90\x3f"),
   Firm6 =  ("\x15\x15\x30\x3c\x00\x00\x10\x41\x00\x00\x5f\x3f\x9a\x99\x79\x3e\xcd\xcc\x0c\x3f\x0a\xd7\x83\x3c"),
   Firm7 =  ("\x60\x60\x70\x3e\x00\x00\x60\x41\x00\x00\x8f\xbf"),
   Firm8 =  ("\x80\x80\x90\x3c\x00\x00\x80\x41\x00\x00\x80\x3a"),
   Firm9 =  ("\x10\x10\x45\x3a\x00\x00\x10\x41\x00\x00\xa0\x3f"),
   Firm10 = ("\x00\x00\x00\x3a\x00\x00\x20\x41\x00\x00\x98\x3f"),
   Firm11 = ("\x05\x10\x45\x3a\x00\x00\x20\x41\x00\x00\x78\x3f\x9a\x99\x99\x3f\xcd\xcc\x0c\x40\x0a\xd7\xa3\x3f"),
   Firm12 = ("\x30\x30\x70\x3d\x00\x00\x00\x42\x00\x00\x88\x3f"),  --ball stops almost immediately
   Firm13 =  ("\x00\x00\x80\x3d\x9a\x99\x99\x3f\x00\x00\x20\x41\x00\x00\x48\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3e\xcd\xcc\xcc\x3d"),
   Firm14 =  ("\x00\x00\x80\x3d\x9a\x99\x99\x3f\x00\x00\x20\x41\x00\x00\x48\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3d\x00\x00\x80\x40\xcd\xcc\xcc\x3d"),
    
 -- More Elastic, Snappier 
   Snappy =  ("\x35\x35\x80\x3f\x00\x00\x20\x41\x00\x00\x95\x3f"),
   Snappy2 = ("\x45\x55\x90\x3f\x00\x00\x20\x41\x00\x00\x90\x3f"), 
   Snappy3 = ("\x3a\x3a\x80\x3f\x00\x00\x20\x41\x00\x00\x92\x3f"),
   Snappy4 = ("\x30\x30\x78\x3f\x00\x00\x40\x41\x00\x00\xc0\x3f\x9a\x99\x99\x3a\xcd\xcc\x0c\x3a\x0a\xd7\xa3\x3a"),
   
 -- Balanced, Less Extreme   
   Balanced1 = 	  ("\x12\x34\x60\x3d\x00\x00\x20\x41\x00\x00\x85\x3f"),
   Balanced2 = 	  ("\x25\x48\x50\x3c\x00\x00\x20\x41\x00\x00\x80\x3f"),
   Balanced3 = 	  ("\x20\x20\x60\x3c\x00\x00\x20\x41\x00\x00\x80\x3f"), 
   Balanced4 =    ("\x12\x34\x60\x3d\x00\x00\x20\x41\x00\x00\x95\x3f\x9a\x99\x99\x3e\xcd\xcc\x0c\x40\x0a\xd7\xa3\x3c"),
   Balanced5 = 	  ("\x12\x12\xff\x3a\x00\x00\x15\x3f\x00\x00\xff\x3f\x9a\x99\x99\x3a\xcd\xcc\x0c\x40\x0a\xd7\xa3\x39"),
   Balanced6 = 	  ("\x12\x12\x60\x3e\x00\x00\x20\x41\x00\x00\x75\x3f\x00\x00\x00\x3c\x00\x00\x00\x39\x00\x00\x00\x3c"),
   Balanced7 = 	  ("\x60\x60\x70\x3e\x00\x00\x60\x41\x00\x00\x8f\xbf\x9a\x99\x99\x3d\xcd\xcc\x0c\x3e\x0a\xd7\xa3\x3b"),
   Balanced8 =  ("\x00\x00\x40\x3f\x33\x33\xb3\x3f\x00\x00\x40\x41\x00\x00\x48\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3e\xcd\xcc\xcc\x3d"),
   

 -- Firm and Snappy
   FirmSnappy1 = ("\x20\x20\x70\x3c\x00\x00\x20\x41\x00\x00\x8f\x3f"),
   FirmSnappy2 = ("\x10\x10\x68\x3b\x00\x00\x18\x41\x00\x00\x85\x3f"),
   FirmSnappy3 = ("\x30\x30\x78\x3e\x00\x00\x20\x41\x00\x00\xa0\x3f\x9a\x99\x99\x3e\xcd\xcc\x0c\x40\x0a\xd7\xa3\x3c"),
   FirmSnappy4 = ("\x12\x12\x60\x3c\x00\x00\x15\x41\x00\x00\x6f\x3f\x9a\x99\x99\x3e\xcd\xcc\x0c\x40\x0a\xd7\xa3\x3c"),
   FirmSnappy5 = ("\x02\x02\x50\x38\x00\x00\x20\x41\x00\x00\x95\x3f\x9a\x99\x99\x3e\xcd\xcc\x0c\x39\x0a\xd7\xa3\x3b"),
   FirmSnappy6 = ("\x02\x02\x50\x38\x00\x00\x20\x41\x00\x00\x95\x3f\x9a\x99\x99\x3e\xcd\xcc\x0c\x3c\x0a\xd7\xa3\x3a"),
   FirmSnappy7 = ("\x12\x12\x60\x3c\x00\x00\x15\x41\x00\x00\x6f\x3f\x9a\x99\x99\x3c\xcd\xcc\x0c\x3a\x0a\xd7\xa3\x3b"),
   FirmSnappy8 = ("\x30\x30\x78\x3e\x00\x00\x20\x41\x00\x00\xa0\x3f\x9a\x99\x99\x39\xcd\xcc\x0c\x39\x0a\xd7\xa3\x39"),
   FirmSnappy9 = ("\x7a\x12\x34\x3c\x00\x00\x18\x41\x00\x00\x85\x3f"),   
   FirmSnappy10 = ("\xa3\xd7\x0a\x3d\x00\x00\x80\x41\x00\x00\x85\x3f"),     
   FirmSnappy11 = ("\xa3\xd7\x0a\x3d\x00\x00\x20\x41\x00\x00\x85\x3f"),
   FirmSnappy12 = ("\x20\x20\x70\x3d\x00\x00\x20\x41\x00\x00\x8f\x3f"),  
   FirmSnappy13 = ("\x30\x30\x78\x3e\x00\x00\x20\x41\x00\x00\xa0\x3f\x9a\x99\x99\x3e\xcd\xcc\x0c\x40\x0a\xd7\xa3\x30"),
   FirmSnappy14 = ("\x10\x10\x40\x3c\x00\x00\x00\x41\x00\x00\x80\x3f"),
   FirmSnappy15 = ("\x30\x30\x40\x3e\x00\x00\x20\x41\x00\x00\x90\x3f\x66\x66\x66\x3e\xcd\xcc\x0c\x3f\x0a\xd7\xa3\x3d"),
   FirmSnappy16 = ("\x02\x02\x50\x39\x00\x00\x20\x41\x00\x00\x95\x3f\x9a\x99\x99\x3f\xcd\xcc\x0c\x40\x0a\xd7\xa3\x3d"),
   
   FirmSnappy17 = ("\xff\xee\x34\x3c\x00\x00\xff\x41\x00\x00\xff\x3f"), --bottom part of net doesnt deform
   FirmSnappy18 = ("\x00\x00\x00\x00\x00\x00\xff\x41\x00\x00\x00\x00"), --bottom part of net doesnt deform
   FirmSnappy19 = ("\x40\x40\x90\x3f\x00\x00\x10\x40\x00\x00\x00\x3f\xff\x00\xff\x3a\x00\xcc\xff\x3b\xff\x00\xff\x3c"),
   FirmSnappy20 =  ("\x00\x00\x40\x3e\x33\x33\xb3\x3f\x00\x00\x40\x41\x00\x00\x60\x43\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3e\xcd\xcc\xcc\x3d"),
   FirmSnappy21 =  ("\x00\x00\x40\x3e\x33\x33\xb3\x3f\x00\x00\x40\x41\x00\x00\x60\x43\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3e\xcd\xcc\xcc\x3e"),


   MoveEPL =  ("\x00\x00\x40\x3e\x33\x33\xb3\x3f\x00\x00\x40\x41\x00\x00\x90\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3e\xcd\xcc\xcc\x3d"),
   MoveEPL2 = ("\x00\x00\x40\x39\x33\x33\xb3\x3f\x00\x00\x40\x41\x00\x00\x90\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3e\xcd\xcc\xcc\x3d"),

	AiryPocket = ("\x85\xf0\x55\x3f\xb8\x1e\xa5\x3f\x00\x00\x28\x41\x00\x00\x52\x42\xcd\xcc\x2c\x3a\x00\x00\x00\x00\x00\x00\x00\x42\xcd\xcc\x7c\x3f\x00\x00\x80\x3f\x9a\x99\x29\x3e\xcd\xcc\x4c\x3d\x9a\x99\x19\x3d\x00\x00\x00\x3f"),
	SnapBreathPro = ("\x9a\x99\x19\x3f\x66\x66\x86\x3f\x9a\x99\x21\x41\xcd\xcc\x49\x42\x52\xb8\x1e\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\xcd\xcc\x7c\x3f\x66\x66\x86\x3e\xec\x51\xb8\x3d\x33\x33\x33\x3d\xcd\xcc\xcc\x3e"),
	CradleSway = ("\xcd\xcc\x4c\x3f\x9a\x99\x99\x3f\x00\x00\x24\x41\x00\x00\x4c\x42\x8f\xc2\xf5\x39\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x7c\x3f\x00\x00\x80\x3f\x66\x66\xa6\x3e\x8f\xc2\x75\x3d\x0a\xd7\xa3\x3c\x66\x66\x26\x3f"),
	DeepPocketWave = ("\x71\x3d\x8a\x3f\xcd\xcc\x8c\x3f\x66\x66\x26\x41\xcd\xcc\x54\x42\x9a\x99\x19\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x9a\x99\xf1\x3f\x00\x00\x80\x3f\x33\x33\x73\x3e\xcd\xcc\x4c\x3d\x8f\xc2\x75\x3d\x33\x33\xb3\x3e"),
	CornerFeather = ("\x33\x33\x73\x3f\xb8\x1e\x85\x3f\x9a\x99\x21\x41\x33\x33\x4f\x42\xcd\xcc\xcc\x39\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x66\x66\x86\x3f\x1f\x85\x6b\x3e\x0a\xd7\xa3\x3d\x29\x5c\x0f\x3d\x0a\xd7\x23\x3f"),
	QuickTaut = ("\x8f\xc2\xf5\x3e\x9a\x99\x99\x3f\x66\x66\x20\x41\xcd\xcc\x48\x42\x9a\x99\x99\x39\x00\x00\x00\x00\x00\x00\x00\x42\xcd\xcc\x7c\x3f\x00\x00\x80\x3f\xae\x47\x61\x3e\x29\x5c\x0f\x3e\x29\x5c\x8f\x3d\x71\x3d\x0a\x3f"),
	SoftCradle = ("\x9a\x99\x39\x3f\xb8\x1e\x83\x3f\x9a\x99\x21\x41\x33\x33\x49\x42\xcd\xcc\x0c\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x7c\x3f\xcd\xcc\x7c\x3f\x9a\x99\x19\x3e\xec\x51\x38\x3d\x8f\xc2\xf5\x3c\x8f\xc2\x75\x3e"),
	PulseWhip = ("\x66\x66\x66\x3f\xcd\xcc\x8c\x3f\xcd\xcc\x1c\x41\x00\x00\x50\x42\x33\x33\x13\x3a\x00\x00\x00\x00\x00\x00\x00\x42\xcd\xcc\x7c\x3f\xcd\xcc\x7c\x3f\x71\x3d\x8a\x3e\xcd\xcc\x4c\x3d\x29\x5c\x0f\x3d\x33\x33\x33\x3f"),
	TaperSettle = ("\x1f\x85\x6b\x3f\xb8\x1e\x85\x3f\x66\x66\x26\x41\x9a\x99\x51\x42\x8f\xc2\xf5\x39\x00\x00\x00\x00\x00\x00\x00\x42\xcd\xcc\x7c\x3f\x00\x00\x80\x3f\x52\xb8\x1e\x3e\x8f\xc2\xf5\x3d\xcd\xcc\x4c\x3d\x1f\x85\x6b\x3e"),
	TopFloatBottomCatch = ("\x66\x66\x86\x3f\xcd\xcc\x8c\x3f\x00\x00\x20\x41\x00\x00\x58\x42\x33\x33\x33\x3a\x00\x00\x00\x00\x00\x00\x08\x42\xcd\xcc\x7c\x3f\x00\x00\x80\x3f\x9a\x99\x99\x3e\x29\x5c\x8f\x3d\x0a\xd7\xa3\x3d\x66\x66\x86\x3e"),
	WhipDampHybrid = ("\x9a\x99\x59\x3f\x9a\x99\x99\x3f\x33\x33\x23\x41\x66\x66\x56\x42\x8f\xc2\xf5\x39\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\xcd\xcc\x7c\x3f\xec\x51\x38\x3e\x71\x3d\x8a\x3d\x8f\xc2\xf5\x3d\x0a\xd7\x23\x3f"),
	
	
	Elastic =  ("\x52\xb8\x1e\x3f\x66\x66\x96\x3f\xcd\xcc\x1c\x41\x9a\x99\x51\x42\x33\x33\x13\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x66\x66\x86\x3f\x00\x00\x80\x3f\xcd\xcc\x4c\x3e\x71\x3d\x0a\x3e\x8f\xc2\xf5\x3d\xec\x51\x38\x3e"),	
	Elastic2 = ("\x52\xb8\x1e\x3f\x66\x66\x96\x3f\xcd\xcc\x1c\x41\x9a\x99\x51\x42\x33\x33\x13\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x66\x66\x86\x3f\x00\x00\x80\x3f\xcd\xcc\x4c\x3e\x71\x3d\x0a\x3e\x8f\xc2\xf5\x3d\xec\x51\x20\x3f"),
	Elastic3 = ("\x52\xb8\x1e\x3f\x66\x66\x96\x3f\xcd\xcc\x1c\x41\x9a\x99\x51\x42\x33\x33\x13\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x66\x66\x86\x3f\x00\x00\x80\x3f\xcd\xcc\x4c\x3e\x71\x3d\x0a\x3e\x8f\xc2\xf5\x3d\xec\x51\x70\x3f"),

-- FC25-ish net movement 
	FC25_1 = ("\x1f\x85\x6b\x3f\x48\xe1\x7a\x3f\x00\x00\x20\x41\x00\x00\x68\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\x0a\xd7\x23\x3e\xae\x47\x61\x3d\x29\x5c\x0f\x3d\xd7\xa3\x70\x3f"),
	FC25_2 = ("\x33\x33\x73\x3f\x5c\x8f\x82\x3f\x00\x00\x28\x41\x00\x00\x78\x42\xe0\x2d\x90\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\xec\x51\x38\x3e\x12\x83\x40\x3d\x02\x2b\x07\x3d\x00\x00\x80\x3f"),
	FC25_3 = ("\xae\x47\x61\x3f\x66\x66\x86\x3f\x00\x00\x20\x41\x00\x00\x84\x42\x52\x49\x9d\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\x3d\x0a\x57\x3e\xf4\xfd\x54\x3d\x0a\xd7\x23\x3d\x66\x66\x66\x3f"),
	FC25_4 = ("\xa4\x70\x7d\x3f\x8f\xc2\x75\x3f\xcd\xcc\x1c\x41\x00\x00\x60\x42\xfa\xed\x6b\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\x29\x5c\x0f\x3e\xcd\xcc\x4c\x3d\x8f\xc2\xf5\x3c\x48\xe1\x7a\x3f"),
	FC25_5 = ("\x7b\x14\x6e\x3f\x71\x3d\x8a\x3f\x33\x33\x23\x41\x00\x00\x70\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\xae\x47\x61\x3e\xa6\x9b\x44\x3d\xbc\x74\x13\x3d\xec\x51\x78\x3f"),
	FC25_6 = ("\x66\x66\x66\x3f\xd7\xa3\x70\x3f\x00\x00\x20\x41\x00\x00\x58\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\x8f\xc2\xf5\x3d\x8f\xc2\x75\x3d\xec\x51\x38\x3d\xae\x47\x61\x3f"),
	FC25_7 = ("\xec\x51\x78\x3f\xa4\x70\x7d\x3f\x00\x00\x20\x41\x00\x00\x68\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x08\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\x9a\x99\x19\x3e\xcd\xcc\x4c\x3d\x96\x43\x0b\x3d\x8f\xc2\x75\x3f"),
	FC25_8 = ("\xc3\xf5\x68\x3f\x0a\xd7\x83\x3f\xcd\xcc\x24\x41\x00\x00\x7c\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\xf8\x41\x00\x00\x80\x3f\x00\x00\x80\x3f\xcd\xcc\x4c\x3e\x39\xb4\x48\x3d\x50\x8d\x17\x3d\x1f\x85\x6b\x3f"),

}

--//================================================================================================================================================================//
-- Goalnets physics
--//================================================================================================================================================================//

local net_physics = {

   Original =  ("\x00\x00\x20\x41\x00\x00\x80\x3f\x17\xb7\xd1\x38\x6f\x12\x83\x3a\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\x9a\x99\x99\x3e\xcd\xcc\x0c\x40\x0a\xd7\xa3\x3c\x00\x00\x80\x3f\x00\x00\x00\x40\xcd\xcc\x4c\x3f\xcd\xcc\x4c\x3e\x00\x00\x00\x3f\xcd\xcc\xcc\x3d\xcd\xcc\x4c\x3f\x0a\xd7\xa3\x3c\xcd\xcc\x4c\x3d"),
   SOriginal = ("\x00\x00\x20\x41\x00\x00\x80\x3f\x17\xb7\xd1\x38\x6f\x12\x83\x3e\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\x9a\x99\x99\x3e\xcd\xcc\x0c\x40\x0a\xd7\xa3\x3c\x00\x00\x80\x3f\x00\x00\x00\x40\xcd\xcc\x4c\x3f\xcd\xcc\x4c\x3e\x00\x00\x00\x3f\xcd\xcc\xcc\x3d\xcd\xcc\x4c\x3f\x0a\xd7\xa3\x3c\xcd\xcc\x4c\x3d"),
   POriginal = ("\x00\x00\x20\x41\x00\x00\x80\x3f\x17\xb7\xd1\x38\x6f\x12\x83\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\x9a\x99\x99\x3e\xcd\xcc\x0c\x40\x0a\xd7\xa3\x3c\x00\x00\x80\x3f\x00\x00\x00\x40\xcd\xcc\x4c\x3f\xcd\xcc\x4c\x3e\x00\x00\x00\x3f\xcd\xcc\xcc\x3d\xcd\xcc\x4c\x3f\x0a\xd7\xa3\x3c\xcd\xcc\x4c\x3d"),

   TOriginal =  ("\x00\x00\x20\x41\x00\x00\x80\x3f\x17\xb7\xd1\x38\x52\x2f\x5f\x39\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\x9a\x99\x99\x3e\xcd\xcc\x0c\x40\x0a\xd7\xa3\x3c\x00\x00\x80\x3f\x00\x00\x00\x40\xcd\xcc\x4c\x3f\xcd\xcc\x4c\x3e\x00\x00\x00\x3f\xcd\xcc\xcc\x3d\xcd\xcc\x4c\x3f\x0a\xd7\xa3\x3c\xcd\xcc\x4c\x3d"),
 

   EPL = 	("\x00\x00\x48\x41\xcd\xcc\x4c\x3b\x17\xb7\xd1\x38\x6f\x12\x83\x3a\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\x9a\x99\x99\x3e\xcd\xcc\x0c\x40\x0a\xd7\xa3\x3c\x00\x00\x80\x3f\x00\x00\x00\x40\xcd\xcc\x4c\x3f\xcd\xcc\x4c\x3e\x00\x00\x00\x3f\xcd\xcc\xcc\x3d\xcd\xcc\x4c\x3f\x0a\xd7\xa3\x3c\x0a\xd7\xa3\x3d"),

   IPL =   	("\x05\x05\x48\x40\xcd\xcc\x4d\x3e\x17\xb7\xcc\x38\x6f\x12\x83\x3a\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\x9a\x99\x99\x3e\xcd\xcc\x0c\x40\x0a\xd7\xa3\x3c\x00\x00\x80\x3f\x00\x00\x00\x40\xcd\xcc\x4c\x3f\xcd\xcc\x4c\x3e\x00\x00\x00\x3f\xcd\xcc\xcc\x3d\xcd\xcc\x4c\x3f\x0a\xd7\xa3\x3c\x29\x5c\x8f\x3d"),
   SIPL =   ("\x05\x05\x48\x40\xcd\xcc\x4d\x3e\x17\xb7\xcc\x38\x6f\x12\x83\x3e\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\x9a\x99\x99\x3e\xcd\xcc\x0c\x40\x0a\xd7\xa3\x3c\x00\x00\x80\x3f\x00\x00\x00\x40\xcd\xcc\x4c\x3f\xcd\xcc\x4c\x3e\x00\x00\x00\x3f\xcd\xcc\xcc\x3d\xcd\xcc\x4c\x3f\x0a\xd7\xa3\x3c\x29\x5c\x8f\x3d"),
   PIPL =   ("\x05\x05\x48\x40\xcd\xcc\x4d\x3e\x17\xb7\xcc\x38\x6f\x12\x83\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\x9a\x99\x99\x3e\xcd\xcc\x0c\x40\x0a\xd7\xa3\x3c\x00\x00\x80\x3f\x00\x00\x00\x40\xcd\xcc\x4c\x3f\xcd\xcc\x4c\x3e\x00\x00\x00\x3f\xcd\xcc\xcc\x3d\xcd\xcc\x4c\x3f\x0a\xd7\xa3\x3c\x29\x5c\x8f\x3d"),
   UIPL =  ("\x05\x05\x48\x40\xcd\xcc\x4d\x3e\x17\xb7\xcc\x38\x6f\x12\x83\x40\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\x9a\x99\x99\x3e\xcd\xcc\x0c\x40\x0a\xd7\xa3\x3c\x00\x00\x80\x3f\x00\x00\x00\x40\xcd\xcc\x4c\x3f\xcd\xcc\x4c\x3e\x00\x00\x00\x3f\xcd\xcc\xcc\x3d\xcd\xcc\x4c\x3f\x0a\xd7\xa3\x3c\x29\x5c\x8f\x3d"),
   UPIPL =  ("\x05\x05\x48\x40\xcd\xcc\x4d\x3e\x17\xb7\xcc\x38\x6f\x12\x83\x41\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\x9a\x99\x99\x3e\xcd\xcc\x0c\x40\x0a\xd7\xa3\x3c\x00\x00\x80\x3f\x00\x00\x00\x40\xcd\xcc\x4c\x3f\xcd\xcc\x4c\x3e\x00\x00\x00\x3f\xcd\xcc\xcc\x3d\xcd\xcc\x4c\x3f\x0a\xd7\xa3\x3c\x29\x5c\x8f\x3d"),
   IPLow = 	("\x00\x00\x48\x3f\xcd\xcc\x4c\x3e\x17\xb7\xd1\x38\x6f\x12\x83\x3a\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\x9a\x99\x99\x3e\xcd\xcc\x0c\x40\x0a\xd7\xa3\x3c\x00\x00\x80\x3f\x00\x00\x00\x40\xcd\xcc\x4c\x3f\xcd\xcc\x4c\x3e\x00\x00\x00\x3f\xcd\xcc\xcc\x3d\xcd\xcc\x4c\x3f\x0a\xd7\xa3\x3c\x29\x5c\x8f\x3d"),

   PL =   	("\x02\x02\x48\x40\x00\x00\x23\x41\x17\xb7\xd5\x39\x6f\x12\x83\x3a\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\x9a\x99\x99\x3e\xcd\xcc\x0c\x40\x0a\xd7\xa3\x3c\x00\x00\x80\x3f\x00\x00\x00\x40\xcd\xcc\x4c\x3f\xcd\xcc\x4c\x3e\x00\x00\x00\x3f\xcd\xcc\xcc\x3d\xcd\xcc\x4c\x3f\x0a\xd7\xa3\x37\x0a\xd7\xa3\x3c"),
   PLow = 	("\x03\x03\x48\x3f\x00\x00\x22\x41\x19\xb7\xd3\x38\x6f\x12\x83\x3a\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\x9a\x99\x99\x3e\xcd\xcc\x0c\x40\x0a\xd7\xa3\x3c\x00\x00\x80\x3f\x00\x00\x00\x40\xcd\xcc\x4c\x3f\xcd\xcc\x4c\x3e\x00\x00\x00\x3f\xcd\xcc\xcc\x3d\xcd\xcc\x4c\x3f\x0a\xd7\xa3\x3a\x17\xd7\xa3\x3c"),
   PLow2 = 	("\x03\x03\x48\x3f\x00\x00\x22\x41\x19\xb7\xd3\x38\x6f\x12\x83\x3a\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\x9a\x99\x99\x3e\xcd\xcc\x0c\x40\x0a\xd7\xa3\x3c\x00\x00\x80\x3f\x00\x00\x00\x40\xcd\xcc\x4c\x3f\xcd\xcc\x4c\x3e\x00\x00\x00\x3f\xcd\xcc\xcc\x3d\xcd\xcc\x4c\x3f\x0a\xd7\xa3\x3a\x17\xd7\xa3\x39"),

   Porto =  ("\x89\x20\x40\x40\x00\x00\x21\x40\x17\xb7\xd1\x38\x6f\x12\x83\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\x9a\x99\x99\x3e\xcd\x29\x4c\x80\x0a\xd7\xa3\x3c\x00\x00\x80\x3f\x00\x00\x00\x40\xcd\xcc\x4c\x3f\xcd\xcc\x4c\x3e\x00\x00\x00\x3f\xcd\xcc\xcc\x3d\xcd\xcc\x4c\x3f\x0a\xd7\xa3\x3c\x29\x5c\x8f\x3d"),
   PortoL = ("\x89\x20\x40\x3f\x00\x00\x21\x41\x17\xb7\xd1\x38\x6f\x12\x83\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\x9a\x99\x99\x3e\xcd\xcc\x0c\x42\x0a\xd7\xa3\x3c\x00\x00\x80\x3f\x00\x00\x00\x40\xcd\xcc\x4c\x3f\xcd\xcc\x4c\x3e\x00\x00\x00\x3f\xcd\xcc\xcc\x3d\xcd\xcc\x4c\x3f\x0a\xd7\xa3\x3c\x29\x5c\x8f\x3d"),
   SPortoL =("\x89\x20\x40\x3f\x00\x00\x21\x41\x17\xb7\xd1\x38\x6f\x12\x83\x3e\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\x9a\x99\x99\x3e\xcd\xcc\x0c\x42\x0a\xd7\xa3\x3c\x00\x00\x80\x3f\x00\x00\x00\x40\xcd\xcc\x4c\x3f\xcd\xcc\x4c\x3e\x00\x00\x00\x3f\xcd\xcc\xcc\x3d\xcd\xcc\x4c\x3f\x0a\xd7\xa3\x3c\x29\x5c\x8f\x3d"),
   PortoT = ("\x89\x20\x40\x41\x00\x00\x21\x3f\x11\xb4\xc9\x38\x6f\x12\x83\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\x9a\x99\x99\x3e\xcd\xcc\x0c\x42\x0a\xd7\xa3\x3c\x00\x00\x80\x3f\x00\x00\x00\x40\xcd\xcc\x4c\x3f\xcd\xcc\x4c\x3e\x00\x00\x00\x3f\xcd\xcc\xcc\x3d\xcd\xcc\x4c\x3f\x0a\xd7\xa3\x3c\x0a\xd7\xa3\x3d"),
   PortoLT =("\x89\x21\x40\x3f\x00\x00\x21\x40\x12\xa9\xd4\x38\x6f\x14\x85\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\x9a\x99\x99\x3e\xcd\xcc\x0c\x42\x0a\xd7\xa3\x3c\x00\x00\x80\x3f\x00\x00\x00\x40\xcd\xcc\x4c\x3f\xcd\xcc\x4c\x3e\x00\x00\x00\x3f\xcd\xcc\xcc\x3d\xcd\xcc\x4c\x3f\x0a\xd7\xa3\x3c\x0a\xca\x81\x3c"),
   SPorto = ("\x89\x20\x40\x40\x00\x00\x21\x40\x17\xb7\xd1\x38\x6f\x12\x83\x3e\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\x9a\x99\x99\x3e\xcd\x29\x4c\x80\x0a\xd7\xa3\x3c\x00\x00\x80\x3f\x00\x00\x00\x40\xcd\xcc\x4c\x3f\xcd\xcc\x4c\x3e\x00\x00\x00\x3f\xcd\xcc\xcc\x3d\xcd\xcc\x4c\x3f\x0a\xd7\xa3\x3c\x29\x5c\x8f\x3d"),
   SPortoT =("\x89\x20\x40\x41\x00\x00\x21\x3f\x11\xb4\xc9\x38\x6f\x12\x83\x3e\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\x9a\x99\x99\x3e\xcd\xcc\x0c\x42\x0a\xd7\xa3\x3c\x00\x00\x80\x3f\x00\x00\x00\x40\xcd\xcc\x4c\x3f\xcd\xcc\x4c\x3e\x00\x00\x00\x3f\xcd\xcc\xcc\x3d\xcd\xcc\x4c\x3f\x0a\xd7\xa3\x3c\x0a\xd7\xa3\x3d"),

   Normal = ("\x00\x00\x00\x3f\x00\x00\x21\x3f\x16\xb7\xd4\x38\x6f\x12\x83\x3a\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\x9a\x99\x99\x3e\xcd\xcc\x0c\x40\x0a\xd7\xa3\x3c\x00\x00\x80\x3f\x00\x00\x00\x40\xcd\xcc\x4c\x3f\xcd\xcc\x4c\x3e\x00\x00\x00\x3f\xcd\xcc\xcc\x3d\xcd\xcc\x4c\x3f\x0a\xd7\xa3\x3e\xcd\xcc\x80\x3c"),
   SNormal =("\x00\x00\x00\x3f\x00\x00\x21\x3f\x16\xb7\xd4\x38\x6f\x12\x83\x3e\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\x9a\x99\x99\x3e\xcd\xcc\x0c\x40\x0a\xd7\xa3\x3c\x00\x00\x80\x3f\x00\x00\x00\x40\xcd\xcc\x4c\x3f\xcd\xcc\x4c\x3e\x00\x00\x00\x3f\xcd\xcc\xcc\x3d\xcd\xcc\x4c\x3f\x0a\xd7\xa3\x3e\xcd\xcc\x80\x3c"),
   PNormal =("\x00\x00\x00\x3f\x00\x00\x21\x3f\x16\xb7\xd4\x38\x6f\x12\x83\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\x9a\x99\x99\x3e\xcd\xcc\x0c\x40\x0a\xd7\xa3\x3c\x00\x00\x80\x3f\x00\x00\x00\x40\xcd\xcc\x4c\x3f\xcd\xcc\x4c\x3e\x00\x00\x00\x3f\xcd\xcc\xcc\x3d\xcd\xcc\x4c\x3f\x0a\xd7\xa3\x3e\xcd\xcc\x80\x3c"),
    
   Italy =  ("\x00\x00\x00\x40\x00\x00\x21\x41\x17\xb7\xd1\x38\x6f\x12\x83\x3a\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\x9a\x99\x99\x3e\xcd\xcc\x0c\x40\x0a\xd7\xa3\x3c\x00\x00\x80\x3f\x00\x00\x00\x40\xcd\xcc\x4c\x3f\xcd\xcc\x4c\x3e\x00\x00\x00\x3f\xcd\xcc\xcc\x3d\xcd\xcc\x4c\x3f\x3a\x42\x66\x37\x00\x00\x7f\x3c"),
   ItalyL = ("\x00\x00\x00\x40\x00\x00\x21\x41\x17\xb7\xd1\x38\x6f\x12\x83\x3a\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\x9a\x99\x99\x3e\xcd\xcc\x0c\x40\x0a\xd7\xa3\x3c\x00\x00\x80\x3f\x00\x00\x00\x40\xcd\xcc\x4c\x3f\xcd\xcc\x4c\x3e\x00\x00\x00\x3f\xcd\xcc\xcc\x3d\xcd\xcc\x4c\x3f\x3a\x42\x66\x37\x00\x00\x7f\x3a"),
   ItalyT = ("\x00\x00\x00\x40\x00\x00\x21\x41\x17\xb7\xd1\x38\x6f\x12\x83\x3a\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\x9a\x99\x99\x3e\xcd\xcc\x0c\x40\x0a\xd2\xa3\x3c\x00\x00\x80\x3f\x00\x00\x00\x40\xcd\xcc\x4c\x3f\xcd\xcc\x4c\x3e\x00\x00\x00\x3f\xcd\xcc\xcc\x3d\xcd\xcc\x4c\x3f\x3a\x42\x66\x37\x00\x00\x7f\xb9"),
   Italy0 = ("\x00\x00\x00\x40\x00\x00\x21\x41\x17\xb7\xd1\x38\x6f\x12\x83\x3a\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\x9a\x99\x99\x3e\xcd\xcc\x0c\x40\x0a\xd7\xa3\x3c\x00\x00\x80\x3f\x00\x00\x00\x40\xcd\xcc\x4c\x3f\xcd\xcc\x4c\x3e\x00\x00\x00\x3f\xcd\xcc\xcc\x3d\xcd\xcc\x4c\x3f\x3a\x42\x66\x37\x00\x00\x7f\x00"),
   Italy2 = ("\x00\x00\x00\x41\x00\x00\x21\x41\x17\xb7\xd1\x38\x6f\x12\x83\x3a\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\x9a\x99\x99\x3e\xcd\xcc\x0c\x40\x0a\xd7\xa3\x3c\x00\x00\x80\x3f\x00\x00\x00\x40\xcd\xcc\x4c\x3f\xcd\xcc\x4c\x3e\x00\x00\x00\x3f\xcd\xcc\xcc\x3d\xcd\xcc\x4c\x3f\x0a\xd7\xa3\x3c\x29\x5c\x8f\x3d"),
   SItaly = ("\x00\x00\x00\x40\x00\x00\x21\x41\x17\xb7\xd1\x38\x6f\x12\x83\x3e\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\x9a\x99\x99\x3e\xcd\xcc\x0c\x40\x0a\xd7\xa3\x3c\x00\x00\x80\x3f\x00\x00\x00\x40\xcd\xcc\x4c\x3f\xcd\xcc\x4c\x3e\x00\x00\x00\x3f\xcd\xcc\xcc\x3d\xcd\xcc\x4c\x3f\x3a\x42\x66\x37\x00\x00\x7f\x3c"),   
   PItaly = ("\x00\x00\x00\x40\x00\x00\x21\x41\x17\xb7\xd1\x38\x6f\x12\x83\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\x9a\x99\x99\x3e\xcd\xcc\x0c\x40\x0a\xd7\xa3\x3c\x00\x00\x80\x3f\x00\x00\x00\x40\xcd\xcc\x4c\x3f\xcd\xcc\x4c\x3e\x00\x00\x00\x3f\xcd\xcc\xcc\x3d\xcd\xcc\x4c\x3f\x3a\x42\x66\x37\x00\x00\x7f\x3c"),
    
   Brasil = ("\x00\x00\x20\x41\x00\x00\x80\x41\x17\xb7\xd1\x38\x6f\x12\x83\x38\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\x9a\x99\x99\x3e\xcd\xcc\x0c\x40\x0a\xd7\xa3\x3c\x00\x00\x80\x3f\x00\x00\x00\x40\xcd\xcc\x4c\x3f\xcd\xcc\x4c\x3e\x00\x00\x00\x3f\xcd\xcc\xcc\x3d\xcd\xcc\x4c\x3f\x0a\xd7\xa3\x3c\x0a\xd7\xa3\x3d"),
   France = ("\x20\x20\x40\x41\x00\x00\xa0\x41\x17\xb7\xd1\x38\x6f\x12\x83\x3a\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\x9a\x99\x99\x3e\xcd\xcc\x0c\x40\x0a\xd7\xa3\x3c\x00\x00\x80\x3f\x00\x00\x00\x40\xcd\xcc\x4c\x3f\xcd\xcc\x4c\x3e\x00\x00\x00\x3f\xcd\xcc\xcc\x3d\xcd\xcc\x4c\x3f\x0a\xd7\xa3\x3c\x29\x5c\x8f\x3d"),
   
   Spain =  ("\x00\x00\x00\x41\x00\x00\xa0\x41\x17\xb7\xd1\x38\x6f\x12\x83\x3a\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\x9a\x99\x99\x3e\xcd\xcc\x0c\x40\x0a\xd7\xa3\x3c\x00\x00\x80\x3f\x00\x00\x00\x40\xcd\xcc\x4c\x3f\xcd\xcc\x4c\x3e\x00\x00\x00\x3f\xcd\xcc\xcc\x3d\xcd\xcc\x4c\x3f\x0a\xd7\xa3\x37\x2c\x5c\x8f\x3c"),
   Spain2 = ("\x00\x00\x00\x41\x00\x00\xa0\x41\x17\xb7\xd1\x38\x6f\x12\x83\x3a\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\x9a\x99\x99\x3e\xcd\xcc\x0c\x40\x0a\xd7\xa3\x3c\x00\x00\x80\x3f\x00\x00\x00\x40\xcd\xcc\x4c\x3f\xcd\xcc\x4c\x3e\x00\x00\x00\x3f\xcd\xcc\xcc\x3d\xcd\xcc\x4c\x3f\x0a\xd7\xa3\x3c\x29\x5c\x8f\x3d"),  
   PSpain = ("\x00\x00\x00\x41\x00\x00\xa0\x41\x17\xb7\xd1\x38\x6f\x12\x83\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\x9a\x99\x99\x3e\xcd\xcc\x0c\x40\x0a\xd7\xa3\x3c\x00\x00\x80\x3f\x00\x00\x00\x40\xcd\xcc\x4c\x3f\xcd\xcc\x4c\x3e\x00\x00\x00\x3f\xcd\xcc\xcc\x3d\xcd\xcc\x4c\x3f\x0a\xd7\xa3\x37\x2c\x5c\x8f\x3c"),
   SSpain = ("\x00\x00\x00\x41\x00\x00\xa0\x41\x17\xb7\xd1\x38\x6f\x12\x83\x3e\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\x9a\x99\x99\x3e\xcd\xcc\x0c\x40\x0a\xd7\xa3\x3c\x00\x00\x80\x3f\x00\x00\x00\x40\xcd\xcc\x4c\x3f\xcd\xcc\x4c\x3e\x00\x00\x00\x3f\xcd\xcc\xcc\x3d\xcd\xcc\x4c\x3f\x0a\xd7\xa3\x37\x2c\x5c\x8f\x3c"),

   FIFA =  	("\x66\x66\x86\x40\x00\x00\x21\x41\x13\xb7\xd0\x38\x6f\x12\x83\x3a\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\x9a\x99\x99\x3e\xcd\xcc\x0c\x40\x0a\xd7\xa3\x3c\x00\x00\x80\x3f\x00\x00\x00\x40\xcd\xcc\x4c\x3f\xcd\xcc\x4c\x3e\x00\x00\x00\x3f\xcd\xcc\xcc\x3d\xcd\xcc\x4c\x3f\x0a\xd7\xa3\x3c\x29\x5c\x8f\x3d"),
   SFIFA =  ("\x66\x66\x86\x40\x00\x00\x21\x41\x13\xb7\xd0\x38\x6f\x12\x83\x3e\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\x9a\x99\x99\x3e\xcd\xcc\x0c\x40\x0a\xd7\xa3\x3c\x00\x00\x80\x3f\x00\x00\x00\x40\xcd\xcc\x4c\x3f\xcd\xcc\x4c\x3e\x00\x00\x00\x3f\xcd\xcc\xcc\x3d\xcd\xcc\x4c\x3f\x0a\xd7\xa3\x3c\x29\x5c\x8f\x3d"),
   FIFA2 = 	("\x66\x66\x86\x40\x00\x00\x21\x41\x13\xb7\xd0\x38\x6f\x12\x83\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\x9a\x99\x99\x3e\xcd\xcc\x0c\x40\x0a\xd7\xa3\x3c\x00\x00\x80\x3f\x00\x00\x00\x40\xcd\xcc\x4c\x3f\xcd\xcc\x4c\x3e\x00\x00\x00\x3f\xcd\xcc\xcc\x3d\xcd\xcc\x4c\x3f\x0a\xd7\xa3\x3c\x29\x5c\x8f\x3d"),
   FIFA3 = 	("\x00\x00\x20\x41\x00\x00\x80\x3f\x17\xb7\xd1\x38\x6f\x12\x83\x3a\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\x9a\x99\x99\x3e\xcd\xcc\x0c\x40\x0a\xd7\xa3\x3c\x00\x00\x80\x3f\x00\x00\x00\x40\xcd\xcc\x4c\x3f\xcd\xcc\x4c\x3e\x00\x00\x00\x3f\xcd\xcc\xcc\x3d\xcd\xcc\x4c\x3f\x0a\xd7\xa3\x3c\xcd\xcc\x4c\x3d"),						 

   NXT =	("\x00\x00\x20\x41\x00\x00\x20\x41\x00\x00\x80\x3f\x17\xb7\xd1\x38\x6f\x12\x83\x3a\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\xcd\xcc\x0c\x40\x0a\xd7\xa3\x3c\x00\x00\x80\x3f\x00\x00\x00\x40\xcd\xcc\x4c\x3f\xcd\xcc\x4c\x3e\x00\x00\x00\x3f\xcd\xcc\xcc\x3d\xcd\xcc\x4c\x3f\x0a\xd7\xa3\x3c\xcd\xcc\x4c\x3d"),
   NXT2 = 	("\x00\x00\x00\x41\x00\x00\xa0\x41\x17\xb7\xd1\x38\x6f\x12\x83\x3a\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\x9a\x99\x99\x3e\xcd\xcc\x0c\x40\x0a\xd7\xa3\x3c\x00\x00\x80\x3f\x00\x00\x00\x40\xcd\xcc\x4c\x3f\xcd\xcc\x4c\x3e\x00\x00\x00\x3f\xcd\xcc\xcc\x3d\xcd\xcc\x4c\x3f\x0a\xd7\xa3\x3c\x29\x5c\x8f\x3d"),
   NXT3 =   ("\x29\x5c\x0f\x40\x30\x30\xc0\x41\x19\xb5\xd2\x39\x6c\x15\x85\x3a\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\x9a\x99\x99\x3e\xcd\xcc\x0c\x40\x0a\xd7\xa3\x3c\x00\x00\x80\x3f\x00\x00\x00\x40\xcd\xcc\x4c\x3f\xcd\xcc\x4c\x3e\x00\x00\x00\x3f\xcd\xcc\xcc\x3d\xcd\xcc\x4c\x3f\x0a\xd7\xa3\x37\x2c\x5c\x8f\x3c"),
   NXT4 = 	("\xcd\xcc\x0c\x41\x00\x00\x80\x41\x3c\xbf\xd1\x38\x6f\x12\x83\x3a\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\x9a\x99\x99\x3e\xcd\xcc\x0c\x40\x0a\xd7\xa3\x3c\x00\x00\x80\x3f\x00\x00\x00\x40\xcd\xcc\x4c\x3f\xcd\xcc\x4c\x3e\x00\x00\x00\x3f\xcd\xcc\xcc\x3d\xcd\xcc\x4c\x3f\x0a\xd7\xa3\x3c\x29\x5a\x8d\x3c"),  

-- Test
   Balanced = ("\x20\x20\x40\x41\x00\x00\x80\x40\x16\xb7\xd1\x39\x6f\x12\x83\x3a\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\x9a\x99\x99\x3f\xcd\xcc\x0c\x40\x0a\xd7\xa3\x3d\x00\x00\x80\x3f\x00\x00\x00\x40\xcd\xcc\x4c\x3f\xcd\xcc\x4c\x3e\x00\x00\x00\x3f\xcd\xcc\xcc\x3d\xcd\xcc\x4c\x3f\x0a\xd7\xa3\x3c\x29\x5c\x8f\x3d"),
   Rigid =    ("\x10\x10\x40\x41\x00\x00\x80\x40\x12\xb7\xd1\x39\x6f\x12\x83\x3a\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\x9a\x99\x99\x3e\xcd\xcc\x0c\x40\x0a\xd7\xa3\x3c\x00\x00\x80\x3f\x00\x00\x00\x40\xcd\xcc\x4c\x3f\xcd\xcc\x4c\x3e\x00\x00\x00\x3f\xcd\xcc\xcc\x3d\xcd\xcc\x4c\x3f\x0a\xd7\xa3\x3c\x29\x5c\x8f\x3d"),
   ElasticPhyisics =  ("\x30\x30\x50\x41\x00\x00\x80\x40\x19\xb7\xd2\x39\x6f\x12\x83\x3a\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\x9a\x99\x99\x3f\xcd\xcc\x0c\x40\x0a\xd7\xa3\x3d\x00\x00\x80\x3f\x00\x00\x00\x40\xcd\xcc\x4c\x3f\xcd\xcc\x4c\x3e\x00\x00\x00\x3f\xcd\xcc\xcc\x3d\xcd\xcc\x4c\x3f\x0a\xd7\xa3\x3c\x29\x5c\x8f\x3d"),
   Tight =    ("\x15\x15\x48\x40\x00\x00\x80\x40\x16\xb7\xd0\x39\x6f\x12\x83\x3a\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\x9a\x99\x99\x3f\xcd\xcc\x0c\x40\x0a\xd7\xa3\x3c\x00\x00\x80\x3f\x00\x00\x00\x40\xcd\xcc\x4c\x3f\xcd\xcc\x4c\x3e\x00\x00\x00\x3f\xcd\xcc\xcc\x3d\xcd\xcc\x4c\x3f\x0a\xd7\xa3\x3c\x29\x5c\x8f\x3d"),
   Tight2 =   ("\x15\x15\x48\x40\x00\x00\x80\x40\x16\xb7\xd0\x39\x6f\x12\x83\x3a\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\x9a\x99\x99\x3f\xcd\xcc\x0c\x40\x0a\xd7\xa3\x3c\x00\x00\x80\x3f\x00\x00\x00\x40\xcd\xcc\x4c\x3f\xcd\xcc\x4c\x3e\x00\x00\x00\x3f\xcd\xcc\xcc\x3d\xcd\xcc\x4c\x3f\x0a\xd7\xa3\x3c\x29\x5c\x8f\x3a"),
   Loose =    ("\x05\x05\x48\x40\x00\x00\x80\x40\x10\xb7\xd1\x39\x6f\x12\x83\x3a\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\x9a\x99\x99\x3f\xcd\xcc\x0c\x40\x0a\xd7\xa3\x3d\x00\x00\x80\x3f\x00\x00\x00\x40\xcd\xcc\x4c\x3f\xcd\xcc\x4c\x3e\x00\x00\x00\x3f\xcd\xcc\xcc\x3d\xcd\xcc\x4c\x3f\x0a\xd7\xa3\x3c\x29\x5c\x8f\x3d"),
   UTD2003 =  ("\x00\x00\x20\x41\x00\x00\x80\x3c\x17\xb7\xd1\x38\x6f\x12\x83\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\x9a\x99\x99\x3e\xcd\xcc\x0c\x40\x0a\xd7\xa3\x3c\x00\x00\x80\x3f\x00\x00\x00\x40\xcd\xcc\x4c\x3f\xcd\xcc\x4c\x3e\x00\x00\x00\x3f\xcd\xcc\xcc\x3d\xcd\xcc\x4c\x3f\x0a\xd7\xa3\x3c\xcd\xcc\x4c\x3d"),
   Slovan =   ("\x00\x00\x00\x40\x00\x00\x21\x39\x17\xb7\xd1\x38\x6f\x12\x83\x3a\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\x9a\x99\x99\x3e\xcd\xcc\x0c\x40\x0a\xd7\xa3\x3c\x00\x00\x80\x3f\x00\x00\x00\x40\xcd\xcc\x4c\x3f\xcd\xcc\x4c\x3e\x00\x00\x00\x3f\xcd\xcc\xcc\x3d\xcd\xcc\x4c\x3f\x3a\x42\x66\x37\x00\x00\x7f\x3c"),
   Fulham =   ("\x00\x00\x00\x80\x00\x00\x21\x3c\xaa\xb7\xd1\x38\x6f\x12\x83\x3a\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\x9a\x99\x99\x3e\xcd\xcc\x0c\x40\x0a\xd2\xa3\x3c\x00\x00\x80\x3f\x00\x00\x00\x40\xcd\xcc\x4c\x3f\xcd\xcc\x4c\x3e\x00\x00\x00\x3f\xcd\xcc\xcc\x3d\xcd\xcc\x4c\x3f\x3a\x42\x66\x37\x00\x00\x7f\xb9"),
   Leicester =("\x00\x00\x00\x40\x00\x00\x21\x40\x17\xb7\xd1\x38\x6f\x12\x83\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\x9a\x99\x99\x3e\xcd\xcc\x0c\x40\x0a\xd7\xa3\x3c\x00\x00\x80\x3f\x00\x00\x00\x40\xcd\xcc\x4c\x3f\xcd\xcc\x4c\x3e\x00\x00\x00\x3f\xcd\xcc\xcc\x3d\xcd\xcc\x4c\x3f\x3a\x42\x66\x37\x00\x00\x7f\x3c"),

-- New values (N-New, T-Tight)

   OriginalNN =  ("\x00\x00\x20\x41\x00\x00\x80\x3f\x17\xb7\xd1\x38\x6f\x12\x83\x3a\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\x9a\x99\x99\x3e\xcd\xcc\x0c\x40\x0a\xd7\xa3\x3c"),
   OriginalN1 = ("\x00\x00\x20\x41\x00\x00\x80\x3f\x00\x00\x80\x38\x00\x00\x88\x37\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x33\x3f\x9a\x99\x99\x3e\xcd\xcc\x0c\x40\x8a\xe1\x58\x3c"),
   OriginalN2 = ("\x00\x00\x20\x41\x00\x00\x80\x3f\x00\x00\x80\x38\x00\x00\x88\x37\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x33\x3f\x9a\x99\x99\x3e\xcd\xcc\x0c\x40\x14\xae\x47\x3d"),
   OriginalN3 = ("\x00\x00\xe0\x41\x9a\x99\x59\x3f\xcf\xc2\xd9\x38\x0a\xd7\xa3\x3c\xcd\xcc\x4c\x3d\x00\x00\x00\x40\x00\x00\x00\x40\x0a\xd7\x83\x3f\xcd\xcc\x4c\x3e\x00\x00\xf8\x40\x00\x00\xa0\x3d"),
   
   
   
   Firm =  		("\x00\x00\x00\x40\x00\x00\x21\x41\x17\xb7\xa1\x36\x6f\x12\x83\x36\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3a\x33\x33\x70\x3a\x9a\x99\x99\xc9\xcd\xcc\x0c\xc9\x0a\xd7\xa3\xc9"),
   Firm2 =  	("\x00\x00\x00\x40\x00\x00\x21\x10\x17\xb7\xa1\x36\x6f\x12\x83\x36\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3a\x33\x33\x70\x3a\x9a\x99\x99\xc9\xcd\xcc\x0c\xc9\x0a\xd7\xa3\xc9"),

   OriginalN =  ("\x00\x00\x20\x41\x00\x00\x80\x3f\x17\xb7\xd1\x38\x6f\x12\x83\x3a"),   
   OriginalN2 =  ("\x00\x00\x20\x41\x00\x00\x00\x40\x17\xb7\xd1\x38\x6f\x12\x83\x3a"),
   SOriginalN =  ("\x00\x00\x20\x41\x00\x00\x80\x3f\x17\xb7\xd1\x38\x6f\x12\x83\x3e"),
   POriginalN =  ("\x00\x00\x20\x41\x00\x00\x80\x3f\x17\xb7\xd1\x38\x6f\x12\x83\x3f"),
  
   
   OriginalNTest =  ("\x00\x00\x20\x41\x00\x00\x00\x2f\x17\xb7\xd1\x38\x6f\x12\x83\x3a"),
   
   OriginalNL1 =  ("\x00\x00\x20\x41\x00\x00\x00\x3f\x17\xb7\xd1\x38\x6f\x12\x83\x3a"),
   SOriginalNL1 =  ("\x00\x00\x20\x41\x00\x00\x00\x3f\x17\xb7\xd1\x38\x6f\x12\x83\x3e"),
   POriginalNL1 =  ("\x00\x00\x20\x41\x00\x00\x00\x3f\x17\xb7\xd1\x38\x6f\x12\x83\x3f"),
   OriginalNL2 =  ("\x00\x00\x20\x41\x00\x00\x50\x40\x17\xb7\xd1\x38\x6f\x12\x83\x3a"),   
   OriginalNL3 =  ("\x00\x00\x20\x41\x00\x00\xa0\x40\x17\xb7\xd1\x38\x6f\x12\x83\x3a"),   
   OriginalNL5 =  ("\x00\x00\x20\x41\x00\x00\x00\x41\x17\xb7\xd1\x38\x6f\x12\x83\x3a"),   
   OriginalNL6 =  ("\x00\x00\x20\x41\x00\x00\x30\x41\x17\xb7\xd1\x38\x6f\x12\x83\x3a"),   
   OriginalNL7 =  ("\x00\x00\x20\x41\x00\x00\x70\x41\x17\xb7\xd1\x38\x6f\x12\x83\x3a"),   
   OriginalNL8 =  ("\x00\x00\x20\x41\x00\x00\xa0\x41\x17\xb7\xd1\x38\x6f\x12\x83\x3a"),
   
   
   OriginalNT =  ("\x00\x00\x20\x41\xcd\xcc\x4c\xbe\x17\xb7\xd1\x38\x6f\x12\x83\x3a"),    
   OriginalNT1 =  ("\x00\x00\x20\x41\x9a\x99\x49\x3f\x17\xb7\xd1\x38\x6f\x12\x83\x3a"),
   POriginalNT1 =  ("\x00\x00\x20\x41\x9a\x99\x49\x3f\x17\xb7\xd1\x38\x6f\x12\x83\x3f"),
   OriginalNT2 =  ("\x00\x00\x20\x41\x9a\x99\x19\x3f\x17\xb7\xd1\x38\x6f\x12\x83\x3a"),   
   OriginalNT3 =  ("\x00\x00\x20\x41\xcd\xcc\xcc\x3e\x17\xb7\xd1\x38\x6f\x12\x83\x3a"),   
   OriginalNT4 =  ("\x00\x00\x20\x41\xcd\xcc\x4c\x3e\x17\xb7\xd1\x38\x6f\x12\x83\x3a"),   
   OriginalNT5 =  ("\x00\x00\x20\x41\x0a\xd7\xa3\x3c\x17\xb7\xd1\x38\x6f\x12\x83\x3a"),   
   OriginalNT6 =  ("\x00\x00\x20\x41\x0a\xd7\x23\x3b\x17\xb7\xd1\x38\x6f\x12\x83\x3a"),   
   OriginalNT7 =  ("\x00\x00\x20\x41\x71\x3d\x0a\x3a\x17\xb7\xd1\x38\x6f\x12\x83\x3a"),   
   OriginalNT8 =  ("\x00\x00\x20\x41\x00\x00\x00\x2f\x17\xb7\xd1\x38\x6f\x12\x83\x3a"),
   
   ItalyN = 	("\x00\x00\x00\x40\x00\x00\x21\x41\x17\xb7\xd1\x38\x6f\x12\x83\x3a"),
   SItalyN = 	("\x00\x00\x00\x40\x00\x00\x21\x41\x17\xb7\xd1\x38\x6f\x12\x83\x3e"),
   ItalyNT = 	("\xc9\xc9\xc9\x40\x00\x00\x21\x40\x17\xb7\xd1\x38\x6f\x12\x83\x3a"),
   SItalyNT = 	("\xc9\xc9\xc9\x40\x00\x00\x21\x40\x17\xb7\xd1\x38\x6f\x12\x83\x3e"),
   PItalyN = 	("\x00\x00\x00\x40\x00\x00\x21\x41\x17\xb7\xd1\x38\x6f\x12\x83\x3f"),
   PItalyNT = 	("\xc9\xc9\xc9\x40\x00\x00\x21\x40\x17\xb7\xd1\x38\x6f\x12\x83\x3f"),
   ItalyNT2 = 	("\x00\x00\x00\x40\x00\x00\x21\x40\x17\xb7\xd1\x00\x6f\x12\x83\x3a"),
   ItalyNF = 	("\x00\x00\x00\x41\x00\x00\x22\x42\x17\xb7\xa1\x37\x6f\x12\x83\x37\x00\x00\x90\x3f\x00\x00\x90\x3f\x00\x00\x90\x3b\x33\x33\x80\x3b\x9a\x99\x99\xc9\xcd\xcc\x0c\xc9\x0a\xd7\xa3\xc9"),

   TItalyN = 	("\x00\x00\x00\x40\x00\x00\x21\x41\x17\xb7\xd1\x38\x52\x2f\x5f\x39\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\x9a\x99\x99\x3e\xcd\xcc\x0c\x40\x0a\xd7\xa3\x3c"),
   
   EnglandN = 	("\x00\x00\x00\x40\x00\x00\x21\x3f\x17\xb7\xd1\x38\x6f\x12\x83\x3a"),
   SEnglandN = 	("\x00\x00\x00\x40\x00\x00\x21\x3f\x17\xb7\xd1\x38\x6f\x12\x83\x3e"),
   EnglandNT = 	("\xc9\xc9\xc9\x40\x00\x00\x21\x3c\x17\xb7\xd1\x38\x6f\x12\x83\x3a"),
   SEnglandNT = ("\xc9\xc9\xc9\x40\x00\x00\x21\x3c\x17\xb7\xd1\x38\x6f\x12\x83\x3e"),
   PEnglandN = 	("\x00\x00\x00\x40\x00\x00\x21\x3f\x17\xb7\xd1\x38\x6f\x12\x83\x3f"),
   PEnglandNT = ("\xc9\xc9\xc9\x40\x00\x00\x21\x3c\x17\xb7\xd1\x38\x6f\x12\x83\x3f"),
   EnglandNT2 = ("\x00\x00\x00\x40\x00\x00\x21\x3a\x17\xb7\xd1\x00\x6f\x12\x83\x3a"),


   EnglandNTLow = 	("\xc9\xc9\xc9\x3f\x00\x00\x21\x3c\x17\xb7\xd1\x39\x6f\x12\x83\x3a"),
--[[ V2 Physics Improvements ]]

    -- "NL" Series: Made even looser by decreasing tension.
    OriginalNL1v2 =  ("\x00\x00\x20\x41\x00\x00\x00\x3f\x34\x40\xcc\x38\x6f\x12\x83\x3a"),
    SOriginalNL1v2 = ("\x00\x00\x20\x41\x00\x00\x00\x3f\x34\x40\xcc\x38\x6f\x12\x83\x3e"),
    POriginalNL1v2 = ("\x00\x00\x20\x41\x00\x00\x00\x3f\x34\x40\xcc\x38\x6f\x12\x83\x3f"),
    OriginalNL2v2 =  ("\x00\x00\x20\x41\x00\x00\x50\x40\x34\x40\xcc\x38\x6f\x12\x83\x3a"),
    OriginalNL3v2 =  ("\x00\x00\x20\x41\x00\x00\xa0\x40\x34\x40\xcc\x38\x6f\x12\x83\x3a"),
    OriginalNL5v2 =  ("\x00\x00\x20\x41\x00\x00\x00\x41\x34\x40\xcc\x38\x6f\x12\x83\x3a"),
    OriginalNL6v2 =  ("\x00\x00\x20\x41\x00\x00\x30\x41\x34\x40\xcc\x38\x6f\x12\x83\x3a"),
    OriginalNL7v2 =  ("\x00\x00\x20\x41\x00\x00\x70\x41\x34\x40\xcc\x38\x6f\x12\x83\x3a"),
    OriginalNL8v2 =  ("\x00\x00\x20\x41\x00\x00\xa0\x41\x34\x40\xcc\x38\x6f\x12\x83\x3a"),
    
    -- "NT" Series: Made genuinely tense by significantly increasing tension.
    OriginalNTv2 =   ("\x00\x00\x20\x41\xcd\xcc\x4c\xbe\x02\x2b\x75\x3b\x6f\x12\x83\x3a"),
    OriginalNT1v2 =  ("\x00\x00\x20\x41\x9a\x99\x49\x3f\x02\x2b\x75\x3b\x6f\x12\x83\x3a"),
    POriginalNT1v2 = ("\x00\x00\x20\x41\x9a\x99\x49\x3f\x02\x2b\x75\x3b\x6f\x12\x83\x3f"),
    OriginalNT2v2 =  ("\x00\x00\x20\x41\x9a\x99\x19\x3f\x02\x2b\x75\x3b\x6f\x12\x83\x3a"),
    OriginalNT3v2 =  ("\x00\x00\x20\x41\xcd\xcc\xcc\x3e\x02\x2b\x75\x3b\x6f\x12\x83\x3a"),
    OriginalNT4v2 =  ("\x00\x00\x20\x41\xcd\xcc\x4c\x3e\x02\x2b\x75\x3b\x6f\x12\x83\x3a"),
    OriginalNT5v2 =  ("\x00\x00\x20\x41\x0a\xd7\xa3\x3c\x02\x2b\x75\x3b\x6f\x12\x83\x3a"),
    OriginalNT6v2 =  ("\x00\x00\x20\x41\x0a\xd7\x23\x3b\x02\x2b\x75\x3b\x6f\x12\x83\x3a"),
    OriginalNT7v2 =  ("\x00\x00\x20\x41\x71\x3d\x0a\x3a\x02\x2b\x75\x3b\x6f\x12\x83\x3a"),
    OriginalNT8v2 =  ("\x00\x00\x20\x41\x00\x00\x00\x2f\x02\x2b\x75\x3b\x6f\x12\x83\x3a"),
    
    -- "Italy" Series: Personalities exaggerated.
    ItalyNv2 =    ("\x00\x00\xc0\x3f\x00\x00\x40\x41\x17\xb7\xd1\x38\x6f\x12\x83\x3a"),
    SItalyNv2 =   ("\x00\x00\xc0\x3f\x00\x00\x40\x41\x17\xb7\xd1\x38\x6f\x12\x83\x3e"),
    PItalyNv2 =   ("\x00\x00\xc0\x3f\x00\x00\x40\x41\x17\xb7\xd1\x38\x6f\x12\x83\x3f"),
    ItalyNTv2 =   ("\xc9\xc9\xc9\x40\x00\x00\x21\x40\x02\x2b\x75\x3b\x6f\x12\x83\x3a"),
    SItalyNTv2 =  ("\xc9\xc9\xc9\x40\x00\x00\x21\x40\x02\x2b\x75\x3b\x6f\x12\x83\x3e"),
    PItalyNTv2 =  ("\xc9\xc9\xc9\x40\x00\x00\x21\x40\x02\x2b\x75\x3b\x6f\x12\x83\x3f"),
    ItalyNT2v2 =  ("\x00\x00\x00\x40\x00\x00\x21\x40\x02\x2b\x75\x3b\x6f\x12\x83\x3a"),
   --Lower nets
   OriginalNL1Low =  ("\x00\x00\x20\x3f\x00\x00\x00\x3f\x17\xb7\xd1\x38\x6f\x12\x83\x3a"),
   SOriginalNL1Low = ("\x00\x00\x20\x3f\x00\x00\x00\x3f\x17\xb7\xd1\x38\x6f\x12\x83\x3e"),
   POriginalNL1Low = ("\x00\x00\x20\x3f\x00\x00\x00\x3f\x17\xb7\xd1\x38\x6f\x12\x83\x3f"),
   OriginalNL2Low =  ("\x00\x00\x20\x3f\x00\x00\x50\x40\x17\xb7\xd1\x38\x6f\x12\x83\x3a"),   
   OriginalNL3Low =  ("\x00\x00\x20\x3f\x00\x00\xa0\x40\x17\xb7\xd1\x38\x6f\x12\x83\x3a"),   
   OriginalNL5Low =  ("\x00\x00\x20\x3f\x00\x00\x00\x41\x17\xb7\xd1\x38\x6f\x12\x83\x3a"),  
   SOriginalNL5Low = ("\x00\x00\x20\x3f\x00\x00\x00\x41\x17\xb7\xd1\x38\x6f\x12\x83\x3e"),    
   OriginalNL6Low =  ("\x00\x00\x20\x3f\x00\x00\x30\x41\x17\xb7\xd1\x38\x6f\x12\x83\x3a"),   
   OriginalNL7Low =  ("\x00\x00\x20\x3f\x00\x00\x70\x41\x17\xb7\xd1\x38\x6f\x12\x83\x3a"),   
   OriginalNL8Low =  ("\x00\x00\x20\x3f\x00\x00\xa0\x41\x17\xb7\xd1\x38\x6f\x12\x83\x3a"),  
 
   OriginalNTLow =   ("\x00\x00\x20\x3f\xcd\xcc\x4c\xbe\x17\xb7\xd1\x38\x6f\x12\x83\x3a"),    
   OriginalNT1Low =  ("\x00\x00\x20\x3f\x9a\x99\x49\x3f\x17\xb7\xd1\x38\x6f\x12\x83\x3a"),
   POriginalNT1Low = ("\x00\x00\x20\x3f\x9a\x99\x49\x3f\x17\xb7\xd1\x38\x6f\x12\x83\x3f"),
   OriginalNT2Low =  ("\x00\x00\x20\x3f\x9a\x99\x19\x3f\x17\xb7\xd1\x38\x6f\x12\x83\x3a"),   
   OriginalNT3Low =  ("\x00\x00\x20\x3f\xcd\xcc\xcc\x3e\x17\xb7\xd1\x38\x6f\x12\x83\x3a"),   
   OriginalNT4Low =  ("\x00\x00\x20\x3f\xcd\xcc\x4c\x3e\x17\xb7\xd1\x38\x6f\x12\x83\x3a"),   
   OriginalNT5Low =  ("\x00\x00\x20\x3f\x0a\xd7\xa3\x3c\x17\xb7\xd1\x38\x6f\x12\x83\x3a"),   
   OriginalNT6Low =  ("\x00\x00\x20\x3f\x0a\xd7\x23\x3b\x17\xb7\xd1\x38\x6f\x12\x83\x3a"),   
   OriginalNT7Low =  ("\x00\x00\x20\x3f\x71\x3d\x0a\x3a\x17\xb7\xd1\x38\x6f\x12\x83\x3a"),   
   OriginalNT8Low =  ("\x00\x00\x20\x3f\x00\x00\x00\x2f\x17\xb7\xd1\x38\x6f\x12\x83\x3a"),
   
   ItalyNLow = 		("\x00\x00\x00\x3f\x00\x00\x21\x41\x17\xb7\xd1\x38\x6f\x12\x83\x3a"),
   SItalyNLow = 	("\x00\x00\x00\x3f\x00\x00\x21\x41\x17\xb7\xd1\x38\x6f\x12\x83\x3e"),
   ItalyNTLow = 	("\xc9\xc9\xc9\x3f\x00\x00\x21\x40\x17\xb7\xd1\x38\x6f\x12\x83\x3a"),
   SItalyNTLow = 	("\xc9\xc9\xc9\x3f\x00\x00\x21\x40\x17\xb7\xd1\x38\x6f\x12\x83\x3e"),
   PItalyNLow = 	("\x00\x00\x00\x3f\x00\x00\x21\x41\x17\xb7\xd1\x38\x6f\x12\x83\x3f"),
   PItalyNTLow = 	("\xc9\xc9\xc9\x3f\x00\x00\x21\x40\x17\xb7\xd1\x38\x6f\x12\x83\x3f"),
   ItalyNT2Low = 	("\x00\x00\x00\x3f\x00\x00\x21\x40\x17\xb7\xd1\x00\x6f\x12\x83\x3a"),
  
    --High nets
	
   OriginalNL1High =  ("\x00\x00\x20\x42\x00\x00\x00\x3f\x17\xb7\xd1\x38\x6f\x12\x83\x3a"),
   SOriginalNL1High = ("\x00\x00\x20\x42\x00\x00\x00\x3f\x17\xb7\xd1\x38\x6f\x12\x83\x3e"),
   POriginalNL1High = ("\x00\x00\x20\x42\x00\x00\x00\x3f\x17\xb7\xd1\x38\x6f\x12\x83\x3f"),
   OriginalNL2High =  ("\x00\x00\x20\x42\x00\x00\x50\x40\x17\xb7\xd1\x38\x6f\x12\x83\x3a"),   
   OriginalNL3High =  ("\x00\x00\x20\x42\x00\x00\xa0\x40\x17\xb7\xd1\x38\x6f\x12\x83\x3a"), 
   POriginalNL3High =  ("\x00\x00\x20\x42\x00\x00\xa0\x40\x17\xb7\xd1\x38\x6f\x12\x83\x3f"),     
   OriginalNL5High =  ("\x00\x00\x20\x42\x00\x00\x00\x41\x17\xb7\xd1\x38\x6f\x12\x83\x3a"),   
   OriginalNL6High =  ("\x00\x00\x20\x42\x00\x00\x30\x41\x17\xb7\xd1\x38\x6f\x12\x83\x3a"),   
   OriginalNL7High =  ("\x00\x00\x20\x42\x00\x00\x70\x41\x17\xb7\xd1\x38\x6f\x12\x83\x3a"),   
   OriginalNL8High =  ("\x00\x00\x20\x42\x00\x00\xa0\x41\x17\xb7\xd1\x38\x6f\x12\x83\x3a"),  
 
   OriginalNTHigh =   ("\x00\x00\x20\x42\xcd\xcc\x4c\xbe\x17\xb7\xd1\x38\x6f\x12\x83\x3a"),    
   OriginalNT1High =  ("\x00\x00\x20\x42\x9a\x99\x49\x3f\x17\xb7\xd1\x38\x6f\x12\x83\x3a"),
   POriginalNT1High = ("\x00\x00\x20\x42\x9a\x99\x49\x3f\x17\xb7\xd1\x38\x6f\x12\x83\x3f"),
   OriginalNT2High =  ("\x00\x00\x20\x42\x9a\x99\x19\x3f\x17\xb7\xd1\x38\x6f\x12\x83\x3a"),   
   OriginalNT3High =  ("\x00\x00\x20\x42\xcd\xcc\xcc\x3e\x17\xb7\xd1\x38\x6f\x12\x83\x3a"),   
   OriginalNT4High =  ("\x00\x00\x20\x42\xcd\xcc\x4c\x3e\x17\xb7\xd1\x38\x6f\x12\x83\x3a"),   
   OriginalNT5High =  ("\x00\x00\x20\x42\x0a\xd7\xa3\x3c\x17\xb7\xd1\x38\x6f\x12\x83\x3a"),   
   OriginalNT6High =  ("\x00\x00\x20\x42\x0a\xd7\x23\x3b\x17\xb7\xd1\x38\x6f\x12\x83\x3a"),   
   OriginalNT7High =  ("\x00\x00\x20\x42\x71\x3d\x0a\x3a\x17\xb7\xd1\x38\x6f\x12\x83\x3a"),   
   OriginalNT8High =  ("\x00\x00\x20\x42\x00\x00\x00\x2f\x17\xb7\xd1\x38\x6f\x12\x83\x3a"),
   
   ItalyNHigh = 	("\x00\x00\x00\x42\x00\x00\x21\x41\x17\xb7\xd1\x38\x6f\x12\x83\x3a"),
   SItalyNHigh = 	("\x00\x00\x00\x42\x00\x00\x21\x41\x17\xb7\xd1\x38\x6f\x12\x83\x3e"),
   ItalyNTHigh = 	("\xc9\xc9\xc9\x42\x00\x00\x21\x40\x17\xb7\xd1\x38\x6f\x12\x83\x3a"),
   SItalyNTHigh = 	("\xc9\xc9\xc9\x42\x00\x00\x21\x40\x17\xb7\xd1\x38\x6f\x12\x83\x3e"),
   PItalyNHigh = 	("\x00\x00\x00\x42\x00\x00\x21\x41\x17\xb7\xd1\x38\x6f\x12\x83\x3f"),
   PItalyNTHigh = 	("\xc9\xc9\xc9\x42\x00\x00\x21\x40\x17\xb7\xd1\x38\x6f\x12\x83\x3f"),
   ItalyNT2High = 	("\x00\x00\x00\x42\x00\x00\x21\x40\x17\xb7\xd1\x00\x6f\x12\x83\x3a"),

 
   NormalN = ("\x00\x00\x00\x3f\x00\x00\x21\x3f\x16\xb7\xd4\x38\x6f\x12\x83\x3a"),
   SNormalN =("\x00\x00\x00\x3f\x00\x00\x21\x3f\x16\xb7\xd4\x38\x6f\x12\x83\x3e"),
   PNormalN =("\x00\x00\x00\x3f\x00\x00\x21\x3f\x16\xb7\xd4\x38\x6f\x12\x83\x3f"),
  

   ItalyFirmT = ("\xc9\xc9\xc9\x40\x00\x00\x21\x40\x17\xb7\xd1\x38\x6f\x12\x83\x39\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\x9a\x99\x99\x3e\xcd\xcc\x0c\x40\x0a\xd7\xa3\x3c"),
   SItalyFirmT = ("\xc9\xc9\xc9\x40\x00\x00\x21\x40\x17\xb7\xd1\x38\x6f\x12\x83\x3e\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\x9a\x99\x99\x3e\xcd\xcc\x0c\x40\x0a\xd7\xa3\x3c"),
   PItalyFirmT = ("\xc9\xc9\xc9\x40\x00\x00\x21\x40\x17\xb7\xd1\x38\x6f\x12\x83\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\x9a\x99\x99\x3e\xcd\xcc\x0c\x40\x0a\xd7\xa3\x3c"),


   MiddeepItaly = 	("\x00\x00\x00\x40\x00\x00\x21\x41\x17\xb7\xd1\x38\x6f\x12\x83\x39\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\x9a\x99\x99\x3e\xcd\xcc\x0c\x40\x0a\xd7\xa3\x3c"),
   MiddeepItalyT = ("\xc9\xc9\xc9\x40\x00\x00\x21\x40\x17\xb7\xd1\x38\x6f\x12\x83\x39\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\x9a\x99\x99\x3e\xcd\xcc\x0c\x40\x0a\xd7\xa3\x3c"),
   MiddeepFirm = ("\x00\x00\x10\x40\x00\x00\x00\x40\x17\xb7\xd1\x38\x6f\x12\x83\x39\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\x9a\x99\x99\x3e\xcd\xcc\x0c\x40\x0a\xd7\xa3\x3c"),
   FirmerMiddeepFirm = ("\x00\x00\x48\x41\xcd\xcc\x4c\x3b\x17\xb7\xd1\x38\x6f\x12\x83\x39\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\x9a\x99\x99\x3e\xcd\xcc\x0c\x40\x0a\xd7\xa3\x3c"),

   IPLN =   	("\x05\x05\x48\x40\xcd\xcc\x4d\x3e\x17\xb7\xcc\x38\x6f\x12\x83\x3a"),
   SIPLN =   	("\x05\x05\x48\x40\xcd\xcc\x4d\x3e\x17\xb7\xcc\x38\x6f\x12\x83\x3e"),
   IPLNT =   	("\x05\x05\x48\x40\xcd\xcc\x4d\x3e\x17\xb7\xcc\x38\x6f\x12\x83\x3a\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\x9a\x99\x99\x3e\xcd\xcc\x0c\x40\x0a\xd7\xa3\x3c"),
   PIPLN =   	("\x05\x05\x48\x40\xcd\xcc\x4d\x3e\x17\xb7\xcc\x38\x6f\x12\x83\x3f"),
   PIPLNT =   	("\x05\x05\x48\x40\xcd\xcc\x4d\x3e\x17\xb7\xcc\x36\x6f\x12\x83\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\x9a\x99\x99\x3e\xcd\xcc\x0c\x40\xca\x22\x33\xb4"),
   SIPLNT =   	("\x05\x05\x48\x40\xcd\xcc\x4d\x3e\x17\xb7\xcc\x36\x6f\x12\x83\x3e\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\x9a\x99\x99\x3e\xcd\xcc\x0c\x40\xca\x22\x33\xb4"),
   
   
   SpainN =  	("\x00\x00\x00\x41\x00\x00\xa0\x41\x17\xb7\xd1\x38\x6f\x12\x83\x3a\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\x9a\x99\x99\x3e\xcd\xcc\x0c\x40\x0a\xd7\xa3\x3c"),
   PLN =   		("\x02\x02\x48\x40\x00\x00\x23\x41\x17\xb7\xd5\x39\x6f\x12\x83\x3a\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\x9a\x99\x99\x3e\xcd\xcc\x0c\x40\x0a\xd7\xa3\x3c"),
   FranceN = 	("\x20\x20\x40\x41\x00\x00\xa0\x41\x17\xb7\xd1\x38\x6f\x12\x83\x3a\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\x9a\x99\x99\x3e\xcd\xcc\x0c\x40\x0a\xd7\xa3\x3c"),
   
   EPLN = 		("\x00\x00\x48\x41\xcd\xcc\x4c\x3b\x17\xb7\xd1\x38\x6f\x12\x83\x3a"),   
   SEPLN = 		("\x00\x00\x48\x41\xcd\xcc\x4c\x3b\x17\xb7\xd1\x38\x6f\x12\x83\x3e"),   
   PEPLN = 		("\x00\x00\x48\x41\xcd\xcc\x4c\x3b\x17\xb7\xd1\x38\x6f\x12\x83\x3f"),
  
 FrancoSpanishFirm = ("\x00\x00\x20\x41\x00\x00\xa0\x41\x17\xb7\xd1\x38\x6f\x12\x83\x3a\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\x9a\x99\x99\x3e\xcd\xcc\x0c\x40\x0a\xd7\xa3\x3c"),

	FPL = ("\x00\x00\x48\x41\x99\x99\xa0\x41\x17\xb7\xd1\x38\x6f\x12\x83\x3a\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\x9a\x99\x99\x3e\xcd\xcc\x0c\x40\x0a\xd7\xa3\x3c"),
	FPL2 = ("\x00\x00\x48\x41\xcd\xcc\x70\x3e\x17\xb7\xd1\x38\x6f\x12\x83\x3a\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\x9a\x99\x99\x3e\xcd\xcc\x0c\x40\x0a\xd7\xa3\x3c"),
	FPLT = ("\x00\x00\x48\x41\xcd\xcc\x50\x40\x17\xb7\xd1\x38\x6f\x12\x83\x3a\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\x9a\x99\x99\x3e\xcd\xcc\x0c\x40\x0a\xd7\xa3\x3c"), 
 
   ItalyN2 = 	("\x00\x00\x00\x40\x00\x00\x21\x41\x33\x33\x73\x20\x00\x00\x28\x40\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\x9a\x99\x99\x3e\xcd\xcc\x0c\x40\x0a\xd7\xa3\x3c"),  
   ItalyN3 = 	("\x00\x00\x00\x40\x00\x00\x21\x41\x33\x33\x73\x20\x00\x00\x28\x40\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\x9a\x99\x99\x3e\xcd\xcc\x0c\x40\x0a\xd7\xa3\x3c"),  
   
   
   SuperBouncy =    ("\x00\x00\x00\x41\x00\x00\xa0\x41\x17\xb7\xd1\x38\x6f\x12\x83\x3a\x00\x00\xc0\x3f\x00\x00\xc0\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\x9a\x99\x99\x3e\xcd\xcc\x0c\x40\x0a\xd7\xa3\x3c"),
   LooseNet =      ("\x00\x00\x00\x41\x00\x00\x40\x41\x17\xb7\xd1\x38\x6f\x12\x83\x3a\x00\x00\x00\x3f\x00\x00\x00\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\x9a\x99\x99\x3e\xcd\xcc\x0c\x40\x0a\xd7\xa3\x3c"),
   ShakyNet =      ("\x15\x15\x88\x40\x00\x00\x40\x41\x17\xb7\xd1\x38\x6f\x12\x83\x3a\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\x9a\x99\x99\x3e\xcd\xcc\x0c\x40\x0a\xd7\xa3\x3c"),
   TenseAndBouncy = ("\xc9\xc9\xc9\x40\x00\x00\xa0\x41\x17\xb7\xd1\x38\x6f\x12\x83\x3a\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\x9a\x99\x99\x3e\xcd\xcc\x0c\x40\x0a\xd7\xa3\x3c"),
   RubberBandPhy =    ("\x00\x00\x00\x40\x00\x00\xa0\x41\x17\xb7\xa1\x36\x6f\x12\x83\x36\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3a\x33\x33\x73\x3f\x9a\x99\x99\x3e\xcd\xcc\x0c\x40\x0a\xd7\xa3\x3c"),
   
   StiffBounceV1 = ("\x00\x00\x00\x40\x00\x00\xa0\x41\x17\xb7\xa1\x36\x6f\x12\x83\x36\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3a\x33\x33\x73\x3f\x9a\x99\x99\x3e\xcd\xcc\x0c\x40\x0a\xd7\xa3\x3c"),
   SStiffBounceV1 = ("\x00\x00\x00\x40\x00\x00\xa0\x41\x17\xb7\xa1\x36\x6f\x12\x83\x3e\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3a\x33\x33\x73\x3f\x9a\x99\x99\x3e\xcd\xcc\x0c\x40\x0a\xd7\xa3\x3c"),
   PStiffBounceV1 = ("\x00\x00\x00\x40\x00\x00\xa0\x41\x17\xb7\xa1\x36\x6f\x12\x83\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3a\x33\x33\x73\x3f\x9a\x99\x99\x3e\xcd\xcc\x0c\x40\x0a\xd7\xa3\x3c"),
   SStiffBounceT = ("\xcf\xcf\xcf\x3f\x00\x00\xa0\x41\x17\xb7\xa1\x36\x6f\x12\x83\x3e\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3a\x33\x33\x73\x3f\x9a\x99\x99\x3e\xcd\xcc\x0c\x40\x0a\xd7\xa3\x3c"),
   
   
   StiffBounceV2 = ("\xc9\xc9\xc9\x40\x00\x00\xa0\x41\x17\xb7\xd1\x38\x6f\x12\x83\x3a\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\x9a\x99\x99\x3e\xcd\xcc\x0c\x40\x0a\xd7\xa3\x3c"),
   
   SPortoLN =	("\x89\x20\x40\x3f\x00\x00\x21\x41\x17\xb7\xd1\x38\x6f\x12\x83\x3e\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\x9a\x99\x99\x3e\xcd\xcc\x0c\x42\x0a\xd7\xa3\x3c"),
   SPortoLNT =	("\x89\x20\x40\x3f\x00\x00\x08\x41\x17\xb7\xd1\x38\x6f\x12\x83\x3e\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\x9a\x99\x99\x3e\xcd\xcc\x0c\x42\x0a\xd7\xa3\x3c"),
  
-- New test
   VeryStiff = 	   ("\x20\x20\x80\x40\x00\x00\x21\x41\x17\xb7\xa1\x36\x6f\x12\x83\x36\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3a\x33\x33\x70\x3a\x9a\x99\x99\xc9\xcd\xcc\x0c\xc9\x0a\xd7\xa3\xc9"),
   VeryBouncy =    ("\x00\x00\x20\x3f\x00\x00\x21\x41\x17\xb7\xd1\x38\x6f\x12\x83\x3a\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\x9a\x99\x99\x3e\xcd\xcc\x0c\x40\x0a\xd7\xa3\x3c"),   
   QuickResponse = ("\x00\x00\x00\x40\x00\x00\x21\x41\x17\xb7\xa1\x36\x6f\x12\x83\x36\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\x9a\x99\x99\x3e\xcd\xcc\x0c\x40\x0a\xd7\xa3\x40"),
   SlowResponse =  ("\x00\x00\x00\x40\x00\x00\x21\x41\x17\xb7\xa1\x36\x6f\x12\x83\x36\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\x9a\x99\x99\x3e\xcd\xcc\x0c\x40\x0a\xd7\xa3\x38"),
   HeavyNet = 	   ("\x20\x20\x80\x40\x00\x00\x21\x41\x17\xb7\xa1\x36\x6f\x12\x83\x36\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\x9a\x99\x99\x3e\xcd\xcc\x0c\x40\x0a\xd7\xa3\x38"),
   

   VeryStiff2 =    ("\x20\x20\x80\x40\x00\x00\xf8\x40\x17\xb7\xa1\x36\x6f\x12\x83\x36\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3a\x33\x33\x70\x3a\x9a\x99\x99\xc9\xcd\xcc\x0c\xc9\x95\x10\x53\xb1"),


	TestPhysics = ("\x00\x00\x28\x41\x00\x00\x10\x41\x17\xb7\xd1\x38\x81\x06\x41\x39"),
	
	PhysicsFIFA22V1 = ("\x8f\xc2\xf5\x3c\x00\x00\x80\x3f\x00\x00\x40\x40\x9a\x99\x99\x3f\x00\x00\x20\x41\x00\x00\x48\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3e\xcd\xcc\xcc\x3d\xcd\xcc\x4c\x3d\x00\x00\x80\x3e"),
    PhysicsFIFA22V3 = ("\x29\x5c\x0f\x3d\x1b\x0d\x80\x3f\x66\x66\x86\x3f\x66\x66\x66\x3f\x00\x00\x20\x41\x00\x00\x48\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\xf0\x41\x47\x03\x80\x3f\x62\x10\x80\x3f\x9a\x99\x99\x3e\xae\x47\xe1\x3d\xcd\xcc\x0c\x3f\x9a\x99\x99\x3e"),
    PhysicsEPL = ("\x29\x5c\x0f\x3d\x5d\x6d\x81\x3f\xf6\x28\xac\x3f\x48\xe1\x3a\x3f\x00\x00\x20\x41\x00\x00\x48\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3e\xcd\xcc\xcc\x3d\xcd\xcc\x4c\x3d\x00\x00\x80\x3e"),
	PhysicsPremier =  ("\x00\x00\x80\x40\x00\x00\x20\x41\x00\x00\x48\x42\x6f\x12\x83\x3a\x00\x00\x00\x00\x00\x00\x00\x42\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3e\xcd\xcc\xcc\x3d\xcd\xcc\x4c\x3d\x00\x00\x80\x3e"),

    TestPhysic =  ("\x00\x00\xa0\x40\xcd\xcc\x8c\x3f\x17\xb7\xd1\x38\x6f\x12\x83\x41"),   
    TestPhysic2 =  ("\x00\x00\x20\x40\x00\x00\x80\x40\x17\xb7\xd1\x38\x6f\x12\xcc\x3a\x00\x00\x80\x40\x00\x00\x80\x42\x33\x33\x73\x33"), 
	
	
    EPLPhysics =  ("\x00\x00\x20\x40\x00\x00\x80\x40\x17\xb7\xd1\x38\x6f\x12\xcc\x3a\x00\x00\x80\x40\x00\x00\x80\x42\x33\x33\x73\x33"), 
	
    SmallNetPhysics =  ("\x00\x00\x20\x40\x00\x00\x80\x40\x17\xb7\xd1\x38\x6f\x12\xcc\x3a\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x73\x33"), 
	
	
   
   PhyTst =  ("\x00\x00\x00\x3f\x00\x00\x00\x38\x00\x00\x00\x3a\x00\x00\x00\x3f\x00\x00\x00\x39\x00\x00\x00\x3f\x00\x00\x00\x3f\x00\x00\x00\x3f"),
   

    HeavyLoose =   ("\x00\x00\x40\x3f\x00\x00\x00\x3f\x34\x40\xcc\x38\x6f\x12\x83\x3a"),
    SHeavyLoose =  ("\x00\x00\x40\x3f\x00\x00\x00\x3f\x34\x40\xcc\x38\x6f\x12\x83\x3e"),
    PHeavyLoose =  ("\x00\x00\x40\x3f\x00\x00\x00\x3f\x34\x40\xcc\x38\x6f\x12\x83\x3f"),

    HyperTense =   ("\x00\x00\xa0\x41\x00\x00\xc0\x3f\x08\x87\xa3\x3b\x6f\x12\x83\x3a"),
    SHyperTense =  ("\x00\x00\xa0\x41\x00\x00\xc0\x3f\x08\x87\xa3\x3b\x6f\x12\x83\x3e"),
    PHyperTense =  ("\x00\x00\xa0\x41\x00\x00\xc0\x3f\x08\x87\xa3\x3b\x6f\x12\x83\x3f"),

    ProBalanced =  ("\x00\x00\x20\x41\xcd\xcc\x4c\x3f\x08\x87\x23\x3b\x6f\x12\x83\x3a"),
    SProBalanced = ("\x00\x00\x20\x41\xcd\xcc\x4c\x3f\x08\x87\x23\x3b\x6f\x12\x83\x3e"),
    PProBalanced = ("\x00\x00\x20\x41\xcd\xcc\x4c\x3f\x08\x87\x23\x3b\x6f\x12\x83\x3f"),
    PProBalancedN = ("\x00\x00\x00\x40\xcd\xcc\x4c\x3f\x08\x87\x23\x3b\x6f\x12\x83\x3f"),
	
    ProBalancedEPL =  ("\x00\x00\x20\x41\xcd\xcc\x4c\x3f\x08\x87\x23\x39\x6f\x12\x83\x3a"),
    ProBalancedEPLow =  ("\x00\x00\x00\x40\xcd\xcc\x4c\x3f\x08\x87\x23\x39\x6f\x12\x83\x3a"),

    Whiplash =     ("\x00\x00\x20\x41\x00\x00\x00\x3e\xb4\xfc\x18\x38\x6f\x12\x83\x3a"),
    ConcreteSlab = ("\x00\x00\x20\x41\x00\x00\x00\x41\xa4\x70\x20\x3c\x6f\x12\x83\x3a"),
    DeepSack =     ("\x00\x00\xa0\x40\x00\x00\x20\x40\x17\xb7\xd1\x38\x6f\x12\x83\x3a"),
	

    Dead = ("\x00\x00\x20\x41\x00\x00\x80\xbf\x17\xb7\xd1\x38\x6f\x12\x83\x3a"), 


    SilkSheet =       ("\x00\x00\x70\x41\x00\x00\xc0\x3e\x54\xe2\x58\x37\x6f\x12\x83\x3a"),
    SilkSheetN =       ("\x00\x00\x00\x40\x00\x00\xc0\x3e\x54\xe2\x58\x37\x6f\x12\x83\x3a"),
    SilkSheetLow =       ("\x00\x00\x85\x3f\x00\x00\xc0\x3e\x54\xe2\x58\x37\x6f\x12\x83\x3a"),
    Jello =           ("\x00\x00\x80\x40\x00\x00\x40\x40\x0b\x57\xf4\x37\x6f\x12\x83\x3a"),

}

--//================================================================================================================================================================//
--// Goalnets 3D Shape
--//================================================================================================================================================================//

local net3D = {

	Original = ("\x00\x00\xc0\x40"),
	Original2 = ("\x00\x00\xc0\x40\x00\x00\x80\x3f\x00\x00\x00\x00"),
	Original3 = ("\x00\x00\x80\xbf\x00\x00\x80\xbf\x00\x00\x80\xbf"),
	Original4 = ("\x00\x00\xc0\xbf\x00\x00\xc0\xbf\x00\x00\xc0\xbf"),
	Original5 = ("\x00\x00\xa0\xc1\x00\x00\x80\x3f\x00\x00\x00\x00"),

	DTest = ("\x00\x00\x80\x3f"),
 --Original lower (greater number = lower net)
    OriginalL1 = ("\x00\x00\xc0\x41"),
    OriginalL2 = ("\x00\x00\xc0\x42"),
    OriginalL3 = ("\x00\x00\xc0\x43"),
 --Original higher (greater number = higher net)	
    OriginalH1 = ("\x00\x00\xc0\x3f"),
    OriginalH2 = ("\x00\x00\xc0\x3e"),
    OriginalH3 = ("\x00\x00\xc0\x3d"),
    OriginalH4 = ("\x00\x00\xc0\x3c"),
    OriginalH5 = ("\x00\x00\xc0\x3b"),
    OriginalH6 = ("\x00\x00\xc0\x3a"),
 --Original Bouncy	
    OriginalB1 =   ("\x00\x00\x99\x40"),
    OriginalB1H1 = ("\x00\x00\x99\x3f"),
    OriginalB1L1 = ("\x00\x00\x99\x41"),
	OriginalB3 =   ("\x9a\x99\x99\x40"),
	
	OriginalB2 =   ("\xc5\x20\x80\x40"),
	OriginalB2L1 = ("\xc5\x20\x80\x41"),
	OriginalB2H1 = ("\xc5\x20\x80\x3f"),
	
	OriginalT1 =   ("\x66\x66\x86\x40"),
	OriginalT1L1 = ("\x66\x66\x86\x41"),	
	OriginalT1L2 = ("\x66\x66\x86\x42"),
	OriginalT1H1 = ("\x66\x66\x86\x3f"),	
	OriginalT1H2 = ("\x66\x66\x86\x3e"),
	OriginalT1H3 = ("\x66\x66\x86\x3d"),
	
    OriginalT2 =   ("\x00\x00\x00\x40"),    
	OriginalT2L1 = ("\x00\x00\x00\x41"),	
    OriginalT2L2 = ("\x00\x00\x00\x42"),
    OriginalT2H1 = ("\x00\x00\x00\x3f"),	    
	OriginalT2H2 = ("\x00\x00\x00\x3e"),
	
	OriginalT3 =   ("\x19\xb7\xd3\x40"),	
	OriginalT3L1 = ("\x19\xb7\xd3\x41"),	
	OriginalT3L2 = ("\x19\xb7\xd3\x42"),	
	OriginalT3H1 = ("\x19\xb7\xd3\x3f"),
	OriginalT3H2 = ("\x19\xb7\xd3\x3e"),

	OriginalT4 =   ("\x6f\x12\x83\x40"),
	OriginalT4L1 = ("\x6f\x12\x83\x41"),
	OriginalT4L2 = ("\x6f\x12\x83\x42"),
	OriginalT4H1 = ("\x6f\x12\x83\x3f"),
	OriginalT4H2 = ("\x6f\x12\x83\x3e"),
	
	OriginalT5 =   ("\x1a\x2b\x8c\x40"),
	OriginalT5L1 = ("\x1a\x2b\x8c\x41"),
	OriginalT5L2 = ("\x1a\x2b\x8c\x42"),
	OriginalT5H1 = ("\x1a\x2b\x8c\x3f"),
	OriginalT5H2 = ("\x1a\x2b\x8c\x3e"),

    LicH1 =      ("\xcd\xcc\x5c\x40"),	
    Lic =        ("\xcd\xcc\x5c\x41"),	
    LicL1 =      ("\xcd\xcc\x5c\x42"),
--Others	
    Zaragoza =     ("\x00\x00\xcd\x42"),
    ZaragozaH1 =   ("\x00\x00\xcd\x41"),
    RomaClassic =  ("\x20\x40\x00\x3f"),	
    OLDPES = 	   ("\x9a\x99\x99\x3f"),
    LargeLooseNet = ("\x66\x66\xc6\x3f"),	
    AnoetaClassic = ("\x00\x00\x48\x42"),	
    SmallNet = 	   ("\xcd\xcf\x5c\x41"),
    SmallNetH =    ("\xcd\xcf\x5c\x40"),
    Brasil = 	   ("\x00\x00\xc5\x40"),
    Belly = 	   ("\xcd\xcc\x5c\x41"),
    Belly2 = 	   ("\xcd\xcc\x5c\x40"),
    PerfShort =    ("\x00\x00\xc0\x80"),
	
	Net3DTest2 = ("\x5a\x2b\xa1\x2f"),
	Net3DTest3 = ("\x9a\x99\xa3\x40"), 
	Net3DTest4 = ("\x1a\x1b\x30\x2f"),
	
}

--//================================================================================================================================================================//
--// Goalnets_Shape
--//================================================================================================================================================================//

local Shape = { 

--triangles
	ShortNet = 		 ("\x00\x00\x80\x3f\xcd\xcc\x40\x3f\x00\x00\x00\x40\x00\x00\xc8\x42\x00\x00\x20\x41"),
    MidTriangleNet = ("\x00\x00\x80\x3f\xcd\xcc\x4c\x3e\x00\x00\xa9\x3f\x00\x00\xc8\x43\x00\x00\x20\x40"),
    MidTriangleNet2 =("\x00\x00\x80\x3f\xcd\xcc\x4c\x3e\x00\x00\xa9\x3f\x00\x00\xc8\x42\x00\x00\x20\x40"),
    TriangleNet = 	 ("\x00\x00\x20\x3f\x00\x00\x00\x3f\x00\x00\x60\x40\x00\x00\xc8\x41\x00\x00\x20\x40"),
	TriangleNet2 = 	 ("\x00\x00\x20\x3f\x00\x00\x00\x3f\x00\x00\x60\x41\x00\x00\xc8\x41\x00\x00\x20\x40"),
    TriangleNet3 = 	 ("\x8f\xc2\x75\x3f\x00\x00\x00\x00\x00\x00\x80\x3f\x00\x7c\x92\x48\x00\x00\xa0\x41"),
	TriangleNet4 = 	 ("\x00\x00\x00\x3c\x00\x00\xc5\x3f\x00\x00\xc8\x44\x00\x00\xb0\x41\x00\x00\x20\x41"),
    CampNouClassic = ("\x00\x00\x80\x3f\xcd\xcc\x4c\x3f\x00\x00\xc0\x3f\x00\x00\xc8\x42\x00\x00\x20\x41"),	
    CampNouClassic2 =("\x00\x00\x60\x3f\xcd\xcc\x4c\x3f\x00\x00\xc3\x3f\x00\x00\xc8\x42\x00\x00\x20\x41"),
    Fener = 		 ("\x00\x00\x80\x3f\x00\x00\x4c\x3f\x00\x00\x9a\x3f\x00\x00\xc8\x43\x00\x00\x20\x42"),
    LooserTriangle = ("\x9a\x99\x99\x3f\x00\x00\x00\x00\x9a\x99\xd9\x3f\x00\x00\xc8\x42\x00\x00\x20\x41"),
	TriangleL = 	 ("\xcd\xcc\x4c\x3e\xcc\xee\x49\x3f\x00\x00\x00\x41\x00\x00\x20\x41\x00\x00\x20\x41"),	
	Flamengo = 	 	 ("\xcd\xcc\x4c\x3f\x00\x00\x00\x00\x00\x00\x20\x40\x00\x00\x48\x43\x00\x00\xc8\x42"),	
	Flamengo2 = 	 ("\xcd\xcc\x4c\x3f\x00\x00\x00\x00\x00\x00\x20\x40\x00\x00\x48\x42\x00\x00\xc8\x42"),	
	Circle = 	 	 ("\x00\x00\x80\x3f\x00\x00\x4c\x00\x00\x00\x00\x41\x00\x00\xc8\x41\x00\x00\x20\x42"),
	BalancedTriangle = ("\x50\x50\x60\x3f\x66\x66\x66\x3e\x00\x00\xb0\x3f\x00\x00\xc8\x42\x00\x00\x28\x41"),
	DeepTriangle =   ("\x75\x75\x75\x3f\x33\x33\x33\x3f\x00\x00\x50\x40\x00\x00\x48\x43\x00\x00\x38\x42"),
	TightTriangle =  ("\x30\x30\x40\x3f\x10\x10\x00\x3f\x00\x00\x80\x41\x00\x00\xc8\x41\x00\x00\x20\x41"),
	CurvedTriangle = ("\x20\x20\x90\x3f\x55\x55\x50\x3f\x00\x00\x70\x40\x00\x00\xc8\x42\x00\x00\x40\x41"),

--squares
    NetOriginal = 	 ("\x00\x00\x80\x3f\xcd\xcc\x4c\x3f\x00\x00\x80\x3f\x00\x00\xc8\x42\x00\x00\x20\x41"),
    NetOriginalT = 	 ("\x00\x00\x80\x3f\xcd\xcc\x4c\x3f\x00\x00\x80\x3f\x00\x00\x10\x43\x00\x00\x20\x41"),
    NetOriginal2 = 	 ("\x00\x00\x89\x3f\xcd\xcc\x4c\x3f\x9a\x80\x40\x3f\x00\x00\xc8\x42\x00\x00\x20\x41"),
    NetOriginal3 = 	 ("\x00\x00\x86\x3f\xcd\xcc\x4c\x3f\x00\x00\x29\x3f\x00\x00\xc8\x43\x00\x00\x20\x41"),
    NetOriginal4 = 	 ("\x00\x00\x80\x3f\xcd\xcc\x4c\x3f\x00\x00\x80\x3f\x00\x00\xc8\x42"),
    NetOriginal5 = 	 ("\x00\x00\x80\x3f\xcd\xca\x4c\x3f\x00\x00\x80\x3f\x00\x00\xc3\x42\x00\x00\x20\x41"),
    NetOriginal6 = 	 ("\x00\x00\x80\x3f\xcd\xc8\x46\x3f\x00\x00\x8c\x3f\x00\x00\xc3\x42\x00\x00\x20\x41"),
	NetOriginal7 = 	 ("\x00\x00\x80\x3f\xcd\xcc\x4c\x3f\x00\x00\x70\x3f\x00\x00\xb8\x42\x00\x00\x18\x41"),
    NetOriginalL = 	 ("\x00\x00\x80\x3f\xcd\xcc\x4c\x3f\x00\x00\x80\x3f\x00\x00\xc8\x41\x00\x00\x20\x41"),
    NetOriginalS = 	 ("\x00\x00\x80\x3f\xcd\xcc\x4c\x3f\x00\x00\x80\x3f\x00\x00\xc8\x44\x00\x00\x20\x41"),
	NetOriginal_V1 = ("\x00\x00\x80\x3f\xcd\xcc\x4c\x3f\x00\x00\x80\x3f\x30\x30\x78\x42\x00\x00\x20\x41"),
    NetOriginalTest5 = 	 ("\x00\x00\x80\x3f\xcd\xcc\x4c\x3f\x00\x00\x80\x3f\x00\x00\xd0\x42\x00\x00\x20\x41"),
    NetNormal = 	 ("\x00\x00\x80\x3f\x00\x00\x00\x3f\x00\x00\x80\x3f\x00\x00\xc8\x48\x00\x00\x20\x42"),
    PerfectSquareH = ("\x9a\x89\x89\x3f\x00\x00\x00\x3e\x9a\x80\x40\x3f\x00\x00\xc8\x44\x00\x00\x20\x42"),
	PerfectSquareH2 = ("\x9a\x89\x89\x3f\x00\x00\x00\x3e\x9a\x80\x40\x3f\x00\x00\xc8\x44\x00\x00\x20\x42\x00\x00\x80\x41\x00\x00\x79\x3b"),
    PerfectSquareH3 = ("\x66\x66\x86\x3f\x00\x00\x00\x3e\x9a\x80\x40\x3f\x00\x00\xc8\x44\x00\x00\x20\x42"),
    PerfectSquareH4 = ("\x00\x00\x80\x3f\x00\x00\x00\x3e\x9a\x80\x40\x3f\x00\x00\xc8\x44\x00\x00\x20\x42"),
    PerfectSquareL = ("\x00\x00\x89\x3f\xcd\xcc\x4c\x3f\x9a\x80\x40\x3f\x00\x00\xc8\x44\x00\x00\x20\x42"),	
    PerfectSquareL2 =("\x00\x00\x89\x3f\xcd\xcc\x4c\x3c\x9a\x80\x40\x3f\x00\x00\xc1\x44\x00\x00\x20\x42"),	
    PerfectSquare =  ("\x00\x00\x89\x3f\xcd\xcc\x4c\x3f\x9a\x80\x40\x3f\x00\x00\xc8\x44\x00\x00\x20\x41"),
    PerfectSquare2 =  ("\x00\x00\x89\x3f\xcd\xcc\x4c\x3f\x99\x80\x40\x3f\x00\x00\xc8\x47\x00\x00\x40\x41"),
    SmallSquare = 	 ("\x00\x00\x89\x3f\xcd\xcc\x4c\x3f\x9a\x80\x40\x3f\x00\x00\xc8\x45\x00\x00\x20\x41"),
    PerfShort = 	 ("\xc5\x20\x80\x3f\xcd\xcc\x4c\x3f\x00\x00\x80\x3f\x00\x00\xc8\x42\x00\x00\x20\x41"),
	Square = 	 	 ("\x66\x66\x86\x3f\x9a\x99\x19\x3f\x33\x33\x33\x3f\x00\x00\xe1\x43\x00\x00\x20\x41"),	
    Trbz = 			 ("\x00\x00\x60\x3f\xcd\xcc\x4c\x3f\x00\x00\x80\x3f\x00\x00\xc8\x41\x00\x00\x20\x41"),
	JapanSquare = 	 ("\x00\x00\x8f\x3f\xcd\xcc\x4c\x3f\x9a\x99\x1c\x3f\x00\x00\xc8\x42\x00\x00\x20\x41"),
	OgSquare = 	 	 ("\x00\x00\x82\x3f\xcd\xcc\x4c\x3f\x9a\x99\x80\x3f\x00\x00\xc8\x42\x00\x00\x20\x41"),
	OgSquareS = 	 ("\x00\x00\x7c\x3f\xcd\xcc\x4c\x3f\x9a\x99\x8c\x3f\x00\x00\xc8\x42\x00\x00\x20\x41"),
	OgMidDeep = 	 ("\x00\x00\x80\x3f\xcd\xcc\x4c\x3f\x9a\x99\x60\x3f\x00\x00\xc8\x42\x00\x00\x20\x41"),
	OgMidDeep2 = 	 ("\x00\x00\x80\x3f\xcd\xcc\x48\x3f\x00\x00\x60\x3f\x00\x00\xa8\x42\x00\x00\x20\x41"),
	OgMidDeep3	= 	 ("\x00\x00\x80\x3f\xcd\xcc\x4c\x3f\x9a\x99\x60\x3f\x00\x00\xc8\x43\x00\x00\x20\x41"),
	NewOriginal = 	 ("\x00\x00\x80\x3f\xcd\xcc\x4c\x3f\x00\x00\x80\x3f\x00\x00\xc8\x43\x00\x00\x20\x41\x9a\x99\x99\x3f\x00\x00\x00\x3f"),
	PerfectSquareS = ("\xb8\x1e\x83\x3f\xcd\xcc\x2c\x3f\x00\x00\x80\x3f\x00\x00\xc8\x43\x00\x00\x20\x41"), -- S = smaller	
	PerfectCube = 	 ("\xf5\x28\x84\x3f\x33\x33\x33\x3f\xcd\xcc\x7c\x3f\x00\x00\xcc\x43\x00\x00\x50\x41"),

	OgMidDeep4 = 	 ("\x00\x00\x80\x3f\xcd\xcc\x4c\x3f\x9a\x99\x60\x3f\x00\x00\xc8\x42\x00\x00\x20\x41\x29\x5c\x0f\x40\x43\x3d\x7d\x3a"),
	OgMidDeep5 = 	 ("\x00\x00\x80\x3f\xcd\xcc\x4c\x3f\x9a\x99\x60\x3f\x00\x00\xc8\x42\x00\x00\x20\x41\x79\xe9\x1e\x41\x1c\x2f\x1b\x3b"),


--reverse triangles (more deep at top then in the bottom)
    Lic = 		 ("\x00\x00\x80\x3f\x0c\xd9\xa3\x3d\x0a\xd7\x5c\x3f\x00\x00\xc6\x42\xcd\xcc\x20\x41"),
    Lic2 = 		 ("\x00\x00\x80\x3f\x0c\xd9\xa3\x3d\x0a\xd7\x5c\x3f\x00\x00\xc6\x43\xcd\xcc\x40\x42"),
	Lic3 = 		 ("\x00\x00\x80\x3f\x0c\xd9\xa3\x3d\x0a\xd7\x5c\x3f\x00\x00\xc6\x42\xcd\xcc\x20\x41"),
    MidDeepNet = 	 ("\x00\x00\x80\x3f\xcd\xcc\x4c\x3f\x9a\x99\x19\x3f\x00\x00\xc8\x42\x00\x00\x20\x41"),
    MidDeepNetT = 	 ("\x00\x00\x80\x3f\xcd\xcc\x4c\x3f\x0f\x5c\x78\x3f\x00\x00\xe6\x42\x00\x00\x20\x41"),
    MidDeepNet2 = 	 ("\x2c\x5f\x8a\x3f\xcd\xcc\x4c\x3f\x45\x45\x45\x3f\x00\x00\xc8\x44\x00\x00\x20\x41"),
    MidDeepNet3 = 	 ("\x00\x00\x85\x3f\xcd\xcc\x4c\x3f\x9a\x99\x19\x3f\x00\x00\xc8\x42\x00\x00\x16\x41"),
    MidDeepNet4 = 	 ("\x00\x00\x81\x3f\xcd\xcc\x49\x3f\x9a\x99\x19\x3f\x00\x00\xc8\x43\x00\x00\xc0\x41"),
	MidDeepNet5 = 	 ("\x00\x00\x80\x3f\xcd\xcc\x4c\x3f\x9a\x99\x60\x3f\x00\x00\xc8\x42\x00\x00\x20\x41"),
    MidDeepNet6 = 	 ("\x00\x00\x80\x3f\xcd\xcc\x4c\x3f\x9a\x99\x19\x3f\x00\x00\xc8\x43\x00\x00\x20\x41"),
    MidDeepNet7 = 	 ("\x00\x00\x80\x3f\xcd\xcc\x4c\x3f\xcd\xcc\x34\x3f\x00\x00\xdc\x42\x00\x00\x20\x41"),
    MidDeepNetS = 	 ("\x00\x00\x79\x3f\xcd\xcc\x4c\x3f\x00\x00\x30\x3f\x00\x00\xc8\x42\x00\x00\x20\x41"),
    MidDeepNetEPL =  ("\x00\x00\x80\x3f\xcd\xcc\x4c\x3f\x9a\x99\x19\x3f\x00\x00\xc8\x45\x00\x00\x20\x41"),
    SAfricaWC2010 =  ("\x00\x00\x89\x3f\xcd\xcc\x4c\x3f\x00\x00\x00\x3f\x00\x00\xc8\x42\x00\x00\xc0\x40"),
    SAfricaWC20102 = ("\x00\x00\x86\x3f\xcd\xcc\x4c\x3f\x00\x00\x00\x3f\x00\x00\xc8\x42\x00\x00\xc0\x40"),
    SAfricaWC20103 =  ("\x00\x00\x84\x3f\xcd\xcc\x4c\x3f\x00\x00\x00\x3f\x00\x00\xc8\x42\x00\x00\xc0\x40"),
    SAfricaWC20104 =  ("\x00\x00\x89\x3f\x0c\xd9\xa3\x3d\x00\x00\x00\x3f\x00\x00\xc8\x42\x00\x00\xc0\x40"),
	MidDeepNetG = 	 ("\x00\x00\x70\x3f\xcc\xcb\x4b\x3f\x90\x98\x10\x3f\x00\x00\xc0\x42\x00\x00\x15\x41"),
	Cardiff = 	 	 ("\x00\x00\x80\x3f\x00\x00\x00\x3f\x00\x00\x80\x3f\x00\x00\xc6\x42\xcd\xcc\x20\x41"),
	Juve = 			 ("\x00\x00\x80\x3f\x00\x00\x00\x3f\x00\x00\x00\x40\x00\x00\xca\x42\x00\x00\x48\x41"), 
	NetOriginalDT =  ("\x00\x00\x80\x3f\x9a\x99\x19\x3f\x66\x66\x66\x3f\x00\x00\x48\x43\x00\x00\x20\x41"), -- DT - DeepTop 
	
--deep nets (lot deeper than original)
    DeepNet = 	  	 ("\xac\xac\xac\x3f\x10\x10\x10\x3f\xcd\xcc\x4c\x3d\x00\x00\xc8\x42\x00\x00\x40\x41"),
    DeepPerfSqr = 	 ("\x9a\x99\x9f\x3f\x00\x00\x00\x39\x9a\x99\xd9\x3e\x00\x00\xc8\x43\x00\x00\x20\x42"),
    DeepPerfSqr2 = 	 ("\x4d\x44\xa1\x3f\x00\x00\x00\x3c\x00\x00\xd9\x3e\x00\x00\xc5\x44\x00\x00\x20\x42"),
    Real = 			 ("\x9a\x89\x89\x3f\x00\x00\x00\x3f\x9a\x99\x19\x3f\x00\x00\xc8\x45\x00\x00\x20\x41"),
    Real2 = 		 ("\x9a\x89\x89\x3f\x00\x00\x00\x3f\x9a\x99\x19\x3f\x00\x00\xc8\x43\x00\x00\x20\x41"),
    Real3 = 	     ("\x80\x88\x88\x3f\x00\x00\x00\x3f\x00\x00\x1c\x3f\x00\x00\xc8\x45\x00\x00\x20\x41"),
    DeepTensNet = 	 ("\xcd\x99\x99\x3f\x00\x00\x00\x3f\xcd\x99\x99\x3e\x00\x00\xc8\x44\x00\x00\x20\x41"),
    DeepLoseNet = 	 ("\xcd\x99\x99\x3f\x00\x00\x00\x3f\xcd\x99\x99\x3e\x00\x00\xc8\x42\x00\x00\x20\x42"),
    DeepLoseNet2 = 	 ("\xcd\x99\x90\x3f\x00\x00\x00\x3f\x00\x00\x99\x3e\x00\x00\xc8\x43\x00\x00\x20\x42"),
    Zaragoza = 		 ("\x9a\x89\x99\x3f\x00\x00\x00\x3e\x9a\x80\x40\x3f\x00\x00\xc8\x44\x00\x00\x20\x42"),
	NewDeepNet = 	 ("\x9a\x99\x99\x3f\x9a\x99\x19\x3f\x9a\x99\x19\x3f\x00\x00\x16\x44\x00\x00\x20\x41"),
	NewDeepNet2 = 	 ("\x00\x00\xa0\x3f\x9a\x99\x19\x3f\x00\x00\x00\x3f\x00\x00\x16\x44\x00\x00\x20\x41"),
	ImprovedDeepNet2 = ("\x00\x00\x99\x3f\x9a\x99\x25\x3f\x9a\x99\x32\x3f\x00\x00\x16\x45\x00\x00\x20\x42"),
	
--small nets
    AnoetaClassic =  ("\x00\x00\x80\x3f\xcd\xcc\x4c\x3f\x00\x00\x80\x3f\x00\x00\xc8\x42\x00\x00\x20\x41"),
    MidNet = 		 ("\x00\x00\x80\x3f\xcd\xcc\x4c\x3f\x00\x00\x80\x3f\x00\x00\xc8\x40\x00\x00\x16\x42"),
    SmallNet = 		 ("\x00\x00\x80\x3f\x0c\xd9\xa3\x3d\x0a\xd5\xa7\x3f\x00\x00\xc8\x42\xcd\xcc\x20\x41"),
    SmallNetB = 		 ("\x00\x00\x80\x3f\x0c\xd9\xa3\x3d\x0a\xd5\xa7\x3f\x00\x00\xc6\x42\xcd\xcc\x20\x41"), --better
    SmallNetT2 = 		 ("\x00\x00\x80\x3f\x00\x00\x00\x3f\x00\x00\x80\x3f\x00\x00\xa8\x43\xcd\xcc\x20\x41"), --test
	SmallNet2 = 	 ("\x20\x20\x85\x3f\x1a\xe5\xb3\x3e\x20\x20\x99\x3f\x00\x00\xc7\x42\x00\x00\x28\x41"),
    SmallNet3 = 	 ("\x00\x00\x60\x3f\x0c\xd9\xa3\x3d\x0a\xd5\xa7\x3f\x00\x00\xc6\x42\xcd\xcc\x20\x41"),
    SmallNet4 = 	 ("\x00\x00\x80\x3f\x0c\xd9\xa3\x3d\x0a\xd5\xa7\x3f\x00\x00\xc6\x42"),
    SmallNet5 = 	 ("\x00\x00\x78\x3f\xcd\xcc\x4c\x3f\x00\x00\xad\x3f\x00\x00\xc6\x42\x00\x00\x20\x41"),
    SmallNetL = 	 ("\x00\x00\x79\x3f\x00\x00\x00\x3f\x00\x00\xaf\x3f\x00\x00\xc6\x42\x00\x00\x20\x41"),
	SmallNetT = 	 ("\x30\x30\x90\x3f\x25\xf0\xbb\x3f\x30\x30\xb0\x3f\x00\x00\xc7\x42\x00\x00\x28\x41"),
    Ajax = 			 ("\x9a\x89\x89\x3f\x00\x00\x00\x3e\x9a\x89\x89\x3f\x00\x00\xc8\x44\x00\x00\x20\x42"),
	SmallMidDeep = 	 ("\x00\x00\x60\x3f\x0c\xd9\xa3\x3d\x00\x00\xaf\x3f\x00\x00\xc6\x42\xcd\xcc\x20\x41"),
	Defensa = 		 ("\x00\x00\x70\x3f\x0c\xd9\xa3\x3d\x0a\xd5\xa9\x3f\x00\x00\xc6\x42\xcd\xcc\x20\x41"),
	

	
	SmallNetTest = 		 ("\x00\x00\x7e\x3f\x0c\xd9\xa3\x3d\x0a\xd5\xa7\x3f\x00\x00\xc6\x42\xcd\xcc\x20\x41\x00\x00\x80\x3f\x00\x00\x79\x38"),
	SmallNetTest2 = 	("\x00\x00\x7e\x3f\x0c\xd9\xa3\x3d\x0a\xd5\xa7\x3f\x00\x00\xc6\x42\xcd\xcc\x20\x41\x00\x00\x7e\x3f\x00\x00\x79\x35"),
	
	SmallNetTriangle = 	("\x00\x00\x7e\x3f\x0c\xd9\xa3\x3d\x0a\xd5\xa7\x3f\x00\x00\xc6\x42\xcd\xcc\x20\x41\x00\x00\x80\x3f\x00\x00\x79\x35"),	
	SmallNetTriangle2 = ("\x00\x00\x7e\x3f\x0c\xd9\xa3\x3d\x0a\xd5\xa7\x3f\x00\x00\xbe\x42\xcd\xcc\x20\x41\x00\x00\x80\x3f\x00\x00\x79\x35"),
	SmallNetTriangle3 = ("\x00\x00\x7e\x3f\x0c\xd9\xa3\x3d\x0a\xd5\xa7\x3f\x00\x00\xc6\x42\xcd\xcc\x20\x42\x00\x00\x80\x3f\x00\x00\x79\x35"),	
--curved nets
    NetOLDPES = 	 ("\xc5\x20\x80\x3f\xcd\xcc\x4c\x3f\x00\x00\x80\x3f\x00\x00\xc8\x42\x00\x00\x20\x41"),
    MidCurveNet = 	 ("\x00\x00\x00\x3f\xcd\xcc\x4c\x3f\x00\x00\x00\x40\x00\x00\xc8\x42\x00\x00\x20\x41"),
    MidCurveNet2 = 	 ("\x00\x00\x00\x3f\xcd\xcc\x4c\x3f\x00\x00\x00\x40\x00\x00\xc8\x41\x00\x00\x20\x41"),
    NetNormalCurve = ("\x00\x00\x66\x3f\x00\x00\x00\x3f\x00\x00\x80\x3f\x00\x00\xc8\x45\x00\x00\x20\x42"),
    CurveNet = 		 ("\x00\x00\x00\x3f\xcd\xcc\x4c\x3f\x00\x00\x80\x3f\x00\x00\xc8\x42\x00\x00\x20\x41"),
    CurveNet2 = 	 ("\x00\x00\x79\x3f\xcd\xcc\x4c\x3f\x00\x00\x80\x3f\x00\x00\xc8\x43\x00\x00\x20\x41"),
    CurveNet3 = 	 ("\x00\x00\x7b\x3f\xcd\xcc\x4f\x3f\x00\x00\x80\x3f\x00\x00\xc8\x43\x00\x00\x20\x40"),
    CurveNet4 = 	 ("\x20\x20\x7a\x3f\xcd\xcc\x4f\x3f\x00\x00\x80\x3f\x00\x00\xc8\x43\x00\x00\x20\x40"),
    CurveNet5 = 	 ("\x00\x00\x78\x3f\xcd\xcc\x4c\x3f\x00\x00\x80\x3f\x00\x00\xc8\x43\x00\x00\x20\x41"),
    CurveNet6 = 	 ("\x00\x00\x60\x3f\xcd\xcc\x4c\x3f\x00\x00\x80\x3f\x00\x00\xc8\x42\x00\x00\x20\x41"),
    CurveNet6L = 	 ("\x00\x00\x60\x3f\xcd\xcc\x4c\x3f\x00\x00\x80\x3f\xcc\xcd\xc8\x41\x00\x00\x20\x41"),
	CurveNet7 = 	 ("\x66\x66\x66\x3f\xcd\xcc\x4c\x3f\x00\x00\x80\x3f\x00\x00\xc8\x42\x00\x00\x20\x41"),
	CurveNet8 = 	 ("\x00\x00\x70\x3f\xcc\xcb\x4b\x3f\x00\x00\x70\x3f\x00\x00\xc0\x42\x00\x00\x15\x41"),	
    CurveNet9 = 	 ("\x00\x00\x7b\x3f\x66\x66\x56\x3f\x00\x00\x80\x3f\x00\x00\x48\x43\x00\x00\x20\x40"),
	-- CurveNet2: Emphasized Sideways Curve
CurveNet2_Sideways = ("\x00\x00\x79\x3f\xce\xcd\x4d\x3f\x00\x00\x85\x3f\x00\x00\xd0\x43\x00\x00\x22\x41"),

-- CurveNet3: Delayed Reaction
CurveNet3_Delayed = ("\x00\x00\x7b\x3f\xcd\xcc\x4f\x3f\x00\x00\x75\x3f\x00\x00\xc0\x43\x00\x00\x18\x40"),

-- CurveNet4:  Top Corner Emphasis
CurveNet4_TopCorner = ("\x20\x20\x7a\x3f\xcd\xcc\x50\x3f\x00\x00\x85\x3f\x00\x00\xd8\x43\x00\x00\x25\x40"),

-- CurveNet5:  Reduced Overall Movement
CurveNet5_Reduced = ("\x00\x00\x78\x3f\xcc\xcb\x4b\x3f\x00\x00\x75\x3f\x00\x00\xc0\x43\x00\x00\x18\x41"),

--loosen nets
    Belly = 		 ("\x00\x00\x80\x3f\xcd\xcc\x4c\x3f\x9a\x99\x19\x3f\x00\x00\xc8\x42\x00\x00\x20\x41"),	
    Belly2 = 		 ("\x00\x00\x79\x3f\xcd\xcc\x4c\x3f\x9a\x99\x49\x3f\x00\x00\xc8\x42\x00\x00\x20\x41"),	
    Belly3 = 		 ("\x00\x00\x80\x3f\xcd\xcc\x4c\x3f\x9a\x99\x19\x3f\x00\x00\xc8\x42"),	
    BellyC = 		 ("\x00\x00\x70\x3f\xcd\xcc\x4c\x3f\x9a\x99\x19\x3f\x00\x00\xc8\x42\x00\x00\x20\x41"),	
	BellyCurved = 	 ("\x1e\x85\x6e\x3f\xcd\xcc\x4c\x3f\x33\x33\x93\x3f\x00\x00\xc8\x42\x00\x00\x20\x41"),	
    LargeLooseNet =  ("\x00\x00\x80\x3f\xcd\xcc\x4c\x3f\x00\x00\x80\x3e\x00\x00\xc8\x42\x00\x00\x20\x41"),
    NetLoose = 		 ("\x9a\x89\x89\x3f\x00\x00\x4c\x3f\x9a\x80\x99\x3f\x00\x00\xc8\x45\x00\x00\x40\x41"),	
--other nets
    LargeNet = 		 ("\x00\x00\x80\x3f\xcd\xcc\x4c\x3f\x00\x00\x00\x00\x00\x00\xc8\x42\x00\x00\x20\x41"),
    NetWC = 		 ("\xe1\x7a\x54\x3f\x00\x00\x80\x3e\x00\x00\xc0\x3f\x00\x00\xc8\x41\x00\x00\xa0\x40"),
    NetWC2 = 		 ("\xe1\x7a\x54\x3f\x00\x00\x80\x3e\x00\x00\xc0\x3f\x00\x00\xc8\x41\x00\x00\x20\x41"),
    MidLowNet = 	 ("\x00\x00\x80\x3f\xcd\xcc\x4c\x3f\x00\x00\x80\x3f\x00\x00\xc8\x42\x00\x00\x16\x43"),
    MidLowNet2 = 	 ("\x00\x00\x80\x3f\xcd\xcc\x5c\x3f\x00\x00\x80\x3f\x00\x00\xc8\x42\x00\x00\x16\x42"),
    RomaClassic = 	 ("\x9a\x99\x99\x3f\x66\x66\xc6\x3f\x00\x00\x80\x3e\x00\x00\xc8\x42\x00\x00\x20\x41"),
    OldTrafClassic = ("\x00\x00\x80\x3f\x66\x66\xc6\x3f\x9a\x99\x19\x3f\x00\x00\xc8\x42\x00\x00\x20\x41"),
    UltraLowNet = 	 ("\x00\x00\xa0\x3f\xcd\xcc\x4c\x3f\x00\x00\x80\x3f\x00\x00\xc8\x42\x00\x00\x16\x43"),
    NetBrasil = 	 ("\x00\x00\x20\x3f\x00\x00\x00\x3f\x00\x00\x80\x40\x00\x00\xc8\x41\x00\x00\x20\x40"),
    Nizny = 	     ("\x00\x00\x80\x3f\x00\x00\x00\x3c\x9a\x80\x80\x3f\x00\x00\xc8\x45\x00\x00\x20\x41"),
    StadeFrance = 	 ("\x00\x00\x80\x3f\x00\x00\x00\x3e\x00\x00\x9a\x3f\x00\x00\xc8\x43\x00\x00\x20\x42"),
    StadeFrance2 = 	 ("\x00\x00\x80\x3f\x00\x00\x00\x3e\x00\x00\x9a\x3f\x00\x00\xc8\x43\x00\x00\x20\x42"),	
	DanishNet = 	 ("\xcd\xcc\x4c\x3f\x9a\x99\x19\x3f\x66\x66\xe6\x3f\x00\x00\xc8\x42\x00\x00\x20\x41"),
	DanishNetL = 	 ("\xcd\xcc\x4c\x3f\x9a\x99\x19\x3f\x66\x66\xe6\x3f\x00\x00\xc8\x42\x00\x00\x20\x41"), --loose middle

	

--Clubs
	Newcastle = 	 ("\x00\x00\x74\x3f\xcd\xcc\x66\x3f\x9a\x99\x9c\x3f\x00\x00\xc8\x42\x00\x00\x20\x41"),
	United =	 	 ("\x12\x12\x84\x3f\xbc\xbc\x3f\x3f\x9a\x99\x35\x3f\x00\x00\xc9\x43\x00\x00\x29\x41"),
	Fenerbahce = 	 ("\x00\x00\x7f\x3f\xcd\xcc\x4c\x3f\x9a\x99\x75\x3f\x00\x00\x08\x43\x00\x00\x20\x41"),
    Lanus = 	 	 ("\x00\x00\x77\x3f\xcd\xcc\x4c\x3f\x00\x00\x79\x3f\x00\x00\xc8\x43\x00\x00\x20\x41"),
    Brondby = 	 	 ("\x00\x00\x30\x3f\xcd\xcc\x4c\x3f\x00\x00\x79\x3f\x00\x00\xc8\x42\x00\x00\x20\x41"),
    Barca = 	 	 ("\x66\x66\x86\x3f\xcd\xcc\x4c\x3f\x9a\x80\x40\x3f\x00\x00\xd4\x43\x00\x00\x20\x41"),
    Slovan = 		 ("\x00\x00\x65\x3f\x0c\xd9\x66\x3d\x00\x00\xaf\x3f\x00\x00\xc2\x42\x00\x00\x80\x41"),
    UTD2003 =	 	 ("\x00\x00\x70\x3f\xcd\xcc\x4c\x3f\x00\x00\xa1\x3f\x00\x00\xc8\x42\x00\x00\x20\x41"),
    Fulham = 		 ("\x00\x00\x50\x3f\x0c\xd9\xa3\x3d\x0a\xd5\xa7\x3f\x00\x00\xc6\x42\xcd\xcc\x20\x41"),
    Antwerp = 		 ("\x00\x00\x50\x3f\x0c\xd9\xa3\x3d\x0a\xd5\xa7\x3f\x00\x00\xc6\x42\xcd\xcc\x20\x41"),
    Olimpico = 	 	 ("\x00\x00\x80\x3f\xcd\xcc\x4c\x3f\x00\x00\x69\x3f\x00\x00\x99\x42\x00\x00\x20\x41"),
    City =  		 ("\x00\x00\x79\x3f\xcd\xcc\x4c\x3f\x00\x00\x30\x3f\x00\x00\xc8\x43\x00\x00\x20\x41"),
    Madrid = 	     ("\x80\x88\x86\x3f\x00\x00\x00\x3f\x00\x00\x1b\x3f\x00\x00\xc8\x44\x00\x00\x20\x42"),
	Twente =  		 ("\x00\x00\x84\x3f\xcd\xcc\x4c\x3f\x00\x00\x50\x3f\x00\x00\xc8\x42\x00\x00\x20\x41"),

-- ENGLAND / Premier League (EPL)
	ArsenalNet = 	 ("\xc2\xf5\x7f\x3f\x9a\x99\x25\x3f\x85\xeb\x7a\x3f\x00\x00\x48\x44"),
	ChelseaNet = 	 ("\xb8\x1e\x83\x3f\x66\x66\x0c\x3f\x66\x66\x88\x3f\x00\x00\xaa\x42\xcd\xcc\x20\x41\x00\x00\x00\x40"),
	UnitedNet = 	 ("\xb8\x1e\x83\x3f\x40\x0f\x44\x3f\xcd\xcc\x0c\x3f\x00\x00\x7a\x43\x00\x00\x50\x41\x00\x00\xa0\x40"),
	BournemouthNet = ("\x3d\x0a\x81\x3f\x33\x33\x33\x3f\xb8\x1e\x83\x3f\x00\x00\x16\x43\x00\x00\x20\x41\xcd\xcc\x2c\x3f"),
	BrentfordNet = 	 ("\x00\x00\x80\x3f\xcd\xcc\x2c\x3f\xe1\x7a\x6b\x3f\x00\x00\x48\x43\x00\x00\x20\x41\xcd\xcc\x2c\x3f"),
	NewcastleNet = 	 ("\x1e\x85\x6e\x3f\xcd\xcc\x4c\x3f\x00\x00\x80\x3f\x00\x00\x48\x43\x00\x00\x20\x41\x66\x66\x66\x3f"),
	SpursNet = 	 	 ("\x85\xeb\x7a\x3f\xcd\xcc\x4c\x3f\xb8\x1e\x83\x3f\x00\x00\x48\x43"),
	EvertonNet =	 ("\x00\x00\x80\x3f\x00\x00\x49\x3f\x66\x66\x70\x3f\x00\x00\x40\x43\x00\x00\x20\x41"),
	FulhamNet = 	 ("\x00\x00\x80\x3f\x0c\xd9\x80\x3c\x0a\xd5\xa7\x3f\x00\x00\x48\x43\x00\x00\x70\x41\x00\x00\xc0\x3f"),
	LiverpoolNet = 	 ("\x00\x00\x80\x3f\xcd\xcc\x4c\x3f\x1e\x85\x6e\x3f\x00\x00\x20\x44"),
	CityNet = 		 ("\x10\x10\x88\x3f\xbc\xbc\x3f\x3f\x9a\x99\x30\x3f\x00\x00\xcc\x42\x00\x00\x28\x41"),
	WestHamNet = 	 ("\xf5\x28\x84\x3f\x33\x33\x33\x3f\xa4\x70\x3b\x3f\x00\x00\x50\x43\x00\x00\x20\x41\x00\x00\x20\x41\x00\x00\x80\x3f\x17\xb7\xd1\x38\x6f\x12\x83\x3a"),
	VillaNet = 	 	 ("\xaf\x47\x95\x3f\x33\x33\x33\x3f\x33\x33\x33\x3f\x00\x00\xaa\x44\x00\x00\x20\x41\x00\x00\x20\x41\x9a\x99\x19\x3f\x17\xb7\xd1\x38\x6f\x12\x83\x39"),
	AstonVillaNet2 = ("\x00\x00\x8d\x3f\xcd\xcc\x3c\x3f\x98\x8a\x23\x3f\x00\x00\x5f\x43\x00\x00\x80\x41"),
	WolvesNet =      ("\x10\x10\x84\x3f\xbc\xbc\x3f\x3f\x9a\x99\x25\x3f\x00\x00\xcc\x43\x00\x00\x30\x41"),
	BrightonNet =    ("\xc2\xf5\x7c\x3f\x33\x33\x33\x3f\xcd\xcc\x7c\x3f\x00\x00\x20\x43\x00\x00\xa9\x41"),
	PalaceNet =	  	 ("\x00\x00\x7c\x3f\x00\x00\xaa\x3d\x00\x00\x80\x3f\x00\x00\x20\x43\xcd\xcc\xbb\x41"),

-- ENGLAND / EFL Championship
	CoventryNet =    ("\x66\x66\x86\x3f\xbc\xbc\x3f\x3f\x33\x33\x33\x3f\x00\x00\x20\x43\x00\x00\x28\x41"),
	BlackburnNet = 	 ("\x7b\x14\x82\x3f\x34\x24\x49\x3f\xcd\xcc\x7c\x3f\x00\x00\x60\x43"),
	LeedsNet = 		 ("\x7b\x14\x80\x3f\xcd\xcc\x4c\x3f\xcd\xcc\x4c\x3f\x00\x00\x10\x44"),
	LeedsNetOLD = 	 ("\x7b\x14\x82\x3f\xcd\xcc\x4c\x3f\xcd\xcc\x4c\x3f\x00\x00\xc0\x43"),
	SunderlandNet =  ("\x48\xe1\x78\x3f\xcd\xcc\x5c\x3f\x00\x00\x80\x3f\x00\x00\x99\x42"),
	WrexhamNet = 	 ("\x00\x00\x78\x3f\xcd\xcc\x4c\x3f\x00\x00\x99\x3f\x00\x00\xcc\x42\x00\x00\x00\x41"),

-- ENGLAND / National Stadiums
	WembleyNet = 	 ("\x9a\x99\x99\x3f\xcd\xcc\x4c\x3f\x9a\x99\x19\x3f\x00\x00\x90\x43\x00\x00\x20\x41"),

-- SCOTLAND / Premiership (William Hill Premiership)
	HibernianNet =   ("\x7b\x14\x82\x3f\x00\x00\x40\x3f\x00\x00\x80\x3f\x00\x00\x16\x43\x00\x00\xbb\x41"),
	AberdeenNet =	 ("\x10\x10\x85\x3f\xbc\xbc\x3f\x3f\x33\x33\x33\x3f\x00\x00\xc9\x42\x00\x00\x60\x41"),
	RangersNet =	 ("\x10\x10\x88\x3f\xbc\xbc\x30\x3f\x00\x00\x17\x3f\x00\x00\x99\x43\x00\x00\x60\x41"),
	DundeeNet =		 ("\x10\x10\x85\x3f\xbc\xbc\x3f\x3f\x33\x33\x33\x3f\x00\x00\xc9\x42\x00\x00\x60\x41"),
	HeartsNet =		 ("\x48\xe1\x78\x3f\xcd\xcc\x4c\x3f\x33\x33\x93\x3f\x00\x00\x70\x43\x00\x00\x00\x41"),
	KilmarnockNet =	 ("\xa4\x70\x87\x3f\xcd\xcc\x4c\x3f\x9a\x99\x19\x3f\x00\x00\x40\x43\x00\x00\x40\x40"),
	MotherwellNet =	 ("\x0a\xd7\x75\x3f\xa4\x70\x68\x3f\xe1\x7a\x88\x3f\x00\x00\xc8\x43\x00\x00\x20\x41"),
	St_MirrenNet =	 ("\x0a\xd7\x75\x3f\xcd\xcc\x4c\x3e\x0a\xd5\xa7\x3f\x00\x00\xc8\x42\xcd\xcc\x00\x42"),
	St_JohnstoneNet =("\x0a\xd7\x75\x3f\xcd\xcc\xcc\x3e\x0a\xd5\xa7\x3f\x00\x00\x25\x43\xcd\xcc\x00\x42"),
	Ross_CountyNet = ("\x0a\xd7\x75\x3f\xcd\xcc\xcc\x3e\x66\x66\xc6\x3f\x00\x00\x60\x43\xcd\xcc\x20\x42"),
	LivingstonNet =	 ("\x0a\xd7\x75\x3f\xcd\xcc\x4c\x3e\x0a\xd5\xa7\x3f\x00\x00\xc8\x42\xcd\xcc\x00\x42"),
	Dundee_UtdNet =	 ("\x5c\x8f\x70\x3f\xcd\xcc\xcc\x3e\x66\x66\xc6\x3f\x00\x00\x60\x43\xcd\xcc\xaa\x41"),
	HampdenNet =     ("\x00\x00\x75\x3f\xcd\xcc\x4c\x3f\x00\x00\x90\x3f\x00\x00\x10\x43\x00\x00\x20\x41"),

-- SPAIN / La Liga
	AlavesNet =		 ("\x0a\xd7\x75\x3f\xc3\xf5\x41\x3f\x00\x00\x30\x3f\x00\x00\xc8\x43\x00\x00\x40\x41\xcd\xcc\x2c\x3f"),
	AtleticoNet =	 ("\x00\x00\x80\x3f\x00\x00\x40\x3f\xcd\xcc\x4c\x3f\x00\x00\x20\x43\x00\x00\x80\x40\x9a\x99\x19\x3f"),
	BilbaoNet =		 ("\x0a\xd7\x75\x3f\x00\x00\x00\x3f\x66\x66\x75\x3f\x00\x00\x7a\x44\x00\x00\x00\x42\x9a\x99\x19\x3f"),
	BarcaNet =		 ("\x99\x99\x81\x3f\xcd\xcc\x4c\x3f\x0a\xd7\x39\x3f\x00\x00\xd4\x43\x00\x00\x00\x41"),
	-- BarcaNet = 	 	("\x66\x66\x86\x3f\xcd\xcc\x4c\x3f\x0a\xd7\x39\x3f\x00\x00\xd4\x43\x00\x00\x20\x41\xcd\xcc\x2c\x3f"),
	BetisNet =		("\xcd\xcc\x7c\x3f\x00\x00\x80\x3e\xcd\xcc\x4c\x3f\x00\x00\xc8\x42"),
	BetisNet2 = 	("\x00\x00\x85\x3f\xcd\xcc\x4c\x3f\x98\x8a\x30\x3f\x00\x00\x30\x43\x00\x00\x80\x41"),
	CeltaNet =		("\xb8\x1e\x83\x3f\xcd\xcc\x4c\x3f\x34\x24\x49\x3f\x00\x00\x7a\x44"),
	EspanyolNet =	("\x66\x66\x86\x3f\xcd\xcc\x43\x3f\x0a\xd7\x25\x3f\x00\x00\xcf\x43\x00\x00\x20\x41"),
	GetafeNet =		("\xc2\xf5\x7f\x3f\xcd\xcc\x4c\x3f\x1f\x85\x45\x3f\x00\x00\x00\x43\x00\x00\x70\x40"),
	MallorcaNet =	("\x48\xe1\x78\x3f\xcd\xcc\x4c\x3e\xcd\xcc\x8c\x3f\x00\x00\x00\x43\x00\x00\x60\x42\xcd\xcc\x2c\x3f"),
	OsasunaNet =	("\x48\xe1\x78\x3f\xcd\xcc\xcc\x3c\x66\x66\x66\x3f\x00\x00\x00\x43\x00\x00\x00\x42\xcd\xcc\x2c\x3f"),
	SociedadNet =	("\x00\x00\x85\x3f\xcd\xcc\x49\x3f\x00\x00\x55\x3f\x00\x00\x60\x44\x00\x00\x50\x41"),
	SevillaNet =	("\xc2\xf5\x7c\x3f\xcd\xcc\x5c\x3f\xcd\xcc\x5c\x3f\x00\x00\x50\x43\x00\x00\x80\x40"),
	ValenciaNet =	("\x00\x00\x80\x3f\x40\x0f\x44\x3f\x00\x00\x80\x3f\x00\x00\x40\x43\x00\x00\x50\x41\xcd\xcc\x2c\x3f"),
	VillarealNet =	("\x66\x66\x86\x3f\x40\x0f\x44\x3f\x40\x0f\x44\x3f\x00\x00\x50\x43\x00\x00\x80\x40"),
	RayoNet  = 		("\xf5\x28\x85\x3f\x33\x33\x45\x3f\xcd\xcc\x52\x3f\x00\x00\xcc\x43\x00\x00\x80\x41"),
	MadridNet =     ("\x66\x66\x86\x3f\x9a\x99\x19\x3f\x33\x33\x33\x3f\x00\x00\xcc\x43\x00\x00\xcc\x41"),
	OviedoNet = 	("\x00\x00\x75\x3f\xcd\xcc\x55\x3f\x00\x00\x80\x3f\x00\x00\xc8\x42\x00\x00\x00\x41"),


-- SPAIN / LaLiga 2 (Segunda División)
	TenerifeNet =   ("\x66\x66\x66\x3f\xcd\xcc\x4c\x3f\x66\x66\x66\x3f\x00\x00\xc8\x42"),
	ZaragozaNet =   ("\x9a\x89\x99\x3f\x9a\x99\x19\x3e\x00\x00\x00\x3f\x00\x00\xc8\x44\x00\x00\x20\x42"),
	LeganesNet =    ("\x3d\x0a\x81\x3f\x00\x00\x00\x3f\xc3\xf5\x41\x3f\x00\x00\x00\x43\x00\x00\x50\x42\xcd\xcc\x2c\x3f"),
	GijonNet =      ("\x66\x66\x86\x3f\xcd\xcc\x8c\x3f\xcd\xcc\x2c\x3f\x00\x00\x16\x43\x00\x00\x20\x41"),

-- FRANCE / Ligue 1
	RennesNet = 	 ("\x3d\x0a\x82\x3f\xcd\xcc\x47\x3f\xb8\x1e\x65\x3f\x00\x00\x00\x45\x00\x00\x99\x41"),
	MarseilleNet = 	 ("\x7b\x14\x82\x3f\xcd\xcc\x4c\x3f\xcd\xcc\x4c\x3f\x00\x00\xcc\x43"),
	PSGNet = 	 	 ("\xc2\xf5\x80\x3f\x7b\x14\x52\x3f\x0a\xd7\x65\x3f\x00\x00\xc8\x44\x00\x00\x70\x41"),
	StEtienneNet = 	 ("\x5c\x8f\x70\x3f\xcd\xcc\x4c\x3f\x9a\x99\x60\x3f\x00\x00\x16\x43"),
	ReimsNet = 		 ("\xb8\x1e\x83\x3f\x7b\x14\x52\x3f\x40\x0f\x44\x3f\x00\x00\x7a\x44\x00\x00\x20\x42"),
	LyonNet =   	 ("\x48\xe1\x78\x3f\x0a\xd7\x75\x3f\x00\x00\x30\x3f\x00\x00\x96\x43"),
	NantesNet = 	 ("\x5c\x8f\x70\x3f\xcd\xcc\x5c\x3f\x33\x33\x33\x3f\x00\x00\xc8\x42"),
	NiceNet =   	 ("\x66\x66\x66\x3f\xcd\xcc\x5c\x3f\x40\x0f\x44\x3f\x00\x00\xc8\x42"),
	LensNet = 		 ("\x00\x00\x80\x3f\xcd\xcc\x4c\x3f\x9a\x99\x45\x3f\x00\x00\xc8\x42\x00\x00\x50\x41"),
	LilleNet = 		 ("\x00\x00\x71\x3f\xcd\xcc\x52\x3f\x00\x00\x55\x3f\x00\x00\xc8\x42\x00\x00\x20\x41"),
	ToulouseNet =    ("\xcd\xcc\x4c\x3f\x0a\xd7\x5e\x3f\xc2\xf5\x7c\x3f\x00\x00\xc8\x42\x00\x00\x70\x41"),
-- FRANCE / Ligue 2
	TroyesNet =      ("\x1e\x85\x6e\x3f\xcd\xcc\x4c\x3f\x66\x66\x66\x3f\x00\x00\xcc\x43\x00\x00\x20\x41"),

-- ITALY / Serie A
	SanSiro = 		 ("\x00\x00\x84\x3f\x9a\x99\x19\x3f\x9a\x99\x23\x3f\x00\x00\x7a\x43\x00\x00\x88\x41"),
	AtalantaNet = 	 ("\xb8\x1e\x83\x3f\x66\x66\x30\x3f\x66\x66\x86\x3f\x00\x00\x48\x43\xcd\xcc\x40\x41"),
	BolognaNet = 	 ("\x7b\x14\x82\x3f\xcd\xcc\x2c\x3f\xb8\x1e\x70\x3f\x00\x00\x80\x43\x00\x00\x20\x41\xcd\xcc\x2c\x3f"),
	CagliariNet = 	 ("\xe1\x7a\x6b\x3f\xcd\xcc\x2c\x3f\x66\x66\xa6\x3f\x00\x00\x16\x43\x00\x00\x20\x42\xcd\xcc\x2c\x3f"),
	ComoNet = 		 ("\xf5\x28\x83\x3f\x33\x33\x33\x3f\xcd\xcc\x65\x3f\x00\x00\x80\x43\x00\x00\x80\x41"),
	EmpoliNet = 	 ("\x7b\x14\x82\x3f\xcd\xcc\x4c\x3f\xcd\xcc\x4c\x3f\x00\x00\x16\x43\x00\x00\x20\x41"),
	FiorentinaNet =  ("\x00\x00\x80\x3f\xcd\xcc\x10\x3f\x00\x00\x6a\x3f\x00\x00\x90\x43\x00\x00\x00\x41"),
	MarassiNet = 	 ("\x7b\x14\x82\x3f\xcd\xcc\x2c\x3f\xe1\x7a\xa8\x3f\x00\x00\x16\x43\x00\x00\x90\x41\xcd\xcc\x2c\x3f"),
	VeronaNet = 	 ("\x7b\x14\x82\x3f\xcd\xcc\x4c\x3f\xcd\xcc\x4c\x3f\x00\x00\x16\x42\x00\x00\x20\x41"),
	JuveNet = 	 	 ("\x00\x00\x83\x3f\x00\x00\xaa\x3d\x00\x00\x55\x3f\x00\x00\x30\x43\xcd\xcc\xbb\x41"),
	MonzaNet = 	 	 ("\x00\x00\x77\x3f\xcd\xcc\x20\x3f\x00\x00\x6a\x3f\x00\x00\x99\x42\x00\x00\x80\x41"),
	NapoliNet = 	 ("\x48\xe1\x78\x3f\x00\x00\x73\x3f\x00\x00\x40\x3f\x00\x00\x20\x42\x00\x00\x00\x40\xcd\xcc\x2c\x3f"),
	ParmaNet = 	     ("\x85\xeb\x7a\x3f\x9a\x99\x00\x3f\x00\x00\x80\x3f\x00\x00\x00\x44\x00\x00\x80\x43"),
	TorinoNet = 	 ("\x1e\x85\x79\x3f\xcd\xcc\x60\x3f\xaf\x47\xaa\x3f\x00\x00\x90\x41\x00\x00\x00\x40"),
	LecceNet = 		 ("\x66\x66\x66\x3f\x00\x00\x40\x3f\xec\x51\xa2\x3f\x00\x00\x96\x43"),
	UdineNet = 		 ("\x00\x00\x7e\x3f\xcd\xcc\x4a\x3f\x00\x00\x83\x3f\x00\x00\x50\x43\x00\x00\x99\x41"),
	VeneziaNet = 	 ("\xb8\x1e\x83\x3f\xcd\xcc\x4c\x3f\x9a\x99\x99\x3f\x00\x00\x48\x44\xcd\xcc\x20\x41\x00\x00\x00\x40"),
	OlimpicoNet =    ("\x66\x66\x86\x3f\xc3\xf5\x42\x3f\xcd\xcc\x5c\x3f\x00\x00\xff\x44\x00\x00\x80\x41"),
	OlimpicoNet2 =   ("\x68\x64\x88\x3f\x9a\x98\x1B\x3f\x1f\x85\x3e\x3f\x00\x00\xfa\x43\x00\x00\x22\x41"),
	SassuoloNet =    ("\xf5\x28\x7d\x3f\x33\x33\x55\x3f\xcd\xcc\x90\x3f\x00\x00\x80\x44\x00\x00\x00\x41"),

-- ITALY / Serie B
	BariNet = 		("\x00\x00\x80\x3f\xcd\xcc\x5c\x3f\x66\x66\x66\x3f\x00\x00\xc8\x42"),
	BresciaNet = 	("\x00\x00\x80\x3f\xcd\xcc\x4c\x3f\x1e\x85\x6e\x3f\x00\x00\xc8\x42\x00\x00\x50\x41"),
	PisaNet =		("\xf5\x28\x84\x3f\x33\x33\x33\x3f\xcd\xcc\x4c\x3f\x00\x00\xcc\x43\x00\x00\x50\x41"),
	PalermoNet =    ("\x00\x00\x74\x3f\xcd\xcc\x3c\x3f\x00\x00\xac\x3f\x00\x00\xc8\x43\x00\x00\x20\x41"),

-- GERMANY / Bundesliga
	AugsburgNet = 	("\x3d\x0a\x81\x3f\x66\x66\xe6\x3e\x66\x66\x66\x3f\x00\x00\xc8\x43\x00\x00\x99\x41\xcd\xcc\x2c\x3f"),
	LeverkusenNet = ("\x85\xeb\x7a\x3f\xcd\xcc\x0c\x3f\x66\x66\x66\x3f\x00\x00\xc8\x43\x00\x00\x00\x40\xcd\xcc\x2c\x3f"),
	BayernNet = 	("\x00\x00\x80\x3f\xa4\x70\x3b\x3f\x00\x00\x80\x3f\x00\x00\xc8\x43\x00\x00\x20\x41"),
	DortmundNet =	("\x3d\x0a\x81\x3f\xcd\xcc\x2c\x3f\x66\x66\x86\x3f\x00\x00\x45\x43\xcd\xcc\x60\x41\x00\x00\x00\x40"),
	GladbachNet = 	("\x10\x10\x7c\x3f\xbc\xbc\x3f\x3f\x9a\x99\x25\x3f\x00\x00\x30\x43\x00\x00\x60\x41"),
	StPauliNet = 	("\x3d\x0a\x81\x3f\x9a\x99\x19\x3f\xf5\x28\x84\x3f\x00\x00\x70\x43\xcd\xcc\x40\x41\xcd\xcc\x2c\x3f"),
	FreiburgNet = 	("\xc2\xf5\x7c\x3f\xbc\xbc\x3f\x3f\x1e\x85\x6e\x3f\x00\x00\xc9\x43\x00\x00\x28\x41\xcd\xcc\x2c\x3f"),
	HeidenheimNet = ("\x5c\x8f\x70\x3f\xcd\xcc\x5c\x3f\xcd\xcc\x8c\x3f\x00\x00\xc9\x43\x00\x00\x00\x40\xcd\xcc\x2c\x3f"),
	HoffenheimNet = ("\x48\xe1\x78\x3f\xcd\xcc\x4c\x3f\x9a\x99\x19\x3f\x00\x00\xc8\x42\x00\x00\x40\x41"),
	KielNet = 	 	("\x48\xe1\x78\x3f\xcd\xcc\x4c\x3f\x48\xe1\x78\x3f\x00\x00\xc8\x42\x00\x00\x20\x41"),
	MainzNet = 	 	("\x5c\x8f\x70\x3f\xcd\xcc\x4c\x3f\xe1\x7a\x88\x3f\x00\x00\x20\x43\x00\x00\x20\x41"),
	FrankfurtNet = 	("\x0a\xd7\x75\x3f\xcd\xcc\x0c\x3f\xc2\xf5\x7c\x3f\x00\x00\x20\x43\x00\x00\x20\x41\xcd\xcc\x2c\x3f"),
	StuttgartNet =	("\x00\x00\x7c\x3f\xcd\xcc\x42\x3f\x00\x00\x80\x3f\x00\x00\x40\x43\x00\x00\x60\x41"),
	WolfsburgNet = 	("\x00\x00\x79\x3f\xcd\xcc\x15\x3f\x00\x00\x80\x3f\x00\x00\x40\x43\x00\x00\x60\x41"),
	WerderNet = 	("\x85\xeb\x7a\x3f\xcd\xcc\x4c\x3f\x00\x00\x80\x3f\x00\x00\xc8\x43\x00\x00\x20\x41"),
	LeipzigNet = 	("\x00\x00\x80\x3f\xcd\xcc\x39\x3f\x00\x00\x80\x3f\x00\x00\x40\x43\x00\x00\x60\x41"),
	
-- GERMANY / Bundesliga	2
	SchalkeNet =    ("\x00\x00\x87\x3f\xcd\xcc\x3f\x3f\x9a\x90\x40\x3f\x00\x00\x00\x43\x00\x00\x20\x41"),
	KaiserslauternNet =    ("\x00\x00\x77\x3f\xcd\xcc\x30\x3f\x9a\x80\x40\x3f\x00\x00\x00\x43\x00\x00\x20\x41"),
	TSVNet = 		("\x00\x00\x80\x3f\xa4\x70\x3b\x3f\x00\x00\x80\x3f\x00\x00\xc8\x43\x00\x00\x20\x41"),
    HerthaNet = 	("\x00\x00\x7b\x3f\x66\x66\x56\x3f\x00\x00\x65\x3f\x00\x00\x48\x43\x00\x00\x20\x40"),
	HannoverNet = 	("\x00\x00\x7a\x3f\xcd\xcc\x60\x3f\x00\x00\x80\x3f\x00\x00\xc8\x42\x00\x00\x20\x41"),
	NurnbergNet = 	("\xf5\x28\x81\x3f\x33\x33\x33\x3f\xcd\xcc\x65\x3f\x00\x00\xcc\x43\x00\x00\x50\x41"),
	GreutherNet = 	("\xf5\x28\x81\x3f\x33\x33\x33\x3f\xcd\xcc\x50\x3f\x00\x00\xcc\x43\x00\x00\x50\x41"),
	KarlsruherNet = ("\xf5\x28\x81\x3f\x33\x33\x45\x3f\xcd\xcc\x80\x3f\x00\x00\xcc\x43\x00\x00\x50\x41"),
	DresdenNet = 	("\x9a\x89\x89\x3f\x00\x00\x00\x3e\x9a\x80\x40\x3f\x00\x00\x90\x44\x00\x00\x20\x42"),
	HansaNet = 		("\x00\x00\x7a\x3f\xcd\xcc\x60\x3f\x00\x00\x80\x3f\x00\x00\x20\x43\x00\x00\x20\x41"),
	
-- NETHERLANDS / Eredivisie
	AjaxNet = 		("\xc2\xf5\x7c\x3f\x66\x66\x66\x3f\xe1\x7a\x88\x3f\x00\x00\x48\x43\x00\x00\x00\x40"),
	FeyenoordNet = 	("\x5c\x8f\x70\x3f\xcd\xcc\x5c\x3f\x00\x00\x80\x3f\x00\x00\xc8\x43\x00\x00\x20\x41"),
	PSVNet = 		("\x85\xeb\x7a\x3f\xc3\xf5\x56\x3f\x85\xeb\x7a\x3f\x00\x00\x96\x43\x00\x00\x20\x41"),
	AzNet = 		("\x48\xe1\x78\x3f\xcd\xcc\x4c\x3f\x00\x00\x80\x3f\x00\x00\x00\x42\x00\x00\x20\x41"),
	HeerenvenNet = 	("\x00\x00\x60\x3f\xcd\xcc\x4c\x3f\xb8\x1e\x83\x3f\x00\x00\xc8\x42\x00\x00\x20\x41"),
	SpartaRNet =	("\x7b\x14\x82\x3f\xcd\xcc\xcc\x3d\xcd\xcc\x5c\x3f\x00\x00\x00\x43\x00\x00\xc9\x41"),
	BredaNet = 		("\x5c\x8f\x70\x3f\xcd\xcc\x5c\x3f\x00\x00\x80\x3f\x00\x00\xc8\x43\x00\x00\xcc\x41"),
	NECNet = 		("\x66\x66\x66\x3f\xcd\xcc\x5c\x3f\x00\x00\x80\x3f\x00\x00\xc8\x42\x00\x00\x99\x41"),
	TwenteNet =		("\x10\x10\x86\x3f\xcd\xcc\x50\x3f\x85\xeb\x69\x3f\x00\x00\x60\x44\x00\x00\xcc\x41"),
	UtrechtNet =	("\x5c\x8f\x70\x3f\xc2\xf5\x7c\x3f\x7b\x14\x82\x3f\x00\x00\x40\x44\x00\x00\x20\x41"),
	RKCNet = 		("\x10\x10\x85\x3f\xcd\xcc\xcc\x3e\x66\x66\x66\x3f\x00\x00\x20\x42\x00\x00\x28\x42"),
	ZwolleNet =		("\x7b\x14\x82\x3f\x5c\x8f\x70\x3f\xcd\xcc\x7c\x3f\x00\x00\xc8\x44\x00\x00\x20\x41"),
	SittardNet =	("\x5c\x8f\x70\x3f\xcd\xcc\x5c\x3f\x9a\x99\x99\x3f\x00\x00\x40\x44\x00\x00\x80\x40"),
	EaglesNet =		("\x5c\x8f\x70\x3f\x66\x66\x66\x3f\x9a\x99\x99\x3f\x00\x00\x40\x44\x00\x00\x80\x40"),
	VolendamNet =    ("\x00\x00\x77\x3f\xcd\xcc\x30\x3f\x9a\x80\x40\x3f\x00\x00\x00\x43\x00\x00\x20\x41"),

-- SWITZERLAND / Super League
	BaselNet = 		("\x00\x00\x81\x3f\x33\x33\x33\x3f\x7b\x14\x82\x3f\x00\x00\xcc\x45\x00\x00\x20\x41"),
	ZurichNet = 	("\x1e\x85\x6e\x3f\xcd\xcc\x4c\x3f\x00\x00\x80\x3f\x00\x00\xc8\x42\x00\x00\x20\x41"),
	LuganoNet = 	("\x48\xe1\x78\x3f\xcd\xcc\x4c\x3f\xcd\xcc\x4c\x3f\x00\x00\xc8\x42\x00\x00\x20\x41"),
	LausanneNet = 	("\x00\x00\x80\x3f\x00\x00\x40\x3f\xcd\xcc\x5c\x3f\x00\x00\xc8\x42\x00\x00\x20\x41"),
	LuzernNet = 	("\xb8\x1e\x83\x3f\x00\x00\x40\x3f\x66\x66\x66\x3f\x00\x00\xc8\x42\x00\x00\x20\x41"),
	ServetteNet = 	("\xcd\xcc\x7c\x3f\xcd\xcc\x4c\x3f\x00\x00\x80\x3f\x00\x00\xc8\x43\x00\x00\x20\x41"),
	SionNet = 		("\xcd\xcc\x7c\x3f\xcd\xcc\x4c\x3f\x9a\x99\x99\x3f\x00\x00\xc8\x43\x00\x00\x20\x41"),
	St_GallenNet = 	("\xcd\xcc\x5c\x3f\xcd\xcc\x4c\x3f\x00\x00\xc0\x3f\x00\x00\xc8\x43\x00\x00\x20\x41"),

-- PORTUGAL / Liga Portugal
	SportingNet =    ("\x00\x00\x77\x3f\xcd\xcc\x30\x3f\x9a\x80\x40\x3f\x00\x00\x00\x43\x00\x00\x20\x41"),
	PortoNet = 	 ("\xb8\x1e\x78\x3f\x40\x0f\x44\x3f\xcd\xcc\x0c\x3f\x00\x00\x7a\x43\x00\x00\x50\x41\x00\x00\xa0\x40"),
	BenficaNet =  ("\xb8\x1e\x83\x3f\x40\x0f\x44\x3f\xcd\xcc\x0c\x3f\x00\x00\x7a\x43\x00\x00\x50\x41\x00\x00\xa0\x40"),
	BragaNet =    ("\x00\x00\x76\x3f\xbc\xbc\x22\x3f\x00\x00\x48\x3f\x00\x00\xc8\x43\x00\x00\x30\x42"),
	AroucaNet =   ("\x00\x00\x78\x3f\xcd\xcc\x20\x3f\x00\x00\x80\x3f\x00\x00\x30\x43\x00\x00\x20\x42"),
	AVSNet =      ("\x00\x00\x58\x3f\xcd\xcc\x4c\x3f\x00\x00\x20\x40\x00\x00\xcc\x42\x00\x00\x20\x41"),
	PiaNet = 		 ("\x00\x00\x75\x3f\xcd\xcc\x30\x3f\x00\x00\x80\x3f\x00\x00\xc8\x42\x00\x00\x20\x41"),

-- PORTUGAL / Liga Portugal 2
	NacionalNet = ("\x00\x00\x60\x3f\xcd\xcc\x80\x3f\x00\x00\x80\x3f\x00\x00\xc8\x42\x00\x00\x90\x41"),

-- BELGIUM / Pro League
	AnderlechtNet = ("\xc2\xf5\x7c\x3f\xcd\xcc\x4c\x3f\x00\x00\x00\x3f\x00\x00\x30\x42\x00\x00\x20\x41"),
	BruggeNet =     ("\x68\x64\x88\x3f\x9a\x98\x40\x3f\x31\x35\x31\x3f\x00\x00\xe3\x43\x00\x00\x22\x41"),
	AntwerpNet =	   ("\x66\x66\x66\x3f\xcd\xcc\x4c\x3f\x66\x66\x66\x3f\x00\x00\x80\x43\x00\x00\x20\x41"),
	GenkNet = 	   ("\xcd\xcc\x5c\x3f\xcd\xcc\x4c\x3f\xcd\xcc\x7c\x3f\x00\x00\x80\x43\x00\x00\x20\x41"),
	CharleroiNet = ("\xb8\x1e\x83\x3f\xcd\xcc\x4c\x3f\x66\x66\x86\x3f\x00\x00\x99\x43\xcd\xcc\x20\x41"),

-- TURKEY / Süper Lig
	TrabzonNet = 	   ("\x00\x00\x80\x3f\x9a\x99\x19\x3f\x7b\x14\x82\x3f\x00\x00\xc8\x42\x00\x00\x20\x41"),
	BesiktasNet = 	   ("\x66\x66\x86\x3f\xcd\xcc\x4c\x3f\xcd\xcc\x8c\x3f\x00\x00\xcc\x43\x00\x00\x20\x41"),
	SivassporNet = 	   ("\xcd\xcc\x7c\x3f\x0c\xd9\xa3\x3d\xec\x51\xb7\x3f\x00\x00\xc6\x43\xcd\xcc\x20\x41\x00\x00\x80\x3f\x00\x00\x79\x35"),
	AntalyasporNet =   ("\x0a\xd7\x75\x3f\xcd\xcc\x5c\x3f\x0a\xd7\xae\x3f\x00\x00\x20\x43\x00\x00\x20\x41"),
	BasaksehirNet =	   ("\x1e\x85\x6e\x3f\xcd\xcc\x4c\x3f\x9a\x99\xb9\x3f\x00\x00\x20\x43\x00\x00\x20\x41"),
	KayserisporNet =   ("\x5c\x8f\x70\x3f\x66\x66\x66\x3f\xb8\x1e\x83\x3f\x00\x00\xc8\x42\x00\x00\x20\x41"),
	KasimpasaNet = 	   ("\x85\xeb\x7a\x3f\xcd\xcc\x4c\x3f\xc2\xf5\x91\x3f\x00\x00\xc8\x42\x00\x00\x20\x41"),
	AlanyasporNet =	   ("\xcd\xcc\x2c\x3f\xcd\xcc\x4c\x3f\x33\x33\xb3\x3f\x00\x00\x10\x43\x00\x00\x20\x41"),
	KonyasporNet = 	   ("\x00\x00\x60\x3f\xcd\xcc\x4c\x3f\x0a\xd7\xae\x3f\x00\x00\xc8\x42\x00\x00\x20\x40"),
	AdanaNet = 	 	   ("\xcd\xcc\x5c\x3f\xcd\xcc\x4c\x3f\xec\x51\xb7\x3f\x00\x00\x80\x42\x00\x00\x20\x41"),
	RizesporNet = 	   ("\x9a\x89\x89\x3f\xcd\xcc\x2c\x3f\x9a\x99\x19\x3f\x00\x00\x50\x44\x00\x00\x20\x41"),
	GaziantepNet = 	   ("\xe1\x7a\x88\x3f\xcd\xcc\x4c\x3f\xcd\xcc\x5c\x3f\x00\x00\x60\x43\x00\x00\x20\x41"),
	SamsunsporNet =	   ("\x00\x00\x80\x3f\xcd\xcc\x4c\x3f\x00\x00\x80\x3f\x00\x00\xc8\x42\x00\x00\x20\x41"),
	HataysporNet = 	   ("\x33\x33\x33\x3f\xcd\xcc\x0c\x3f\x00\x00\x80\x3f\x00\x00\x70\x42\x00\x00\x20\x41"),
	GoztepeNet = 	   ("\xe1\x7a\x54\x3f\x33\x33\xb3\x3e\x00\x00\xc0\x3f\x00\x00\xf0\x41\x00\x00\xa0\x40"),
	BodrumNet = 	   ("\x00\x00\x60\x3f\xcd\xcc\x4c\x3f\x00\x00\x00\x40\x00\x00\x80\x44\x00\x00\x50\x41"),

-- DENMARK / 3F Superliga
	CopenhagenNet =	 ("\x00\x00\x80\x3f\x00\x00\x00\x3f\x66\x66\x66\x3f\x00\x00\xc8\x42\x00\x00\x20\x41"),
	BrondbyNet =	 ("\x66\x66\x66\x3f\x00\x00\x00\x3f\x9a\x99\x99\x3f\x00\x00\x50\x41\x00\x00\xa0\x40"),
	AalborgNet =	 ("\x66\x66\x66\x3f\x00\x00\x00\x3f\xcd\xcc\x4c\x3f\x00\x00\x80\x41\x00\x00\x20\x41"),
	ViborgNet =		 ("\x48\xe1\x78\x3f\xcd\xcc\x4c\x3f\xcd\xcc\x7c\x3f\x00\x00\xc8\x43\x00\x00\x20\x41"),
	MidtjyllandNet = ("\xe1\x7a\x6b\x3f\xcd\xcc\x4c\x3f\x66\x66\xa6\x3f\x00\x00\xc8\x43"),
	SonderjyskeNet = ("\xe1\x7a\x6b\x3f\xcd\xcc\x4c\x3f\x66\x66\xa6\x3f\x00\x00\xc8\x43"),
	SilkeborgNet = 	 ("\xe1\x7a\x6b\x3f\x66\x66\x0c\x3f\x0a\xd7\x8c\x3f\x00\x00\xc8\x42\xcd\xcc\x20\x41"),
	LyngbyNet = 	 ("\x85\xeb\x7a\x3f\xcd\xcc\x4c\x3f\x66\x66\x66\x3f\x00\x00\x80\x43"),
	RandersNet = 	 ("\xc2\xf5\x7c\x3f\xcd\xcc\x5c\x3f\x9a\x99\x25\x3f\x00\x00\xaa\x43\x00\x00\x28\x41"),
	NordsjællandNet =("\xe1\x7a\x54\x3f\xcd\xcc\x4c\x3f\x00\x00\xc0\x3f\x00\x00\xc8\x42\x00\x00\xa0\x40"),
	VejleNet = 	 	 ("\xa4\x70\x87\x3f\xcd\xcc\x4c\x3f\x33\x33\x33\x3f\x00\x00\x60\x43"),

-- CROATIA / HNL
	HajdukNet = 	("\x1e\x85\x70\x3f\xcd\xcc\x6a\x3f\x33\x33\xaa\x3f\x00\x00\xc8\x43\x00\x00\x20\x41"),
	RijekaNet = 	("\x1e\x85\x6e\x3f\xcd\xcc\x4c\x3f\x33\x33\x33\x3f\x00\x00\xc8\x43\x00\x00\x20\x41"),

-- BULGARIA / First League
	LudogoretsNet = ("\x00\x00\x84\x3f\xcd\xcc\x4c\x3f\x00\x00\x45\x3f\x00\x00\x50\x43\x00\x00\x20\x41"),

-- SERBIA / SuperLiga
	PartizanNet = 	("\xe1\x7a\x88\x3f\xcd\xcc\x4c\x3f\xcd\xcc\x5c\x3f\x00\x00\x30\x43\x00\x00\x20\x41"),
	Red_StarNet = 	("\x00\x00\x75\x3f\xcd\xcc\x5c\x3f\x00\x00\x80\x3f\x00\x00\xc8\x44\x00\x00\x20\x41"),

-- RUSSIA / Premier League
	Dinamo_MoscowNet = ("\xe1\x7a\x88\x3f\xcd\xcc\x4c\x3e\x33\x33\x33\x3f\x00\x00\xc8\x42\x00\x00\x20\x41"),
	RubinNet = 		   ("\x5c\x8f\x8b\x3f\xcd\xcc\x4c\x3f\x9a\x99\x19\x3f\x00\x00\x20\x43\x00\x00\x20\x41"),

-- GREECE / Super League
	PAOKNet = 		("\x00\x00\x87\x3f\x00\x00\x00\x3f\x00\x00\x00\x3f\x00\x00\x20\x43\x00\x00\x50\x41"),
	AEKNet = 		("\x00\x00\x77\x3f\xcd\xcc\x4c\x3f\x00\x00\x70\x3f\x00\x00\x30\x43\x00\x00\x00\x41"),

-- CYPRUS / Super League	
	APOELNet =  	("\x00\x00\x85\x3f\xcd\xcc\x4c\x3f\x00\x00\x10\x3f\x00\x00\xc8\x42\x00\x00\x20\x41"),
	PafosNet = 		("\x00\x00\x73\x3f\xcd\xcc\x4c\x3f\x00\x00\x80\x3f\x00\x00\xcc\x43\x00\x00\x20\x41"),
-- AUSTRIA / Bundesliga
	SalzburgNet = 	("\x00\x00\x80\x3f\xa4\x70\x3b\x3f\x00\x00\x85\x3f\x00\x00\xc8\x43\x00\x00\x20\x41"),
	RapidNet = 	 	("\x00\x00\x75\x3f\xcd\xcc\x10\x3f\x00\x00\x80\x3f\x00\x00\x10\x43\x00\x00\x50\x41"),
	
-- HUNGARY
	FerencvarosNet = ("\xb8\x1e\x83\x3f\xcd\xcc\x4c\x3f\x66\x66\x86\x3f\x00\x00\x48\x43\xcd\xcc\x00\x41\x00\x00\x00\x40"),

-- AZERBAIJAN / Premier League
	QarabagNet = 	("\x10\x10\x78\x3f\xbc\xbc\x3f\x3f\x9a\x99\x45\x3f\x00\x00\xcc\x42\x00\x00\x28\x41"),

-- JAPAN / J1 League
	KashimaNet = 	("\xcd\xcc\x8c\x3f\xcd\xcc\x9c\x3e\xcd\xcc\x5c\x3f\x00\x00\xc8\x43\x00\x00\x00\x41"),
	NiigataNet = 	("\x9a\x99\x95\x3f\x33\x33\x40\x3f\x9a\x99\x30\x3f\x00\x00\x20\x45\x00\x00\xb9\x41"),

-- ARGENTINA / Primera División
	TucumanNet = 	 ("\x00\x00\x75\x3f\x00\x00\x4c\x3f\x00\x00\xaa\x3f\x00\x00\xc8\x43\x00\x00\x80\x42"),
	BanfieldNet = 	 ("\x66\x66\x86\x3f\x9a\x99\x19\x3f\x33\x33\x33\x3f\x00\x00\x30\x44"),
	BarracasNet = 	 ("\x00\x00\x7e\x3f\x0c\xd9\xa3\x3d\x0a\xd5\xa7\x3f\x00\x00\xc6\x42\xcd\xcc\x20\x41\x00\x00\x80\x3f\x00\x00\x79\x35"),
	BelgranoNet = 	 ("\x3d\x0a\x81\x3f\xcd\xcc\x4c\x3f\x1e\x85\x6e\x3f\x00\x00\x40\x43\x00\x00\x20\x41"),
	RiverNet =       ("\x00\x00\x87\x3f\xcd\xcc\x10\x3f\x00\x00\x20\x3f\x00\x00\xcc\x42\x00\x00\x20\x41"),
	VelezNet =       ("\x00\x00\x82\x3f\xcd\xcc\x3f\x3f\x00\x00\x7c\x3f\x00\x00\xc8\x43\x00\x00\x20\x41"),
	BocaNet = 	     ("\x00\x00\x80\x3f\xcd\xcc\x48\x3f\x00\x00\x80\x3f\x00\x00\xc8\x44\x00\x00\x20\x41"),	
	LanusNet = 	 	 ("\x00\x00\x82\x3f\xcd\xcc\x65\x3f\x00\x00\x60\x3f\x00\x00\xc8\x43\x00\x00\x00\x41"),
	InstitutoNet = 	 ("\x00\x00\x60\x3f\xcd\xcc\x3c\x3f\x00\x00\x10\x3f\x00\x00\xcc\x43\x00\x00\x20\x41"),
	NewellsNet = 	 ("\x00\x00\x80\x3f\xcd\xcc\x20\x3f\x00\x00\xbb\x3f\x00\x00\xc8\x42\x00\x00\x00\x41"),
	RacingNet = 	 ("\x00\x00\x7c\x3f\xcd\xcc\x35\x3f\x00\x00\x75\x3f\x00\x00\xc8\x43\x00\x00\x90\x40"),
	
-- BRAZIL / Série A
	PalmeirasNet = 	("\x66\x66\x86\x3f\x9a\x99\x19\x3f\x33\x33\x33\x3f\x00\x00\x00\x44\x00\x00\x20\x41"),
	BragantinoNet =	("\xb8\x1e\x83\x3f\xcd\xcc\x4c\x3f\x00\x00\x80\x3f\x00\x00\xc8\x42\x00\x00\x20\x41"),
	CorinthiansNet =  ("\x10\x10\x7c\x3f\xbc\xbc\x3f\x3f\x9a\x99\x30\x3f\x00\x00\x50\x43\x00\x00\x28\x41"),

-- ITALY / National Stadium – ROME (Olimpico) variants
	OlimpicoBounce = ("\x00\x00\x90\x3f\xce\xcd\x4d\x3f\x00\x00\x70\x3f\x00\x00\xa0\x42\x00\x00\x25\x41"),
	OlimpicoFirm =   ("\x00\x00\x70\x3f\xcc\xcb\x4b\x3f\x00\x00\x60\x3f\x00\x00\x90\x42\x00\x00\x15\x41"),
	OlimpicoFast =   ("\x00\x00\x85\x3f\xcd\xcc\x4c\x3f\x00\x00\x75\x3f\x00\x00\xa5\x42\x00\x00\x22\x41"),
	OlimpicoTighter =("\x00\x00\x75\x3f\xcb\xca\x4a\x3f\x00\x00\x65\x3f\x00\x00\x95\x42\x00\x00\x18\x41"),


-- SPAIN / Historic & Classics (see also global Classics below)
	Liverpool2014 =	("\x7b\x14\x82\x3f\xcd\xcc\x5c\x3f\xcd\xcc\x4c\x3f\x00\x00\xcc\x43"),
	City2014 = 	 	("\x5c\x8f\x8b\x3f\xcd\xcc\x5c\x3f\x9a\x99\x19\x3f\x00\x00\xb1\x43"),
	Newcastle2012 =	("\xf5\x28\x84\x3f\xcd\xcc\x5c\x3f\xcd\xcc\x4c\x3f\x00\x00\xcc\x43"),
	Chelsea2005 = 	("\xb8\x1e\x83\x3f\xcd\xcc\x4c\x3f\xcd\xcc\x4c\x3f\x00\x00\x40\x43\x00\x00\x20\x41"),
	Dortmund2005 = 	("\xcd\xcc\x5c\x3f\xcd\xcc\x4c\x3f\x66\x66\x66\x3f\x00\x00\x60\x42\x00\x00\x20\x41"),

-- ITALY / Misc (long-form Villa preset for testing/visuals)
	VillaNet2 = ("\xb8\x1e\x9a\x3f\xcd\xcc\x4c\x3f\x1e\x85\x00\x3f\x00\x00\x10\x47\x00\x00\x80\x41\x00\x00\x20\x41\x00\x00\x80\x3f\x17\xb7\xd1\x38\x6f\x12\x83\x3a\x00\x00\x80\x3f\x00\x00\x80\x3f\x00\x00\x80\x3f\x33\x33\x73\x3f\x9a\x99\x99\x3e\xcd\xcc\x0c\x40\x0a\xd7\xa3\x3c\x00\x00\x80\x3f\x00\x00\x00\x40\xcd\xcc\x4c\x3f\xcd\xcc\x4c\x3e\x00\x00\x00\x3f\xcd\xcc\xcc\x3d\xcd\xcc\x4c\x3f\x0a\xd7\xa3\x3c\xcd\xcc\x4c\x3d"),


-- WORLD CUPS / National Team Tournaments
	WC26_Net1 = ("\x10\x10\x85\x3f\xbc\xbc\x3f\x3f\x9a\x99\x25\x3f\x00\x00\xc9\x42\x00\x00\x28\x41"),
	WC26_Net2 = ("\x10\x10\x85\x3f\xbc\xbc\x3f\x3f\x9a\x99\x25\x3f\x00\x00\xc9\x42\x00\x00\x28\x41"),
	WC26_Net3 = ("\x66\x66\x86\x3f\xcd\xcc\xcc\x3d\xcd\xcc\x4c\x3f\x00\x00\xc8\x42\x00\x00\x40\x41"),
	WC26_Net4 = ("\x1e\x85\x6e\x3f\xcd\xcc\xcc\x3d\x0a\xd7\x39\x3f\x00\x00\xc8\x42\x00\x00\x40\x41"),
	WC26_Net5 = ("\xcd\xcc\x7c\x3f\xcd\xcc\x4c\x3f\x66\x66\x66\x3f\x00\x00\x80\x42\x00\x00\x20\x41"),
	WC26_Net7 = ("\x66\x66\x86\x3f\x33\x33\x33\x3f\x66\x66\x66\x3f\x00\x00\x50\x43\x00\x00\x20\x41"),
	WC26_Net8 = ("\x0a\xd7\x75\x3f\xcd\xcc\xcc\x3e\x0a\xd5\xa7\x3f\x00\x00\x25\x43\xcd\xcc\x00\x42"),

-- STADIUM-SPECIFIC 
	WembleyNet = 	 ("\x9a\x99\x99\x3f\xcd\xcc\x4c\x3f\x9a\x99\x19\x3f\x00\x00\x90\x43\x00\x00\x20\x41"),
	HampdenNet =     ("\x00\x00\x75\x3f\xcd\xcc\x4c\x3f\x00\x00\x90\x3f\x00\x00\x10\x43\x00\x00\x20\x41"),
	SanSiro = 		 ("\x00\x00\x84\x3f\x9a\x99\x19\x3f\x9a\x99\x23\x3f\x00\x00\x7a\x43\x00\x00\x88\x41"),
	MarassiNet = 	 ("\x7b\x14\x82\x3f\xcd\xcc\x2c\x3f\xe1\x7a\xa8\x3f\x00\x00\x16\x43\x00\x00\x90\x41\xcd\xcc\x2c\x3f"),
	OlimpicoNet =    ("\x66\x66\x86\x3f\xc3\xf5\x42\x3f\xcd\xcc\x5c\x3f\x00\x00\xff\x44\x00\x00\x80\x41"),
	OlimpicoNet2 =   ("\x68\x64\x88\x3f\x9a\x98\x1B\x3f\x1f\x85\x3e\x3f\x00\x00\xfa\x43\x00\x00\x22\x41"),


-- CLASSIC NETS (Historic club presets)
	La_Coruna2003 =	 ("\xe1\x7a\x88\x3f\xcd\xcc\x4c\x3f\x00\x00\x40\x3f\x00\x00\x30\x44\x00\x00\x20\x41"),
	Villareal2006 = ("\x5c\x8f\x70\x3f\xcd\xcc\x4c\x3f\x33\x33\xb3\x3f\x00\x00\x99\x42\x00\x00\x20\x41"),
	Liverpool2014 = ("\x7b\x14\x82\x3f\xcd\xcc\x5c\x3f\xcd\xcc\x4c\x3f\x00\x00\xcc\x43"),
	City2014 = 		("\x5c\x8f\x8b\x3f\xcd\xcc\x5c\x3f\x9a\x99\x19\x3f\x00\x00\xb1\x43"),
	Newcastle2012 = ("\xf5\x28\x84\x3f\xcd\xcc\x5c\x3f\xcd\xcc\x4c\x3f\x00\x00\xcc\x43"),
	Chelsea2005 = 	("\xb8\x1e\x83\x3f\xcd\xcc\x4c\x3f\xcd\xcc\x4c\x3f\x00\x00\x40\x43\x00\x00\x20\x41"),
	Dortmund2005 = 	("\xcd\xcc\x5c\x3f\xcd\xcc\x4c\x3f\x66\x66\x66\x3f\x00\x00\x60\x42\x00\x00\x20\x41"),


-- GENERIC / SHAPES & TEST PRESETS (Non-club)
	IntermedNet =	    ("\x56\x56\x93\x3f\x89\x89\x2f\x3f\x66\x66\x6c\x3e\x00\x00\xc8\x42\x00\x00\x30\x41"),
	IntermedNet2 =	    ("\x56\x56\x93\x3f\x89\x89\x2f\x3f\x66\x66\x6c\x3e\x00\x00\xc8\x43\x00\x00\x30\x42"),
	IntermedNet3 =	    ("\x56\x56\x8c\x3f\x89\x89\x2f\x3f\x66\x66\x6c\x3e\x00\x00\xc8\x42\x00\x00\x30\x41"),
	BalancedSquare =    ("\x4d\x44\x89\x3f\x66\x66\x33\x3f\x9a\x80\x40\x3f\x00\x00\xc8\x44\x00\x00\x30\x41"),
	MediumNet = 	    ("\x26\x22\x85\x3f\x36\x6f\xb9\x3e\x55\xae\xa3\x3f\x00\x00\xc7\x43\x66\x66\x28\x41"),
	ImprovedMidDeep =   ("\x10\x10\x85\x3f\xbc\xbc\x3f\x3f\x9a\x99\x25\x3f\x00\x00\xc9\x42\x00\x00\x28\x41"),
	ImprovedMidDeepT =  ("\x10\x10\x85\x3f\xbc\xbc\x3f\x3f\x9a\x99\x25\x3f\x00\x00\xc9\x43\x00\x00\x28\x41"),
	ImprovedReal3 =	    ("\x75\x75\x90\x3f\x10\x10\x30\x3f\x9a\x99\x22\x3f\x00\x00\xc9\x44\x00\x00\x28\x41"),
	StraightTriangle =  ("\x30\x30\x80\x3f\x9a\x99\x4c\x3e\x50\x50\x80\x40\x00\x00\xc8\x44\x00\x00\x30\x41"),
	TightConeNet = 	    ("\x45\x45\x70\x3f\x66\x66\x33\x3e\x20\x20\x90\x3f\x00\x00\xc8\x43\x00\x00\x28\x41"),
	SmallSquare2 =	    ("\x66\x66\x86\x3f\xcd\xcc\x4c\x3e\x00\x00\x80\x3f\x00\x00\xc8\x42\x00\x00\x30\x41"),
	WaveNet = 		    ("\x00\x00\x60\x3f\xcd\xcc\x4c\x3f\x33\x33\x73\x3f\x00\x00\xc8\x44\x00\x00\x28\x41"),
	Napoli = 	 		("\x00\x00\x50\x3f\xcd\xcc\x4c\x3f\x00\x00\x80\x3f\x00\x00\xc8\x41\x00\x00\x20\x41"),
	HexagonalNet =      ("\x68\x64\x88\x3f\x9a\x98\x1B\x3f\x31\x35\x31\x3f\x00\x00\xe3\x43\x00\x00\x22\x41"),
	WideSquare =        ("\x00\x00\x89\x3f\xcd\xcc\x4c\x3f\x9a\x80\x40\x3f\x00\x00\xc8\x45\x00\x00\x20\x41"),
	StandardSquare =    ("\x00\x00\x80\x3f\xcd\xcc\x4c\x3f\x9a\x99\x19\x3f\x00\x00\xc8\x43\x00\x00\x20\x41"),
	TriangleTop =       ("\x00\x00\x80\x3f\x0c\xd9\xa3\x3d\x0a\xd7\x5c\x3f\x00\x00\xc6\x42\xcd\xcc\x20\x41"), 
	TriangleBottomSquare = ("\x00\x00\x80\x3f\x0c\xd9\xa3\x3d\x00\x00\x80\x3f\x00\x00\xc8\x42\x00\x00\x20\x41"), 
	WideTopSquare =     ("\x00\x00\x89\x3f\xcd\xcc\x4c\x3f\x9a\x80\x40\x3f\x00\x00\x02\x43\x00\x00\x20\x41"), 
	CurvedTopDeep =     ("\x00\x00\x80\x3f\x0c\xd9\xa3\x3d\x0a\xd7\x5c\x3f\x00\x00\xc8\x43\x00\x00\x20\x41"), 
	StraightTopDeep =   ("\x00\x00\x80\x3f\xcd\xcc\x4c\x3f\x9a\x99\x19\x3f\x00\x00\xc8\x44\x00\x00\x20\x41"),
	CurvedTopShallow =  ("\x00\x00\x80\x3f\x0c\xd9\xa3\x3d\x0a\xd7\x5c\x3f\x00\x00\xc8\x42\x00\x00\x20\x41"),
	StandardNet =	    ("\x00\x00\x80\x3f\xcd\xcc\x4c\x3f\x00\x00\x80\x3f\x00\x00\xc8\x43\x00\x00\x20\x41"),
	DeepTightNet =      ("\x9a\x99\x9f\x3f\x00\x00\x00\x39\x9a\x99\xd9\x3e\x00\x00\xc8\x44\x00\x00\x20\x42"), 
	NetOriginalTest1 =  ("\x00\x00\x80\x3f\x00\x00\x00\x3f\xcd\xcc\xcc\x3f\x00\x00\xc8\x42\x00\x00\x20\x41"),
	DeepTopCurveNet =   ("\x00\x00\x00\x3f\xcd\xcc\x4c\x3f\x00\x00\x40\x3f\x00\x00\xc8\x42\x00\x00\x20\x41"),
	TightSquareLessMaterialNet = ("\x33\x33\x93\x3f\xcd\xcc\x2c\x3f\x00\x00\x80\x3f\x00\x00\x16\x44\x00\x00\x20\x41"),
	ExtremeCurveNet =   ("\xcd\xcc\x4c\x3e\x00\x00\x00\x3f\x00\x00\x00\x3f\x00\x00\xc8\x42\x00\x00\x20\x41"),
	LoweredDefaultNet = ("\x00\x00\x80\x3f\xcd\xcc\x4c\x3f\x00\x00\x80\x3f\x00\x00\xc8\x42\x00\x00\xf0\x41"),
	NewDeepNet3 =	    ("\x29\x5c\x98\x3f\xcd\xcc\x2c\x3f\xcd\xcc\x0c\x3f\x00\x00\x16\x43\x00\x00\x20\x41\xcd\xcc\x2c\x3f"),
	PerfectSquareH5 =   ("\x66\x66\x86\x3f\x00\x00\x00\x3e\x66\x66\x66\x3f\x00\x00\x7a\x44\x00\x00\x20\x42\xcd\xcc\x2c\x3f"),
	PerfectSmallSquare =("\x66\x66\x86\x3f\x00\x00\x00\x3e\x66\x66\x66\x3f\x00\x00\x7a\x44\x00\x00\x20\x42\xcd\xcc\x2c\x3f"),
	FinalTestNet =      ("\x66\x66\x86\x3f\x9a\x99\x19\x3f\x00\x00\x80\x3f\x00\x00\x7a\x43\x00\x00\x88\x41"),
	UltraDeepNet =      ("\x66\x66\x90\x3f\x9a\x99\x22\x3f\xcd\xcc\x5c\x3f\x00\x00\x20\x45\x00\x00\x20\x42"),
	KindaLiverpool =    ("\x66\x66\x86\x3f\x9a\x99\x19\x3f\xcd\xcc\x5c\x3f\x00\x00\xfa\x44\x00\x00\x20\x42"),
	SmallNet9 =         ("\x66\x66\x86\x3f\x0c\xd9\xa3\x3d\x0a\xd5\xa7\x3f\x00\x00\xc8\x42\xcd\xcc\x20\x41\xcd\xcc\x0c\x3f"),
	PES17 = 			("\x00\x00\x40\x3f\x00\x00\xa0\x3f\xa4\x70\x3b\x3f\x00\x00\x48\x42\x00\x00\x20\x41"),
	FinalNet =          ("\x00\x00\x84\x3f\xcd\xcc\x4c\x3f\x9a\x99\x23\x3f\x00\x00\xaf\x43\x00\x00\x80\x41"),
	LowTriangleNet =    ("\x00\x00\x80\x3f\xcd\xcc\x4c\x3f\x00\x00\x80\x3f\x00\x00\xc8\x42\x00\x00\x20\x41\x00\x00\x80\x40\x00\x00\x80\x40\x00\x00\x80\x3f\x00\x00\x80\x42\x00\x00\x80\x3f"),

}	


--//================================================================================================================================================================//
--// Goalnet colors with responding code
--//================================================================================================================================================================//

--[[
New ID-s used for some specific things

prefix P means pattern ids (P000, P001, P002...)
prefix R means retro nets ids (R000, R001, R002...)
prefix NC means Net Color ids (NC00, NC01, NC02...)

-- SOLID COLORS:

NC00 - WHITE
NC01 - BLACK
NC02 - RED
NC03 - BLUE
NC04 - YELLOW
NC05 - GREEN
NC06 - GREEN2
NC07 - GRAY
NC08 - WHITE-GRAYISH
NC09 - PURPLE
NC10 - GREEN3
NC11 - GREEN4
NC12 - RED2
NC13 - RED3

-- 2 COLORS

NC30 - WHITE-BLACK 
NC31 - WHITE-BLACK S
NC32 - WHITE-RED
NC33 - WHITE-BLUE S 
NC34 - WHITE-BLUE
NC35 - WHITE-GREEN

NC40 - BLACK-YELLOW

NC44 - BLUE-GRAY

-- SPECIFIC
NC70 - Italian flag for cup final
NC71 - Netherlands in Rotterdam (orange-white)

--]]
--//================================================================================================================================================================//
--// Goalnets_Clubs
--//================================================================================================================================================================//

local team_presets = {

Default = {
    bounce = net_bounce.nb05_9,
    movement = movement.FC26_3,
    physics = net_physics.SItalyNT,
    net3d = net3D.OriginalT1L1,
    shape = Shape.PerfectSquareH,
    pattern = "P084",
    color_id = "0172",
    sound_file = "SE_Move0003"
},
-- ENGLAND
--  Premier League 
Arsenal = {
    bounce = net_bounce.nb075_9,
    movement = movement.FC26_3,
    physics = net_physics.EnglandN,
    net3d = net3D.Original,
    shape = Shape.ArsenalNet,
    pattern = "P084",
    color_id = "0101",
    sound_file = "SE_Move0003"
},
Aston_Villa = {
    bounce = net_bounce.nbNormal1,
    movement = movement.Deadstop2,
    physics = net_physics.EnglandNT,
    net3d = net3D.Original,
    shape = Shape.AstonVillaNet2,
    pattern = "P084",
    color_id = "0107",
    sound_file = "SE_Move0001"
},
Bournemouth = {
    bounce = net_bounce.nbMed5,
    movement = movement.Firm3,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.BournemouthNet,
    pattern = "P078",
    color_id = "4071",
    sound_file = "SE_Move0004"
},
Brentford = {
    bounce = net_bounce.nb05_9,
    movement = movement.Balanced5,
    physics = net_physics.SItalyNT,
    net3d = net3D.Original,
    shape = Shape.BrentfordNet,
    pattern = "P084",
    color_id = "4180",
    sound_file = "SE_Move0004"
},
Brighton_And_Hove_Albion = {
    bounce = net_bounce.nb006_11,
    movement = movement.FirmSnappy20,
    physics = net_physics.ProBalancedEPLow,
    net3d = net3D.Original,
    shape = Shape.BrightonNet,
    pattern = "P084",
    color_id = "0377",
    sound_file = "SE_Move0001"
},
Chelsea = {
    bounce = net_bounce.nb07_9,
    movement = movement.HardSnap2,
    physics = net_physics.ProBalanced,
    net3d = net3D.Original,
    shape = Shape.ChelseaNet,
    pattern = "P084",
    color_id = "0102",
    sound_file = "SE_Move0003"
},
Crystal_Palace = {
    bounce = net_bounce.nbNormal2,
    movement = movement.FirmSnappy20,
    physics = net_physics.SmallNetPhysics,
    net3d = net3D.SmallNet,
    shape = Shape.PalaceNet,
    pattern = "P018",
    color_id = "0382",
    sound_file = "SE_Move0004"
},
Everton = {
    bounce = net_bounce.nbVeryHigh4,
    movement = movement.Firm5,
    physics = net_physics.EnglandNT,
    net3d = net3D.Original,
    shape = Shape.EvertonNet,
    pattern = "P078",
    color_id = "0177",
    sound_file = "SE_Move0004"
},
Fulham = {
    bounce = net_bounce.nbNormal1,
    movement = movement.Deadstop3,
    physics = net_physics.ConcreteSlab,
    net3d = net3D.SmallNet,
    shape = Shape.FulhamNet,
    pattern = "P078",
    color_id = "0178",
    sound_file = "SE_Movement"
},
Ipswich_Town = {
    bounce = net_bounce.nb075_10,
    movement = movement.FirmSnappy2,
    physics = net_physics.ItalyNT,
    net3d = net3D.OriginalT2L1,
    shape = Shape.Chelsea,
    pattern = "P078",
    color_id = "0386",
    sound_file = "SE_Move0004"
},
Leicester_City = {
    bounce = net_bounce.nbNormal2,
    movement = movement.FirmSnappy12,
    physics = net_physics.OriginalNL2,
    net3d = net3D.OriginalH1,
    shape = Shape.NewDeepNet3,
    pattern = "P043",
    color_id = "0204",
    sound_file = "SE_Move0004"
},
Liverpool = {
	bounce = net_bounce.nb075_10,
	movement = movement.FC26_4,
	physics = net_physics.OriginalNL1,
	net3d = net3D.Original,
	shape = Shape.LiverpoolNet,
	pattern = "P084",
	color_id = "0103",
	sound_file = "SE_Move0003"
},
Manchester_City = {
	bounce = net_bounce.nb05_9,
	movement = movement.Elastic2,
	physics = net_physics.SIPLNT,
	net3d = net3D.OriginalH2,
	shape = Shape.CityNet,
	pattern = "P084",
	color_id = "0173",
	sound_file = "SE_Move0001"
},
Manchester_United = {
    bounce = net_bounce.nb05_9,
    movement = movement.FirmSnappy18,
    physics = net_physics.PProBalanced,
    net3d = net3D.Original,
    shape = Shape.UnitedNet,
    pattern = "P006",
    color_id = "0100",
    sound_file = "SE_Movement"
},
Newcastle_United = {
	bounce = net_bounce.nb02_6,
	movement = movement.FirmSnappy2,
	physics = net_physics.POriginalNT1,
	net3d = net3D.OriginalH1,
	shape = Shape.NewcastleNet,
	pattern = "P084",
	color_id = "0106",
	sound_file = "SE_Movement"
},
Nottingham_Forest = {
    bounce = net_bounce.nb2021,
    movement = movement.FirmSnappy9,
    physics = net_physics.POriginalNT1,
    net3d = net3D.OriginalH1,
    shape = Shape.NewcastleNet,
    pattern = "P078",
    color_id = "0389",
    sound_file = "SE_Move0004"
},
Southampton = {
    bounce = net_bounce.nbOT6,
    movement = movement.FirmSnappy2,
    physics = net_physics.SItalyNT,
    net3d = net3D.OriginalT2L2,
    shape = Shape.Real3,
    pattern = "P006",
    color_id = "0207",
    sound_file = "SE_Movement"
},
Tottenham_Hotspur = {
    bounce = net_bounce.nb075_10,
    movement = movement.FirmSnappy18,
    physics = net_physics.OriginalNL2v2,
    net3d = net3D.Original,
    shape = Shape.SpursNet,
    pattern = "P084",
    color_id = "0179",
    sound_file = "SE_Move0003"
},
West_Ham_United = {
    bounce = net_bounce.nb05_9,
    movement = movement.FC26_3,
    physics = net_physics.Original,
    net3d = net3D.Original,
    shape = Shape.WestHamNet,
    pattern = "P078",
    color_id = "0105",
    sound_file = "SE_Move0004"
},
Wolverhampton_Wanderers = {
    bounce = net_bounce.nb075_9,
    movement = movement.FirmSnappy20,
    physics = net_physics.PProBalanced,
    net3d = net3D.Original,
    shape = Shape.WolvesNet,
    pattern = "P084",
    color_id = "0208",
    sound_file = "SE_Move0004"
},
		     
--  EFL Championship		
Birmingham = {
    bounce = net_bounce.nb18,
    movement = movement.EPL6,
    physics = net_physics.PIPL,
    net3d = net3D.OriginalT1,
    shape = Shape.NetOriginal,
    pattern = "P043",
    color_id = "0201",
    sound_file = "SE_Movement"
},
Blackburn = {
    bounce = net_bounce.nb2021,
    movement = movement.Firm9,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.BlackburnNet,
    pattern = "P084",
    color_id = "0176",
    sound_file = "SE_Move0003"
},
Bristol = {
    bounce = net_bounce.nbMed5,
    movement = movement.FirmSnappy10,
    physics = net_physics.SItalyN,
    net3d = net3D.OriginalT2,
    shape = Shape.PerfectSquareL,
    pattern = "6208",
    color_id = "1760",
    sound_file = "SE_Movement"
},
Burnley = {
    bounce = net_bounce.nbMed5,
    movement = movement.FirmSnappy10,
    physics = net_physics.PLow,
    net3d = net3D.OriginalT2L1,
    shape = Shape.SmallNet,
    pattern = "P044",
    color_id = "0378",
    sound_file = "SE_Movement"
},
Cardiff = {
    bounce = net_bounce.nb18,
    movement = movement.Firm3,
    physics = net_physics.VeryStiff2,
    net3d = net3D.SmallNet,
    shape = Shape.Cardiff,
    pattern = "P078",
    color_id = "0379",
    sound_file = "SE_Movement"
},
Coventry = {
    bounce = net_bounce.nb075_10,
    movement = movement.Firm9,
    physics = net_physics.SIPLNT,
    net3d = net3D.OriginalH2,
    shape = Shape.CoventryNet,
    pattern = "P078",
    color_id = "4183",
    sound_file = "SE_Movement"
},
Derby_County = {
    bounce = net_bounce.nb1920_1,
    movement = movement.FirmSnappy2,
    physics = net_physics.PItalyNT,
    net3d = net3D.OriginalT4,
    shape = Shape.SAfricaWC20103,
    pattern = "P078",
    color_id = "0383",
    sound_file = "SE_Movement"
},
Huddersfield = {
    bounce = net_bounce.nb18,
    movement = movement.Firm3,
    physics = net_physics.PIPL,
    net3d = net3D.OriginalT4,
    shape = Shape.City,
    pattern = "P084",
    color_id = "2610",
    sound_file = "SE_Movement"
},
Hull = {
    bounce = net_bounce.nb20,
    movement = movement.Firm3,
    physics = net_physics.SIPL,
    net3d = net3D.OriginalT3,
    shape = Shape.NetOriginal,
    pattern = "P088",
    color_id = "1589",
    sound_file = "SE_Movement"
},
Leeds = {
    bounce = net_bounce.nb085_9,
    movement = movement.FirmSnappy20,
    physics = net_physics.PProBalanced,
    net3d = net3D.Original,
    shape = Shape.LeedsNet,
    pattern = "P084",
    color_id = "0104",
    sound_file = "SE_Movement"
},
Luton = {
    bounce = net_bounce.nbMed5,
    movement = movement.FirmSnappy2,
    physics = net_physics.PIPLNT,
    net3d = net3D.Original,
    shape = Shape.NetOriginal,
    pattern = "P043",
    color_id = "4363",
    sound_file = "SE_Movement"
},
Middlesbrough = {
    bounce = net_bounce.nb19,
    movement = movement.FirmSnappy7,
    physics = net_physics.SEPLN,
    net3d = net3D.OriginalT1,
    shape = Shape.NetOriginal,
    pattern = "P044",
    color_id = "0205",
    sound_file = "SE_Movement"
},
Millwall = {
    bounce = net_bounce.nb17,
    movement = movement.Firm3,
    physics = net_physics.SIPLNT,
    net3d = net3D.OriginalT3,
    shape = Shape.MidDeepNet,
    pattern = "P078",
    color_id = "0387",
    sound_file = "SE_Movement"
},
Norwich_City = {
    bounce = net_bounce.nbOT6,
    movement = movement.Snappy2,
    physics = net_physics.PItalyNT,
    net3d = net3D.Lic,
    shape = Shape.PerfectSquareH4,
    pattern = "P078",
    color_id = "0388",
    sound_file = "SE_Movement"
},
Oxford_United = {
    bounce = net_bounce.nbMed5,
    movement = movement.FirmSnappy2,
    physics = net_physics.SItalyN,
    net3d = net3D.LicH1,
    shape = Shape.MidDeepNetS,
    pattern = "P078",
    color_id = "5086",
    sound_file = "SE_Movement"
},
Plymouth = {
    bounce = net_bounce.nbMed5,
    movement = movement.FirmSnappy2,
    physics = net_physics.SItalyNT,
    net3d = net3D.Original,
    shape = Shape.NetOriginal,
    pattern = "P078",
    color_id = "4364",
    sound_file = "SE_Movement"
},
Preston_North_End = {
    bounce = net_bounce.nb1920_1,
    movement = movement.NXTOg,
    physics = net_physics.NormalN,
    net3d = net3D.Original,
    shape = Shape.SAfricaWC20104,
    pattern = "P078",
    color_id = "4192",
    sound_file = "SE_Movement"
},
QPR = {
    bounce = net_bounce.nbMidLow,
    movement = movement.Firm3,
    physics = net_physics.ItalyN,
    net3d = net3D.OriginalT2L1,
    shape = Shape.SmallNet,
    pattern = "P043",
    color_id = "1327",
    sound_file = "SE_Movement"
},
Sheffield_United = {
    bounce = net_bounce.nb9,
    movement = movement.Firm3,
    physics = net_physics.SItalyNT,
    net3d = net3D.OriginalT2,
    shape = Shape.OgMidDeep,
    pattern = "P084",
    color_id = "4194",
    sound_file = "SE_Move0001"
},
Sheffield_Wednesday = {
    bounce = net_bounce.nbMed2,
    movement = movement.Snappy2,
    physics = net_physics.IPL,
    net3d = net3D.OriginalT2L1,
    shape = Shape.CurveNet3,
    pattern = "P078",
    color_id = "0394",
    sound_file = "SE_Move0001"
},
Stoke_City = {
    bounce = net_bounce.nb2021,
    movement = movement.FirmSnappy2,
    physics = net_physics.SItalyN,
    net3d = net3D.Lic,
    shape = Shape.PerfectSquareH2,
    pattern = "P089",
    color_id = "0395",
    sound_file = "SE_Movement"
},
Sunderland = {
    bounce = net_bounce.nb2021,
    movement = movement.FirmSnappy17,
    physics = net_physics.OriginalNL2,
    net3d = net3D.OriginalH1,
    shape = Shape.SunderlandNet,
    pattern = "P084",
    color_id = "0396",
    sound_file = "SE_Movement"
},
Swansea = {
    bounce = net_bounce.nb2021,
    movement = movement.NXTOg,
    physics = net_physics.ItalyNT,
    net3d = net3D.OriginalT1,
    shape = Shape.NetOriginal,
    pattern = "P078",
    color_id = "1909",
    sound_file = "SE_Movement"
},
Watford = {
    bounce = net_bounce.nbMed2,
    movement = movement.Snappy,
    physics = net_physics.IPL,
    net3d = net3D.OriginalT2L1,
    shape = Shape.CurveNet3,
    pattern = "P084",
    color_id = "0398",
    sound_file = "SE_Movement"
},
West_Brom = {
    bounce = net_bounce.nb20,
    movement = movement.EPL,
    physics = net_physics.SItalyNT,
    net3d = net3D.OriginalT1,
    shape = Shape.NetOriginal,
    pattern = "P044",
    color_id = "0399",
    sound_file = "SE_Movement"
},

--  League One
Rotherham = {
    bounce = net_bounce.nbMidLow,
    movement = movement.Firm3,
    physics = net_physics.ItalyN,
    net3d = net3D.OriginalT2,
    shape = Shape.NetOriginal,
    pattern = "P043",
    color_id = "4193",
    sound_file = "SE_Movement"
},
Reading = {
    bounce = net_bounce.nb18,
    movement = movement.Firm,
    physics = net_physics.PortoLT,
    net3d = net3D.OriginalT2,
    shape = Shape.MidDeepNet,
    pattern = "P078",
    color_id = "0391",
    sound_file = "SE_Movement"
},
Blackpool = {
    bounce = net_bounce.nb20,
    movement = movement.FIFA5,
    physics = net_physics.PLow,
    net3d = net3D.OriginalT2L1,
    shape = Shape.SmallNet,
    pattern = "1761",
    color_id = "1761",
    sound_file = "SE_Movement"
},
Wigan = {
    bounce = net_bounce.nb20,
    movement = movement.Bouncy,
    physics = net_physics.PL,
    net3d = net3D.Original,
    shape = Shape.PerfectSquareL,
    pattern = "1588",
    color_id = "1588",
    sound_file = "SE_Movement"
},
Wrexham = {
    bounce = net_bounce.nb006_10,
    movement = movement.FC26_5,
    physics = net_physics.EnglandNT,
    net3d = net3D.Original,
    shape = Shape.WrexhamNet,
    pattern = "P044",
    color_id = "6069",
    sound_file = "SE_Movement"
},

--  Cups	
The_Emirates_FA_Cup = {
    bounce = net_bounce.nb006_6,
    movement = movement.Firm3,
    physics = net_physics.OriginalNL2Low,
    net3d = net3D.Original,
    shape = Shape.WembleyNet,
    pattern = "P044",
    goalnetcolor = "NC00",
    n_of_strings = "0005",
    rod_position = "0005",
    sound_file = "SE_Move0003"
},
Community_Shield = {
    bounce = net_bounce.nb006_6,
    movement = movement.Firm3,
    physics = net_physics.OriginalNL2Low,
    net3d = net3D.Original,
    shape = Shape.WembleyNet,
    pattern = "P044",
    goalnetcolor = "NC00",
    n_of_strings = "0005",
    rod_position = "0005",
    sound_file = "SE_Move0003"
},
	
--  Classic
Chelsea_2005 = {
	bounce = net_bounce.nb07_9,
	movement = movement.FirmSnappy12,
	physics = net_physics.PItalyNT,
	net3d = net3D.Original,
	shape = Shape.Chelsea2005,
	pattern = "P084",
	color_id = "R005",
	sound_file = "SE_Move0003"
},
Liverpool_2014 = {
    bounce = net_bounce.nb085_9,
    movement = movement.NXTOg,
    physics = net_physics.ItalyNTv2,
    net3d = net3D.Original,
    shape = Shape.Liverpool2014,
    pattern = "P078",
    color_id = "R002",
    sound_file = "SE_Move0003"
},
Manchester_City_2014 = {
    bounce = net_bounce.nb05_10,
    movement = movement.FirmSnappy20,
    physics = net_physics.ProBalanced,
    net3d = net3D.Original,
    shape = Shape.City2014,
    pattern = "P084",
    color_id = "R003",
    sound_file = "SE_Move0001"
},		
Newcastle_United_2012 = {
    bounce = net_bounce.nb085_9,
    movement = movement.NXTOg,
    physics = net_physics.ItalyNT,
    net3d = net3D.Original,
    shape = Shape.Newcastle2012,
    pattern = "P078",
    color_id = "R004",
    sound_file = "SE_Movement"
},

--//================================================================================================================================================================//

-- SPAIN
--  LaLiga Santander
Deportivo_Alaves = {
    bounce = net_bounce.nbOriginalT,
    movement = movement.Firm13,
    physics = net_physics.ProBalancedEPL,
    net3d = net3D.Original,
    shape = Shape.Real2,
    pattern = "P006",
    color_id = "4145",
    sound_file = "SE_Movement"
},
Athletic_Bilbao = {
    bounce = net_bounce.nb05_8,
    movement = movement.RippleFade2,
    physics = net_physics.OriginalNL1,
    net3d = net3D.Original,
    shape = Shape.BilbaoNet,
    pattern = "P018",
    color_id = "0258",
    sound_file = "SE_Move0003"
},
Atletico_Madrid = {
    bounce = net_bounce.nb01_8,
    movement = movement.FirmSnappy6,
    physics = net_physics.OriginalNL1,
    net3d = net3D.Original,
    shape = Shape.AtleticoNet,
    pattern = "P024",
    color_id = "0172",
    sound_file = "SE_Movement"
},
Barcelona = {
    bounce = net_bounce.nb05_9,
    movement = movement.FC26_3,
    physics = net_physics.OriginalNL1,
    net3d = net3D.Original,
    shape = Shape.BarcaNet,
    pattern = "P078",
    color_id = "7001",
    sound_file = "SE_Move0004"
},
Betis = {
    bounce = net_bounce.nb075_9,
    movement = movement.FirmSnappy13,
    physics = net_physics.OriginalNL1Low,
    net3d = net3D.Original,
    shape = Shape.BetisNet,
    pattern = "P089",
    color_id = "0194",
    sound_file = "SE_Move0004"
},
Betis_Cartuja = {
    bounce = net_bounce.nb075_9,
    movement = movement.FC26_3,
    physics = net_physics.EnglandNT,
    net3d = net3D.Original,
    shape = Shape.BetisNet2,
    pattern = "P078",
    color_id = "9999",
    sound_file = "SE_Move0004"
},
Celta = {
    bounce = net_bounce.nb05_9,
    movement = movement.HardSnap2,
    physics = net_physics.SOriginalNL1,
    net3d = net3D.Original,
    shape = Shape.CeltaNet,
    pattern = "P078",
    color_id = "0195",
    sound_file = "SE_Movement"
},
Espanyol = {
    bounce = net_bounce.nb05_9,
    movement = movement.FC26_3,
    physics = net_physics.EnglandNTLow,
    net3d = net3D.Original,
    shape = Shape.EspanyolNet,
    pattern = "P006",
    color_id = "0259",
    sound_file = "SE_Movement"
},
Getafe = {
    bounce = net_bounce.nb2021,
    movement = movement.FirmSnappy2,
    physics = net_physics.EnglandN,
    net3d = net3D.Original,
    shape = Shape.GetafeNet,
    pattern = "P078",
    color_id = "0362",
    sound_file = "SE_Movement"
},
Girona = {
    bounce = net_bounce.nb03_10,
    movement = movement.FirmSnappy9,
    physics = net_physics.SIPLN,
    net3d = net3D.OriginalT2L1,
    shape = Shape.City,
    pattern = "P084",
    color_id = "2187",
    sound_file = "SE_Move0003"
},
Las_Palmas = {
    bounce = net_bounce.nb20,
    movement = movement.FirmSnappy2,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.MidDeepNet,
    pattern = "P078",
    color_id = "0364",
    sound_file = "SE_Move0003"
},
CD_Leganes = {
    bounce = net_bounce.nb02_7,
    movement = movement.Balanced2,
    physics = net_physics.IPLNT,
    net3d = net3D.Original,
    shape = Shape.LeganesNet,
    pattern = "P084",
    color_id = "4272",
    sound_file = "SE_Movement"
},
Mallorca = {
    bounce = net_bounce.nbOriginalBT,
    movement = movement.Balanced2,
    physics = net_physics.OriginalNL1,
    net3d = net3D.Original,
    shape = Shape.MallorcaNet,
    pattern = "P006",
    color_id = "0261",
    sound_file = "SE_Movement"
},
Osasuna = {
    bounce = net_bounce.nbOT8,
    movement = movement.FirmSnappy2,
    physics = net_physics.OriginalNL3,
    net3d = net3D.Original,
    shape = Shape.OsasunaNet,
    pattern = "P018",
    color_id = "0263",
    sound_file = "SE_Movement"
},
Real_Madrid = {
    bounce = net_bounce.nb05_9,
    movement = movement.FC26_3,
    physics = net_physics.EnglandNTLow,
    net3d = net3D.Original,
    shape = Shape.MadridNet,
    pattern = "P078",
    color_id = "0109",
    sound_file = "SE_Move0004"
},
Real_Oviedo = {
    bounce = net_bounce.nb07_9,
    movement = movement.FC26_3,
    physics = net_physics.PEnglandNT,
    net3d = net3D.OriginalH1,
    shape = Shape.OviedoNet,
    pattern = "P078",
    color_id = "4260",
    sound_file = "SE_Movement"
},
Real_Sociedad = {
    bounce = net_bounce.nb2021,
    movement = movement.WhippyCorners_Lite,
    physics = net_physics.EnglandNTLow,
    net3d = net3D.Original,
    shape = Shape.SociedadNet,
    pattern = "P084",
    color_id = "0196",
    sound_file = "SE_Move0004"
},
Real_Valladolid = {
    bounce = net_bounce.nbOT7,
    movement = movement.Balanced4,
    physics = net_physics.OriginalNL3,
    net3d = net3D.Belly,
    shape = Shape.Belly,
    pattern = "P078",
    color_id = "0266",
    sound_file = "SE_Movement"
},
Sevilla = {
    bounce = net_bounce.nb05_9,
    movement = movement.FC26_3,
    physics = net_physics.OriginalNL2,
    net3d = net3D.Original,
    shape = Shape.SevillaNet,
    pattern = "P018",
    color_id = "0265",
    sound_file = "SE_Move0004"
},
Valencia = {
    bounce = net_bounce.nb01_7,
    movement = movement.FirmSnappy2,
    physics = net_physics.SItalyNT,
    net3d = net3D.OriginalT1,
    shape = Shape.ValenciaNet,
    pattern = "P078",
    color_id = "0110",
    sound_file = "SE_Move0003"
},
Rayo_Vallecano = {
    bounce = net_bounce.nb01_10,
    movement = movement.FC26_5,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.RayoNet,
    pattern = "P078",
    color_id = "0370",
    sound_file = "SE_Movement"
},
Villareal = {
    bounce = net_bounce.nb006_8,
    movement = movement.FirmSnappy6,
    physics = net_physics.EnglandNT,
    net3d = net3D.Original,
    shape = Shape.VillarealNet,
    pattern = "P098",
    color_id = "0267",
    sound_file = "SE_Movement"
},

--  LaLiga SmartBank
Almeria = {
    bounce = net_bounce.nb18,
    movement = movement.NXT6,
    physics = net_physics.Porto,
    net3d = net3D.OriginalT1L1,
    shape = Shape.MidDeepNet,
    pattern = "P078",
    color_id = "0357",
    sound_file = "SE_Movement"
},
Cadiz = {
    bounce = net_bounce.nb20,
    movement = movement.FIFA2,
    physics = net_physics.PLow,
    net3d = net3D.OriginalT2L1,
    shape = Shape.SmallNet,
    pattern = "P043",
    color_id = "4308",
    sound_file = "SE_Move0003"
},
Elche = {
    bounce = net_bounce.nb17,
    movement = movement.Porto,
    physics = net_physics.PortoLT,
    net3d = net3D.Original,
    shape = Shape.MidDeepNet,
    pattern = "P078",
    color_id = "0361",
    sound_file = "SE_Movement"
},
Deportivo_La_Coruna = {
    bounce = net_bounce.nb05_9,
    movement = movement.Balanced3,
    physics = net_physics.SItalyNT,
    net3d = net3D.Original,
    shape = Shape.NetOriginal,
    pattern = "P078",
    color_id = "0111",
    sound_file = "SE_Movement"
},
Granada = {
    bounce = net_bounce.nbMed5,
    movement = movement.FirmSnappy2,
    physics = net_physics.PItalyNT,
    net3d = net3D.OriginalH1,
    shape = Shape.SAfricaWC2010,
    pattern = "P078",
    color_id = "1765",
    sound_file = "SE_Move0003"
},
Levante = {
    bounce = net_bounce.nb22,
    movement = movement.Firm3,
    physics = net_physics.SItalyN,
    net3d = net3D.OriginalT2,
    shape = Shape.MidDeepNet,
    pattern = "P084",
    color_id = "0366",
    sound_file = "SE_Movement"
},
Malaga = {
    bounce = net_bounce.nb15,
    movement = movement.Balanced2,
    physics = net_physics.SItalyNT,
    net3d = net3D.OriginalT1,
    shape = Shape.Belly,
    pattern = "P010",
    color_id = "0260",
    sound_file = "SE_Movement"
},
Real_Zaragoza = {
    bounce = net_bounce.nb05_5,
    movement = movement.Firm3,
    physics = net_physics.ItalyNLow,
    net3d = net3D.OriginalL2,
    shape = Shape.ZaragozaNet,
    pattern = "P098",
    color_id = "0268",
    sound_file = "SE_Movement"
},
SD_Huesca = {
    bounce = net_bounce.nb9,
    movement = movement.Firm3,
    physics = net_physics.SItalyN,
    net3d = net3D.OriginalT2L1,
    shape = Shape.SmallNet,
    pattern = "P078",
    color_id = "2188",
    sound_file = "SE_Movement"
},
CD_Mirandes = {
    bounce = net_bounce.nb18,
    movement = movement.NXTOg,
    physics = net_physics.SItalyN,
    net3d = net3D.OriginalT1,
    shape = Shape.MidDeepNet,
    pattern = "P080",
    color_id = "2616",
    sound_file = "SE_Movement"
},
CD_Tenerife = {
    bounce = net_bounce.nb15,
    movement = movement.Balanced6,
    physics = net_physics.ItalyNTLow,
    net3d = net3D.Original,
    shape = Shape.TenerifeNet,
    pattern = "P006",
    color_id = "4147",
    sound_file = "SE_Movement"
},
CD_Eldense = {
    bounce = net_bounce.nb18,
    movement = movement.Balanced2,
    physics = net_physics.SItalyNT,
    net3d = net3D.OriginalT1L1,
    shape = Shape.NetOriginal,
    pattern = "P060",
    color_id = "4988",
    sound_file = "SE_Movement"
},
CD_Castellon = {
    bounce = net_bounce.nb18,
    movement = movement.NXTOg,
    physics = net_physics.SItalyN,
    net3d = net3D.OriginalT1,
    shape = Shape.MidDeepNet,
    pattern = "P078",
    color_id = "4395",
    sound_file = "SE_Movement"
},
SD_Eibar = {
    bounce = net_bounce.nb18,
    movement = movement.Firm3,
    physics = net_physics.Spain,
    net3d = net3D.Original,
    shape = Shape.Madrid,
    pattern = "P078",
    color_id = "4146",
    sound_file = "SE_Movement"
},
Burgos_CF = {
    bounce = net_bounce.nb18,
    movement = movement.Balanced2,
    physics = net_physics.SItalyN,
    net3d = net3D.OriginalT1H1,
    shape = Shape.NetOriginal,
    pattern = "P078",
    color_id = "4247",
    sound_file = "SE_Movement"
},
Racing_Ferrol = {
    bounce = net_bounce.nb18,
    movement = movement.Balanced2,
    physics = net_physics.ItalyNT,
    net3d = net3D.OriginalT1,
    shape = Shape.NetOriginal,
    pattern = "P078",
    color_id = "4259",
    sound_file = "SE_Movement"
},
Racing_Santander = {
    bounce = net_bounce.nb18,
    movement = movement.Balanced2,
    physics = net_physics.SItalyN,
    net3d = net3D.OriginalT1L1,
    shape = Shape.CurveNet2,
    pattern = "P010",
    color_id = "0264",
    sound_file = "SE_Movement"
},
Sporting_Gijon = {
    bounce = net_bounce.nb19,
    movement = movement.Firm3,
    physics = net_physics.ItalyNT,
    net3d = net3D.OriginalT2L1,
    shape = Shape.NetOriginal,
    pattern = "P078",
    color_id = "0363",
    sound_file = "SE_Movement"
},
Albacete = {
    bounce = net_bounce.nb18,
    movement = movement.Firm3,
    physics = net_physics.IPL,
    net3d = net3D.OriginalT1L1,
    shape = Shape.NetOriginal,
    pattern = "P010",
    color_id = "4302",
    sound_file = "SE_Movement"
},
FC_Cartagena = {
    bounce = net_bounce.nb18,
    movement = movement.NXTOg,
    physics = net_physics.SIPL,
    net3d = net3D.Original,
    shape = Shape.MidDeepNet,
    pattern = "P078",
    color_id = "4309",
    sound_file = "SE_Movement"
},

-- RFEF Primera
CD_Lugo = {
    bounce = net_bounce.nb18,
    movement = movement.EPL2,
    physics = net_physics.Spain,
    net3d = net3D.Original,
    shape = Shape.PerfectSquare,
    pattern = "goal",
    color_id = "goal",
    sound_file = "SE_Movement"
},
UD_Ibiza = {
    bounce = net_bounce.nb18,
    movement = movement.EPL2,
    physics = net_physics.Spain,
    net3d = net3D.Original,
    shape = Shape.PerfectSquare,
    pattern = "goal",
    color_id = "goal",
    sound_file = "SE_Movement"
},
FC_Andorra = {
    bounce = net_bounce.nbMed2,
    movement = movement.Firm3,
    physics = net_physics.ItalyNT,
    net3d = net3D.Original,
    shape = Shape.TightTriangle,
    pattern = "goal",
    color_id = "goal",
    sound_file = "SE_Movement"
},
Villareal_B = {
    bounce = net_bounce.nb006_8,
    movement = movement.FirmSnappy6,
    physics = net_physics.EnglandNT,
    net3d = net3D.Original,
    shape = Shape.VillarealNet,
    pattern = "P098",
    color_id = "0267",
    sound_file = "SE_Movement"
},
SD_Ponferradina = {
    bounce = net_bounce.nb18,
    movement = movement.EPL2,
    physics = net_physics.Spain,
    net3d = net3D.Original,
    shape = Shape.PerfectSquare,
    pattern = "goal",
    color_id = "goal",
    sound_file = "SE_Movement"
},
	
--  Classic
Deportivo_La_Coruna_2003 = {
    bounce = net_bounce.nb17,
    movement = movement.Balanced3,
    physics = net_physics.SItalyNT,
    net3d = net3D.Original,
    shape = Shape.NetOriginal,
    pattern = "P078",
    color_id = "R000",
    sound_file = "SE_Movement"
},
Villareal_2006 = {
    bounce = net_bounce.nb006_8,
    movement = movement.FirmSnappy6,
    physics = net_physics.OriginalNL2,
    net3d = net3D.Original,
    shape = Shape.Villareal2006,
    pattern = "P078",
    color_id = "R001",
    sound_file = "SE_Movement"
},

-- Spanish Cup Competitions
Copa_del_Rey = {
    bounce = net_bounce.nb20,
    movement = movement.FIFA2,
    physics = net_physics.SItaly,
    net3d = net3D.OriginalT1,
    shape = Shape.MidCurveNet,
    pattern = "P091",
    goalnetcolor = "NC00",
    n_of_strings = "9012",
    rod_position = "9012",
    sound_file = "SE_Move0003"
},
Supercopa_de_Espana = {
    bounce = net_bounce.nb20,
    movement = movement.NXT2,
    physics = net_physics.SItaly,
    net3d = net3D.OriginalT2H1,
    shape = Shape.CurveNet,
    pattern = "P081",
    goalnetcolor = "NC00",
    n_of_strings = "9012",
    rod_position = "9012",
    sound_file = "SE_Move0003"
},

--//================================================================================================================================================================//

-- ITALY
-- Serie A

Atalanta = {
    bounce = net_bounce.nb05_8,
    movement = movement.RippleFade2,
    physics = net_physics.EnglandNT,
    net3d = net3D.Original,
    shape = Shape.AtalantaNet,
    pattern = "P084",
    color_id = "0234",
    sound_file = "SE_Movement"
},
Bologna = {
    bounce = net_bounce.nb05_10,
    movement = movement.FirmSnappy2,
    physics = net_physics.OriginalNT4,
    net3d = net3D.Original,
    shape = Shape.BolognaNet,
    pattern = "P084",
    color_id = "0186",
    sound_file = "SE_Move0001"
},
Cagliari = {
    bounce = net_bounce.nb05_8,
    movement = movement.Balanced4,
    physics = net_physics.OriginalNT4,
    net3d = net3D.Original,
    shape = Shape.CagliariNet,
    pattern = "P006",
    color_id = "0320",
    sound_file = "SE_Movement"
},
Como = {
    bounce = net_bounce.nb05_7,
    movement = movement.FC26_5,
    physics = net_physics.OriginalNL2,
    net3d = net3D.OriginalT2L1,
    shape = Shape.ComoNet,
    pattern = "P006",
    color_id = "4219",
    sound_file = "SE_Move0002"
},
Cremonese = {
    bounce = net_bounce.nb20,
    movement = movement.Balanced2,
    physics = net_physics.PItalyNT,
    net3d = net3D.OriginalT1H1,
    shape = Shape.NetOriginal,
    pattern = "P019",
    color_id = "4220",
    sound_file = "SE_Movement"
},
Empoli = {
    bounce = net_bounce.nbOriginalBT,
    movement = movement.Balanced4,
    physics = net_physics.PIPLNT,
    net3d = net3D.OriginalT4,
    shape = Shape.EmpoliNet,
    pattern = "P006",
    color_id = "0235",
    sound_file = "SE_Move0002"
},
Fiorentina = {
    bounce = net_bounce.nb05_10,
    movement = movement.RippleFade2,
    physics = net_physics.EnglandNT,
    net3d = net3D.OriginalL1,
    shape = Shape.FiorentinaNet,
    pattern = "P078",
    color_id = "0124",
    sound_file = "SE_Move0003"
},
Genoa = {
    bounce = net_bounce.nbOT7,
    movement = movement.FirmSnappy2,
    physics = net_physics.OriginalNL1,
    net3d = net3D.Original,
    shape = Shape.MarassiNet,
    pattern = "P006",
    color_id = "0323",
    sound_file = "SE_Move0002"
},
Hellas_Verona = {
    bounce = net_bounce.nbOriginalBT,
    movement = movement.Balanced4,
    physics = net_physics.PIPLNT,
    net3d = net3D.OriginalT4,
    shape = Shape.VeronaNet,
    pattern = "P006",
    color_id = "0336",
    sound_file = "SE_Move0002"
},
Inter = {
    bounce = net_bounce.nb05_9,
    movement = movement.FC26_3,
    physics = net_physics.EnglandN,
    net3d = net3D.Net3DTest4,
    shape = Shape.SanSiro,
    pattern = "P078",
    color_id = "0119",
    sound_file = "SE_Move0003"
},
Juventus = {
    bounce = net_bounce.nb075_9,
    movement = movement.CornerSlack2,
    physics = net_physics.EnglandN,
    net3d = net3D.Original,
    shape = Shape.JuveNet,
    pattern = "P078",
    color_id = "0120",
    sound_file = "SE_Move0003"
},
Lazio = {
    bounce = net_bounce.nb05_8,
    movement = movement.WindSway3_0,
    physics = net_physics.EnglandN,
    net3d = net3D.Original,
    shape = Shape.OlimpicoNet,
    pattern = "P084",
    color_id = "0122",
    sound_file = "SE_Move0003"
},
Lecce = {
    bounce = net_bounce.nbT5,
    movement = movement.Balanced7,
    physics = net_physics.OriginalNL3,
    net3d = net3D.Original,
    shape = Shape.LecceNet,
    pattern = "P078",
    color_id = "4237",
    sound_file = "SE_Move0003"
},
Milan = {
    bounce = net_bounce.nb05_9,
    movement = movement.FC26_3,
    physics = net_physics.EnglandN,
    net3d = net3D.Net3DTest4,
    shape = Shape.SanSiro,
    pattern = "P078",
    color_id = "0121",
    sound_file = "SE_Move0003"
},
Napoli = {
    bounce = net_bounce.nb03_10,
    movement = movement.Firm11,
    physics = net_physics.OriginalNL2,
    net3d = net3D.Original,
    shape = Shape.NapoliNet,
    pattern = "P006",
    color_id = "0327",
    sound_file = "SE_Move0004"
},
Parma = {
    bounce = net_bounce.nbNormal2,
    movement = movement.Balanced4,
    physics = net_physics.OriginalNL2,
    net3d = net3D.OriginalL1,
    shape = Shape.ParmaNet,
    pattern = "P006",
    color_id = "0123",
    sound_file = "SE_Movement"
},
Pisa = {
    bounce = net_bounce.nbNormal2,
    movement = movement.Bouncy,
    physics = net_physics.ItalyNLow,
    net3d = net3D.Original,
    shape = Shape.PisaNet,
    pattern = "P006",
    color_id = "4241",
    sound_file = "SE_Movement"
},
Roma = {
    bounce = net_bounce.nb075_9,
    movement = movement.Deadstop1,
    physics = net_physics.EnglandN,
    net3d = net3D.Original,
    shape = Shape.OlimpicoNet,
    pattern = "P084",
    color_id = "0125",
    sound_file = "SE_Move0003"
},
Sassuolo = {
    bounce = net_bounce.nbNormal2,
    movement = movement.FC26_5,
    physics = net_physics.EnglandNT,
    net3d = net3D.Original,
    shape = Shape.SassuoloNet,
    pattern = "P006",
    color_id = "1919",
    sound_file = "SE_Move0004"
},
Torino = {
    bounce = net_bounce.nbOriginalT,
    movement = movement.FirmSnappy2,
    physics = net_physics.EnglandNT,
    net3d = net3D.OriginalH1,
    shape = Shape.TorinoNet,
    pattern = "P006",
    color_id = "0333",
    sound_file = "SE_Move0004"
},
Udinese = {
    bounce = net_bounce.nb05_7,
    movement = movement.CornerSlack4_8,
    physics = net_physics.ItalyNTLow,
    net3d = net3D.Original,
    shape = Shape.UdineNet,
    pattern = "P047",
    color_id = "0190",
    sound_file = "SE_Movement"
},

-- Serie B

AC_Reggiana = {
    bounce = net_bounce.nb10,
    movement = movement.Balanced3,
    physics = net_physics.PIPL,
    net3d = net3D.OriginalT2L1,
    shape = Shape.Belly,
    pattern = "P010",
    color_id = "4225",
    sound_file = "SE_Movement"
},
Carrarese = {
    bounce = net_bounce.nbTest,
    movement = movement.Balanced2,
    physics = net_physics.Italy,
    net3d = net3D.SmallNet,
    shape = Shape.Antwerp,
    pattern = "P089",
    color_id = "4218",
    sound_file = "SE_Movement"
},
Juve_Stabia = {
    bounce = net_bounce.nbTest,
    movement = movement.Balanced2,
    physics = net_physics.ItalyN,
    net3d = net3D.OriginalL1,
    shape = Shape.Antwerp,
    pattern = "P089",
    color_id = "2517",
    sound_file = "SE_Movement"
},
Citadella = {
    bounce = net_bounce.nb15,
    movement = movement.NXTOg,
    physics = net_physics.ItalyN,
    net3d = net3D.OriginalT4L1,
    shape = Shape.OgMidDeep,
    pattern = "P043",
    color_id = "1920",
    sound_file = "SE_Movement"
},
Brescia = {
    bounce = net_bounce.nb20,
    movement = movement.Firm3,
    physics = net_physics.ItalyN,
    net3d = net3D.OriginalL1,
    shape = Shape.BresciaNet,
    pattern = "P078",
    color_id = "0187",
    sound_file = "SE_Movement"
},
Bari = {
    bounce = net_bounce.nb05_10,
    movement = movement.FirmSnappy15,
    physics = net_physics.ItalyNT,
    net3d = net3D.Original,
    shape = Shape.BariNet,
    pattern = "P084",
    color_id = "0319",
    sound_file = "SE_Movement"
},
US_Catanzaro = {
    bounce = net_bounce.nbMidLow,
    movement = movement.Balanced3,
    physics = net_physics.Normal,
    net3d = net3D.OriginalT2L1,
    shape = Shape.Lic,
    pattern = "P084",
    color_id = "4233",
    sound_file = "SE_Movement"
},
Cosenza = {
    bounce = net_bounce.nbMidLow,
    movement = movement.Firm3,
    physics = net_physics.SItaly,
    net3d = net3D.OriginalT2L1,
    shape = Shape.MidDeepNet,
    pattern = "P084",
    color_id = "4928",
    sound_file = "SE_Movement"
},
Cesena = {
    bounce = net_bounce.nb10,
    movement = movement.Firm3,
    physics = net_physics.PItalyN,
    net3d = net3D.OriginalT2L1,
    shape = Shape.NetOriginal,
    pattern = "P084",
    color_id = "1362",
    sound_file = "SE_Movement"
},
Sampdoria = {
    bounce = net_bounce.nbOT7,
    movement = movement.FirmSnappy2,
    physics = net_physics.OriginalNL1,
    net3d = net3D.Original,
    shape = Shape.MarassiNet,
    pattern = "P006",
    color_id = "0240",
    sound_file = "SE_Movement"
},
Frosinone = {
    bounce = net_bounce.nb10,
    movement = movement.Firm3,
    physics = net_physics.Normal,
    net3d = net3D.OriginalT3L1,
    shape = Shape.Lic,
    pattern = "P010",
    color_id = "4234",
    sound_file = "SE_Move0002"
},
Salernitana = {
    bounce = net_bounce.nb20,
    movement = movement.Firm3,
    physics = net_physics.SIPL,
    net3d = net3D.Original,
    shape = Shape.MidDeepNet,
    pattern = "P078",
    color_id = "4244",
    sound_file = "SE_Move0004"
},
Sudtirol = {
    bounce = net_bounce.nb10,
    movement = movement.Firm3,
    physics = net_physics.PItalyNT,
    net3d = net3D.OriginalT2L1,
    shape = Shape.NetOriginal,
    pattern = "P010",
    color_id = "4228",
    sound_file = "SE_Movement"
},
Modena = {
    bounce = net_bounce.nb20,
    movement = movement.Firm3,
    physics = net_physics.ItalyN,
    net3d = net3D.OriginalT2L2,
    shape = Shape.ImprovedMidDeep,
    pattern = "P043",
    color_id = "0237",
    sound_file = "SE_Movement"
},
Mantova = {
    bounce = net_bounce.nb9,
    movement = movement.Firm3,
    physics = net_physics.PIPL,
    net3d = net3D.OriginalT1L1,
    shape = Shape.NetOriginal,
    pattern = "P060",
    color_id = "4379",
    sound_file = "SE_Movement"
},
Monza = {
    bounce = net_bounce.nb2021,
    movement = movement.FirmSnappy2,
    physics = net_physics.EnglandNTLow,
    net3d = net3D.Original,
    shape = Shape.MonzaNet,
    pattern = "P006",
    color_id = "4914",
    sound_file = "SE_Movement"
},
Palermo = {
    bounce = net_bounce.nb10,
    movement = movement.Balanced3,
    physics = net_physics.PIPLNT,
    net3d = net3D.Original,
    shape = Shape.PalermoNet,
    pattern = "P010",
    color_id = "0238",
    sound_file = "SE_Movement"
},
Spezia = {
    bounce = net_bounce.nb20,
    movement = movement.Firm3,
    physics = net_physics.PLow,
    net3d = net3D.OriginalT2L1,
    shape = Shape.SmallNet,
    pattern = "P043",
    color_id = "1600",
    sound_file = "SE_Movement"
},
Venezia = {
    bounce = net_bounce.nbNormal3,
    movement = movement.FirmSnappy20,
    physics = net_physics.EnglandNT,
    net3d = net3D.Original,
    shape = Shape.VeneziaNet,
    pattern = "P084",
    color_id = "4229",
    sound_file = "SE_Movement"
},

-- Seria C

Ascoli = {
    bounce = net_bounce.nb20,
    movement = movement.Balanced2,
    physics = net_physics.Normal,
    net3d = net3D.Original,
    shape = Shape.NetOriginal,
    pattern = "P010",
    color_id = "2010",
    sound_file = "SE_Movement"
},
Benevento = {
    bounce = net_bounce.nb20,
    movement = movement.FIFA2,
    physics = net_physics.PLow,
    net3d = net3D.OriginalT2L1,
    shape = Shape.SmallNet,
    pattern = "2126",
    color_id = "2126",
    sound_file = "SE_Movement"
},
Perugia = {
    bounce = net_bounce.nb18,
    movement = movement.FIFA4,
    physics = net_physics.PIPL,
    net3d = net3D.OriginalT2L2,
    shape = Shape.Belly,
    pattern = "0180",
    color_id = "0180",
    sound_file = "SE_Movement"
},
Ternana = {
    bounce = net_bounce.nb18,
    movement = movement.EPL,
    physics = net_physics.SIPL,
    net3d = net3D.OriginalT1,
    shape = Shape.NetOriginal,
    pattern = "0361",
    color_id = "0361",
    sound_file = "SE_Movement"
},

--  Cups	
Coppa_Italia = {
    bounce = net_bounce.nb075_9,
    movement = movement.Deadstop1,
    physics = net_physics.EnglandN,
    net3d = net3D.Original,
    shape = Shape.OlimpicoNet,
    pattern = "P084",
    goalnetcolor = "NC70",
    n_of_strings = "0125",
    rod_position = "0125",
    sound_file = "SE_Move0003"
},
Supercoppa_Italiana = {
    bounce = net_bounce.nb075_9,
    movement = movement.Deadstop1,
    physics = net_physics.EnglandN,
    net3d = net3D.Original,
    shape = Shape.OlimpicoNet,
    pattern = "P084",
    goalnetcolor = "NC70",
    n_of_strings = "9012",
    rod_position = "9012",
    sound_file = "SE_Move0003"
},


--//================================================================================================================================================================//

-- GERMANY
-- Bundesliga
Augsburg = {
    bounce = net_bounce.nb05_10,
    movement = movement.Deadstop1,
    physics = net_physics.EnglandN,
    net3d = net3D.Original,
    shape = Shape.AugsburgNet,
    pattern = "P006",
    color_id = "4124",
    sound_file = "SE_Move0003"
},
Bayer_Leverkusen = {
    bounce = net_bounce.nbNormal2,
    movement = movement.Deadstop1,
    physics = net_physics.EnglandN,
    net3d = net3D.Original,
    shape = Shape.LeverkusenNet,
    pattern = "P078",
    color_id = "0128",
    sound_file = "SE_Move0001"
},
FC_Bayern = {
    bounce = net_bounce.nb05_10,
    movement = movement.FC26_3,
    physics = net_physics.OriginalNL2,
    net3d = net3D.Original,
    shape = Shape.BayernNet,
    pattern = "P006",
    color_id = "0127",
    sound_file = "SE_Movement"
},
Vfl_Bochum = {
    bounce = net_bounce.nb075_9,
    movement = movement.RippleFade2,
    physics = net_physics.PIPL,
    net3d = net3D.OriginalT1L1,
    shape = Shape.MidDeepNet,
    pattern = "P006",
    color_id = "4128",
    sound_file = "SE_Move0002"
},
Borussia_Dortmund = {
    bounce = net_bounce.nb05_10,
    movement = movement.RippleFade2,
    physics = net_physics.OriginalNL2,
    net3d = net3D.Original,
    shape = Shape.DortmundNet,
    pattern = "P006",
    color_id = "0126",
    sound_file = "SE_Move0003"
},
Borussia_Monchengladbach = {
    bounce = net_bounce.nb075_9,
    movement = movement.RippleFade2,
    physics = net_physics.PItalyNT,
    net3d = net3D.Original,
    shape = Shape.GladbachNet,
    pattern = "P006",
    color_id = "0225",
    sound_file = "SE_Move0001"
},
Eintracht_Frankfurt = {
    bounce = net_bounce.nb05_9,
    movement = movement.Deadstop1,
    physics = net_physics.IPLNT,
    net3d = net3D.OriginalT2,
    shape = Shape.FrankfurtNet,
    pattern = "P006",
    color_id = "0226",
    sound_file = "SE_Move0001"
},
Koln = {
    bounce = net_bounce.nb19,
    movement = movement.NXTOg,
    physics = net_physics.SItalyNT,
    net3d = net3D.OriginalT2,
    shape = Shape.NetOriginal,
    pattern = "P052",
    color_id = "4137",
    sound_file = "SE_Move0002"
},
Mainz = {
    bounce = net_bounce.nb18,
    movement = movement.NXT6,
    physics = net_physics.ItalyNT,
    net3d = net3D.OriginalT1,
    shape = Shape.MainzNet,
    pattern = "P006",
    color_id = "0436",
    sound_file = "SE_Move0003"
},
FC_Heidenheim = {
    bounce = net_bounce.nb20,
    movement = movement.Balanced4,
    physics = net_physics.OriginalNT1,
    net3d = net3D.Original,
    shape = Shape.HeidenheimNet,
    pattern = "P006",
    color_id = "5009",
    sound_file = "SE_Movement"
},
TSG_Hoffenheim = {
    bounce = net_bounce.nbOriginalBT,
    movement = movement.FirmSnappy2,
    physics = net_physics.PIPLNT,
    net3d = net3D.OriginalH1,
    shape = Shape.HoffenheimNet,
    pattern = "P006",
    color_id = "4126",
    sound_file = "SE_Movement"
},
SC_Freiburg = {
    bounce = net_bounce.nb03_10,
    movement = movement.FirmSnappy2,
    physics = net_physics.OriginalNL2,
    net3d = net3D.Original,
    shape = Shape.FreiburgNet,
    pattern = "P006",
    color_id = "0227",
    sound_file = "SE_Move0003"
},
RB_Leipzig = {
    bounce = net_bounce.nb05_8,
    movement = movement.Deadstop1,
    physics = net_physics.EnglandN,
    net3d = net3D.Original,
    shape = Shape.LeipzigNet,
    pattern = "P060",
    color_id = "5010",
    sound_file = "SE_Move0004"
},
Union_Berlin = {
    bounce = net_bounce.nb05_9,
    movement = movement.FC26_3,
    physics = net_physics.SItalyNT,
    net3d = net3D.OriginalT1L1,
    shape = Shape.PerfectSquareH,
    pattern = "P078",
    color_id = "4140",
    sound_file = "SE_Move0001"
},
Vfb_Stuttgart = {
    bounce = net_bounce.nb05_8,
    movement = movement.Deadstop1,
    physics = net_physics.EnglandN,
    net3d = net3D.Original,
    shape = Shape.StuttgartNet,
    pattern = "P006",
    color_id = "0231",
    sound_file = "SE_Move0001"
},
FC_St_Pauli = {
    bounce = net_bounce.nb18,
    movement = movement.CornerSlack2,
    physics = net_physics.OriginalNT2,
    net3d = net3D.Original,
    shape = Shape.StPauliNet,
    pattern = "P091",
    color_id = "4139",
    sound_file = "SE_Movement"
},
Holstein_Kiel = {
    bounce = net_bounce.nb02_7,
    movement = movement.Balanced3,
    physics = net_physics.ItalyNT,
    net3d = net3D.OriginalT1,
    shape = Shape.KielNet,
    pattern = "P060",
    color_id = "5719",
    sound_file = "SE_Movement"
},
Werder_Bremen = {
    bounce = net_bounce.nbNormal2,
    movement = movement.FC26_3,
    physics = net_physics.OriginalNL1,
    net3d = net3D.Original,
    shape = Shape.WerderNet,
    pattern = "P060",
    color_id = "0185",
    sound_file = "SE_Move0003"
},
Vfl_Wolfsburg = {
    bounce = net_bounce.nbNormal2,
    movement = movement.FC26_3,
    physics = net_physics.EnglandN,
    net3d = net3D.Original,
    shape = Shape.WolfsburgNet,
    pattern = "P010",
    color_id = "0232",
    sound_file = "SE_Move0004"
},

-- Bundesliga 2
SV_Darmstadt = {
    bounce = net_bounce.nb9,
    movement = movement.EPL,
    physics = net_physics.Italy,
    net3d = net3D.OriginalT2L1,
    shape = Shape.NetOriginalS,
    pattern = "5008",
    color_id = "5008",
    sound_file = "SE_Move0004"
},
Eintracht_Braunschweig = {
    bounce = net_bounce.nb05_9,
    movement = movement.AiryPocket,
    physics = net_physics.ItalyNT,
    net3d = net3D.OriginalT2H1,
    shape = Shape.NetOriginal,
    pattern = "P078",
    color_id = "4074",
    sound_file = "SE_Movement"
},
Fortuna_Dusseldorf = {
    bounce = net_bounce.nb03_9,
    movement = movement.SnapBreathPro,
    physics = net_physics.EnglandNTLow,
    net3d = net3D.OriginalT2,
    shape = Shape.NetOriginal,
    pattern = "P078",
    color_id = "0431",
    sound_file = "SE_Movement"
},
Hertha_Bsc = {
    bounce = net_bounce.nb2021,
    movement = movement.CradleSway,
    physics = net_physics.ItalyNT,
    net3d = net3D.OriginalH1,
    shape = Shape.HerthaNet,
    pattern = "P091",
    color_id = "4125",
    sound_file = "SE_Movement"
},
Hamburger_SV = {
    bounce = net_bounce.nb15,
    movement = movement.Balanced3,
    physics = net_physics.SItalyNT,
    net3d = net3D.OriginalT2,
    shape = Shape.NetOriginal,
    pattern = "P078",
    color_id = "0129",
    sound_file = "SE_Movement"
},
Hannover_96 = {
    bounce = net_bounce.nb20,
    movement = movement.Balanced3,
    physics = net_physics.EnglandN,
    net3d = net3D.Original,
    shape = Shape.HannoverNet,
    pattern = "P078",
    color_id = "0228",
    sound_file = "SE_Movement"
},
FC_Nurnberg = {
    bounce = net_bounce.nb05_9,
    movement = movement.DeepPocketWave,
    physics = net_physics.EnglandN,
    net3d = net3D.Original,
    shape = Shape.NurnbergNet,
    pattern = "P006",
    color_id = "0437",
    sound_file = "SE_Movement"
},
FC_Kaiserslautern = {
    bounce = net_bounce.nb05_9,
    movement = movement.FirmSnappy2,
    physics = net_physics.EnglandN,
    net3d = net3D.Original,
    shape = Shape.KaiserslauternNet,
    pattern = "P084",
    color_id = "0230",
    sound_file = "SE_Movement"
},
Greuther_Furth = {
    bounce = net_bounce.nb05_9,
    movement = movement.DeepPocketWave,
    physics = net_physics.EnglandN,
    net3d = net3D.Original,
    shape = Shape.GreutherNet,
    pattern = "P078",
    color_id = "4133",
    sound_file = "SE_Movement"
},
Karlsruher_SC = {
    bounce = net_bounce.nb20,
    movement = movement.CornerFeather,
    physics = net_physics.EnglandN,
    net3d = net3D.Original,
    shape = Shape.KarlsruherNet,
    pattern = "P078",
    color_id = "4136",
    sound_file = "SE_Movement"
},
SC_Paderborn = {
    bounce = net_bounce.nb20,
    movement = movement.Balanced3,
    physics = net_physics.SIPL,
    net3d = net3D.OriginalT1,
    shape = Shape.NetOriginal,
    pattern = "P003",
    color_id = "4324",
    sound_file = "SE_Movement"
},
FC_Magdeburg = {
    bounce = net_bounce.nb20,
    movement = movement.Snappy2,
    physics = net_physics.SItalyNT,
    net3d = net3D.OriginalT2L1,
    shape = Shape.Real2,
    pattern = "P078",
    color_id = "9018",
    sound_file = "SE_Movement"
},
Schalke = {
    bounce = net_bounce.nb05_9,
    movement = movement.FirmSnappy18,
    physics = net_physics.EnglandN,
    net3d = net3D.OriginalT1,
    shape = Shape.SchalkeNet,
    pattern = "P003",
    color_id = "0184",
    sound_file = "SE_Movement"
},
TSV_1860_München = {
    bounce = net_bounce.nb05_10,
    movement = movement.FC26_3,
    physics = net_physics.OriginalNL2,
    net3d = net3D.Original,
    shape = Shape.TSVNet,
    pattern = "P078",
    color_id = "4138",
    sound_file = "SE_Movement"
},
Dynamo_Dresden = {
    bounce = net_bounce.nb05_9,
    movement = movement.AiryPocket,
    physics = net_physics.SItalyNT,
    net3d = net3D.OriginalT1L1,
    shape = Shape.DresdenNet,
    pattern = "P078",
    color_id = "4129",
    sound_file = "SE_Movement"
},
Hansa_Rostock = {
    bounce = net_bounce.nb03_8,
    movement = movement.WhipDampHybrid ,
    physics = net_physics.EnglandN,
    net3d = net3D.Original,
    shape = Shape.HansaNet,
    pattern = "P078",
    color_id = "0229",
    sound_file = "SE_Movement"
},

--  Cups	
DFB_Pokal = {
    bounce = net_bounce.nb20,
    movement = movement.FIFA2,
    physics = net_physics.FIFA,
    net3d = net3D.OriginalT3L1,
    shape = Shape.Real,
    pattern = "P060",
    goalnetcolor = "NC07",
    n_of_strings = "8000",
    rod_position = "8000",
    sound_file = "SE_Move0002",
},
DFL_Supercup_Berlin = {
    bounce = net_bounce.nb20,
    movement = movement.FIFA2,
    physics = net_physics.FIFA,
    net3d = net3D.OriginalT3L1,
    shape = Shape.Real,
    pattern = "P060",
    goalnetcolor = "NC07",
    n_of_strings = "8000",
    rod_position = "8000",
    sound_file = "SE_Move0002",
},
DFL_Supercup_München = {
    bounce = net_bounce.nb05_10,
    movement = movement.FC26_3,
    physics = net_physics.OriginalNL2,
    net3d = net3D.Original,
    shape = Shape.BayernNet,
    pattern = "P006",
    color_id = "0127",
    sound_file = "SE_Movement"
},
DFL_Supercup_Dortmund = {
    bounce = net_bounce.nb05_10,
    movement = movement.RippleFade2,
    physics = net_physics.OriginalNL2,
    net3d = net3D.Original,
    shape = Shape.DortmundNet,
    pattern = "P006",
    color_id = "0126",
    sound_file = "SE_Move0003"
},
DFL_Supercup_Leipzig = {
    bounce = net_bounce.nb05_8,
    movement = movement.Deadstop1,
    physics = net_physics.EnglandN,
    net3d = net3D.Original,
    shape = Shape.LeipzigNet,
    pattern = "P060",
    color_id = "5010",
    sound_file = "SE_Move0004"
},

--  Classic
Borussia_Dortmund_2005 = {
    bounce = net_bounce.nb075_9,
    movement = movement.FirmSnappy17,
    physics = net_physics.OriginalNL2,
    net3d = net3D.Original,
    shape = Shape.Dortmund2005,
    pattern = "P078",
    goalnetcolor = "NC00",
    n_of_strings = "0126",
    rod_position = "0126",
    sound_file = "SE_Movement"
},

--//================================================================================================================================================================//

-- FRANCE
-- Ligue 1
Angers = {
    bounce = net_bounce.nbOriginalBT,
    movement = movement.FirmSnappy2,
    physics = net_physics.PIPLNT,
    net3d = net3D.OriginalH1,
    shape = Shape.CurveNet6,
    pattern = "P088",
    color_id = "0403",
    sound_file = "SE_Movement"
},
Auxerre = {
    bounce = net_bounce.nbOriginalB1,
    movement = movement.Firm3,
    physics = net_physics.PIPL,
    net3d = net3D.OriginalT2L1,
    shape = Shape.NetOriginal,
    pattern = "P043",
    color_id = "0180",
    sound_file = "SE_Movement"
},
Brest = {
    bounce = net_bounce.nbOriginalB1,
    movement = movement.FirmSnappy2,
    physics = net_physics.SIPLNT,
    net3d = net3D.OriginalH1,
    shape = Shape.CurveNet6,
    pattern = "P006",
    color_id = "1329",
    sound_file = "SE_Move0001"
},
Le_Havre = {
    bounce = net_bounce.nbOriginalB1,
    movement = movement.Firm3,
    physics = net_physics.PIPL,
    net3d = net3D.OriginalT2L1,
    shape = Shape.NetOriginal,
    pattern = "P098",
    color_id = "0413",
    sound_file = "SE_Move0001"
},
Lens = {
    bounce = net_bounce.nbNormal2,
    movement = movement.RippleFade2,
    physics = net_physics.PIPLNT,
    net3d = net3D.Original,
    shape = Shape.LensNet,
    pattern = "P067",
    color_id = "0182",
    sound_file = "SE_Move0003"
},
Lille = {
    bounce = net_bounce.nb05_9,
    movement = movement.RippleFade5_0,
    physics = net_physics.PIPLNT,
    net3d = net3D.Original,
    shape = Shape.LilleNet,
    pattern = "P078",
    color_id = "0213",
    sound_file = "SE_Movement"
},
Lyon = {
    bounce = net_bounce.nb05_9,
    movement = movement.RippleFade5_0,
    physics = net_physics.PIPLN,
    net3d = net3D.Original,
    shape = Shape.LyonNet,
    pattern = "P078",
    color_id = "0181",
    sound_file = "SE_Move0004"
},
Marseille = {
    bounce = net_bounce.nbOriginalT,
    movement = movement.MoveEPL,
    physics = net_physics.ItalyN,
    net3d = net3D.OriginalT3,
    shape = Shape.MarseilleNet,
    pattern = "P084",
    color_id = "0113",
    sound_file = "SE_Movement"
},
Monaco = {
    bounce = net_bounce.nb05_9,
    movement = movement.Balanced3,
    physics = net_physics.PItalyNT,
    net3d = net3D.OriginalL1,
    shape = Shape.ImprovedMidDeep,
    pattern = "P067",
    color_id = "0112",
    sound_file = "SE_Move0003"
},
Montpellier = {
    bounce = net_bounce.nbOT8,
    movement = movement.FirmSnappy2,
    physics = net_physics.PIPLN,
    net3d = net3D.Original,
    shape = Shape.LyonNet,
    pattern = "P078",
    color_id = "0215",
    sound_file = "SE_Move0002"
},
Nantes = {
    bounce = net_bounce.nb03_10,
    movement = movement.Firm3,
    physics = net_physics.UIPL,
    net3d = net3D.OriginalT1H1,
    shape = Shape.NantesNet,
    pattern = "P006",
    color_id = "0216",
    sound_file = "SE_Move0003"
},
Nice = {
    bounce = net_bounce.nb03_6,
    movement = movement.Balanced4,
    physics = net_physics.UIPL,
    net3d = net3D.OriginalT1H1,
    shape = Shape.NiceNet,
    pattern = "P044",
    color_id = "0217",
    sound_file = "SE_Move0003"
},
PSG = {
    bounce = net_bounce.nbNormal2,
    movement = movement.FC26_8,
    physics = net_physics.OriginalNL1,
    net3d = net3D.Original,
    shape = Shape.PSGNet,
    pattern = "P078",
    color_id = "0114",
    sound_file = "SE_Move0003",
},
Rennes = {
    bounce = net_bounce.nbNormal2,
    movement = movement.Balanced4,
    physics = net_physics.EnglandNTLow,
    net3d = net3D.Original,
    shape = Shape.RennesNet,
    pattern = "P006",
    color_id = "0218",
    sound_file = "SE_Move0001"
},
Stade_De_Reims = {
    bounce = net_bounce.nb20,
    movement = movement.NXT6,
    physics = net_physics.OriginalNL2,
    net3d = net3D.OLDPES,
    shape = Shape.ReimsNet,
    pattern = "P006",
    color_id = "1330",
    sound_file = "SE_Move0003"
},
Strasbourg = {
    bounce = net_bounce.nb18,
    movement = movement.Balanced4,
    physics = net_physics.PIPLN,
    net3d = net3D.OriginalT4,
    shape = Shape.City,
    pattern = "P006",
    color_id = "4213",
    sound_file = "SE_Move0004"
},
St_Etienne = {
    bounce = net_bounce.nbOriginalBT,
    movement = movement.Balanced4,
    physics = net_physics.PIPLNT,
    net3d = net3D.OriginalT4,
    shape = Shape.StEtienneNet,
    pattern = "P006",
    color_id = "0418",
    sound_file = "SE_Movement"
},
Toulouse = {
    bounce = net_bounce.nb02_7,
    movement = movement.Balanced4,
    physics = net_physics.OriginalNL2,
    net3d = net3D.OriginalL1,
    shape = Shape.ToulouseNet,
    pattern = "P088",
    color_id = "0221",
    sound_file = "SE_Move0003"
},

-- Ligue 2
Annecy = {
    bounce = net_bounce.nbMed5,
    movement = movement.Firm3,
    physics = net_physics.PItalyN,
    net3d = net3D.OriginalT1,
    shape = Shape.PerfectSquareL,
    pattern = "P003",
    color_id = "5685",
    sound_file = "SE_Movement"
},
Ajaccio = {
    bounce = net_bounce.nb17,
    movement = movement.Porto,
    physics = net_physics.Porto,
    net3d = net3D.Original,
    shape = Shape.Ajax,
    pattern = "0209",
    color_id = "0209",
    sound_file = "SE_Movement"
},
Amiens_SC = {
    bounce = net_bounce.nb17,
    movement = movement.Firm3,
    physics = net_physics.ItalyNT,
    net3d = net3D.OriginalT1,
    shape = Shape.NetOriginal,
    pattern = "P089",
    color_id = "4200",
    sound_file = "SE_Movement"
},
SC_Bastia = {
    bounce = net_bounce.nb17,
    movement = movement.NXTOg,
    physics = net_physics.PItalyNT,
    net3d = net3D.Original,
    shape = Shape.NetOriginalS,
    pattern = "P078",
    color_id = "0210",
    sound_file = "SE_Movement"
},
Bordeaux = {
    bounce = net_bounce.nb15,
    movement = movement.Original,
    physics = net_physics.Normal,
    net3d = net3D.Original,
    shape = Shape.MidTriangleNet,
    pattern = "0115",
    color_id = "0115",
    sound_file = "SE_Movement"
},
Stade_Malherbe_Caen = {
    bounce = net_bounce.nb17,
    movement = movement.Firm3,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.NetOriginal,
    pattern = "P089",
    color_id = "0405",
    sound_file = "SE_Movement"
},
Clermont = {
    bounce = net_bounce.nb20,
    movement = movement.EPL,
    physics = net_physics.Porto,
    net3d = net3D.OriginalT1,
    shape = Shape.NetOriginal,
    pattern = "0407",
    color_id = "0407",
    sound_file = "SE_Movement"
},
USL_Dunkerque = {
    bounce = net_bounce.nb19,
    movement = movement.FirmSnappy2,
    physics = net_physics.SItalyNT,
    net3d = net3D.Original,
    shape = Shape.NetOriginalS,
    pattern = "P078",
    color_id = "4206",
    sound_file = "SE_Movement"
},
Grenoble_Foot = {
    bounce = net_bounce.nb10,
    movement = movement.Firm3,
    physics = net_physics.PItalyNT,
    net3d = net3D.Original,
    shape = Shape.SAfricaWC2010,
    pattern = "P078",
    color_id = "4370",
    sound_file = "SE_Movement"
},
Troyes = {
    bounce = net_bounce.nb075_9,
    movement = movement.FirmSnappy14,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.TroyesNet,
    pattern = "P078",
    color_id = "0420",
    sound_file = "SE_Movement"
},
Paris_FC = {
    bounce = net_bounce.nb18,
    movement = movement.QuickResponse,
    physics = net_physics.PIPL,
    net3d = net3D.OriginalT1L1,
    shape = Shape.MidDeepNet,
    pattern = "P010",
    color_id = "4211",
    sound_file = "SE_Move0004"
},
Valenciennes_FC = {
    bounce = net_bounce.nb17,
    movement = movement.Bouncy,
    physics = net_physics.PL,
    net3d = net3D.Original,
    shape = Shape.NetOriginalS,
    pattern = "goal",
    color_id = "goal",
    sound_file = "SE_Movement"
},
Metz = {
    bounce = net_bounce.nb10,
    movement = movement.FIFA5,
    physics = net_physics.PortoLT,
    net3d = net3D.Belly,
    shape = Shape.Belly,
    pattern = "P078",
    color_id = "4123",
    sound_file = "SE_Move0002"
},
Lorient = {
    bounce = net_bounce.nb10,
    movement = movement.EPL,
    physics = net_physics.Porto,
    net3d = net3D.Original,
    shape = Shape.NetOriginal,
    pattern = "0414",
    color_id = "0414",
    sound_file = "SE_Movement"
},
Chamois_Niortais_FC = {
    bounce = net_bounce.nb17,
    movement = movement.Bouncy,
    physics = net_physics.PL,
    net3d = net3D.Original,
    shape = Shape.NetOriginalS,
    pattern = "goal",
    color_id = "goal",
    sound_file = "SE_Movement"
},
Stade_Lavallois = {
    bounce = net_bounce.nb17,
    movement = movement.Bouncy,
    physics = net_physics.PL,
    net3d = net3D.Original,
    shape = Shape.NetOriginalS,
    pattern = "goal",
    color_id = "goal",
    sound_file = "SE_Movement"
},
AC_Le_Havre = {
    bounce = net_bounce.nb17,
    movement = movement.Bouncy,
    physics = net_physics.PL,
    net3d = net3D.Original,
    shape = Shape.NetOriginalS,
    pattern = "goal",
    color_id = "goal",
    sound_file = "SE_Movement"
},
FC_Sochaux = {
    bounce = net_bounce.nb17,
    movement = movement.Bouncy,
    physics = net_physics.PL,
    net3d = net3D.Original,
    shape = Shape.NetOriginalS,
    pattern = "goal",
    color_id = "goal",
    sound_file = "SE_Movement"
},
EA_Guingamp = {
    bounce = net_bounce.nb17,
    movement = movement.Porto,
    physics = net_physics.Porto,
    net3d = net3D.Belly,
    shape = Shape.Belly,
    pattern = "0211",
    color_id = "0211",
    sound_file = "SE_Movement"
},
Pau_FC = {
    bounce = net_bounce.nb17,
    movement = movement.Bouncy,
    physics = net_physics.PL,
    net3d = net3D.Original,
    shape = Shape.NetOriginalS,
    pattern = "goal",
    color_id = "goal",
    sound_file = "SE_Movement"
},
Rodez_AF = {
    bounce = net_bounce.nb17,
    movement = movement.Bouncy,
    physics = net_physics.PL,
    net3d = net3D.Original,
    shape = Shape.NetOriginalS,
    pattern = "goal",
    color_id = "goal",
    sound_file = "SE_Movement"
},
Quevilly_Rouen_Metropole = {
    bounce = net_bounce.nb17,
    movement = movement.Bouncy,
    physics = net_physics.PL,
    net3d = net3D.Original,
    shape = Shape.NetOriginalS,
    pattern = "goal",
    color_id = "goal",
    sound_file = "SE_Movement"
},

--  Cups	
Coupe_de_France = {
    bounce = net_bounce.nb18,
    movement = movement.Porto,
    physics = net_physics.PortoT,
    net3d = net3D.Belly,
    shape = Shape.Belly,
    pattern = "P021",
    goalnetcolor = "0012",
    n_of_strings = "0012",
    rod_position = "0012",
    sound_file = "SE_Movement",
},
Trophee_des_Champions = {
    bounce = net_bounce.nb18,
    movement = movement.Porto,
    physics = net_physics.PortoT,
    net3d = net3D.Belly,
    shape = Shape.Belly,
    pattern = "P021",
    goalnetcolor = "0012",
    n_of_strings = "0012",
    rod_position = "0012",
    sound_file = "SE_Movement",
},

-- Classic Nets

PSG_2003 = {
    bounce = net_bounce.nb05_8,
    movement = movement.Firm14,
    physics = net_physics.PItalyN,
    net3d = net3D.OriginalT1,
    shape = Shape.WC26_Net1,
    pattern = "R006",
    color_id = "R006",
    sound_file = "SE_Move0003"
},

--//================================================================================================================================================================//

-- NETHERLANDS
-- Eredivisie
Ajax_Amsterdam = {
    bounce = net_bounce.nb03_8,
    movement = movement.FirmSnappy3,
    physics = net_physics.OriginalNL1,
    net3d = net3D.OriginalH5,
    shape = Shape.AjaxNet,
    pattern = "P078",
    color_id = "0116",
    sound_file = "SE_Move0001",
},
Az_Alkmaar = {
    bounce = net_bounce.nb6,
    movement = movement.Balanced3,
    physics = net_physics.IPL,
    net3d = net3D.Original,
    shape = Shape.AzNet,
    pattern = "P006",
    color_id = "0242",
    sound_file = "SE_Move0004",
},
Feyenoord = {
    bounce = net_bounce.nb10,
    movement = movement.FirmSnappy2,
    physics = net_physics.ItalyNT,
    net3d = net3D.Original,
    shape = Shape.FeyenoordNet,
    pattern = "P006",
    color_id = "0117",
    sound_file = "SE_Movement",
},
Fortuna_Sittard = {
    bounce = net_bounce.nb9,
    movement = movement.FirmSnappy2,
    physics = net_physics.OriginalNL3,
    net3d = net3D.Original,
    shape = Shape.SittardNet,
    pattern = "P078",
    color_id = "0345",
    sound_file = "SE_Movement",
},
GA_Eagles = {
    bounce = net_bounce.nb9,
    movement = movement.Firm3,
    physics = net_physics.PIPLNT,
    net3d = net3D.OriginalH1,
    shape = Shape.EaglesNet,
    pattern = "P088",
    color_id = "0346",
    sound_file = "SE_Movement",
},
Heracles_Almelo = {
    bounce = net_bounce.nb10,
    movement = movement.FirmSnappy2,
    physics = net_physics.POriginalNL1,
    net3d = net3D.OriginalT1,
    shape = Shape.NetOriginal,
    pattern = "P006",
    color_id = "0349",
    sound_file = "SE_Move0001",
},
Groningen = {
    bounce = net_bounce.nb18,
    movement = movement.FirmSnappy2,
    physics = net_physics.PItalyN,
    net3d = net3D.OriginalT1,
    shape = Shape.ImprovedMidDeep,
    pattern = "P078",
    color_id = "0244",
    sound_file = "SE_Move0003",
},
NEC = {
    bounce = net_bounce.nb8,
    movement = movement.Firm3,
    physics = net_physics.IPL,
    net3d = net3D.Original,
    shape = Shape.NECNet,
    pattern = "P003",
    color_id = "0247",
    sound_file = "SE_Movement",
},
PSV = {
    bounce = net_bounce.nbT8,
    movement = movement.FirmSnappy2,
    physics = net_physics.OriginalNL2,
    net3d = net3D.Original,
    shape = Shape.PSVNet,
    pattern = "P084",
    color_id = "0118",
    sound_file = "SE_Movement",
},
RKC = {
    bounce = net_bounce.nb20,
    movement = movement.FirmSnappy2,
    physics = net_physics.PortoT,
    net3d = net3D.Original,
    shape = Shape.RKCNet,
    pattern = "P089",
    color_id = "0254",
    sound_file = "SE_Movement",
},
SC_Heerenven = {
    bounce = net_bounce.nb10,
    movement = movement.Firm3,
    physics = net_physics.PortoLT,
    net3d = net3D.OriginalH1,
    shape = Shape.HeerenvenNet,
    pattern = "P003",
    color_id = "0245",
    sound_file = "SE_Movement",
},
Sparta_Rotterdam = {
    bounce = net_bounce.nb7,
    movement = movement.Porto,
    physics = net_physics.OriginalNL2,
    net3d = net3D.OriginalL1,
    shape = Shape.SpartaRNet,
    pattern = "P078",
    color_id = "0351",
    sound_file = "SE_Movement",
},
Twente = {
    bounce = net_bounce.nb03_9,
    movement = movement.Firm3,
    physics = net_physics.SEnglandNT,
    net3d = net3D.Original,
    shape = Shape.TwenteNet,
    pattern = "P091",
    color_id = "0250",
    sound_file = "SE_Move0004",
},
Utrecht = {
    bounce = net_bounce.nb15,
    movement = movement.FirmSnappy1,
    physics = net_physics.ItalyNT,
    net3d = net3D.Original,
    shape = Shape.UtrechtNet,
    pattern = "P010",
    color_id = "0251",
    sound_file = "SE_Move0002",
},
PEC_Zwolle = {
    bounce = net_bounce.nb01_7,
    movement = movement.Balanced4,
    physics = net_physics.OriginalNT2,
    net3d = net3D.OriginalH1,
    shape = Shape.ZwolleNet,
    pattern = "P006",
    color_id = "0256",
    sound_file = "SE_Movement",
},

-- Eerste Divisie
Almere_City = {
    bounce = net_bounce.nb6,
    movement = movement.Porto,
    physics = net_physics.Spain,
    net3d = net3D.OriginalT1,
    shape = Shape.NetOriginal,
    pattern = "P046",
    color_id = "1598",
    sound_file = "SE_Move0001",
},
Cambuur = {
    bounce = net_bounce.nb17,
    movement = movement.Original,
    physics = net_physics.Normal,
    net3d = net3D.Original,
    shape = Shape.MidDeepNet,
    pattern = "0338",
    color_id = "0338",
    sound_file = "SE_Movement",
},
Excelsior = {
    bounce = net_bounce.nb17,
    movement = movement.Porto,
    physics = net_physics.PortoL,
    net3d = net3D.Original,
    shape = Shape.MidDeepNet,
    pattern = "P021",
    color_id = "0344",
    sound_file = "SE_Move0001",
},
Vitesse = {
    bounce = net_bounce.nb15,
    movement = movement.EPL9,
    physics = net_physics.Italy,
    net3d = net3D.OriginalT1,
    shape = Shape.PerfectSquareL,
    pattern = "0252",
    color_id = "0252",
    sound_file = "SE_Movement",
},
Volendam = {
    bounce = net_bounce.nb05_9,
    movement = movement.FirmSnappy2,
    physics = net_physics.EnglandN,
    net3d = net3D.Original,
    shape = Shape.VolendamNet,
    pattern = "P078",
    color_id = "0253",
    sound_file = "SE_Movement",
},
Willem_II = {
    bounce = net_bounce.nb10,
    movement = movement.Firm3,
    physics = net_physics.PortoLT,
    net3d = net3D.OriginalH1,
    shape = Shape.CurveNet6,
    pattern = "P089",
    color_id = "0255",
    sound_file = "SE_Movement",
},

-- KNVB Cups
KNVB_Cup = {
    bounce = net_bounce.nbFIFA2,
    movement = movement.FIFA2,
    physics = net_physics.Italy,
    net3d = net3D.OriginalT2L1,
    shape = Shape.NetOriginal,
    pattern = "P080",
    goalnetcolor = "NC00",
    n_of_strings = "0117",
    rod_position = "0117",
    sound_file = "SE_Movement",
},
Johan_Cruyff_Shield = {
    bounce = net_bounce.nb075_10,
    movement = movement.FirmSnappy18,
    physics = net_physics.OriginalNL1,
    net3d = net3D.OriginalH5,
    shape = Shape.AjaxNet,
    pattern = "P078",
    goalnetcolor = "NC00",
    n_of_strings = "0116",
    rod_position = "0116",
    sound_file = "SE_Move0001",
},

--//================================================================================================================================================================//

-- SCOTLAND
-- Premiership
Aberdeen = {
    bounce = net_bounce.nbOT7,
    movement = movement.FirmSnappy9,
    physics = net_physics.SOriginalNL1,
    net3d = net3D.Original,
    shape = Shape.AberdeenNet,
    pattern = "P006",
    color_id = "1219",
    sound_file = "SE_Movement",
},
Celtic = {
    bounce = net_bounce.nbHigh1,
    movement = movement.Firm3,
    physics = net_physics.PortoLT,
    net3d = net3D.Original,
    shape = Shape.Belly,
    pattern = "P084",
    color_id = "0131",
    sound_file = "SE_Move0004",
},
Dundee = {
    bounce = net_bounce.nb20,
    movement = movement.FIFA2,
    physics = net_physics.PLow,
    net3d = net3D.Original,
    shape = Shape.DundeeNet,
    pattern = "P006",
    color_id = "2621",
    sound_file = "SE_Movement",
},
Dundee_United = {
    bounce = net_bounce.nb01_7,
    movement = movement.FirmSnappy2,
    physics = net_physics.OriginalNL6Low,
    net3d = net3D.Original,
    shape = Shape.Dundee_UtdNet,
    pattern = "P078",
    color_id = "1220",
    sound_file = "SE_Movement",
},
Hearts = {
    bounce = net_bounce.nb18,
    movement = movement.EPL9,
    physics = net_physics.OriginalNT1Low,
    net3d = net3D.Original,
    shape = Shape.HeartsNet,
    pattern = "P044",
    color_id = "1221",
    sound_file = "SE_Movement",
},
Hibernian = {
    bounce = net_bounce.nb20,
    movement = movement.Original,
    physics = net_physics.OriginalNT4,
    net3d = net3D.Original,
    shape = Shape.HibernianNet,
    pattern = "P006",
    color_id = "1222",
    sound_file = "SE_Move0001",
},
Kilmarnock = {
    bounce = net_bounce.nb7,
    movement = movement.EPL2,
    physics = net_physics.OriginalNT4,
    net3d = net3D.Original,
    shape = Shape.KilmarnockNet,
    pattern = "P006",
    color_id = "1985",
    sound_file = "SE_Movement",
},
Livingston = {
    bounce = net_bounce.nb01_7,
    movement = movement.FirmSnappy2,
    physics = net_physics.OriginalNL6Low,
    net3d = net3D.Original,
    shape = Shape.LivingstonNet,
    pattern = "P006",
    color_id = "5319",
    sound_file = "SE_Movement",
},
Motherwell = {
    bounce = net_bounce.nb006_8,
    movement = movement.EPL9,
    physics = net_physics.OriginalNL1,
    net3d = net3D.Original,
    shape = Shape.MotherwellNet,
    pattern = "P078",
    color_id = "1986",
    sound_file = "SE_Movement",
},
Rangers = {
    bounce = net_bounce.nb006_11,
    movement = movement.Balanced2,
    physics = net_physics.EnglandNT,
    net3d = net3D.Original,
    shape = Shape.SportingLisbonNet,
    pattern = "P058",
    color_id = "0132",
    sound_file = "SE_Movement",
},
Ross_County = {
    bounce = net_bounce.nb01_7,
    movement = movement.FirmSnappy2,
    physics = net_physics.OriginalNL6Low,
    net3d = net3D.Original,
    shape = Shape.Ross_CountyNet,
    pattern = "P078",
    color_id = "2622",
    sound_file = "SE_Movement",
},
St_Johnstone = {
    bounce = net_bounce.nb01_7,
    movement = movement.FirmSnappy2,
    physics = net_physics.OriginalNL6Low,
    net3d = net3D.Original,
    shape = Shape.St_JohnstoneNet,
    pattern = "P078",
    color_id = "2365",
    sound_file = "SE_Movement",
},
St_Mirren = {
    bounce = net_bounce.nb01_7,
    movement = movement.FirmSnappy2,
    physics = net_physics.OriginalNL6Low,
    net3d = net3D.Original,
    shape = Shape.St_MirrenNet,
    pattern = "P006",
    color_id = "1987",
    sound_file = "SE_Movement",
},

-- Scottish Cup
Scottish_Cup = {
    bounce = net_bounce.nb05_10,
    movement = movement.FirmSnappy18,
    physics = net_physics.OriginalNL2Low,
    net3d = net3D.Original,
    shape = Shape.HampdenNet,
    pattern = "P044",
    goalnetcolor = "0003",
    n_of_strings = "0003",
    rod_position = "0003",
    sound_file = "SE_Movement",
},

--//================================================================================================================================================================//

-- TURKEY
-- Super Lig
Adana_Demirspor = {
    bounce = net_bounce.nb075_7,
    movement = movement.FirmSnappy20,
    physics = net_physics.PProBalancedN,
    net3d = net3D.Original,
    shape = Shape.AdanaNet,
    pattern = "P006",
    color_id = "5348",
    sound_file = "SE_Movement",
},
Alanyaspor = {
    bounce = net_bounce.nb05_9,
    movement = movement.FIFA2,
    physics = net_physics.OriginalNL7Low,
    net3d = net3D.OriginalL1,
    shape = Shape.AlanyasporNet,
    pattern = "P089",
    color_id = "NC17",
    sound_file = "SE_Move0001",
},
Ankaragucu = {
    bounce = net_bounce.nb6,
    movement = movement.EPL9,
    physics = net_physics.Italy,
    net3d = net3D.OriginalT1L1,
    shape = Shape.MidDeepNet2,
    pattern = "P052",
    color_id = "5360",
    sound_file = "SE_Movement",
},
Antalyaspor = {
    bounce = net_bounce.nb6,
    movement = movement.EPL2,
    physics = net_physics.OriginalNT3Low,
    net3d = net3D.Original,
    shape = Shape.AntalyasporNet,
    pattern = "1989",
    color_id = "1989",
    sound_file = "SE_Movement",
},
Basaksehir = {
    bounce = net_bounce.nb6,
    movement = movement.EPL8,
    physics = net_physics.OriginalNL2,
    net3d = net3D.Original,
    shape = Shape.BasaksehirNet,
    pattern = "P089",
    color_id = "1995",
    sound_file = "SE_Movement",
},
Besiktas = {
    bounce = net_bounce.nb075_9,
    movement = movement.NXTOg,
    physics = net_physics.OriginalNL1High,
    net3d = net3D.Original,
    shape = Shape.BesiktasNet,
    pattern = "P060",
    color_id = "0273",
    sound_file = "SE_Movement",
},
Bodrum = {
    bounce = net_bounce.nbMed5,
    movement = movement.FirmSnappy2,
    physics = net_physics.OriginalNL5Low,
    net3d = net3D.Original,
    shape = Shape.BodrumNet,
    pattern = "P089",
    color_id = "5898",
    sound_file = "SE_Movement",
},
Eyupspor = {
    bounce = net_bounce.nb6,
    movement = movement.EPL3,
    physics = net_physics.OriginalNL1Low,
    net3d = net3D.Original,
    shape = Shape.KasimpasaNet,
    pattern = "P089",
    color_id = "2625",
    sound_file = "SE_Movement",
},
Fenerbahce = {
    bounce = net_bounce.nb08_10,
    movement = movement.NXTB2,
    physics = net_physics.SItalyNT,
    net3d = net3D.OriginalT4,
    shape = Shape.Fenerbahce,
    pattern = "P056",
    color_id = "0197",
    sound_file = "SE_Movement",
},
Galatasaray = {
    bounce = net_bounce.nb07_10,
    movement = movement.NXTB4,
    physics = net_physics.ItalyN,
    net3d = net3D.SmallNetH,
    shape = Shape.SmallNetTriangle,
    pattern = "P088",
    color_id = "0130",
    sound_file = "SE_Movement",
},
Gaziantep = {
    bounce = net_bounce.nb075_7,
    movement = movement.Firm2,
    physics = net_physics.OriginalNL3Low,
    net3d = net3D.Original,
    shape = Shape.GaziantepNet,
    pattern = "P006",
    color_id = "5356",
    sound_file = "SE_Movement",
},
Goztepe = {
    bounce = net_bounce.nbOT8,
    movement = movement.FirmSnappy12,
    physics = net_physics.SmallNetPhysics,
    net3d = net3D.Original,
    shape = Shape.GoztepeNet,
    pattern = "P062",
    color_id = "5203",
    sound_file = "SE_Movement",
},
Hatayspor = {
    bounce = net_bounce.nb10,
    movement = movement.EPL2,
    physics = net_physics.SOriginalNL5Low,
    net3d = net3D.Original,
    shape = Shape.HataysporNet,
    pattern = "P062",
    color_id = "5452",
    sound_file = "SE_Move0001",
},
Istanbulspor = {
    bounce = net_bounce.nb20,
    movement = movement.FIFA2,
    physics = net_physics.PLow,
    net3d = net3D.OriginalT2L1,
    shape = Shape.SmallNet,
    pattern = "P020",
    color_id = "5358",
    sound_file = "SE_Move0003",
},
Karagumruk = {
    bounce = net_bounce.nb6,
    movement = movement.Porto,
    physics = net_physics.PortoT,
    net3d = net3D.OriginalT1,
    shape = Shape.NetOriginal,
    pattern = "P036",
    color_id = "5652",
    sound_file = "SE_Movement",
},
Kasimpasa = {
    bounce = net_bounce.nb6,
    movement = movement.EPL3,
    physics = net_physics.OriginalNL1Low,
    net3d = net3D.Original,
    shape = Shape.KasimpasaNet,
    pattern = "P089",
    color_id = "2625",
    sound_file = "SE_Movement",
},
Kayserispor = {
    bounce = net_bounce.nb085_9,
    movement = movement.EPL5,
    physics = net_physics.ItalyN,
    net3d = net3D.OriginalH1,
    shape = Shape.KayserisporNet,
    pattern = "P006",
    color_id = "1996",
    sound_file = "SE_Movement",
},
Konyaspor = {
    bounce = net_bounce.nb075_9,
    movement = movement.EPL,
    physics = net_physics.PortoT,
    net3d = net3D.OriginalH1,
    shape = Shape.KonyasporNet,
    pattern = "P089",
    color_id = "5204",
    sound_file = "SE_Movement",
},
Pendikspor = {
    bounce = net_bounce.nb20,
    movement = movement.FIFA2,
    physics = net_physics.PLow,
    net3d = net3D.OriginalT2L1,
    shape = Shape.SmallNet,
    pattern = "P062",
    color_id = "5899",
    sound_file = "SE_Movement",
},
Rizespor = {
    bounce = net_bounce.nb01_8,
    movement = movement.EPL2,
    physics = net_physics.OriginalNT3Low,
    net3d = net3D.OriginalT2L1,
    shape = Shape.RizesporNet,
    pattern = "P006",
    color_id = "5354",
    sound_file = "SE_Movement",
},
Samsunspor = {
    bounce = net_bounce.nb7,
    movement = movement.EPL9,
    physics = net_physics.OriginalNL3Low,
    net3d = net3D.Original,
    shape = Shape.SamsunsporNet,
    pattern = "P010",
    color_id = "5361",
    sound_file = "SE_Movement",
},
Sivasspor = {
    bounce = net_bounce.nb075_9,
    movement = movement.NXTOg,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.SivassporNet,
    pattern = "P078",
    color_id = "1809",
    sound_file = "SE_Movement",
},
Trabzon = {
    bounce = net_bounce.nb01_7,
    movement = movement.FirmSnappy9,
    physics = net_physics.OriginalNL1Low,
    net3d = net3D.Original,
    shape = Shape.TrabzonNet,
    pattern = "P010",
    color_id = "1945",
    sound_file = "SE_Movement",
},

-- Turkish Cups
Turkish_Cup = {
    bounce = net_bounce.nb15,
    movement = movement.Porto,
    physics = net_physics.PortoL,
    net3d = net3D.Original,
    shape = Shape.NetOriginal,
    pattern = "5652",
    goalnetcolor = "5652",
    n_of_strings = "5652",
    rod_position = "5652",
    sound_file = "SE_Movement",
},
Turkish_Super_Cup = {
    bounce = net_bounce.nb19,
    movement = movement.EPL,
    physics = net_physics.PL,
    net3d = net3D.Original,
    shape = Shape.CampNouClassic,
    pattern = "5348",
    goalnetcolor = "5348",
    n_of_strings = "5348",
    rod_position = "5348",
    sound_file = "SE_Movement",
},

--//================================================================================================================================================================//

-- RUSSIA
-- RPL (Russian Premier League)
Akhmat = {
    bounce = net_bounce.nbMed5,
    movement = movement.FirmSnappy2,
    physics = net_physics.ItalyNT,
    net3d = net3D.OriginalT1,
    shape = Shape.NetOriginal,
    pattern = "P043",
    color_id = "5196",
    sound_file = "SE_Movement",
},
Akron_Tolyatti = {
    bounce = net_bounce.nb2021,
    movement = movement.EPL,
    physics = net_physics.IPLN,
    net3d = net3D.OriginalT1L1,
    shape = Shape.PerfectSquare,
    pattern = "P089",
    color_id = "4143",
    sound_file = "SE_Movement",
},
CSKA = {
    bounce = net_bounce.nb15,
    movement = movement.NXT6,
    physics = net_physics.ItalyNT,
    net3d = net3D.OriginalT1,
    shape = Shape.NetOriginal,
    pattern = "P078",
    color_id = "0101",
    sound_file = "SE_Movement",
},
Dinamo_Makhachkala = {
    bounce = net_bounce.nb17,
    movement = movement.Firm3,
    physics = net_physics.PItalyNT,
    net3d = net3D.OriginalL1,
    shape = Shape.ImprovedMidDeep,
    pattern = "P078",
    color_id = "9015",
    sound_file = "SE_Movement",
},
Dinamo_Moscow = {
    bounce = net_bounce.nb19,
    movement = movement.Porto,
    physics = net_physics.OriginalNL1Low,
    net3d = net3D.Original,
    shape = Shape.Dinamo_MoscowNet,
    pattern = "P078",
    color_id = "1753",
    sound_file = "SE_Movement",
},
Fakel = {
    bounce = net_bounce.nb7,
    movement = movement.Spain,
    physics = net_physics.SItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectSquare,
    pattern = "P089",
    color_id = "5297",
    sound_file = "SE_Movement",
},
Khimki = {
    bounce = net_bounce.nbMed5,
    movement = movement.FirmSnappy2,
    physics = net_physics.Normal,
    net3d = net3D.OriginalT3L1,
    shape = Shape.Lic,
    pattern = "P088",
    color_id = "5298",
    sound_file = "SE_Movement",
},
Krasnodar = {
    bounce = net_bounce.nbMed5,
    movement = movement.FirmSnappy2,
    physics = net_physics.SItalyN,
    net3d = net3D.OriginalH1,
    shape = Shape.NetOriginalS,
    pattern = "P078",
    color_id = "2618",
    sound_file = "SE_Movement",
},
Krylia_Sovetov = {
    bounce = net_bounce.nb2021,
    movement = movement.EPL,
    physics = net_physics.IPLN,
    net3d = net3D.OriginalT1,
    shape = Shape.PerfectSquareL,
    pattern = "P089",
    color_id = "4143",
    sound_file = "SE_Movement",
},
Lokomotiv_Moscow = {
    bounce = net_bounce.nbx,
    movement = movement.FirmSnappy2,
    physics = net_physics.PIPL,
    net3d = net3D.OriginalT4,
    shape = Shape.City,
    pattern = "P078",
    color_id = "0271",
    sound_file = "SE_Movement",
},
Nizhny_Novgorod = {
    bounce = net_bounce.nb15,
    movement = movement.Balanced4,
    physics = net_physics.SItalyNT,
    net3d = net3D.OriginalT1H1,
    shape = Shape.NetOriginal,
    pattern = "P082",
    color_id = "5300",
    sound_file = "SE_Movement",
},
Orenburg = {
    bounce = net_bounce.nb2021,
    movement = movement.FirmSnappy6,
    physics = net_physics.ItalyFirmT,
    net3d = net3D.OriginalT2L1,
    shape = Shape.HexagonalNet,
    pattern = "P084",
    color_id = "5301",
    sound_file = "SE_Movement",
},
Rostov = {
    bounce = net_bounce.nb2021,
    movement = movement.FirmSnappy5,
    physics = net_physics.PItalyNT,
    net3d = net3D.OriginalT1,
    shape = Shape.ImprovedMidDeep,
    pattern = "P078",
    color_id = "2229",
    sound_file = "SE_Movement",
},
Rubin_Kazan = {
    bounce = net_bounce.nb05_9,
    movement = movement.FirmSnappy2,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.RubinNet,
    pattern = "P091",
    color_id = "1941",
    sound_file = "SE_Movement",
},
Spartak_Moskva = {
    bounce = net_bounce.nb8T,
    movement = movement.FirmSnappy2,
    physics = net_physics.PItalyN,
    net3d = net3D.OriginalH1,
    shape = Shape.MidCurveNet2,
    pattern = "P089",
    color_id = "0135",
    sound_file = "SE_Movement",
},
Ural = {
    bounce = net_bounce.nb19,
    movement = movement.Italy,
    physics = net_physics.Italy,
    net3d = net3D.Original,
    shape = Shape.NetOriginalS,
    pattern = "5201",
    color_id = "5201",
    sound_file = "SE_Movement",
},
Zenit = {
    bounce = net_bounce.nb2021,
    movement = movement.FirmSnappy2,
    physics = net_physics.PItalyNT,
    net3d = net3D.OriginalT1,
    shape = Shape.ImprovedMidDeep,
    pattern = "P089",
    color_id = "1218",
    sound_file = "SE_Movement",
},

-- Russian Cups
Russian_Cup = {
    bounce = net_bounce.nb20,
    movement = movement.Italy,
    physics = net_physics.Italy,
    net3d = net3D.Original,
    shape = Shape.PerfectSquare,
    pattern = "5295",
    goalnetcolor = "5295",
    n_of_strings = "5295",
    rod_position = "5295",
    sound_file = "SE_Movement",
},
Russian_Super_Cup = {
    bounce = net_bounce.nb20,
    movement = movement.Original,
    physics = net_physics.Normal,
    net3d = net3D.Original,
    shape = Shape.PerfectSquareH,
    pattern = "1218",
    goalnetcolor = "1218",
    n_of_strings = "1218",
    rod_position = "1218",
    sound_file = "SE_Movement",
},

--//================================================================================================================================================================//

-- DENMARK
-- 3F SUPERLIGA
Aalborg = {
    bounce = net_bounce.nb9,
    movement = movement.EPL6,
    physics = net_physics.POriginalNL3High,
    net3d = net3D.Original,
    shape = Shape.AalborgNet,
    pattern = "P082",
    color_id = "1818",
    sound_file = "SE_Movement",
},
Aarhus_GF = {
    bounce = net_bounce.nbMed5,
    movement = movement.Balanced3,
    physics = net_physics.ItalyN,
    net3d = net3D.OriginalT1,
    shape = Shape.CurveNet2,
    pattern = "P078",
    color_id = "2067",
    sound_file = "SE_Movement",
},
Brondby = {
    bounce = net_bounce.nb075_7,
    movement = movement.Firm3,
    physics = net_physics.SmallNetPhysics,
    net3d = net3D.Original,
    shape = Shape.BrondbyNet,
    pattern = "P083",
    color_id = "1832",
    sound_file = "SE_Movement",
},
Copenhagen = {
    bounce = net_bounce.nb075_9,
    movement = movement.NXTB1,
    physics = net_physics.OriginalNL2Low,
    net3d = net3D.Original,
    shape = Shape.CopenhagenNet,
    pattern = "P019",
    color_id = "1207",
    sound_file = "SE_Move0001",
},
Lyngby = {
    bounce = net_bounce.nb15,
    movement = movement.Balanced6,
    physics = net_physics.OriginalNT1,
    net3d = net3D.Original,
    shape = Shape.LyngbyNet,
    pattern = "P078",
    color_id = "5224",
    sound_file = "SE_Movement",
},
Midtjylland = {
    bounce = net_bounce.nb05_10,
    movement = movement.EPLOg,
    physics = net_physics.OriginalNT2Low,
    net3d = net3D.Original,
    shape = Shape.MidtjyllandNet,
    pattern = "P031",
    color_id = "2069",
    sound_file = "SE_Movement",
},
Nordsjælland = {
    bounce = net_bounce.nb20,
    movement = movement.EPL9,
    physics = net_physics.Italy,
    net3d = net3D.Original,
    shape = Shape.NordsjællandNet,
    pattern = "P091",
    color_id = "1208",
    sound_file = "SE_Movement",
},
Odense = {
    bounce = net_bounce.nb6,
    movement = movement.EPL9,
    physics = net_physics.Normal,
    net3d = net3D.Original,
    shape = Shape.NetOriginal,
    pattern = "P091",
    color_id = "2070",
    sound_file = "SE_Movement",
},
Randers = {
    bounce = net_bounce.nb19,
    movement = movement.FirmSnappy18,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.RandersNet,
    pattern = "P091",
    color_id = "2071",
    sound_file = "SE_Movement",
},
Silkeborg = {
    bounce = net_bounce.nb075_7,
    movement = movement.FirmSnappy18,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.SilkeborgNet,
    pattern = "P003",
    color_id = "5225",
    sound_file = "SE_Movement",
},
Sonderjyske = {
    bounce = net_bounce.nb05_10,
    movement = movement.EPLOg,
    physics = net_physics.OriginalNT2Low,
    net3d = net3D.Original,
    shape = Shape.SonderjyskeNet,
    pattern = "P034",
    color_id = "5226",
    sound_file = "SE_Movement",
},
Vejle_Boldklub = {
    bounce = net_bounce.nb10,
    movement = movement.EPL6,
    physics = net_physics.OriginalNL2Low,
    net3d = net3D.Original,
    shape = Shape.VejleNet,
    pattern = "P091",
    color_id = "5235",
    sound_file = "SE_Movement",
},
Viborg = {
    bounce = net_bounce.nb19,
    movement = movement.Porto,
    physics = net_physics.SOriginalNL1,
    net3d = net3D.Original,
    shape = Shape.ViborgNet,
    pattern = "P089",
    color_id = "5237",
    sound_file = "SE_Movement",
},

-- Nordic Bet Liga
Horsens = {
    bounce = net_bounce.nb20,
    movement = movement.FIFA2,
    physics = net_physics.PLow,
    net3d = net3D.OriginalT2L1,
    shape = Shape.SmallNet,
    pattern = "2066",
    color_id = "2066",
    sound_file = "SE_Movement",
},
Hvidovre_IF = {
    bounce = net_bounce.nb10,
    movement = movement.EPL2,
    physics = net_physics.Italy,
    net3d = net3D.Original,
    shape = Shape.PerfectSquareL,
    pattern = "P060",
    color_id = "5423",
    sound_file = "SE_Movement",
},

-- DBU Cup
DBU_Cup = {
    bounce = net_bounce.nb20,
    movement = movement.Original,
    physics = net_physics.Original,
    net3d = net3D.Original,
    shape = Shape.NetOriginal,
    pattern = "1207",
    goalnetcolor = "1207",
    n_of_strings = "1207",
    rod_position = "1207",
    sound_file = "SE_Movement",
},

--//================================================================================================================================================================//

-- BELGIUM
-- Jupiler Pro League
Anderlecht = {
    bounce = net_bounce.nb075_9,
    movement = movement.Elastic,
    physics = net_physics.PIPL,
    net3d = net3D.Original,
    shape = Shape.AnderlechtNet,
    pattern = "P033",
    color_id = "0174",
    sound_file = "SE_Movement",
},
Antwerp = {
    bounce = net_bounce.nb05_10,
    movement = movement.Balanced2,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.AntwerpNet,
    pattern = "P091",
    color_id = "5191",
    sound_file = "SE_Movement",
},
Cercle_Brugge = {
    bounce = net_bounce.nb20,
    movement = movement.FirmSnappy2,
    physics = net_physics.PItalyNT,
    net3d = net3D.OriginalL1,
    shape = Shape.HexagonalNet,
    pattern = "P078",
    color_id = "2009",
    sound_file = "SE_Movement",
},
Charleroi = {
    bounce = net_bounce.nb05_8,
    movement = movement.Balanced8,
    physics = net_physics.PItalyNTLow,
    net3d = net3D.Original,
    shape = Shape.CharleroiNet,
    pattern = "P078",
    color_id = "2010",
    sound_file = "SE_Movement",
},
Club_Brugge = {
    bounce = net_bounce.nb20,
    movement = movement.FirmSnappy2,
    physics = net_physics.PItalyNT,
    net3d = net3D.Original,
    shape = Shape.BruggeNet,
    pattern = "P078",
    color_id = "0269",
    sound_file = "SE_Movement",
},
Genk = {
    bounce = net_bounce.nb05_10,
    movement = movement.Firm3,
    physics = net_physics.SItalyNTLow,
    net3d = net3D.Original,
    shape = Shape.GenkNet,
    pattern = "P091",
    color_id = "1195",
    sound_file = "SE_Movement",
},
Gent = {
    bounce = net_bounce.nbMed2,
    movement = movement.Balanced2,
    physics = net_physics.SIPL,
    net3d = net3D.OriginalT1,
    shape = Shape.NetOriginal,
    pattern = "P003",
    color_id = "1196",
    sound_file = "SE_Move0003",
},
Kortrijk = {
    bounce = net_bounce.nb20,
    movement = movement.Smooth,
    physics = net_physics.PIPL,
    net3d = net3D.OriginalT1,
    shape = Shape.NetOriginal,
    pattern = "P060",
    color_id = "2013",
    sound_file = "SE_Movement",
},
Mechelen = {
    bounce = net_bounce.nb20,
    movement = movement.RigidPlus,
    physics = net_physics.Italy,
    net3d = net3D.OriginalT1L1,
    shape = Shape.NetOriginal,
    pattern = "P081",
    color_id = "1200",
    sound_file = "SE_Movement",
},
OH_Leuven = {
    bounce = net_bounce.nbMed2,
    movement = movement.Firm,
    physics = net_physics.PIPL,
    net3d = net3D.OriginalT2L1,
    shape = Shape.IntermedNet3,
    pattern = "P043",
    color_id = "5217",
    sound_file = "SE_Movement",
},
Sint_Truiden_VV = {
    bounce = net_bounce.nb10,
    movement = movement.Firm,
    physics = net_physics.Italy,
    net3d = net3D.OriginalT1L1,
    shape = Shape.NetOriginal,
    pattern = "P078",
    color_id = "5194",
    sound_file = "SE_Movement",
},
Standard_Liege = {
    bounce = net_bounce.nb17,
    movement = movement.Firm,
    physics = net_physics.PIPL,
    net3d = net3D.OriginalT1L1,
    shape = Shape.BellyC,
    pattern = "P081",
    color_id = "1197",
    sound_file = "SE_Move0002",
},
UnionSG = {
    bounce = net_bounce.nb10,
    movement = movement.Balanced2,
    physics = net_physics.SItaly,
    net3d = net3D.OriginalT1L1,
    shape = Shape.SmallSquare2,
    pattern = "P060",
    color_id = "5220",
    sound_file = "SE_Movement",
},
Westerlo = {
    bounce = net_bounce.nb10,
    movement = movement.EPL,
    physics = net_physics.PIPL,
    net3d = net3D.OriginalH1,
    shape = Shape.CurveNet6,
    pattern = "P003",
    color_id = "5221",
    sound_file = "SE_Movement",
},

-- Challenger Pro League
Eupen = {
    bounce = net_bounce.nb6,
    movement = movement.Small,
    physics = net_physics.IPL,
    net3d = net3D.Original,
    shape = Shape.MidLowNet,
    pattern = "5190",
    color_id = "5190",
    sound_file = "SE_Movement",
},
Oostende = {
    bounce = net_bounce.nb15,
    movement = movement.EPL2,
    physics = net_physics.PL,
    net3d = net3D.Original,
    shape = Shape.MidLowNet,
    pattern = "5192",
    color_id = "5192",
    sound_file = "SE_Movement",
},
RWD_Molenbeek = {
    bounce = net_bounce.nb20,
    movement = movement.Firm,
    physics = net_physics.FIFA,
    net3d = net3D.OriginalT2L1,
    shape = Shape.NetOriginal,
    pattern = "P098",
    color_id = "5683",
    sound_file = "SE_Movement",
},
Zulte = {
    bounce = net_bounce.nb10,
    movement = movement.EPL,
    physics = net_physics.PLow,
    net3d = net3D.Original,
    shape = Shape.NetOriginal,
    pattern = "2019",
    color_id = "2019",
    sound_file = "SE_Movement",
},

-- Belgian Cups
Belgian_Super_Cup = {
    bounce = net_bounce.nb15,
    movement = movement.Porto,
    physics = net_physics.Porto,
    net3d = net3D.Original,
    shape = Shape.MidDeepNet,
    pattern = "0009",
    goalnetcolor = "0009",
    n_of_strings = "0009",
    rod_position = "0009",
    sound_file = "SE_Movement",
},
Croky_Cup = {
    bounce = net_bounce.nb15,
    movement = movement.Porto,
    physics = net_physics.Porto,
    net3d = net3D.Original,
    shape = Shape.MidDeepNet,
    pattern = "0009",
    goalnetcolor = "0009",
    n_of_strings = "0009",
    rod_position = "0009",
    sound_file = "SE_Movement",
},

--//================================================================================================================================================================//

-- PORTUGAL
-- Primeira Liga
Arouca_FC = {
    bounce = net_bounce.nbNormal2,
    movement = movement.Deadstop2,
    physics = net_physics.ItalyNLow,
    net3d = net3D.Original,
    shape = Shape.AroucaNet,
    pattern = "P047",
    color_id = "2380",
    sound_file = "SE_Movement",
},
Avs_Futebol_SAD = {
    bounce = net_bounce.nb05_8,
    movement = movement.Firm3,
    physics = net_physics.PIPLN,
    net3d = net3D.Original,
    shape = Shape.AVSNet,
    pattern = "P078",
    color_id = "5954",
    sound_file = "SE_Move0001",
},
Benfica = {
    bounce = net_bounce.nb2021,
    movement = movement.Balanced3,
    physics = net_physics.POriginalNL1,
    net3d = net3D.Original,
    shape = Shape.BenficaNet,
    pattern = "P078",
    color_id = "0191",
    sound_file = "SE_Move0001",
},
Casa_Pia = {
    bounce = net_bounce.nbNormal2,
    movement = movement.FirmSnappy20,
    physics = net_physics.SItalyN,
    net3d = net3D.OriginalL1,
    shape = Shape.PiaNet,
    pattern = "P078",
    color_id = "5633",
    sound_file = "SE_Movement",
},
CD_Nacional = {
    bounce = net_bounce.nbMed5,
    movement = movement.Deadstop2,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.NacionalNet,
    pattern = "P047",
    color_id = "1944",
    sound_file = "SE_Movement",
},
Estoril_Praia = {
    bounce = net_bounce.nb6,
    movement = movement.Firm3,
    physics = net_physics.PIPLN,
    net3d = net3D.Original,
    shape = Shape.NetOriginal,
    pattern = "P078",
    color_id = "2383",
    sound_file = "SE_Movement",
},
Estrela_da_Amadora = {
    bounce = net_bounce.nb17,
    movement = movement.Porto,
    physics = net_physics.PortoT,
    net3d = net3D.OriginalT1L1,
    shape = Shape.SAfricaWC2010,
    pattern = "P043",
    color_id = "5844",
    sound_file = "SE_Movement",
},
Famalicao_FC = {
    bounce = net_bounce.nb18,
    movement = movement.Balanced2,
    physics = net_physics.IPLow,
    net3d = net3D.OriginalT2L1,
    shape = Shape.NetOriginal,
    pattern = "P043",
    color_id = "5028",
    sound_file = "SE_Movement",
},
FC_Porto = {
    bounce = net_bounce.nb03_9,
    movement = movement.HardSnap2,
    physics = net_physics.POriginalNL1,
    net3d = net3D.Original,
    shape = Shape.PortoNet,
    pattern = "P078",
    color_id = "0192",
    sound_file = "SE_Move0001",
},
Gil_Vicente = {
    bounce = net_bounce.nb9,
    movement = movement.Balanced3,
    physics = net_physics.SItalyN,
    net3d = net3D.OriginalT1L1,
    shape = Shape.MidTriangleNet,
    pattern = "P098",
    color_id = "2387",
    sound_file = "SE_Movement",
},
Moreirense_FC = {
    bounce = net_bounce.nb8,
    movement = movement.Firm3,
    physics = net_physics.PLow,
    net3d = net3D.OriginalT2L1,
    shape = Shape.SmallNet,
    pattern = "P043",
    color_id = "2388",
    sound_file = "SE_Movement",
},
Rio_Ave = {
    bounce = net_bounce.nb20,
    movement = movement.NXTOg,
    physics = net_physics.PItalyNT,
    net3d = net3D.OriginalT1L1,
    shape = Shape.NetOriginal,
    pattern = "P019",
    color_id = "1979",
    sound_file = "SE_Movement",
},
Santa_Clara = {
    bounce = net_bounce.nbx,
    movement = movement.FirmSnappy2,
    physics = net_physics.PIPL,
    net3d = net3D.OriginalT4,
    shape = Shape.City,
    pattern = "P078",
    color_id = "2391",
    sound_file = "SE_Movement",
},
SC_Farense = {
    bounce = net_bounce.nb9,
    movement = movement.Snappy2,
    physics = net_physics.ItalyN,
    net3d = net3D.OriginalT2L1,
    shape = Shape.NetOriginalS,
    pattern = "P078",
    color_id = "4086",
    sound_file = "SE_Movement",
},
Sporting_Braga = {
    bounce = net_bounce.nb01_9,
    movement = movement.FirmSnappy20,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.BragaNet,
    pattern = "P084",
    color_id = "1974",
    sound_file = "SE_Move0004",
},
Sporting_CP = {
    bounce = net_bounce.nb05_9,
    movement = movement.FC26_7,
    physics = net_physics.EnglandN,
    net3d = net3D.Original,
    shape = Shape.SportingNet,
    pattern = "P078",
    color_id = "0193",
    sound_file = "SE_Move0004",
},
Vitoria_Guimaraes = {
    bounce = net_bounce.nb10,
    movement = movement.FIFA5,
    physics = net_physics.Italy,
    net3d = net3D.OriginalT3L1,
    shape = Shape.NetOriginal,
    pattern = "P089",
    color_id = "1804",
    sound_file = "SE_Movement",
},

-- Segunda Divisao
CS_Maritimo = {
    bounce = net_bounce.nb20,
    movement = movement.FIFA2,
    physics = net_physics.PLow,
    net3d = net3D.OriginalT2L1,
    shape = Shape.SmallNet,
    pattern = "1976",
    color_id = "1976",
    sound_file = "SE_Movement",
},
GD_Chaves = {
    bounce = net_bounce.nb9,
    movement = movement.EPL6,
    physics = net_physics.PLow,
    net3d = net3D.Original,
    shape = Shape.NetOriginal,
    pattern = "4085",
    color_id = "4085",
    sound_file = "SE_Movement",
},
Pacos_De_Ferreira = {
    bounce = net_bounce.nb17,
    movement = movement.EPL,
    physics = net_physics.IPL,
    net3d = net3D.Belly,
    shape = Shape.Belly,
    pattern = "1978",
    color_id = "1978",
    sound_file = "SE_Movement",
},
Portimonense_SC = {
    bounce = net_bounce.nb7,
    movement = movement.EPL9,
    physics = net_physics.IPLow,
    net3d = net3D.OriginalT2L1,
    shape = Shape.NetOriginal,
    pattern = "P043",
    color_id = "2369",
    sound_file = "SE_Movement",
},
Vizela_FC = {
    bounce = net_bounce.nb10,
    movement = movement.EPL9,
    physics = net_physics.IPLow,
    net3d = net3D.Original,
    shape = Shape.NetOriginalS,
    pattern = "P043",
    color_id = "5115",
    sound_file = "SE_Movement",
},
Boavista_FC = {
    bounce = net_bounce.nbMed5,
    movement = movement.Balanced3,
    physics = net_physics.PItalyN,
    net3d = net3D.OriginalT1L1,
    shape = Shape.NetOriginal,
    pattern = "P078",
    color_id = "4323",
    sound_file = "SE_Movement",
},
-- Portuguese Cups
Taca_de_Portugal = {
    bounce = net_bounce.nb6,
    movement = movement.Italy2,
    physics = net_physics.Italy,
    net3d = net3D.OriginalT1L1,
    shape = Shape.PerfectSquareH,
    pattern = "0119",
    goalnetcolor = "NC00",
    n_of_strings = "0091",
    rod_position = "0091",
    sound_file = "SE_Movement",
},
Supertaca_Candido_de_Oliveira = {
    bounce = net_bounce.nb6,
    movement = movement.Italy2,
    physics = net_physics.Italy,
    net3d = net3D.OriginalT1L1,
    shape = Shape.PerfectSquareH,
    pattern = "0119",
    goalnetcolor = "NC00",
    n_of_strings = "0091",
    rod_position = "0091",
    sound_file = "SE_Movement",
},

--//================================================================================================================================================================//

-- GREECE
-- Super League Greece
AE_Kifisias = {
    bounce = net_bounce.nb20,
    movement = movement.Italy,
    physics = net_physics.Italy,
    net3d = net3D.Original,
    shape = Shape.MidLowNet,
    pattern = "9020",
    color_id = "9020",
    sound_file = "SE_Movement",
},
AEK = {
    bounce = net_bounce.nbTest,
    movement = movement.Balanced3,
    physics = net_physics.PItalyN,
    net3d = net3D.SmallNet,
    shape = Shape.AEKNet,
    pattern = "P078",
    color_id = "0270",
    sound_file = "SE_Movement",
},
Aris_Thessaloniki = {
    bounce = net_bounce.nb10,
    movement = movement.Firm3,
    physics = net_physics.PItaly,
    net3d = net3D.OriginalT1L1,
    shape = Shape.CurveNet6,
    pattern = "P089",
    color_id = "1948",
    sound_file = "SE_Movement",
},
Asteras_Tripolis = {
    bounce = net_bounce.nb20,
    movement = movement.Firm3,
    physics = net_physics.ItalyN,
    net3d = net3D.OriginalB2L1,
    shape = Shape.CurveNet6,
    pattern = "P003",
    color_id = "2020",
    sound_file = "SE_Movement",
},
Atromitos_Athen = {
    bounce = net_bounce.nb15,
    movement = movement.Balanced3,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectSquareL,
    pattern = "P078",
    color_id = "2559",
    sound_file = "SE_Movement",
},
OFI_Crete = {
    bounce = net_bounce.nb17,
    movement = movement.NXTOg,
    physics = net_physics.ItalyN,
    net3d = net3D.OriginalL1,
    shape = Shape.CurveNet6,
    pattern = "P003",
    color_id = "2025",
    sound_file = "SE_Movement",
},
Olympiakos = {
    bounce = net_bounce.nb17,
    movement = movement.Balanced3,
    physics = net_physics.ItalyNT,
    net3d = net3D.OriginalT2,
    shape = Shape.NetOriginal,
    pattern = "P078",
    color_id = "0133",
    sound_file = "SE_Movement",
},
Panathinaikos = {
    bounce = net_bounce.nb10,
    movement = movement.NXTOg,
    physics = net_physics.SItalyN,
    net3d = net3D.OriginalT1L1,
    shape = Shape.PerfectSquareL,
    pattern = "P021",
    color_id = "0198",
    sound_file = "SE_Movement",
},
Panetolikos_FC = {
    bounce = net_bounce.nb15,
    movement = movement.Porto,
    physics = net_physics.PortoL,
    net3d = net3D.Original,
    shape = Shape.MidDeepNet,
    pattern = "P010",
    color_id = "2556",
    sound_file = "SE_Movement",
},
Panserraikos_FC = {
    bounce = net_bounce.nb20,
    movement = movement.Firm3,
    physics = net_physics.ItalyN,
    net3d = net3D.OriginalT2L1,
    shape = Shape.SmallNet,
    pattern = "P078",
    color_id = "9019",
    sound_file = "SE_Movement",
},
PAS_Giannina = {
    bounce = net_bounce.nb17,
    movement = movement.Firm3,
    physics = net_physics.UPIPL,
    net3d = net3D.OriginalH1,
    shape = Shape.MidDeepNet,
    pattern = "P088",
    color_id = "2607",
    sound_file = "SE_Movement",
},
PAS_Lamia = {
    bounce = net_bounce.nb18,
    movement = movement.EPLOg,
    physics = net_physics.PIPL,
    net3d = net3D.OriginalT1L1,
    shape = Shape.MidDeepNet,
    pattern = "P014",
    color_id = "2557",
    sound_file = "SE_Movement",
},
PAOK = {
    bounce = net_bounce.nb03_9,
    movement = movement.FC26_3,
    physics = net_physics.SItalyNT,
    net3d = net3D.Original,
    shape = Shape.PAOKNet,
    pattern = "P078",
    color_id = "1212",
    sound_file = "SE_Movement",
},
Volos_NPS = {
    bounce = net_bounce.nb9,
    movement = movement.Balanced3,
    physics = net_physics.PortoT,
    net3d = net3D.OLDPES,
    shape = Shape.MidDeepNet,
    pattern = "P078",
    color_id = "2555",
    sound_file = "SE_Movement",
},

-- Greek Cup
Greek_Cup = {
    bounce = net_bounce.nb20,
    movement = movement.Italy,
    physics = net_physics.Italy,
    net3d = net3D.Original,
    shape = Shape.PerfectSquare,
    pattern = "0091",
    goalnetcolor = "0091",
    n_of_strings = "0091",
    rod_position = "0091",
    sound_file = "SE_Movement",
},

--//================================================================================================================================================================//

-- SERBIA
-- Superliga Srbije
Cukaricki = {
    bounce = net_bounce.nbMed1,
    movement = movement.Firm3,
    physics = net_physics.PItalyN,
    net3d = net3D.Belly,
    shape = Shape.Belly,
    pattern = "P078",
    color_id = "2054",
    sound_file = "SE_Movement",
},
Javor = {
    bounce = net_bounce.nb6,
    movement = movement.Original,
    physics = net_physics.Normal,
    net3d = net3D.Belly,
    shape = Shape.Belly,
    pattern = "9027",
    color_id = "9027",
    sound_file = "SE_Movement",
},
Kolubara = {
    bounce = net_bounce.nb10,
    movement = movement.Original,
    physics = net_physics.Normal,
    net3d = net3D.Original,
    shape = Shape.NetOriginal,
    pattern = "9025",
    color_id = "9025",
    sound_file = "SE_Movement",
},
Mladost_GAT = {
    bounce = net_bounce.nb8,
    movement = movement.EPL,
    physics = net_physics.IPLow,
    net3d = net3D.Original,
    shape = Shape.NetOriginalS,
    pattern = "9022",
    color_id = "9022",
    sound_file = "SE_Movement",
},
Mladost_Lucani = {
    bounce = net_bounce.nb15,
    movement = movement.Porto,
    physics = net_physics.Porto,
    net3d = net3D.Original,
    shape = Shape.Ajax,
    pattern = "9026",
    color_id = "9026",
    sound_file = "SE_Movement",
},
Napredak = {
    bounce = net_bounce.nb6,
    movement = movement.EPL,
    physics = net_physics.IPL,
    net3d = net3D.Original,
    shape = Shape.MidLowNet,
    pattern = "9020",
    color_id = "9020",
    sound_file = "SE_Movement",
},
Novi_Pazar = {
    bounce = net_bounce.nbItaly,
    movement = movement.Bouncy,
    physics = net_physics.PL,
    net3d = net3D.Original,
    shape = Shape.Ajax,
    pattern = "9028",
    color_id = "9028",
    sound_file = "SE_Movement",
},
Partizan = {
    bounce = net_bounce.nb05_7,
    movement = movement.FirmSnappy20,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PartizanNet,
    pattern = "P035",
    color_id = "0272",
    sound_file = "SE_Movement",
},
Radnicki_KG = {
    bounce = net_bounce.nb7,
    movement = movement.Original,
    physics = net_physics.Normal,
    net3d = net3D.Belly,
    shape = Shape.Belly,
    pattern = "9023",
    color_id = "9023",
    sound_file = "SE_Movement",
},
Radnicki_Nis = {
    bounce = net_bounce.nb18,
    movement = movement.Porto,
    physics = net_physics.Porto,
    net3d = net3D.Belly,
    shape = Shape.Belly,
    pattern = "2053",
    color_id = "2053",
    sound_file = "SE_Movement",
},
Radnik = {
    bounce = net_bounce.nb15,
    movement = movement.EPL,
    physics = net_physics.IPL,
    net3d = net3D.Original,
    shape = Shape.MidLowNet,
    pattern = "9021",
    color_id = "9021",
    sound_file = "SE_Movement",
},
Red_Star = {
    bounce = net_bounce.nb075_8,
    movement = movement.FC26_3,
    physics = net_physics.EnglandNT,
    net3d = net3D.Original,
    shape = Shape.Red_StarNet,
    pattern = "P078",
    color_id = "1223",
    sound_file = "SE_Movement",
},
Spartak_Subotica = {
    bounce = net_bounce.nb8,
    movement = movement.Bouncy,
    physics = net_physics.PL,
    net3d = net3D.Original,
    shape = Shape.Ajax,
    pattern = "9019",
    color_id = "9019",
    sound_file = "SE_Movement",
},
TSC = {
    bounce = net_bounce.nb6,
    movement = movement.Original,
    physics = net_physics.Normal,
    net3d = net3D.Original,
    shape = Shape.NetOriginalS,
    pattern = "9018",
    color_id = "9018",
    sound_file = "SE_Movement",
},
Vojvodina = {
    bounce = net_bounce.nb8,
    movement = movement.EPL,
    physics = net_physics.IPLow,
    net3d = net3D.Original,
    shape = Shape.NetOriginalS,
    pattern = "2597",
    color_id = "2597",
    sound_file = "SE_Movement",
},
Vozdovac = {
    bounce = net_bounce.nb6,
    movement = movement.EPL,
    physics = net_physics.IPL,
    net3d = net3D.Original,
    shape = Shape.MidLowNet,
    pattern = "9024",
    color_id = "9024",
    sound_file = "SE_Movement",
},

--//================================================================================================================================================================//

-- SWITZERLAND
-- Super League
Basel = {
    bounce = net_bounce.nb01_7,
    movement = movement.FirmSnappy20,
    physics = net_physics.ItalyNLow,
    net3d = net3D.Original,
    shape = Shape.BaselNet,
    pattern = "P003",
    color_id = "1706",
    sound_file = "SE_Movement",
},
FC_Lausanne = {
    bounce = net_bounce.nbT8,
    movement = movement.FirmSnappy2,
    physics = net_physics.OriginalNT2,
    net3d = net3D.OriginalH1,
    shape = Shape.LausanneNet,
    pattern = "P006",
    color_id = "4964",
    sound_file = "SE_Movement",
},
FC_Sion = {
    bounce = net_bounce.nb2021,
    movement = movement.Balanced4,
    physics = net_physics.OriginalNT5,
    net3d = net3D.Original,
    shape = Shape.SionNet,
    pattern = "P006",
    color_id = "1955",
    sound_file = "SE_Movement",
},
Grasshopper = {
    bounce = net_bounce.nb15,
    movement = movement.Firm3,
    physics = net_physics.ItalyN,
    net3d = net3D.OriginalT1H1,
    shape = Shape.ZurichNet,
    pattern = "P088",
    color_id = "1957",
    sound_file = "SE_Movement",
},
Lugano = {
    bounce = net_bounce.nb10,
    movement = movement.Firm3,
    physics = net_physics.PIPL,
    net3d = net3D.OriginalT1L1,
    shape = Shape.LuganoNet,
    pattern = "P078",
    color_id = "4965",
    sound_file = "SE_Movement",
},
Luzern = {
    bounce = net_bounce.nb18,
    movement = movement.EPL2,
    physics = net_physics.OriginalNL3,
    net3d = net3D.OriginalH1,
    shape = Shape.LuzernNet,
    pattern = "P006",
    color_id = "4962",
    sound_file = "SE_Movement",
},
Servette_FC = {
    bounce = net_bounce.nbOT9,
    movement = movement.FirmSnappy5,
    physics = net_physics.OriginalNL2,
    net3d = net3D.Original,
    shape = Shape.ServetteNet,
    pattern = "P006",
    color_id = "1958",
    sound_file = "SE_Movement",
},
St_Gallen = {
    bounce = net_bounce.nb18,
    movement = movement.EPL2,
    physics = net_physics.Spain,
    net3d = net3D.Original,
    shape = Shape.St_GallenNet,
    pattern = "P006",
    color_id = "4937",
    sound_file = "SE_Movement",
},
Young_Boys = {
    bounce = net_bounce.nbOT6,
    movement = movement.Snappy2,
    physics = net_physics.EPL,
    net3d = net3D.Lic,
    shape = Shape.PerfectSquareH,
    pattern = "P006",
    color_id = "1950",
    sound_file = "SE_Movement",
},
Zurich = {
    bounce = net_bounce.nb15,
    movement = movement.Firm3,
    physics = net_physics.ItalyN,
    net3d = net3D.OriginalT1H1,
    shape = Shape.ZurichNet,
    pattern = "P088",
    color_id = "1957",
    sound_file = "SE_Movement",
},
--//================================================================================================================================================================//

-- AUSTRIA
-- Bundesliga
LASK_Linz = {
    bounce = net_bounce.nb18,
    movement = movement.NXTOg,
    physics = net_physics.SItalyN,
    net3d = net3D.OriginalT1,
    shape = Shape.OgMidDeep,
    pattern = "P078",
    color_id = "2078",
    sound_file = "SE_Movement",
},
Rapid_Wien = {
    bounce = net_bounce.nb05_8,
    movement = movement.RippleFade2,
    physics = net_physics.OriginalNL2,
    net3d = net3D.Original,
    shape = Shape.RapidNet,
    pattern = "P006",
    color_id = "1819",
    sound_file = "SE_Movement",
},
RB_Salzburg = {
    bounce = net_bounce.nb05_10,
    movement = movement.FC26_3,
    physics = net_physics.OriginalNL2,
    net3d = net3D.Original,
    shape = Shape.SalzburgNet,
    pattern = "P006",
    color_id = "1586",
    sound_file = "SE_Movement",
},
Sturm_Graz = {
    bounce = net_bounce.nb10,
    movement = movement.Firm3,
    physics = net_physics.UIPL,
    net3d = net3D.OriginalT1,
    shape = Shape.NetOriginal,
    pattern = "P078",
    color_id = "2081",
    sound_file = "SE_Movement",
},

--//================================================================================================================================================================//

-- POLAND
-- Ekstraklasa
Jagiellonia_Bialystok = {
    bounce = net_bounce.nb8,
    movement = movement.FirmSnappy2,
    physics = net_physics.ItalyNT,
    net3d = net3D.OriginalT1,
    shape = Shape.NetOriginalS,
    pattern = "P078",
    color_id = "5269",
    sound_file = "SE_Movement",
},
Lech_Poznan = {
    bounce = net_bounce.nb17,
    movement = movement.Snappy2,
    physics = net_physics.ItalyNT,
    net3d = net3D.OriginalB1H1,
    shape = Shape.PerfectSquareL,
    pattern = "P081",
    color_id = "2126",
    sound_file = "SE_Movement",
},
Legia_Warszawa = {
    bounce = net_bounce.nb15,
    movement = movement.Balanced3,
    physics = net_physics.SItalyNT,
    net3d = net3D.OriginalB2L1,
    shape = Shape.Belly,
    pattern = "P081",
    color_id = "1756",
    sound_file = "SE_Movement",
},
Rakow = {
    bounce = net_bounce.nb01_7,
    movement = movement.FirmSnappy2,
    physics = net_physics.Original,
    net3d = net3D.Original,
    shape = Shape.NetOriginal,
    pattern = "P060",
    color_id = "5288",
    sound_file = "SE_Movement",
},

--//================================================================================================================================================================//

-- UKRAINE
-- Premyer-Liha
Dynamo_Kyiv = {
    bounce = net_bounce.nb6,
    movement = movement.Original,
    physics = net_physics.Normal,
    net3d = net3D.Original,
    shape = Shape.MidDeepNetEPL,
    pattern = "0134",
    color_id = "0134",
    sound_file = "SE_Movement",
},
Shakhtar_Donetsk = {
    bounce = net_bounce.nb20,
    movement = movement.NXTOg,
    physics = net_physics.SItalyN,
    net3d = net3D.OriginalT1,
    shape = Shape.MidDeepNet,
    pattern = "P003",
    color_id = "0184",
    sound_file = "SE_Movement",
},
SK_Dnipro = {
    bounce = net_bounce.nb20,
    movement = movement.Italy,
    physics = net_physics.Italy,
    net3d = net3D.Belly,
    shape = Shape.Belly,
    pattern = "2569",
    color_id = "2569",
    sound_file = "SE_Movement",
},
--//================================================================================================================================================================//

-- CZECH REPUBLIC
-- Fortuna liga
Slavia_Prague = {
    bounce = net_bounce.nb20,
    movement = movement.Snappy2,
    physics = net_physics.ItalyNT,
    net3d = net3D.OriginalT1L1,
    shape = Shape.Real2,
    pattern = "P078",
    color_id = "5189",
    sound_file = "SE_Movement",
},
Slovan_Liberec = {
    bounce = net_bounce.nb20,
    movement = movement.Balanced3,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.NetOriginal,
    pattern = "P088",
    color_id = "1206",
    sound_file = "SE_Movement",
},
Sparta_Prague = {
    bounce = net_bounce.nb03_10,
    movement = movement.Balanced7,
    physics = net_physics.SOriginalNL1,
    net3d = net3D.OriginalT2L1,
    shape = Shape.ImprovedMidDeep,
    pattern = "P019",
    color_id = "0175",
    sound_file = "SE_Movement",
},
Viktoria_Plzen = {
    bounce = net_bounce.nb20,
    movement = movement.Balanced4,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.CurveNet6,
    pattern = "P091",
    color_id = "2037",
    sound_file = "SE_Movement",
},

--//================================================================================================================================================================//

-- CROATIA
-- HNL
Dinamo_Zagreb = {
    bounce = net_bounce.nb18,
    movement = movement.Firm3,
    physics = net_physics.PIPL,
    net3d = net3D.OriginalT1L1,
    shape = Shape.NetOriginal,
    pattern = "P078",
    color_id = "1203",
    sound_file = "SE_Movement",
},
Hajduk_Split = {
    bounce = net_bounce.nb05_10,
    movement = movement.FirmSnappy20,
    physics = net_physics.ItalyNT,
    net3d = net3D.OriginalH1,
    shape = Shape.HajdukNet,
    pattern = "P035",
    color_id = "2525",
    sound_file = "SE_Movement",
},
Rijeka = {
    bounce = net_bounce.nb05_10,
    movement = movement.FirmSnappy20,
    physics = net_physics.PItalyNT,
    net3d = net3D.Original,
    shape = Shape.RijekaNet,
    pattern = "P044",
    color_id = "2526",
    sound_file = "SE_Movement",
},

--//================================================================================================================================================================//

-- ROMANIA
-- Superliga
Cluj = {
    bounce = net_bounce.nb10,
    movement = movement.FirmSnappy1,
    physics = net_physics.ItalyNT,
    net3d = net3D.OriginalT3L1,
    shape = Shape.NetOriginal,
    pattern = "P078",
    color_id = "1746",
    sound_file = "SE_Movement",
},
FCSB = {
    bounce = net_bounce.nbMed6,
    movement = movement.FirmSnappy2,
    physics = net_physics.ItalyNT,
    net3d = net3D.OriginalH1,
    shape = Shape.PerfectSquareL,
    pattern = "P081",
    color_id = "1216",
    sound_file = "SE_Movement",
},

--//================================================================================================================================================================//

-- HUNGARY
-- Nemzeti Bajnokság I
Ferencvaros = {
    bounce = net_bounce.nb05_9,
    movement = movement.FirmSnappy20,
    physics = net_physics.ItalyNT,
    net3d = net3D.OriginalH1,
    shape = Shape.FerencvarosNet,
    pattern = "P078",
    color_id = "2241",
    sound_file = "SE_Movement",
},

--//================================================================================================================================================================//

-- BULGARIA
-- Parva Liga
Ludogorets = {
    bounce = net_bounce.nb075_9,
    movement = movement.FirmSnappy20,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.LudogoretsNet,
    pattern = "P078",
    color_id = "4355",
    sound_file = "SE_Movement",
},

--//================================================================================================================================================================//

-- SWEDEN
-- Allsvenskan
AIK = {
    bounce = net_bounce.nb20,
    movement = movement.Porto,
    physics = net_physics.PortoLT,
    net3d = net3D.Original,
    shape = Shape.DeepLoseNet,
    pattern = "1583",
    color_id = "1583",
    sound_file = "SE_Movement",
},
Malmo = {
    bounce = net_bounce.nb19,
    movement = movement.Italy,
    physics = net_physics.Italy,
    net3d = net3D.Original,
    shape = Shape.NetOriginalS,
    pattern = "1702",
    color_id = "1702",
    sound_file = "SE_Movement",
},

--//================================================================================================================================================================//

-- NORWAY
-- Eliteserien
Bodo_Glimt = {
    bounce = net_bounce.nb19,
    movement = movement.NXT6,
    physics = net_physics.PItalyN,
    net3d = net3D.OriginalT2,
    shape = Shape.MidDeepNet,
    pattern = "P078",
    color_id = "5253",
    sound_file = "SE_Movement",
},
Molde_FK = {
    bounce = net_bounce.nb19,
    movement = movement.NXT6,
    physics = net_physics.PSpain,
    net3d = net3D.OriginalT2L1,
    shape = Shape.MidDeepNet,
    pattern = "P019",
    color_id = "5242",
    sound_file = "SE_Movement",
},
Rosenborg = {
    bounce = net_bounce.nb20,
    movement = movement.EPL,
    physics = net_physics.PLow,
    net3d = net3D.Original,
    shape = Shape.PerfectSquareL,
    pattern = "1215",
    color_id = "1215",
    sound_file = "SE_Movement",
},

--//================================================================================================================================================================//

-- AZERBAIJAN
-- Premier League
Qarabag = {
    bounce = net_bounce.nb20,
    movement = movement.FirmSnappy20,
    physics = net_physics.PProBalancedN,
    net3d = net3D.Original,
    shape = Shape.QarabagNet,
    pattern = "P003",
    color_id = "4326",
    sound_file = "SE_Movement",
},

--//================================================================================================================================================================//

-- MOLDOVA
-- Super Liga
Sheriff = {
    bounce = net_bounce.nb10,
    movement = movement.Bouncy,
    physics = net_physics.PL,
    net3d = net3D.Original,
    shape = Shape.Ajax,
    pattern = "4347",
    color_id = "4347",
    sound_file = "SE_Movement",
},

--//================================================================================================================================================================//

-- SLOVAKIA
-- Fortuna Liga
Slovan_Bratislava = {
    bounce = net_bounce.nb10,
    movement = movement.Firm3,
    physics = net_physics.UIPL,
    net3d = net3D.OriginalT1,
    shape = Shape.NetOriginal,
    pattern = "P078",
    color_id = "4344",
    sound_file = "SE_Movement",
},

--//================================================================================================================================================================//

-- CYPRUS
-- First Division
APOEL = {
    bounce = net_bounce.nb05_9,
    movement = movement.Firm3,
    physics = net_physics.PItalyNT,
    net3d = net3D.OriginalH1,
    shape = Shape.APOELNet,
    pattern = "P078",
    color_id = "2178",
    sound_file = "SE_Movement",
},
Omonia = {
    bounce = net_bounce.nb05_9,
    movement = movement.Firm3,
    physics = net_physics.PItalyNT,
    net3d = net3D.OriginalH1,
    shape = Shape.APOELNet,
    pattern = "P078",
    color_id = "2185",
    sound_file = "SE_Movement",
},
Pafos = {
    bounce = net_bounce.nb05_9,
    movement = movement.Deadstop1,
    physics = net_physics.EnglandN,
    net3d = net3D.OriginalL1,
    shape = Shape.PafosNet,
    pattern = "P078",
    color_id = "9504",
    sound_file = "SE_Movement",
},

--//================================================================================================================================================================//

-- KAZAKHSTAN
-- Premier League
Astana = {
    bounce = net_bounce.nb8,
    movement = movement.EPL,
    physics = net_physics.IPL,
    net3d = net3D.Original,
    shape = Shape.NetOriginalS,
    pattern = "2374",
    color_id = "2374",
    sound_file = "SE_Movement",
},

--//================================================================================================================================================================//

-- LITHUANIA
-- A Lyga
Zalgiris = {
    bounce = net_bounce.nb8,
    movement = movement.EPL,
    physics = net_physics.IPL,
    net3d = net3D.Original,
    shape = Shape.NetOriginal,
    pattern = "0199",
    color_id = "0199",
    sound_file = "SE_Movement",
},

--//================================================================================================================================================================//

-- ISRAEL
-- Premier League
Maccabi_Haifa = {
    bounce = net_bounce.nb15,
    movement = movement.EPL,
    physics = net_physics.IPL,
    net3d = net3D.Original,
    shape = Shape.MidLowNet,
    pattern = "1213",
    color_id = "1213",
    sound_file = "SE_Movement",
},



--//================================================================================================================================================================//
--//================================================================================================================================================================//

-- SOUTH and NORTH AMERICA

-- ARGENTINA
-- Primera Division
Argentinos_Juniors = {
    bounce = net_bounce.nb006_9,
    movement = movement.NXTOg,
    physics = net_physics.OriginalNL2Low,
    net3d = net3D.SmallNet,
    shape = Shape.SmallNet,
    pattern = "P043",
    color_id = "1236",
    sound_file = "SE_Movement"
},
Arsenal_De_Sarandi = {
    bounce = net_bounce.nb20,
    movement = movement.FIFA2,
    physics = net_physics.PLow,
    net3d = net3D.OriginalT2L1,
    shape = Shape.SmallNet,
    pattern = "1921",
    color_id = "1921",
    sound_file = "SE_Movement"
},
Atletico_Tucuman = {
    bounce = net_bounce.nb006_10,
    movement = movement.FirmSnappy20,
    physics = net_physics.OriginalNL2,
    net3d = net3D.OriginalT3H1,
    shape = Shape.TucumanNet,
    pattern = "P066",
    color_id = "2719",
    sound_file = "SE_Move0003"
},
Banfield = {
    bounce = net_bounce.nb075_9,
    movement = movement.FirmSnappy13,
    physics = net_physics.SProBalanced,
    net3d = net3D.OriginalT1L1,
    shape = Shape.BanfieldNet,
    pattern = "P083",
    color_id = "1927",
    sound_file = "SE_Movement"
},
Barracas_Central = {
    bounce = net_bounce.nbx,
    movement = movement.FirmSnappy2,
    physics = net_physics.SItalyN,
    net3d = net3D.SmallNet,
    shape = Shape.BarracasNet,
    pattern = "P002",
    color_id = "5657",
    sound_file = "SE_Movement"
},
Belgrano = {
    bounce = net_bounce.nb07_9,
    movement = movement.NXT6,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.BelgranoNet,
    pattern = "P021",
    color_id = "2536",
    sound_file = "SE_Movement"
},
Boca_Juniors = {
    bounce = net_bounce.nb05_9,
    movement = movement.FC26_4,
    physics = net_physics.ItalyNT,
    net3d = net3D.OriginalT2L1,
    shape = Shape.BocaNet,
    pattern = "P078",
    color_id = "0139",
    sound_file = "SE_Movement"
},
Central_Cordoba = {
    bounce = net_bounce.nb17,
    movement = movement.NXT7,
    physics = net_physics.SItaly,
    net3d = net3D.OriginalT1L1,
    shape = Shape.PerfectSquare,
    pattern = "P010",
    color_id = "4995",
    sound_file = "SE_Movement"
},
Colon = {
    bounce = net_bounce.nb18,
    movement = movement.NXT6,
    physics = net_physics.PortoLT,
    net3d = net3D.OriginalT3,
    shape = Shape.NetOriginal,
    pattern = "1923",
    color_id = "1923",
    sound_file = "SE_Movement"
},
Defensa_y_Justicia = {
    bounce = net_bounce.nb19,
    movement = movement.NXT6,
    physics = net_physics.SItaly,
    net3d = net3D.OriginalT4L1,
    shape = Shape.Defensa,
    pattern = "P087",
    color_id = "2722",
    sound_file = "SE_Movement"
},
Estudiantes = {
    bounce = net_bounce.nb10,
    movement = movement.NXT6,
    physics = net_physics.Italy,
    net3d = net3D.OriginalT4,
    shape = Shape.OgMidDeep,
    pattern = "P084",
    color_id = "1238",
    sound_file = "SE_Movement"
},
Gimnasia_La_Plata = {
    bounce = net_bounce.nbMed2,
    movement = movement.NXT6,
    physics = net_physics.SItaly,
    net3d = net3D.OriginalT4L1,
    shape = Shape.CurveNet2,
    pattern = "P066",
    color_id = "1239",
    sound_file = "SE_Movement"
},
Godoy_Cruz = {
    bounce = net_bounce.nb18,
    movement = movement.NXT6,
    physics = net_physics.PortoLT,
    net3d = net3D.OriginalT2L1,
    shape = Shape.MidDeepNet2,
    pattern = "P060",
    color_id = "1924",
    sound_file = "SE_Movement"
},
Huracan = {
    bounce = net_bounce.nb18,
    movement = movement.NXT2,
    physics = net_physics.SItaly,
    net3d = net3D.OriginalT2,
    shape = Shape.Fener,
    pattern = "P015",
    color_id = "1922",
    sound_file = "SE_Movement"
},
Independiente = {
    bounce = net_bounce.nb05_8,
    movement = movement.FC26_5,
    physics = net_physics.SItalyN,
    net3d = net3D.OriginalT2L1,
    shape = Shape.PerfectSquare,
    pattern = "P091",
    color_id = "1240",
    sound_file = "SE_Move0002"
},
Instituto_ACC = {
    bounce = net_bounce.nb03_7,
    movement = movement.CornerSlack7_0,
    physics = net_physics.PEnglandNT,
    net3d = net3D.OriginalL1,
    shape = Shape.InstitutoNet,
    pattern = "P078",
    color_id = "2727",
    sound_file = "SE_Movement"
},
Lanus = {
    bounce = net_bounce.nb07_7,
    movement = movement.FC26_3,
    physics = net_physics.EnglandN,
    net3d = net3D.OriginalH1,
    shape = Shape.LanusNet,
    pattern = "P078",
    color_id = "1929",
    sound_file = "SE_Movement"
},
Newells = {
    bounce = net_bounce.nb006_10,
    movement = movement.FC26_5,
    physics = net_physics.EnglandN,
    net3d = net3D.Original,
    shape = Shape.NewellsNet,
    pattern = "P070",
    color_id = "1241",
    sound_file = "SE_Movement"
},
Patronato = {
    bounce = net_bounce.nb10,
    movement = movement.NXT6,
    physics = net_physics.FIFA,
    net3d = net3D.OriginalT1L1,
    shape = Shape.SmallNet,
    pattern = "P020",
    color_id = "2729",
    sound_file = "SE_Movement"
},
Platense = {
    bounce = net_bounce.nb20,
    movement = movement.FIFA2,
    physics = net_physics.PLow,
    net3d = net3D.OriginalT2L1,
    shape = Shape.SmallNet,
    pattern = "P070",
    color_id = "5454",
    sound_file = "SE_Movement"
},
Racing_Club = {
    bounce = net_bounce.nb05_9,
    movement = movement.FC26_3,
    physics = net_physics.EnglandNT,
    net3d = net3D.Original,
    shape = Shape.RacingNet,
    pattern = "P084",
    color_id = "1237",
    sound_file = "SE_Movement"
},
River_Plate = {
    bounce = net_bounce.nb05_10,
    movement = movement.Spain,
    physics = net_physics.EnglandN,
    net3d = net3D.Original,
    shape = Shape.RiverNet,
    pattern = "P044",
    color_id = "0138",
    sound_file = "SE_Movement"
},
Rosario_Central = {
    bounce = net_bounce.nb20,
    movement = movement.NXT6,
    physics = net_physics.SItaly,
    net3d = net3D.OriginalT5,
    shape = Shape.MidDeepNet,
    pattern = "P044",
    color_id = "1242",
    sound_file = "SE_Movement"
},
San_Lorenzo = {
    bounce = net_bounce.nb18,
    movement = movement.NXT6,
    physics = net_physics.SItaly,
    net3d = net3D.OriginalT1,
    shape = Shape.NetOriginal,
    pattern = "P014",
    color_id = "1243",
    sound_file = "SE_Movement"
},
Sarmiento = {
    bounce = net_bounce.nb10,
    movement = movement.NXT3,
    physics = net_physics.PL,
    net3d = net3D.OriginalT1L1,
    shape = Shape.PerfectSquareL,
    pattern = "P070",
    color_id = "2730",
    sound_file = "SE_Movement"
},
Talleres = {
    bounce = net_bounce.nb17,
    movement = movement.NXT2,
    physics = net_physics.Porto,
    net3d = net3D.OriginalT1L1,
    shape = Shape.Belly,
    pattern = "P072",
    color_id = "5046",
    sound_file = "SE_Movement"
},
Tigre = {
    bounce = net_bounce.nb10,
    movement = movement.NXT6,
    physics = net_physics.Italy,
    net3d = net3D.OriginalT5L1,
    shape = Shape.SmallNet,
    pattern = "P021",
    color_id = "1926",
    sound_file = "SE_Movement"
},
CA_Union = {
    bounce = net_bounce.nb7,
    movement = movement.NXT6,
    physics = net_physics.Italy,
    net3d = net3D.OriginalL1,
    shape = Shape.TriangleNet2,
    pattern = "P068",
    color_id = "2538",
    sound_file = "SE_Movement"
},
Velez_Sarsfield = {
    bounce = net_bounce.nb05_9,
    movement = movement.FC26_6,
    physics = net_physics.EnglandNT,
    net3d = net3D.Original,
    shape = Shape.VelezNet,
    pattern = "P078",
    color_id = "1244",
    sound_file = "SE_Movement"
},
-- Cups
Copa_Argentina = {
    bounce = net_bounce.nb18,
    movement = movement.EPL,
    physics = net_physics.PLow,
    net3d = net3D.Original,
    shape = Shape.PerfectSquareH,
    pattern = "1240",
    color_id = "1240",
    sound_file = "SE_Movement"
},
Supercopa_Argentina = {
    bounce = net_bounce.nbOriginal,
    movement = movement.Original,
    physics = net_physics.Original,
    net3d = net3D.Original,
    shape = Shape.NetOriginal,
    pattern = "1927",
    color_id = "1927",
    sound_file = "SE_Movement"
},

--//================================================================================================================================================================//

-- BRASIL
-- Série A
Atletico_Mineiro = {
    bounce = net_bounce.nb5,
    movement = movement.NXTOg,
    physics = net_physics.SItalyN,
    net3d = net3D.OriginalT2,
    shape = Shape.Flamengo2,
    pattern = "P003",
    color_id = "1245",
    sound_file = "SE_Movement"
},
Bahia = {
    bounce = net_bounce.nb19,
    movement = movement.Italy3,
    physics = net_physics.Porto,
    net3d = net3D.OriginalT1H1,
    shape = Shape.MidDeepNet,
    pattern = "P003",
    color_id = "2453",
    sound_file = "SE_Movement"
},
Botafogo = {
    bounce = net_bounce.nbx,
    movement = movement.FirmSnappy2,
    physics = net_physics.PItalyN,
    net3d = net3D.SmallNet,
    shape = Shape.SmallNetTriangle,
    pattern = "P070",
    color_id = "1246",
    sound_file = "SE_Movement"
},
Ceara = {
    bounce = net_bounce.nb17,
    movement = movement.NXT,
    physics = net_physics.PortoLT,
    net3d = net3D.OriginalT1,
    shape = Shape.NetOriginal,
    pattern = "P060",
    color_id = "2454",
    sound_file = "SE_Movement"
},
Corinthians = {
    bounce = net_bounce.nb03_5,
    movement = movement.DeepPocketWave,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.CorinthiansNet,
    pattern = "P091",
    color_id = "1247",
    sound_file = "SE_Movement"
},
Cruzeiro = {
    bounce = net_bounce.nb15,
    movement = movement.Firm3,
    physics = net_physics.ItalyNT,
    net3d = net3D.OriginalT4,
    shape = Shape.Flamengo,
    pattern = "P003",
    color_id = "0274",
    sound_file = "SE_Movement"
},
Flamengo = {
    bounce = net_bounce.nbx,
    movement = movement.FirmSnappy2,
    physics = net_physics.PItalyN,
    net3d = net3D.SmallNet,
    shape = Shape.SmallNetTriangle,
    pattern = "P003",
    color_id = "1248",
    sound_file = "SE_Movement"
},
Fluminense = {
    bounce = net_bounce.nbx,
    movement = movement.FirmSnappy2,
    physics = net_physics.PItalyN,
    net3d = net3D.SmallNet,
    shape = Shape.SmallNetTriangle,
    pattern = "P003",
    color_id = "1249",
    sound_file = "SE_Movement"
},
Fortaleza = {
    bounce = net_bounce.nb15,
    movement = movement.NXT6,
    physics = net_physics.Porto,
    net3d = net3D.OriginalT2L1,
    shape = Shape.NetOriginal,
    pattern = "P003",
    color_id = "5143",
    sound_file = "SE_Movement"
},
Goias = {
    bounce = net_bounce.nb5,
    movement = movement.NXT6,
    physics = net_physics.ItalyN,
    net3d = net3D.OriginalT1H1,
    shape = Shape.Flamengo,
    pattern = "P081",
    color_id = "1933",
    sound_file = "SE_Movement"
},
Gremio = {
    bounce = net_bounce.nb20,
    movement = movement.Firm3,
    physics = net_physics.SItalyN,
    net3d = net3D.Original,
    shape = Shape.CurveNet,
    pattern = "P025",
    color_id = "1250",
    sound_file = "SE_Movement"
},
Internacional = {
    bounce = net_bounce.nb5,
    movement = movement.NXT6,
    physics = net_physics.Italy,
    net3d = net3D.OriginalT1H1,
    shape = Shape.Flamengo,
    pattern = "P043",
    color_id = "1252",
    sound_file = "SE_Movement"
},
Juventude = {
    bounce = net_bounce.nb19,
    movement = movement.EPL9,
    physics = net_physics.Spain2,
    net3d = net3D.Original,
    shape = Shape.PerfectSquareL,
    pattern = "P074",
    color_id = "5137",
    sound_file = "SE_Movement"
},
Mirassol_FC = {
    bounce = net_bounce.nb20,
    movement = movement.FIFA2,
    physics = net_physics.PItaly,
    net3d = net3D.OriginalT2L1,
    shape = Shape.MidDeepNet,
    pattern = "P070",
    color_id = "5767",
    sound_file = "SE_Movement"
},
Palmeiras = {
    bounce = net_bounce.nb075_9,
    movement = movement.FirmSnappy13,
    physics = net_physics.SItalyN,
    net3d = net3D.OriginalT1L1,
    shape = Shape.PalmeirasNet,
    pattern = "P089",
    color_id = "0137",
    sound_file = "SE_Movement"
},
Red_Bull_Bragantino = {
    bounce = net_bounce.nb18,
    movement = movement.EPL9,
    physics = net_physics.SItalyNTLow,
    net3d = net3D.Original,
    shape = Shape.BragantinoNet,
    pattern = "P003",
    color_id = "2459",
    sound_file = "SE_Movement"
},
Santos = {
    bounce = net_bounce.nb9,
    movement = movement.NXT6,
    physics = net_physics.Italy,
    net3d = net3D.OriginalT1L1,
    shape = Shape.NetOriginal,
    pattern = "P081",
    color_id = "1254",
    sound_file = "SE_Movement"
},
Sao_Paulo = {
    bounce = net_bounce.nbx,
    movement = movement.FirmSnappy2,
    physics = net_physics.SItalyN,
    net3d = net3D.SmallNet,
    shape = Shape.SmallNetTriangle,
    pattern = "P020",
    color_id = "1255",
    sound_file = "SE_Movement"
},
Sport_Recife = {
    bounce = net_bounce.nb5,
    movement = movement.NXT6,
    physics = net_physics.Italy,
    net3d = net3D.OriginalT1H1,
    shape = Shape.Flamengo,
    pattern = "P044",
    color_id = "1936",
    sound_file = "SE_Movement"
},
Vasco_Da_Gama = {
    bounce = net_bounce.nbx,
    movement = movement.FirmSnappy2,
    physics = net_physics.PItalyN,
    net3d = net3D.SmallNet,
    shape = Shape.SmallNetTriangle,
    pattern = "P021",
    color_id = "0136",
    sound_file = "SE_Move0003"
},

-- Série B
America_Mineiro = {
    bounce = net_bounce.nbFIFA2,
    movement = movement.NXT7,
    physics = net_physics.Italy2,
    net3d = net3D.OriginalT2L1,
    shape = Shape.NetOriginal,
    pattern = "P081",
    color_id = "2450",
    sound_file = "SE_Movement"
},
Athletico_Paranaense = {
    bounce = net_bounce.nb20,
    movement = movement.FirmSnappy2,
    physics = net_physics.PItalyNT,
    net3d = net3D.OriginalL1,
    shape = Shape.HexagonalNet,
    pattern = "P003",
    color_id = "1930",
    sound_file = "SE_Movement"
},
Atletico_Goianiense = {
    bounce = net_bounce.nb075_9,
    movement = movement.FirmSnappy13,
    physics = net_physics.SItalyN,
    net3d = net3D.OriginalT1L1,
    shape = Shape.Square,
    pattern = "P006",
    color_id = "2451",
    sound_file = "SE_Movement"
},
Avai = {
    bounce = net_bounce.nb17,
    movement = movement.FIFA2,
    physics = net_physics.PLow,
    net3d = net3D.OriginalT2L1,
    shape = Shape.NetWC,
    pattern = "P081",
    color_id = "2452",
    sound_file = "SE_Movement"
},
Chapecoense = {
    bounce = net_bounce.nb17,
    movement = movement.FIFA2,
    physics = net_physics.PortoLT,
    net3d = net3D.OriginalT2L1,
    shape = Shape.MidDeepNet,
    pattern = "P003",
    color_id = "4108",
    sound_file = "SE_Movement"
},
Coritiba = {
    bounce = net_bounce.nb19,
    movement = movement.NXT4,
    physics = net_physics.Porto,
    net3d = net3D.OriginalL1,
    shape = Shape.Belly,
    pattern = "P043",
    color_id = "1931",
    sound_file = "SE_Movement"
},
Criciúma = {
    bounce = net_bounce.nb10,
    movement = movement.Italy,
    physics = net_physics.Italy,
    net3d = net3D.OriginalT2L1,
    shape = Shape.NetOriginal,
    pattern = "P003",
    color_id = "2460",
    sound_file = "SE_Movement"
},
CRB = {
    bounce = net_bounce.nb19,
    movement = movement.FIFA2,
    physics = net_physics.PItaly,
    net3d = net3D.OriginalT2L1,
    shape = Shape.PerfectSquare,
    pattern = "P060",
    color_id = "2506",
    sound_file = "SE_Movement"
},
Cuiaba = {
    bounce = net_bounce.nb18,
    movement = movement.NXT4,
    physics = net_physics.Italy2,
    net3d = net3D.OriginalT1L1,
    shape = Shape.PerfectSquare,
    pattern = "P082",
    color_id = "5142",
    sound_file = "SE_Movement"
},
Gremio_Novorizontino = {
    bounce = net_bounce.nb17,
    movement = movement.FIFA2,
    physics = net_physics.PLow,
    net3d = net3D.OriginalT2L1,
    shape = Shape.NetWC,
    pattern = "P081",
    color_id = "5768",
    sound_file = "SE_Movement"
},
Guarani = {
    bounce = net_bounce.nb19,
    movement = movement.NXT3,
    physics = net_physics.Italy2,
    net3d = net3D.OriginalT2L1,
    shape = Shape.CurveNet6,
    pattern = "P003",
    color_id = "1251",
    sound_file = "SE_Movement"
},
Ituano = {
    bounce = net_bounce.nb18,
    movement = movement.NXT4,
    physics = net_physics.Italy2,
    net3d = net3D.OriginalT1L1,
    shape = Shape.PerfectSquare,
    pattern = "P003",
    color_id = "2455",
    sound_file = "SE_Movement"
},
Ponte_Preta = {
    bounce = net_bounce.nb20,
    movement = movement.NXT6,
    physics = net_physics.Italy,
    net3d = net3D.OriginalT2L1,
    shape = Shape.NetOriginal,
    pattern = "P078",
    color_id = "2465",
    sound_file = "SE_Movement"
},
Vila_Nova = {
    bounce = net_bounce.nb17,
    movement = movement.NXT3,
    physics = net_physics.PL,
    net3d = net3D.Original,
    shape = Shape.NetWC,
    pattern = "P081",
    color_id = "2468",
    sound_file = "SE_Movement"
},
EC_Vitoria = {
    bounce = net_bounce.nb17,
    movement = movement.NXT2,
    physics = net_physics.IPL,
    net3d = net3D.Original,
    shape = Shape.MidDeepNet,
    pattern = "1937",
    color_id = "1937",
    sound_file = "SE_Movement"
},
Botafogo_RP = {
    bounce = net_bounce.nb18,
    movement = movement.FIFA2,
    physics = net_physics.FIFA,
    net3d = net3D.OriginalT3L1,
    shape = Shape.Real,
    pattern = "P003",
    color_id = "5139",
    sound_file = "SE_Movement"
},

-- Série C
ABC_FC = {
    bounce = net_bounce.nb20,
    movement = movement.Original,
    physics = net_physics.Original,
    net3d = net3D.Original,
    shape = Shape.Ajax,
    pattern = "5433",
    color_id = "5433",
    sound_file = "SE_Movement"
},
CSA = {
    bounce = net_bounce.nb17,
    movement = movement.Italy,
    physics = net_physics.Italy,
    net3d = net3D.Original,
    shape = Shape.MidLowNet,
    pattern = "5141",
    color_id = "5141",
    sound_file = "SE_Movement"
},
Nautico = {
    bounce = net_bounce.nb17,
    movement = movement.Original,
    physics = net_physics.Original,
    net3d = net3D.Original,
    shape = Shape.MidLowNet,
    pattern = "1935",
    color_id = "1935",
    sound_file = "SE_Movement"
},
Londrina = {
    bounce = net_bounce.nb17,
    movement = movement.Original,
    physics = net_physics.Original,
    net3d = net3D.OriginalT2L1,
    shape = Shape.DeepNet,
    pattern = "5048",
    color_id = "5048",
    sound_file = "SE_Movement"
},
Tombense = {
    bounce = net_bounce.nb20,
    movement = movement.FIFA2,
    physics = net_physics.PLow,
    net3d = net3D.OriginalT2L1,
    shape = Shape.SmallNet,
    pattern = "P081",
    color_id = "5644",
    sound_file = "SE_Movement"
},
Sampaio_Correa = {
    bounce = net_bounce.nb17,
    movement = movement.Bouncy,
    physics = net_physics.PL,
    net3d = net3D.Original,
    shape = Shape.MidNet,
    pattern = "4111",
    color_id = "4111",
    sound_file = "SE_Movement"
},
-- Cups
Copa_do_Brasil = {
    bounce = net_bounce.nb20,
    movement = movement.EPL,
    physics = net_physics.PLow,
    net3d = net3D.Original,
    shape = Shape.PerfectSquareL,
    pattern = "1247",
    color_id = "1247",
    sound_file = "SE_Movement"
},

--//================================================================================================================================================================//

-- CHILE
-- Primera Division
Audax_Italiano = {
    bounce = net_bounce.nb15,
    movement = movement.FIFA4,
    physics = net_physics.Italy,
    net3d = net3D.OriginalT1L1,
    shape = Shape.MidLowNet2,
    pattern = "P043",
    color_id = "2192",
    sound_file = "SE_Movement",
},
Cobresal = {
    bounce = net_bounce.nb15,
    movement = movement.EPL,
    physics = net_physics.PortoLT,
    net3d = net3D.OriginalH1,
    shape = Shape.MidCurveNet,
    pattern = "P003",
    color_id = "2553",
    sound_file = "SE_Movement",
},
Colo_Colo = {
    bounce = net_bounce.nb17,
    movement = movement.EPLS,
    physics = net_physics.PortoLT,
    net3d = net3D.OriginalT1L1,
    shape = Shape.DeepLoseNet,
    pattern = "P078",
    color_id = "1256",
    sound_file = "SE_Movement",
},
Coquimbo = {
    bounce = net_bounce.nb19,
    movement = movement.NXT8,
    physics = net_physics.Italy,
    net3d = net3D.OriginalT2L1,
    shape = Shape.NetOriginal,
    pattern = "P060",
    color_id = "2707",
    sound_file = "SE_Movement",
},
Deportes_Copiapo = {
    bounce = net_bounce.nb15,
    movement = movement.NXT6,
    physics = net_physics.Italy,
    net3d = net3D.Lic,
    shape = Shape.Lic,
    pattern = "P078",
    color_id = "2710",
    sound_file = "SE_Movement",
},
Deportes_Iquique = {
    bounce = net_bounce.nb20,
    movement = movement.FIFA2,
    physics = net_physics.PLow,
    net3d = net3D.OriginalT2L1,
    shape = Shape.SmallNet,
    pattern = "P081",
    color_id = "2712",
    sound_file = "SE_Movement",
},
Everton_De_Vina = {
    bounce = net_bounce.nb17,
    movement = movement.FIFA4,
    physics = net_physics.PortoLT,
    net3d = net3D.OriginalT1L1,
    shape = Shape.DeepLoseNet,
    pattern = "P095",
    color_id = "2208",
    sound_file = "SE_Movement",
},
Huachipato = {
    bounce = net_bounce.nb01_8,
    movement = movement.QuickTaut,
    physics = net_physics.ItalyN,
    net3d = net3D.OriginalT4,
    shape = Shape.NetOriginal,
    pattern = "P070",
    color_id = "2545",
    sound_file = "SE_Movement",
},
Nublense = {
    bounce = net_bounce.nb15,
    movement = movement.FIFA4,
    physics = net_physics.PItaly,
    net3d = net3D.OriginalT1,
    shape = Shape.MidLowNet,
    pattern = "P043",
    color_id = "2699",
    sound_file = "SE_Movement",
},
OHiggins = {
    bounce = net_bounce.nb18,
    movement = movement.FIFA4,
    physics = net_physics.SItaly,
    net3d = net3D.OriginalT2L1,
    shape = Shape.NetOriginal,
    pattern = "P095",
    color_id = "2541",
    sound_file = "SE_Movement",
},
Palestino = {
    bounce = net_bounce.nb20,
    movement = movement.NXT7,
    physics = net_physics.SItaly,
    net3d = net3D.OriginalT2L1,
    shape = Shape.NetOriginal,
    pattern = "P060",
    color_id = "2209",
    sound_file = "SE_Movement",
},
Union_Espanola = {
    bounce = net_bounce.nb10,
    movement = movement.FIFA5,
    physics = net_physics.Italy,
    net3d = net3D.OriginalT3L1,
    shape = Shape.NetOriginal,
    pattern = "P095",
    color_id = "2360",
    sound_file = "SE_Movement",
},
Union_La_Calera = {
    bounce = net_bounce.nb15,
    movement = movement.NXT6,
    physics = net_physics.Spain2,
    net3d = net3D.Original,
    shape = Shape.NetOriginal,
    pattern = "P078",
    color_id = "2546",
    sound_file = "SE_Movement",
},
Universidad_Catolica = {
    bounce = net_bounce.nb10,
    movement = movement.FIFA5,
    physics = net_physics.Italy,
    net3d = net3D.OriginalT3L1,
    shape = Shape.NetOriginal,
    pattern = "P095",
    color_id = "2360",
    sound_file = "SE_Movement",
},
Universidad_De_Chile = {
    bounce = net_bounce.nb18,
    movement = movement.NXT8,
    physics = net_physics.SItaly,
    net3d = net3D.OriginalT2L1,
    shape = Shape.NetOriginal,
    pattern = "P015",
    color_id = "2209",
    sound_file = "SE_Movement",
},

-- Segunda Division
Curico_Unido = {
    bounce = net_bounce.nb17,
    movement = movement.NXT8,
    physics = net_physics.PL,
    net3d = net3D.OriginalL2,
    shape = Shape.PerfectSquareH,
    pattern = "2708",
    color_id = "2708",
    sound_file = "SE_Movement",
},
Magallanes_CF = {
    bounce = net_bounce.nb4,
    movement = movement.Bouncy,
    physics = net_physics.PL,
    net3d = net3D.Original,
    shape = Shape.MidLowNet,
    pattern = "2544",
    color_id = "2544",
    sound_file = "SE_Movement",
},
Universidad_De_Concepcion = {
    bounce = net_bounce.nb17,
    movement = movement.EPL,
    physics = net_physics.IPL,
    net3d = net3D.Original,
    shape = Shape.MidLowNet,
    pattern = "2551",
    color_id = "2551",
    sound_file = "SE_Movement",
},
-- Copa Chile
Copa_Chile = {
    bounce = net_bounce.nb17,
    movement = movement.Original,
    physics = net_physics.Normal,
    net3d = net3D.Original,
    shape = Shape.SAfricaWC2010,
    pattern = "2191",
    color_id = "2191",
    sound_file = "SE_Movement",
},

--//================================================================================================================================================================//

-- MEXICO
-- Liga MX
Atlas = {
    bounce = net_bounce.nb19,
    movement = movement.NXT6,
    physics = net_physics.SSpain,
    net3d = net3D.OriginalT2L1,
    shape = Shape.MidDeepNet,
    pattern = "P003",
    color_id = "1777",
    sound_file = "SE_Movement",
},
Club_America = {
    bounce = net_bounce.nb10,
    movement = movement.FIFA5,
    physics = net_physics.PIPL,
    net3d = net3D.OriginalT3L1,
    shape = Shape.DeepLoseNet2,
    pattern = "P043",
    color_id = "1264",
    sound_file = "SE_Movement",
},
Monterrey = {
    bounce = net_bounce.nb17,
    movement = movement.FIFA5,
    physics = net_physics.PItaly,
    net3d = net3D.OriginalH4,
    shape = Shape.CurveNet,
    pattern = "P003",
    color_id = "1778",
    sound_file = "SE_Movement",
},
Tigres = {
    bounce = net_bounce.nb20,
    movement = movement.Porto,
    physics = net_physics.PortoLT,
    net3d = net3D.Original,
    shape = Shape.DeepLoseNet,
    pattern = "P043",
    color_id = "1782",
    sound_file = "SE_Movement",
},
Atletico_San_Luis = {
    bounce = net_bounce.nb17,
    movement = movement.Bouncy,
    physics = net_physics.PL,
    net3d = net3D.Original,
    shape = Shape.CampNouClassic,
    pattern = "5379",
    color_id = "5379",
    sound_file = "SE_Movement",
},
Chivas_Guadalajara = {
    bounce = net_bounce.nb17,
    movement = movement.Bouncy,
    physics = net_physics.PL,
    net3d = net3D.Original,
    shape = Shape.NetNormalCurve,
    pattern = "1700",
    color_id = "1700",
    sound_file = "SE_Movement",
},
Club_Leon = {
    bounce = net_bounce.nb17,
    movement = movement.EPL,
    physics = net_physics.IPL,
    net3d = net3D.Original,
    shape = Shape.UltraLowNet,
    pattern = "1789",
    color_id = "1789",
    sound_file = "SE_Movement",
},
Cruz_Azul = {
    bounce = net_bounce.nb17,
    movement = movement.Bouncy,
    physics = net_physics.PL,
    net3d = net3D.Original,
    shape = Shape.OldTrafClassic,
    pattern = "1265",
    color_id = "1265",
    sound_file = "SE_Movement",
},
FC_Juarez = {
    bounce = net_bounce.nb17,
    movement = movement.Bouncy,
    physics = net_physics.PL,
    net3d = net3D.Original,
    shape = Shape.NetOriginal2,
    pattern = "5153",
    color_id = "5153",
    sound_file = "SE_Movement",
},
Mazatlan = {
    bounce = net_bounce.nb17,
    movement = movement.Original,
    physics = net_physics.Original,
    net3d = net3D.OriginalT2L1,
    shape = Shape.DeepNet,
    pattern = "5730",
    color_id = "5730",
    sound_file = "SE_Movement",
},
Necaxa = {
    bounce = net_bounce.nb17,
    movement = movement.Original,
    physics = net_physics.Original,
    net3d = net3D.AnoetaClassic,
    shape = Shape.AnoetaClassic,
    pattern = "5130",
    color_id = "5130",
    sound_file = "SE_Movement",
},
Pachuca = {
    bounce = net_bounce.nb17,
    movement = movement.EPL,
    physics = net_physics.IPL,
    net3d = net3D.Original,
    shape = Shape.MidLowNet,
    pattern = "1699",
    color_id = "1699",
    sound_file = "SE_Movement",
},
Puebla = {
    bounce = net_bounce.nb17,
    movement = movement.Bouncy,
    physics = net_physics.PL,
    net3d = net3D.Original,
    shape = Shape.CampNouClassic,
    pattern = "1772",
    color_id = "1772",
    sound_file = "SE_Movement",
},
Pumas = {
    bounce = net_bounce.nb17,
    movement = movement.Original,
    physics = net_physics.Original,
    net3d = net3D.OriginalT2L1,
    shape = Shape.DeepNet,
    pattern = "1775",
    color_id = "1775",
    sound_file = "SE_Movement",
},
Queretaro = {
    bounce = net_bounce.nb17,
    movement = movement.Bouncy,
    physics = net_physics.PL,
    net3d = net3D.AnoetaClassic,
    shape = Shape.AnoetaClassic,
    pattern = "1792",
    color_id = "1792",
    sound_file = "SE_Movement",
},
Santos_Laguna = {
    bounce = net_bounce.nb8,
    movement = movement.Original,
    physics = net_physics.Original,
    net3d = net3D.AnoetaClassic,
    shape = Shape.AnoetaClassic,
    pattern = "1779",
    color_id = "1779",
    sound_file = "SE_Movement",
},
Tijuana = {
    bounce = net_bounce.nb17,
    movement = movement.Bouncy,
    physics = net_physics.PL,
    net3d = net3D.AnoetaClassic,
    shape = Shape.AnoetaClassic,
    pattern = "1785",
    color_id = "1785",
    sound_file = "SE_Movement",
},
Toluca = {
    bounce = net_bounce.nb17,
    movement = movement.Original,
    physics = net_physics.Original,
    net3d = net3D.OriginalT2L1,
    shape = Shape.DeepNet,
    pattern = "1773",
    color_id = "1773",
    sound_file = "SE_Movement",
},

--//================================================================================================================================================================//

-- COLOMBIA
-- Primera Division
America_de_Cali = {
    bounce = net_bounce.nbFIFA2,
    movement = movement.FIFA4,
    physics = net_physics.Italy,
    net3d = net3D.OriginalT1L1,
    shape = Shape.NetOriginal,
    pattern = "P043",
    color_id = "1257",
    sound_file = "SE_Movement",
},
Millonarios_FC = {
    bounce = net_bounce.nb20,
    movement = movement.FIFA5,
    physics = net_physics.PIPL,
    net3d = net3D.OriginalT1,
    shape = Shape.MidDeepNet,
    pattern = "P021",
    color_id = "1258",
    sound_file = "SE_Movement",
},
Atletico_Nacional = {
    bounce = net_bounce.nb18,
    movement = movement.NXT9,
    physics = net_physics.PItaly,
    net3d = net3D.Original,
    shape = Shape.MidDeepNet,
    pattern = "P078",
    color_id = "2193",
    sound_file = "SE_Movement",
},
Independiente_Medellin = {
    bounce = net_bounce.nb18,
    movement = movement.FIFA4,
    physics = net_physics.PIPL,
    net3d = net3D.OriginalT1,
    shape = Shape.NetOriginal,
    pattern = "P008",
    color_id = "2210",
    sound_file = "SE_Movement",
},
Once_Caldas = {
    bounce = net_bounce.nbFIFA3,
    movement = movement.FIFA5,
    physics = net_physics.IPL,
    net3d = net3D.OriginalL1,
    shape = Shape.NetOriginal,
    pattern = "P060",
    color_id = "2284",
    sound_file = "SE_Move0003",
},
Junior_FC = {
    bounce = net_bounce.nb18,
    movement = movement.NXT9,
    physics = net_physics.PItaly,
    net3d = net3D.Original,
    shape = Shape.MidDeepNet,
    pattern = "P078",
    color_id = "2285",
    sound_file = "SE_Move0002",
},
Deportes_Tolima = {
    bounce = net_bounce.nb18,
    movement = movement.NXT4,
    physics = net_physics.SItaly,
    net3d = net3D.OriginalT2L1,
    shape = Shape.MidDeepNet2,
    pattern = "P070",
    color_id = "2361",
    sound_file = "SE_Movement",
},
Deportivo_Cali = {
    bounce = net_bounce.nb20,
    movement = movement.Spain,
    physics = net_physics.PortoLT,
    net3d = net3D.OriginalL1,
    shape = Shape.DeepLoseNet,
    pattern = "P078",
    color_id = "2650",
    sound_file = "SE_Movement",
},
Deportivo_Pasto = {
    bounce = net_bounce.nb18,
    movement = movement.NXT9,
    physics = net_physics.PItaly,
    net3d = net3D.Original,
    shape = Shape.MidDeepNet,
    pattern = "P078",
    color_id = "2651",
    sound_file = "SE_Movement",
},
Envigado_FC = {
    bounce = net_bounce.nb20,
    movement = movement.NXT7,
    physics = net_physics.PortoT,
    net3d = net3D.OriginalT1H2,
    shape = Shape.NetOriginal,
    pattern = "P098",
    color_id = "2652",
    sound_file = "SE_Movement",
},
Rionegro_Aguilas = {
    bounce = net_bounce.nb20,
    movement = movement.FIFA2,
    physics = net_physics.PLow,
    net3d = net3D.OriginalT2L1,
    shape = Shape.SmallNet,
    pattern = "P019",
    color_id = "2653",
    sound_file = "SE_Movement",
},
CD_La_Equidad = {
    bounce = net_bounce.nb20,
    movement = movement.NXT7,
    physics = net_physics.PortoT,
    net3d = net3D.OriginalT1H2,
    shape = Shape.NetOriginal,
    pattern = "P095",
    color_id = "2654",
    sound_file = "SE_Movement",
},
Independiente_Santa_Fe = {
    bounce = net_bounce.nb18,
    movement = movement.NXT9,
    physics = net_physics.PItaly,
    net3d = net3D.Original,
    shape = Shape.MidDeepNet,
    pattern = "P078",
    color_id = "2657",
    sound_file = "SE_Movement",
},
Alianza_Petrolera = {
    bounce = net_bounce.nb20,
    movement = movement.FIFA2,
    physics = net_physics.PLow,
    net3d = net3D.OriginalT2L1,
    shape = Shape.SmallNet,
    pattern = "P095",
    color_id = "5207",
    sound_file = "SE_Movement",
},
Atletico_Bucaramanga = {
    bounce = net_bounce.nb18,
    movement = movement.NXT6,
    physics = net_physics.PNormal,
    net3d = net3D.OriginalT2L1,
    shape = Shape.PerfectSquareL,
    pattern = "P043",
    color_id = "5208",
    sound_file = "SE_Movement",
},
Deportivo_Pereira = {
    bounce = net_bounce.nb17,
    movement = movement.FIFA4,
    physics = net_physics.PLow,
    net3d = net3D.OriginalT1L1,
    shape = Shape.PerfectSquare,
    pattern = "P015",
    color_id = "5370",
    sound_file = "SE_Move0003",
},
Boyaca_Chico_FC = {
    bounce = net_bounce.nb10,
    movement = movement.EPL,
    physics = net_physics.PLow,
    net3d = net3D.OriginalL1,
    shape = Shape.PerfectSquare,
    pattern = "P003",
    color_id = "2195",
    sound_file = "SE_Move0001",
},
Union_Magdalena = {
    bounce = net_bounce.nb8,
    movement = movement.EPL,
    physics = net_physics.PL,
    net3d = net3D.OriginalL1,
    shape = Shape.NetOriginal,
    pattern = "P078",
    color_id = "5376",
    sound_file = "SE_Move0003",
},

-- Segunda Division
Jaguares_de_Cordoba = {
    bounce = net_bounce.nb10,
    movement = movement.NXT6,
    physics = net_physics.PortoT,
    net3d = net3D.OriginalT1,
    shape = Shape.NetOriginal,
    pattern = "P098",
    color_id = "5210",
    sound_file = "SE_Movement",
},
Boyaca_Patriotas_FC = {
    bounce = net_bounce.nb17,
    movement = movement.NXT2,
    physics = net_physics.Italy,
    net3d = net3D.OriginalT1L1,
    shape = Shape.DeepTensNet,
    pattern = "P089",
    color_id = "5376",
    sound_file = "SE_Movement",
},
CD_Atletico_Huila = {
    bounce = net_bounce.nb15,
    movement = movement.PIPL,
    physics = net_physics.PL,
    net3d = net3D.OriginalT2L1,
    shape = Shape.CurveNet6,
    pattern = "P003",
    color_id = "goal",
    sound_file = "SE_Movement",
},
Cortulua = {
    bounce = net_bounce.nb18,
    movement = movement.Bouncy,
    physics = net_physics.PL,
    net3d = net3D.OriginalL2,
    shape = Shape.PerfectSquareH,
    pattern = "2209",
    color_id = "2209",
    sound_file = "SE_Movement",
},
-- Cups
Copa_Colombia = {
    bounce = net_bounce.nb20,
    movement = movement.Italy,
    physics = net_physics.Italy,
    net3d = net3D.Original,
    shape = Shape.PerfectSquare,
    pattern = "0091",
    color_id = "0091",
    sound_file = "SE_Movement",
},
Supercopa_Colombia = {
    bounce = net_bounce.nb20,
    movement = movement.Italy,
    physics = net_physics.Italy,
    net3d = net3D.Original,
    shape = Shape.PerfectSquare,
    pattern = "0091",
    color_id = "0091",
    sound_file = "SE_Movement",
},


--//================================================================================================================================================================//

-- USA
-- Major League Soccer
Atlanta = {
    bounce = net_bounce.nb18,
    movement = movement.NXT7,
    physics = net_physics.PortoT,
    net3d = net3D.OriginalH1,
    shape = Shape.MidLowNet,
    pattern = "P021",
    color_id = "5736",
    sound_file = "SE_Movement",
},
Chicago_Fire = {
    bounce = net_bounce.nb15,
    movement = movement.NXT8,
    physics = net_physics.PItaly,
    net3d = net3D.OriginalH1,
    shape = Shape.MidDeepNet,
    pattern = "P060",
    color_id = "4148",
    sound_file = "SE_Movement",
},
FC_Cincinnati = {
    bounce = net_bounce.nb20,
    movement = movement.EPL6,
    physics = net_physics.SPortoT,
    net3d = net3D.OriginalT2H2,
    shape = Shape.MidCurveNet,
    pattern = "P099",
    color_id = "5737",
    sound_file = "SE_Movement",
},
Colorado_Rapids = {
    bounce = net_bounce.nb19,
    movement = movement.NXT10,
    physics = net_physics.PSpain,
    net3d = net3D.Original,
    shape = Shape.SAfricaWC2010,
    pattern = "P084",
    color_id = "4150",
    sound_file = "SE_Movement",
},
Columbus_Crew = {
    bounce = net_bounce.nb18,
    movement = movement.NXT7,
    physics = net_physics.PortoLT,
    net3d = net3D.OriginalT2,
    shape = Shape.MidDeepNet,
    pattern = "P084",
    color_id = "4151",
    sound_file = "SE_Movement",
},
FC_Dallas = {
    bounce = net_bounce.nb18,
    movement = movement.NXT6,
    physics = net_physics.Italy2,
    net3d = net3D.OriginalT1,
    shape = Shape.CurveNet6,
    pattern = "P003",
    color_id = "4153",
    sound_file = "SE_Movement",
},
DC_United = {
    bounce = net_bounce.nb20,
    movement = movement.NXT7,
    physics = net_physics.PortoLT,
    net3d = net3D.OriginalT2H1,
    shape = Shape.MidDeepNet,
    pattern = "P084",
    color_id = "4152",
    sound_file = "SE_Movement",
},
Inter_Miami = {
    bounce = net_bounce.nb20,
    movement = movement.NXT6,
    physics = net_physics.PortoLT,
    net3d = net3D.OriginalT2H1,
    shape = Shape.MidDeepNet,
    pattern = "P060",
    color_id = "5738",
    sound_file = "SE_Movement",
},
Kansas_City = {
    bounce = net_bounce.nb20,
    movement = movement.FIFA4,
    physics = net_physics.SIPL,
    net3d = net3D.OriginalT2,
    shape = Shape.SAfricaWC2010,
    pattern = "P003",
    color_id = "4164",
    sound_file = "SE_Movement",
},
LAFC = {
    bounce = net_bounce.nb20,
    movement = movement.FIFA2,
    physics = net_physics.PLow,
    net3d = net3D.OriginalT2L1,
    shape = Shape.SmallNet,
    pattern = "P020",
    color_id = "5741",
    sound_file = "SE_Movement",
},
LA_Galaxy = {
    bounce = net_bounce.nb20,
    movement = movement.NXT8,
    physics = net_physics.PortoLT,
    net3d = net3D.OriginalT2H2,
    shape = Shape.MidDeepNet,
    pattern = "P019",
    color_id = "4155",
    sound_file = "SE_Movement",
},
Minnesota_United = {
    bounce = net_bounce.nb8,
    movement = movement.EPL,
    physics = net_physics.IPL,
    net3d = net3D.Original,
    shape = Shape.PerfectSquareL,
    pattern = "5742",
    color_id = "5742",
    sound_file = "SE_Movement",
},
CF_Montreal = {
    bounce = net_bounce.nb20,
    movement = movement.NXT8,
    physics = net_physics.SPortoT,
    net3d = net3D.OriginalT2H2,
    shape = Shape.MidDeepNet,
    pattern = "P060",
    color_id = "4156",
    sound_file = "SE_Movement",
},
Nashiville = {
    bounce = net_bounce.nb18,
    movement = movement.NXT7,
    physics = net_physics.PortoT,
    net3d = net3D.OriginalT1L1,
    shape = Shape.MidDeepNet2,
    pattern = "P084",
    color_id = "5739",
    sound_file = "SE_Movement",
},
New_York_City = {
    bounce = net_bounce.nb19,
    movement = movement.EPL6,
    physics = net_physics.PItaly,
    net3d = net3D.OriginalH1,
    shape = Shape.NetOriginal,
    pattern = "P084",
    color_id = "5061",
    sound_file = "SE_Movement",
},
New_York_RB = {
    bounce = net_bounce.nb20,
    movement = movement.NXT6,
    physics = net_physics.PIPL,
    net3d = net3D.OriginalT3,
    shape = Shape.NetOriginal,
    pattern = "P044",
    color_id = "4158",
    sound_file = "SE_Movement",
},
New_England_Revolution = {
    bounce = net_bounce.nb18,
    movement = movement.FIFA5,
    physics = net_physics.SItaly,
    net3d = net3D.OriginalT1,
    shape = Shape.Belly,
    pattern = "P090",
    color_id = "4157",
    sound_file = "SE_Movement",
},
Orlando_City = {
    bounce = net_bounce.nb20,
    movement = movement.NXT8,
    physics = net_physics.SPortoT,
    net3d = net3D.OriginalT2H2,
    shape = Shape.MidDeepNet,
    pattern = "P060",
    color_id = "5062",
    sound_file = "SE_Movement",
},
Portland_Timbers = {
    bounce = net_bounce.nb20,
    movement = movement.FIFA4,
    physics = net_physics.SIPL,
    net3d = net3D.OriginalT2,
    shape = Shape.SAfricaWC2010,
    pattern = "P060",
    color_id = "4160",
    sound_file = "SE_Movement",
},
San_Jose = {
    bounce = net_bounce.nb21,
    movement = movement.Porto,
    physics = net_physics.PortoT,
    net3d = net3D.Original,
    shape = Shape.MidDeepNet,
    pattern = "P095",
    color_id = "4162",
    sound_file = "SE_Movement",
},
Seattle_Sounders = {
    bounce = net_bounce.nb18,
    movement = movement.NXT6,
    physics = net_physics.PItaly,
    net3d = net3D.OriginalT1H1,
    shape = Shape.MidDeepNet,
    pattern = "P043",
    color_id = "4163",
    sound_file = "SE_Movement",
},
Toronto = {
    bounce = net_bounce.nb20,
    movement = movement.EPL6,
    physics = net_physics.SPortoT,
    net3d = net3D.OriginalT2H2,
    shape = Shape.MidCurveNet,
    pattern = "P099",
    color_id = "4165",
    sound_file = "SE_Movement",
},
Vancouver_Whitecaps = {
    bounce = net_bounce.nb18,
    movement = movement.EPL6,
    physics = net_physics.IPL,
    net3d = net3D.OriginalT1,
    shape = Shape.PerfectSquareL,
    pattern = "P084",
    color_id = "4166",
    sound_file = "SE_Movement",
},

--//================================================================================================================================================================//

-- OTHER AMERICAN LEAGUES

Club_Alianza_Lima = {
    bounce = net_bounce.nb20,
    movement = movement.FIFA2,
    physics = net_physics.PLow,
    net3d = net3D.OriginalT2L1,
    shape = Shape.SmallNet,
    pattern = "P022",
    color_id = "2287",
    sound_file = "SE_Movement",
},
SD_Aucas = {
    bounce = net_bounce.nb20,
    movement = movement.FIFA2,
    physics = net_physics.SItaly,
    net3d = net3D.OriginalT2L1,
    shape = Shape.SmallNet,
    pattern = "P081",
    color_id = "5458",
    sound_file = "SE_Movement",
},
Barcelona_SC = {
    bounce = net_bounce.nb19,
    movement = movement.NXT6,
    physics = net_physics.PSpain,
    net3d = net3D.OriginalT2L1,
    shape = Shape.NetOriginal,
    pattern = "P021",
    color_id = "2658",
    sound_file = "SE_Movement",
},
Bolívar_La_Paz = {
    bounce = net_bounce.nb18,
    movement = movement.NXT6,
    physics = net_physics.PSpain,
    net3d = net3D.OriginalT1,
    shape = Shape.NetOriginal,
    pattern = "P060",
    color_id = "2283",
    sound_file = "SE_Movement",
},
The_Strongest = {
    bounce = net_bounce.nb8,
    movement = movement.NXT6,
    physics = net_physics.Spain2,
    net3d = net3D.OriginalT2L1,
    shape = Shape.CampNouClassic,
    pattern = "P078",
    color_id = "2502",
    sound_file = "SE_Movement",
},
Independiente_Del_Valle = {
    bounce = net_bounce.nb15,
    movement = movement.NXT8,
    physics = net_physics.PIPL,
    net3d = net3D.OriginalT1,
    shape = Shape.NetOriginal,
    pattern = "P078",
    color_id = "2659",
    sound_file = "SE_Movement",
},
Club_Cerro_Porteño = {
    bounce = net_bounce.nb18,
    movement = movement.NXT6,
    physics = net_physics.PSpain,
    net3d = net3D.OriginalL1,
    shape = Shape.PerfectSquare,
    pattern = "P019",
    color_id = "1260",
    sound_file = "SE_Movement",
},
Olimpia_Asun = {
    bounce = net_bounce.nb20,
    movement = movement.NXT3,
    physics = net_physics.PItaly,
    net3d = net3D.Original,
    shape = Shape.NetOriginal,
    pattern = "P083",
    color_id = "1261",
    sound_file = "SE_Movement",
},
Club_Libertad = {
    bounce = net_bounce.nb18,
    movement = movement.NXT4,
    physics = net_physics.SSpain,
    net3d = net3D.Original,
    shape = Shape.PerfectSquare,
    pattern = "P019",
    color_id = "2198",
    sound_file = "SE_Movement",
},
Universitario_Deportes = {
    bounce = net_bounce.nb20,
    movement = movement.FIFA4,
    physics = net_physics.SItaly,
    net3d = net3D.OriginalT2L2,
    shape = Shape.MidTriangleNet,
    pattern = "P019",
    color_id = "2215",
    sound_file = "SE_Movement",
},
Sporting_Cristal = {
    bounce = net_bounce.nb6,
    movement = movement.NXT6,
    physics = net_physics.PItaly,
    net3d = net3D.OriginalT3H1,
    shape = Shape.Fener,
    pattern = "P066",
    color_id = "2216",
    sound_file = "SE_Movement",
},
Club_Nacional = {
    bounce = net_bounce.nb18,
    movement = movement.NXT6,
    physics = net_physics.SIPL,
    net3d = net3D.OriginalT2,
    shape = Shape.MidCurveNet,
    pattern = "P043",
    color_id = "1262",
    sound_file = "SE_Movement",
},
CA_Peñarol = {
    bounce = net_bounce.nb17,
    movement = movement.FIFA5,
    physics = net_physics.PSpain,
    net3d = net3D.OriginalT2L1,
    shape = Shape.MidDeepNet,
    pattern = "P060",
    color_id = "1263",
    sound_file = "SE_Movement",
},
Deportivo_Táchira = {
    bounce = net_bounce.nb19,
    movement = movement.NXT6,
    physics = net_physics.PSpain,
    net3d = net3D.OriginalT2,
    shape = Shape.NetOriginal,
    pattern = "P060",
    color_id = "2218",
    sound_file = "SE_Movement",
},
Monagas_SC = {
    bounce = net_bounce.nb19,
    movement = movement.NXT7,
    physics = net_physics.PSpain,
    net3d = net3D.OriginalT1,
    shape = Shape.NetOriginal,
    pattern = "P060",
    color_id = "2701",
    sound_file = "SE_Movement",
},
Zamora_FC = {
    bounce = net_bounce.nb6,
    movement = movement.FIFA5,
    physics = net_physics.SItaly,
    net3d = net3D.OriginalL1,
    shape = Shape.MidTriangleNet,
    pattern = "P060",
    color_id = "0899",
    sound_file = "SE_Movement",
},


--//================================================================================================================================================================//
--//================================================================================================================================================================//

-- ASIA
-- Japan
--  J League
Consadole_Sapporo = {
    bounce = net_bounce.nb20,
    movement = movement.EPL,
    physics = net_physics.IPL,
    net3d = net3D.Original,
    shape = Shape.MidDeepNet,
    pattern = "0144",
    color_id = "0144",
    sound_file = "SE_Movement",
},
Kashima_Antlers = {
    bounce = net_bounce.nb17,
    movement = movement.FirmSnappy13,
    physics = net_physics.OriginalNL2Low,
    net3d = net3D.OriginalL1,
    shape = Shape.KashimaNet,
    pattern = "P089",
    color_id = "0146",
    sound_file = "SE_Movement",
},
Urawa_Reds = {
    bounce = net_bounce.nb19,
    movement = movement.NXT2,
    physics = net_physics.PItaly,
    net3d = net3D.OriginalT5,
    shape = Shape.MidDeepNet2,
    pattern = "P081",
    color_id = "0147",
    sound_file = "SE_Movement",
},
Kashiwa_Reysol = {
    bounce = net_bounce.nb8,
    movement = movement.NXT8,
    physics = net_physics.Brasil,
    net3d = net3D.OriginalT2L1,
    shape = Shape.NetOriginal,
    pattern = "P088",
    color_id = "0149",
    sound_file = "SE_Movement",
},
FC_Tokyo = {
    bounce = net_bounce.nb20,
    movement = movement.NXT8,
    physics = net_physics.SItaly,
    net3d = net3D.OriginalT2L1,
    shape = Shape.PerfectSquare,
    pattern = "P082",
    color_id = "0150",
    sound_file = "SE_Movement",
},
Yokohama_Marinos = {
    bounce = net_bounce.nb20,
    movement = movement.NXT7,
    physics = net_physics.PLow,
    net3d = net3D.OriginalT2H1,
    shape = Shape.MidDeepNet2,
    pattern = "P088",
    color_id = "0152",
    sound_file = "SE_Movement",
},
Machida_Zelvia = {
    bounce = net_bounce.nb15,
    movement = movement.NXT10,
    physics = net_physics.PItaly,
    net3d = net3D.OriginalH1,
    shape = Shape.PerfectSquareL,
    pattern = "P089",
    color_id = "2372",
    sound_file = "SE_Movement",
},
Jubilo_Iwata = {
    bounce = net_bounce.nb20,
    movement = movement.FIFA2,
    physics = net_physics.PItaly,
    net3d = net3D.OriginalT1L1,
    shape = Shape.PerfectSquare,
    pattern = "P081",
    color_id = "0154",
    sound_file = "SE_Movement",
},
Nagoya_Grampus = {
    bounce = net_bounce.nb20,
    movement = movement.FIFA2,
    physics = net_physics.PItaly,
    net3d = net3D.OriginalT5,
    shape = Shape.MidDeepNet,
    pattern = "P075",
    color_id = "0155",
    sound_file = "SE_Movement",
},
Kyoto_Sanga = {
    bounce = net_bounce.nb20,
    movement = movement.FIFA2,
    physics = net_physics.Spain,
    net3d = net3D.Original,
    shape = Shape.NetOriginal,
    pattern = "P075",
    color_id = "0156",
    sound_file = "SE_Movement",
},
Gamba_Osaka = {
    bounce = net_bounce.nb20,
    movement = movement.FIFA2,
    physics = net_physics.PItaly,
    net3d = net3D.OriginalT2L1,
    shape = Shape.PerfectSquare,
    pattern = "P003",
    color_id = "0157",
    sound_file = "SE_Movement",
},
Vissel_Kobe = {
    bounce = net_bounce.nb10,
    movement = movement.EPL2,
    physics = net_physics.SItaly,
    net3d = net3D.OriginalT2,
    shape = Shape.PerfectSquare,
    pattern = "P086",
    color_id = "0158",
    sound_file = "SE_Movement",
},
Sanfrecce_Hiroshima = {
    bounce = net_bounce.nb15,
    movement = movement.FirmSnappy2,
    physics = net_physics.SItalyN,
    net3d = net3D.OriginalT2L1,
    shape = Shape.PerfectSquareL,
    pattern = "P086",
    color_id = "0159",
    sound_file = "SE_Movement",
},
Kawasaki_Frontale = {
    bounce = net_bounce.nb20,
    movement = movement.NXT7,
    physics = net_physics.PItaly,
    net3d = net3D.OriginalT2,
    shape = Shape.MidDeepNet2,
    pattern = "P075",
    color_id = "0163",
    sound_file = "SE_Movement",
},
Shonan_Bellmare = {
    bounce = net_bounce.nb15,
    movement = movement.NXT9,
    physics = net_physics.Porto,
    net3d = net3D.OriginalT2L1,
    shape = Shape.MidDeepNet,
    pattern = "P075",
    color_id = "0165",
    sound_file = "SE_Movement",
},
Cerezo_Osaka = {
    bounce = net_bounce.nbFIFA2,
    movement = movement.FIFA4,
    physics = net_physics.Spain,
    net3d = net3D.Original,
    shape = Shape.NetOriginal,
    pattern = "P085",
    color_id = "0168",
    sound_file = "SE_Movement",
},
Avispa_Fukuoka = {
    bounce = net_bounce.nb20,
    movement = movement.EPL9,
    physics = net_physics.Italy2,
    net3d = net3D.Original,
    shape = Shape.CurveNet6,
    pattern = "P075",
    color_id = "0169",
    sound_file = "SE_Movement",
},
Sagan_Tosu = {
    bounce = net_bounce.nb20,
    movement = movement.FIFA2,
    physics = net_physics.PItaly,
    net3d = net3D.OriginalT2L1,
    shape = Shape.PerfectSquare,
    pattern = "P003",
    color_id = "0170",
    sound_file = "SE_Movement",
},
Tokyo_Verdy = {
    bounce = net_bounce.nb20,
    movement = movement.NXT7,
    physics = net_physics.PLow,
    net3d = net3D.OriginalT2L1,
    shape = Shape.MidDeepNet2,
    pattern = "P088",
    color_id = "0164",
    sound_file = "SE_Movement",
},
Albirex_Niigata = {
    bounce = net_bounce.nb18,
    movement = movement.Firm3,
    physics = net_physics.SIPL,
    net3d = net3D.Original,
    shape = Shape.NiigataNet,
    pattern = "P091",
    color_id = "0167",
    sound_file = "SE_Movement",
},
Shimizu_Pulse = {
    bounce = net_bounce.nbFIFA2,
    movement = movement.NXT2,
    physics = net_physics.Italy,
    net3d = net3D.OriginalT2,
    shape = Shape.CampNouClassic,
    pattern = "0153",
    color_id = "0153",
    sound_file = "SE_Movement",
},
-- Cup
Emperors_Cup = {
    bounce = net_bounce.nb18,
    movement = movement.EPL,
    physics = net_physics.PLow,
    net_movement3 = net_physics.PortoLT,
    net3d = net3D.Real,
    shape = Shape.MidDeepNetEPL,
    pattern = "P086",
    goalnetcolor = "NC00",
    n_of_strings = "0159",
    rod_position = "0159",
    sound_file = "SE_Movement",
},

-- CHINA
--  Superleague
Beijing_Guoan = {
    bounce = net_bounce.nb20,
    movement = movement.FIFA2,
    physics = net_physics.SItaly,
    net3d = net3D.OriginalL1,
    shape = Shape.DeepPerfSqr2,
    pattern = "P095",
    color_id = "0295",
    sound_file = "SE_Movement",
},
Cangzhou_Mighty = {
    bounce = net_bounce.nb10,
    movement = movement.FIFA5,
    physics = net_physics.SItaly,
    net3d = net3D.OriginalT3L1,
    shape = Shape.DeepLoseNet2,
    pattern = "P043",
    color_id = "5185",
    sound_file = "SE_Movement",
},
Changchun_Yatai = {
    bounce = net_bounce.nb10,
    movement = movement.FIFA5,
    physics = net_physics.SItaly,
    net3d = net3D.OriginalT3L1,
    shape = Shape.DeepLoseNet2,
    pattern = "P044",
    color_id = "0302",
    sound_file = "SE_Movement",
},
Chengdu_Rongcheng = {
    bounce = net_bounce.nb20,
    movement = movement.FIFA5,
    physics = net_physics.SItaly,
    net3d = net3D.OriginalL1,
    shape = Shape.DeepLoseNet2,
    pattern = "P044",
    color_id = "0314",
    sound_file = "SE_Movement",
},
Dalian_Pro = {
    bounce = net_bounce.nb10,
    movement = movement.FIFA5,
    physics = net_physics.SItaly,
    net3d = net3D.OriginalT3L1,
    shape = Shape.DeepLoseNet2,
    pattern = "P044",
    color_id = "4092",
    sound_file = "SE_Movement",
},
Wuhan_Three_Towns = {
    bounce = net_bounce.nb18,
    movement = movement.FIFA4,
    physics = net_physics.IPL,
    net3d = net3D.OriginalT1,
    shape = Shape.MidDeepNet,
    pattern = "P044",
    color_id = "0304",
    sound_file = "SE_Movement",
},
Henan_Songshan = {
    bounce = net_bounce.nbMed5,
    movement = movement.FirmSnappy2,
    physics = net_physics.SItalyN,
    net3d = net3D.OriginalT3L1,
    shape = Shape.DeepLoseNet2,
    pattern = "P044",
    color_id = "5171",
    sound_file = "SE_Movement",
},
Meizhou_Hakka = {
    bounce = net_bounce.nb10,
    movement = movement.FIFA5,
    physics = net_physics.SIPL,
    net3d = net3D.OriginalT3L1,
    shape = Shape.DeepLoseNet2,
    pattern = "P044",
    color_id = "5181",
    sound_file = "SE_Movement",
},
Nantong_Zhiyun = {
    bounce = net_bounce.nb20,
    movement = movement.FIFA2,
    physics = net_physics.PLow,
    net3d = net3D.OriginalL2,
    shape = Shape.Zaragoza,
    pattern = "P060",
    color_id = "5586",
    sound_file = "SE_Movement",
},
Qingdao_Hainiu = {
    bounce = net_bounce.nb20,
    movement = movement.FIFA5,
    physics = net_physics.PItaly,
    net3d = net3D.OriginalB1,
    shape = Shape.DeepLoseNet2,
    pattern = "P044",
    color_id = "0297",
    sound_file = "SE_Movement",
},
Shandong_Taishan = {
    bounce = net_bounce.nb10,
    movement = movement.FIFA5,
    physics = net_physics.PIPL,
    net3d = net3D.OriginalT3L1,
    shape = Shape.DeepLoseNet2,
    pattern = "P082",
    color_id = "4168",
    sound_file = "SE_Movement",
},
Guangzhou_City = {
    bounce = net_bounce.nb21,
    movement = movement.EPL,
    physics = net_physics.IPL,
    net3d = net3D.Original,
    shape = Shape.DeepLoseNet,
    pattern = "4943",
    color_id = "4943",
    sound_file = "SE_Movement",
},
Shanghai_Shenhua = {
    bounce = net_bounce.nb10,
    movement = movement.FIFA5,
    physics = net_physics.PIPL,
    net3d = net3D.OriginalT3L1,
    shape = Shape.DeepLoseNet2,
    pattern = "P021",
    color_id = "5173",
    sound_file = "SE_Movement",
},
Shanghai_Port = {
    bounce = net_bounce.nb10,
    movement = movement.FIFA5,
    physics = net_physics.PIPL,
    net3d = net3D.OriginalT3,
    shape = Shape.DeepLoseNet2,
    pattern = "P021",
    color_id = "4094",
    sound_file = "SE_Movement",
},
Tianjin_Teda = {
    bounce = net_bounce.nb10,
    movement = movement.FIFA5,
    physics = net_physics.PIPL,
    net3d = net3D.OriginalT3L1,
    shape = Shape.DeepLoseNet2,
    pattern = "P021",
    color_id = "5175",
    sound_file = "SE_Movement",
},
Zhejiang_Greentown = {
    bounce = net_bounce.nb20,
    movement = movement.FIFA5,
    physics = net_physics.PItaly,
    net3d = net3D.OriginalH1,
    shape = Shape.DeepLoseNet,
    pattern = "P021",
    color_id = "5180",
    sound_file = "SE_Movement",
},
-- 2. League
Shenzhen_FC = {
    bounce = net_bounce.nb18,
    movement = movement.EPL,
    physics = net_physics.PIPL,
    net3d = net3D.OriginalT1L1,
    shape = Shape.NetOriginal,
    pattern = "P021",
    color_id = "5184",
    sound_file = "SE_Movement",
},
Kunshan_FC = {
    bounce = net_bounce.nb17,
    movement = movement.EPL,
    physics = net_physics.IPL,
    net3d = net3D.Original,
    shape = Shape.DeepLoseNet,
    pattern = "P021",
    color_id = "0310",
    sound_file = "SE_Movement",
},
-- Chinese Cup
Chinese_FA_Cup = {
    bounce = net_bounce.nb18,
    movement = movement.EPL,
    physics = net_physics.PLow,
    net_movement3 = net_physics.PortoLT,
    net3d = net3D.Real,
    shape = Shape.MidDeepNetEPL,
    pattern = "P003",
    color_id = "4180",
    n_of_strings = "4180",
    rod_position = "4180",
    sound_file = "SE_Movement",
},

--//================================================================================================================================================================//

-- SAUDI ARABIA
--  Pro League
Al_Nassr_FC = {
    bounce = net_bounce.nb21,
    movement = movement.Italy,
    physics = net_physics.Italy,
    net3d = net3D.Original,
    shape = Shape.NetOriginalS,
    pattern = "2577",
    color_id = "2577",
    sound_file = "SE_Movement",
},
Al_Hilal = {
    bounce = net_bounce.nb19,
    movement = movement.Original,
    physics = net_physics.Original,
    net3d = net3D.Original,
    shape = Shape.NetOriginal,
    pattern = "1489",
    color_id = "1489",
    sound_file = "SE_Movement",
},
Al_Ittihad = {
    bounce = net_bounce.nb10,
    movement = movement.Original,
    physics = net_physics.Normal,
    net3d = net3D.Original,
    shape = Shape.Trbz,
    pattern = "1350",
    color_id = "1350",
    sound_file = "SE_Movement",
},
Al_Hazem_SC = {
    bounce = net_bounce.nb18,
    movement = movement.Italy,
    physics = net_physics.Italy,
    net3d = net3D.Original,
    shape = Shape.PerfectSquareH,
    pattern = "9000",
    color_id = "9000",
    sound_file = "SE_Movement",
},
Abha_Club = {
    bounce = net_bounce.nb10,
    movement = movement.Original,
    physics = net_physics.Normal,
    net3d = net3D.Original,
    shape = Shape.Trbz,
    pattern = "9012",
    color_id = "9012",
    sound_file = "SE_Movement",
},
Al_Shabab_Club = {
    bounce = net_bounce.nb17,
    movement = movement.Porto,
    physics = net_physics.Porto,
    net3d = net3D.Original,
    shape = Shape.NetOriginal,
    pattern = "1348",
    color_id = "1348",
    sound_file = "SE_Movement",
},
Al_Ahli_SFC = {
    bounce = net_bounce.nb10,
    movement = movement.Balanced2,
    physics = net_physics.Italy,
    net3d = net3D.OriginalT3,
    shape = Shape.BalancedSquare,
    pattern = "P003",
    color_id = "1349",
    sound_file = "SE_Movement",
},
Al_Wehda_FC = {
    bounce = net_bounce.nb22,
    movement = movement.Italy,
    physics = net_physics.Italy,
    net3d = net3D.OLDPES,
    shape = Shape.Real,
    pattern = "1351",
    color_id = "1351",
    sound_file = "SE_Movement",
},
Al_Ettifaq_FC = {
    bounce = net_bounce.nb22,
    movement = movement.Italy,
    physics = net_physics.Italy,
    net3d = net3D.Original,
    shape = Shape.PerfectSquareL,
    pattern = "1902",
    color_id = "1902",
    sound_file = "SE_Movement",
},
Al_Fateh_SC = {
    bounce = net_bounce.nb10,
    movement = movement.Original,
    physics = net_physics.Normal,
    net3d = net3D.Original,
    shape = Shape.CampNouClassic,
    pattern = "2576",
    color_id = "2576",
    sound_file = "SE_Movement",
},
Al_Raed_SFC = {
    bounce = net_bounce.nb18,
    movement = movement.Italy,
    physics = net_physics.Italy,
    net3d = net3D.Original,
    shape = Shape.PerfectSquareH,
    pattern = "2578",
    color_id = "2578",
    sound_file = "SE_Movement",
},
Al_Taawoun_FC = {
    bounce = net_bounce.nb20,
    movement = movement.Italy,
    physics = net_physics.Italy,
    net3d = net3D.Original,
    shape = Shape.CurveNet6,
    pattern = "2580",
    color_id = "2580",
    sound_file = "SE_Movement",
},
Al_Riyadh_SC = {
    bounce = net_bounce.nb19,
    movement = movement.France,
    physics = net_physics.France,
    net3d = net3D.Original,
    shape = Shape.NetOriginalS,
    pattern = "P017",
    color_id = "9002",
    sound_file = "SE_Movement",
},
Damac_FC = {
    bounce = net_bounce.nb20,
    movement = movement.EPL,
    physics = net_physics.PLow,
    net3d = net3D.Original,
    shape = Shape.CurveNet6,
    pattern = "9003",
    color_id = "9003",
    sound_file = "SE_Movement",
},
Al_Okhdood_Club = {
    bounce = net_bounce.nb10,
    movement = movement.Original,
    physics = net_physics.Normal,
    net3d = net3D.Original,
    shape = Shape.Trbz,
    pattern = "9005",
    color_id = "9005",
    sound_file = "SE_Movement",
},
Al_Khaleej_Club = {
    bounce = net_bounce.nb19,
    movement = movement.Italy,
    physics = net_physics.Italy,
    net3d = net3D.Original,
    shape = Shape.NetOriginalS,
    pattern = "5010",
    color_id = "5010",
    sound_file = "SE_Movement",
},
Al_Tai_FC = {
    bounce = net_bounce.nb19,
    movement = movement.Italy,
    physics = net_physics.Italy,
    net3d = net3D.Original,
    shape = Shape.MidDeepNet,
    pattern = "9010",
    color_id = "9010",
    sound_file = "SE_Movement",
},
Al_Fayha_FC = {
    bounce = net_bounce.nb18,
    movement = movement.Original,
    physics = net_physics.Original,
    net3d = net3D.Original,
    shape = Shape.NetOriginal,
    pattern = "9014",
    color_id = "9014",
    sound_file = "SE_Movement",
},
-- Cups
KSA_Cup = {
    bounce = net_bounce.nb18,
    movement = movement.Italy,
    physics = net_physics.Italy,
    net3d = net3D.Original,
    shape = Shape.PerfectSquareH,
    pattern = "9000",
    color_id = "9000",
    n_of_strings = "9000",
    rod_position = "9000",
    sound_file = "SE_Movement",
},
KSA_Supercup = {
    bounce = net_bounce.nb22,
    movement = movement.Italy,
    physics = net_physics.Italy,
    net3d = net3D.OLDPES,
    shape = Shape.Real,
    pattern = "1351",
    color_id = "1351",
    n_of_strings = "1351",
    rod_position = "1351",
    sound_file = "SE_Movement",
},

--//================================================================================================================================================================//


-- OTHER ASIA
-- South Korea
-- K League
Jeonbuk_Hyundai_Motors = {
    bounce = net_bounce.nb18,
    movement = movement.NXT6,
    physics = net_physics.PIPL,
    net3d = net3D.OriginalT1H1,
    shape = Shape.MidDeepNet,
    pattern = "P043",
    color_id = "0279",
    sound_file = "SE_Movement",
},
Pohang_Steelers = {
    bounce = net_bounce.nb075_10,
    movement = movement.FirmSnappy20,
    physics = net_physics.SilkSheetN,
    net3d = net3D.Original,
    shape = Shape.ArsenalNet,
    pattern = "P084",
    color_id = "0172",
    sound_file = "SE_Movement",
},
Ulsan_Hyundai = {
    bounce = net_bounce.nb075_10,
    movement = movement.FirmSnappy20,
    physics = net_physics.SilkSheetN,
    net3d = net3D.Original,
    shape = Shape.ArsenalNet,
    pattern = "P084",
    color_id = "0172",
    sound_file = "SE_Movement",
},
Daegu_FC = {
    bounce = net_bounce.nb075_10,
    movement = movement.FirmSnappy20,
    physics = net_physics.SilkSheetN,
    net3d = net3D.Original,
    shape = Shape.ArsenalNet,
    pattern = "P084",
    color_id = "0172",
    sound_file = "SE_Movement",
},

--//================================================================================================================================================================//

-- Australia
-- A League
Sydney_FC = {
    bounce = net_bounce.nb075_10,
    movement = movement.FirmSnappy20,
    physics = net_physics.SilkSheetN,
    net3d = net3D.Original,
    shape = Shape.ArsenalNet,
    pattern = "P084",
    color_id = "0172",
    sound_file = "SE_Movement",
},
Melbourne_City_FC = {
    bounce = net_bounce.nb9,
    movement = movement.EPL9,
    physics = net_physics.Normal,
    net3d = net3D.OriginalT3L1,
    shape = Shape.Lic,
    pattern = "P065",
    color_id = "5773",
    sound_file = "SE_Move0004",
},

--//================================================================================================================================================================//

-- Iran
-- Persian Gulf Pro League
Esteghlal_FC = {
    bounce = net_bounce.nb075_10,
    movement = movement.FirmSnappy20,
    physics = net_physics.SilkSheetN,
    net3d = net3D.Original,
    shape = Shape.ArsenalNet,
    pattern = "P084",
    color_id = "0172",
    sound_file = "SE_Movement",
},
Tractor_FC = {
    bounce = net_bounce.nb20,
    movement = movement.FIFA2,
    physics = net_physics.PLow,
    net3d = net3D.OriginalL2,
    shape = Shape.Zaragoza,
    pattern = "P043",
    color_id = "2602",
    sound_file = "SE_Movement",
},
Foolad_FC = {
    bounce = net_bounce.nb075_10,
    movement = movement.FirmSnappy20,
    physics = net_physics.SilkSheetN,
    net3d = net3D.Original,
    shape = Shape.ArsenalNet,
    pattern = "P084",
    color_id = "0172",
    sound_file = "SE_Movement",
},
Persepolis_FC = {
    bounce = net_bounce.nb10,
    movement = movement.FIFA5,
    physics = net_physics.PIPL,
    net3d = net3D.OriginalT3L1,
    shape = Shape.DeepLoseNet2,
    pattern = "P043",
    color_id = "4951",
    sound_file = "SE_Movement",
},

--//================================================================================================================================================================//

-- Iraq
-- Iraqi Premier League
Al_Shorta_SC = {
    bounce = net_bounce.nb075_10,
    movement = movement.FirmSnappy20,
    physics = net_physics.SilkSheetN,
    net3d = net3D.Original,
    shape = Shape.ArsenalNet,
    pattern = "P084",
    color_id = "0172",
    sound_file = "SE_Movement",
},
Air_Force_Club = {
    bounce = net_bounce.nb075_10,
    movement = movement.FirmSnappy20,
    physics = net_physics.SilkSheetN,
    net3d = net3D.Original,
    shape = Shape.ArsenalNet,
    pattern = "P084",
    color_id = "0172",
    sound_file = "SE_Movement",
},

--//================================================================================================================================================================//

-- Hong Kong
-- Hong Kong Premier League
Kitchee = {
    bounce = net_bounce.nb075_10,
    movement = movement.FirmSnappy20,
    physics = net_physics.SilkSheetN,
    net3d = net3D.Original,
    shape = Shape.ArsenalNet,
    pattern = "P084",
    color_id = "0172",
    sound_file = "SE_Movement",
},

--//================================================================================================================================================================//

-- India
-- Indian Super League
FC_Goa = {
    bounce = net_bounce.nb075_10,
    movement = movement.FirmSnappy20,
    physics = net_physics.SilkSheetN,
    net3d = net3D.Original,
    shape = Shape.ArsenalNet,
    pattern = "P084",
    color_id = "0172",
    sound_file = "SE_Movement",
},
Mumbai_City_FC = {
    bounce = net_bounce.nb075_10,
    movement = movement.FirmSnappy20,
    physics = net_physics.SilkSheetN,
    net3d = net3D.Original,
    shape = Shape.ArsenalNet,
    pattern = "P084",
    color_id = "0172",
    sound_file = "SE_Movement",
},

--//================================================================================================================================================================//

-- Jordan
-- Jordan Pro League
Al_Wehdat_SC = {
    bounce = net_bounce.nb075_10,
    movement = movement.FirmSnappy20,
    physics = net_physics.SilkSheetN,
    net3d = net3D.Original,
    shape = Shape.ArsenalNet,
    pattern = "P084",
    color_id = "0172",
    sound_file = "SE_Movement",
},

--//================================================================================================================================================================//

-- Malaysia
-- Malaysia Super League
Johor_Darul_Ta_zim = {
    bounce = net_bounce.nb075_10,
    movement = movement.FirmSnappy20,
    physics = net_physics.SilkSheetN,
    net3d = net3D.Original,
    shape = Shape.ArsenalNet,
    pattern = "P084",
    color_id = "0172",
    sound_file = "SE_Movement",
},

--//================================================================================================================================================================//

-- Philippines
-- Philippines Football League
Ceres_Negros = {
    bounce = net_bounce.nb075_10,
    movement = movement.FirmSnappy20,
    physics = net_physics.SilkSheetN,
    net3d = net3D.Original,
    shape = Shape.ArsenalNet,
    pattern = "P084",
    color_id = "0172",
    sound_file = "SE_Movement",
},
United_City = {
    bounce = net_bounce.nb075_10,
    movement = movement.FirmSnappy20,
    physics = net_physics.SilkSheetN,
    net3d = net3D.Original,
    shape = Shape.ArsenalNet,
    pattern = "P084",
    color_id = "0172",
    sound_file = "SE_Movement",
},
Kaya_FC_Iloilo = {
    bounce = net_bounce.nb075_10,
    movement = movement.FirmSnappy20,
    physics = net_physics.SilkSheetN,
    net3d = net3D.Original,
    shape = Shape.ArsenalNet,
    pattern = "P084",
    color_id = "0172",
    sound_file = "SE_Movement",
},

--//================================================================================================================================================================//

-- Qatar
-- Qatar Stars League
Al_Rayyan_SC = {
    bounce = net_bounce.nb075_10,
    movement = movement.FirmSnappy20,
    physics = net_physics.SilkSheetN,
    net3d = net3D.Original,
    shape = Shape.ArsenalNet,
    pattern = "P084",
    color_id = "0172",
    sound_file = "SE_Movement",
},
Al_Duhail_SC = {
    bounce = net_bounce.nb075_10,
    movement = movement.FirmSnappy20,
    physics = net_physics.SilkSheetN,
    net3d = net3D.Original,
    shape = Shape.ArsenalNet,
    pattern = "P084",
    color_id = "0172",
    sound_file = "SE_Movement",
},
Al_Sadd_SC = {
    bounce = net_bounce.nb075_10,
    movement = movement.FirmSnappy20,
    physics = net_physics.SilkSheetN,
    net3d = net3D.Original,
    shape = Shape.ArsenalNet,
    pattern = "P084",
    color_id = "0172",
    sound_file = "SE_Movement",
},
Al_Gharafa_SC = {
    bounce = net_bounce.nb075_10,
    movement = movement.FirmSnappy20,
    physics = net_physics.SilkSheetN,
    net3d = net3D.Original,
    shape = Shape.ArsenalNet,
    pattern = "P084",
    color_id = "0172",
    sound_file = "SE_Movement",
},

--//================================================================================================================================================================//

-- Thailand
-- Thai League 1
Buriram_United = {
    bounce = net_bounce.nb075_10,
    movement = movement.FirmSnappy20,
    physics = net_physics.SilkSheetN,
    net3d = net3D.Original,
    shape = Shape.ArsenalNet,
    pattern = "P084",
    color_id = "0172",
    sound_file = "SE_Movement",
},
BG_Pathum_United = {
    bounce = net_bounce.nb075_10,
    movement = movement.FirmSnappy20,
    physics = net_physics.SilkSheetN,
    net3d = net3D.Original,
    shape = Shape.ArsenalNet,
    pattern = "P084",
    color_id = "0172",
    sound_file = "SE_Movement",
},
Chiangrai_United_FC = {
    bounce = net_bounce.nb075_10,
    movement = movement.FirmSnappy20,
    physics = net_physics.SilkSheetN,
    net3d = net3D.Original,
    shape = Shape.ArsenalNet,
    pattern = "P084",
    color_id = "0172",
    sound_file = "SE_Movement",
},
Port_FC = {
    bounce = net_bounce.nb075_10,
    movement = movement.FirmSnappy20,
    physics = net_physics.SilkSheetN,
    net3d = net3D.Original,
    shape = Shape.ArsenalNet,
    pattern = "P084",
    color_id = "0172",
    sound_file = "SE_Movement",
},
Ratchaburi_Mitr_Phol = {
    bounce = net_bounce.nb075_10,
    movement = movement.FirmSnappy20,
    physics = net_physics.SilkSheetN,
    net3d = net3D.Original,
    shape = Shape.ArsenalNet,
    pattern = "P084",
    color_id = "0172",
    sound_file = "SE_Movement",
},

--//================================================================================================================================================================//

-- UAE
-- UAE Pro League
Shabab_Al_Ahli_Dubai = {
    bounce = net_bounce.nb075_10,
    movement = movement.FirmSnappy20,
    physics = net_physics.SilkSheetN,
    net3d = net3D.Original,
    shape = Shape.ArsenalNet,
    pattern = "P084",
    color_id = "0172",
    sound_file = "SE_Movement",
},
Al_Wahda_FC = {
    bounce = net_bounce.nb075_10,
    movement = movement.FirmSnappy20,
    physics = net_physics.SilkSheetN,
    net3d = net3D.Original,
    shape = Shape.ArsenalNet,
    pattern = "P084",
    color_id = "0172",
    sound_file = "SE_Movement",
},
Sharjah_FC = {
    bounce = net_bounce.nb075_10,
    movement = movement.FirmSnappy20,
    physics = net_physics.SilkSheetN,
    net3d = net3D.Original,
    shape = Shape.ArsenalNet,
    pattern = "P084",
    color_id = "0172",
    sound_file = "SE_Movement",
},

--//================================================================================================================================================================//

-- Vietnam
-- V.League 1
Viettel_FC = {
    bounce = net_bounce.nb075_10,
    movement = movement.FirmSnappy20,
    physics = net_physics.SilkSheetN,
    net3d = net3D.Original,
    shape = Shape.ArsenalNet,
    pattern = "P084",
    color_id = "0172",
    sound_file = "SE_Movement",
},

--//================================================================================================================================================================//

-- Tajikistan
-- Tajik Higher League
FC_Istiqlol_Dushanbe = {
    bounce = net_bounce.nb075_10,
    movement = movement.FirmSnappy20,
    physics = net_physics.SilkSheetN,
    net3d = net3D.Original,
    shape = Shape.ArsenalNet,
    pattern = "P084",
    color_id = "0172",
    sound_file = "SE_Movement",
},

--//================================================================================================================================================================//

-- Uzbekistan
-- Uzbekistan Super League
Pakhtakor_Tashkent = {
    bounce = net_bounce.nb075_10,
    movement = movement.FirmSnappy20,
    physics = net_physics.SilkSheetN,
    net3d = net3D.Original,
    shape = Shape.ArsenalNet,
    pattern = "P084",
    color_id = "0172",
    sound_file = "SE_Movement",
},
AGMK_Olmaliq = {
    bounce = net_bounce.nb075_10,
    movement = movement.FirmSnappy20,
    physics = net_physics.SilkSheetN,
    net3d = net3D.Original,
    shape = Shape.ArsenalNet,
    pattern = "P084",
    color_id = "0172",
    sound_file = "SE_Movement",
},

--//================================================================================================================================================================//
--//================================================================================================================================================================//

-- FIFA
-- FIFA CWC 
FIFA_Club_World_Cup_Default = {
    bounce = net_bounce.nb03_5,
    movement = movement.FirmSnappy2,
    physics = net_physics.PItalyN,
    net3d = net3D.OriginalT1,
    shape = Shape.WC26_Net1,
    pattern = "P082",
    goalnetcolor = "6301",
    n_of_strings = "6301",
    rod_position = "6301",
    sound_file = "SE_Movement",
},
FIFA_Club_World_Cup_52 = {
    bounce = net_bounce.nb01_7,
    movement = movement.FirmSnappy2,
    physics = net_physics.PItalyN,
    net3d = net3D.OriginalT1,
    shape = Shape.WC26_Net2,
    pattern = "P089",
    goalnetcolor = "6302",
    n_of_strings = "6302",
    rod_position = "6302",
    sound_file = "SE_Movement",
},
FIFA_Club_World_Cup_53 = {
    bounce = net_bounce.nb03_10,
    movement = movement.FirmSnappy2,
    physics = net_physics.OriginalNL1Low,
    net3d = net3D.Original,
    shape = Shape.WC26_Net3,
    pattern = "P089",
    goalnetcolor = "6303",
    n_of_strings = "6303",
    rod_position = "6301",
    sound_file = "SE_Movement",
},
-- UEFA
Champions_League = {
    bounce = net_bounce.nb01_7,
    movement = movement.FirmSnappy5,
    physics = net_physics.OriginalNL2,
    net3d = net3D.Original,
    shape = Shape.BayernNet,
    pattern = "P010",
    goalnetcolor = "0127",
    n_of_strings = "0127",
    rod_position = "0127",
    sound_file = "SE_Movement",
},
Europa_League = {
    bounce = net_bounce.nbOT7,
    movement = movement.FirmSnappy6,
    physics = net_physics.OriginalNL1,
    net3d = net3D.Original,
    shape = Shape.BilbaoNet,
    pattern = "P018",
    goalnetcolor = "0258",
    n_of_strings = "0258",
    rod_position = "0258",
    sound_file = "SE_Move0003",
},
UEFA_Super_Cup = {
    bounce = net_bounce.nbMed5,
    movement = movement.FirmSnappy2,
    physics = net_physics.ItalyN,
    net3d = net3D.OriginalT1H1,
    shape = Shape.CurveNet3,
    pattern = "P078",
    goalnetcolor = "NC01",
    n_of_strings = "0190",
    rod_position = "0190",
    sound_file = "SE_Movement",
},


--//================================================================================================================================================================//
--//================================================================================================================================================================//

-- NATIONAL TEAMS
-- UEFA (EUROPE)

Ireland = {
    bounce = net_bounce.nb6,
    movement = movement.EPL9,
    physics = net_physics.SItalyN,
    net3d = net3D.OriginalT1,
    shape = Shape.NetOriginal2,
    pattern = "P044",
    goalnetcolor = "0006",
    n_of_strings = "0006",
    rod_position = "0006",
    sound_file = "SE_Movement",
},
Northern_Ireland = {
    bounce = net_bounce.nb19,
    movement = movement.FirmSnappy10,
    physics = net_physics.PIPLN,
    net3d = net3D.OriginalH1,
    shape = Shape.NetOriginalT,
    pattern = "P078",
    goalnetcolor = "0002",
    n_of_strings = "0002",
    rod_position = "0002",
    sound_file = "SE_Movement",
},
Scotland = {
    bounce = net_bounce.nbMed2,
    movement = movement.EPL,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.CurveNet2,
    pattern = "P044",
    goalnetcolor = "0003",
    n_of_strings = "0003",
    rod_position = "0003",
    sound_file = "SE_Move0002",
},
Wales = {
    bounce = net_bounce.nb18,
    movement = movement.FirmSnappy7,
    physics = net_physics.PItalyN,
    net3d = net3D.Original,
    shape = Shape.MidDeepNetS,
    pattern = "P021",
    goalnetcolor = "0004",
    n_of_strings = "0004",
    rod_position = "0004",
    sound_file = "SE_Move0003",
},
England = {
    bounce = net_bounce.nbMed5,
    movement = movement.FirmSnappy2,
    physics = net_physics.PortoLT,
    net3d = net3D.Original,
    shape = Shape.DeepLoseNet,
    pattern = "P044",
    goalnetcolor = "0005",
    n_of_strings = "0005",
    rod_position = "0005",
    sound_file = "SE_Movement",
},
Portugal = {
    bounce = net_bounce.nb18,
    movement = movement.FirmSnappy2,
    physics = net_physics.PItalyNT,
    net3d = net3D.OriginalT2L1,
    shape = Shape.MidDeepNet,
    pattern = "P078",
    goalnetcolor = "NC00",
    n_of_strings = "0191",
    rod_position = "0191",
    sound_file = "SE_Move0001",
},
Spain = {
    bounce = net_bounce.nb2122,
    movement = movement.FirmSnappy5,
    physics = net_physics.SItalyFirmT,
    net3d = net3D.OriginalT2L1,
    shape = Shape.Madrid,
    pattern = "P078",
    goalnetcolor = "NC00",
    n_of_strings = "0109",
    rod_position = "0109",
    sound_file = "SE_Move0004",
},
France = {
    bounce = net_bounce.nb18,
    movement = movement.Porto,
    physics = net_physics.PortoT,
    net3d = net3D.Belly,
    shape = Shape.Belly,
    pattern = "P021",
    goalnetcolor = "0012",
    n_of_strings = "0012",
    rod_position = "0012",
    sound_file = "SE_Movement",
},
Belgium = {
    bounce = net_bounce.nb6,
    movement = movement.EPL7,
    physics = net_physics.FIFA2,
    net3d = net3D.OriginalT5,
    shape = Shape.SAfricaWC2010,
    pattern = "0009",
    goalnetcolor = "NC00",
    n_of_strings = "0009",
    rod_position = "0009",
    sound_file = "SE_Move0003",
},
Netherlands_Amsterdam = {
    bounce = net_bounce.nb03_8,
    movement = movement.FC26_3,
    physics = net_physics.OriginalNL1,
    net3d = net3D.OriginalH5,
    shape = Shape.AjaxNet,
    pattern = "P078",
    goalnetcolor = "0010",
    n_of_strings = "0116",
    rod_position = "0116",
    sound_file = "SE_Movement",
},
Netherlands_Rotterdam = {
    bounce = net_bounce.nb10,
    movement = movement.FirmSnappy2,
    physics = net_physics.ItalyNT,
    net3d = net3D.Original,
    shape = Shape.FeyenoordNet,
    pattern = "P006",
    goalnetcolor = "NC71",
    n_of_strings = "0117",
    rod_position = "0117",
    sound_file = "SE_Movement",
},
Switzerland = {
    bounce = net_bounce.nbMidBounce,
    movement = movement.Snappy2,
    physics = net_physics.EPL,
    net3d = net3D.Lic,
    shape = Shape.PerfectSquareH,
    pattern = "P078",
    goalnetcolor = "NC00",
    n_of_strings = "1950",
    rod_position = "1950",
    sound_file = "SE_Movement",
},
Italy = {
    bounce = net_bounce.nb2021,
    movement = movement.FirmSnappy6,
    physics = net_physics.ItalyFirmT,
    net3d = net3D.OriginalT2L1,
    shape = Shape.HexagonalNet,
    pattern = "P084",
    goalnetcolor = "NC00",
    n_of_strings = "0125",
    rod_position = "0125",
    sound_file = "SE_Move0003",
},
Czech_Republic = {
    bounce = net_bounce.nb20,
    movement = movement.Snappy2,
    physics = net_physics.ItalyNT,
    net3d = net3D.OriginalT1L1,
    shape = Shape.Real2,
    pattern = "P078",
    goalnetcolor = "NC00",
    n_of_strings = "5189",
    rod_position = "5189",
    sound_file = "SE_Movement",
},
Germany = {
    bounce = net_bounce.nb2021,
    movement = movement.FirmSnappy2,
    physics = net_physics.ItalyNT,
    net3d = net3D.OriginalH1,
    shape = Shape.CurveNet9,
    pattern = "P089",
    goalnetcolor = "4125",
    n_of_strings = "4125",
    rod_position = "4125",
    sound_file = "SE_Movement",
},
Denmark = {
    bounce = net_bounce.nb19,
    movement = movement.NXT6,
    physics = net_physics.ItalyN,
    net3d = net3D.OriginalT4,
    shape = Shape.OgMidDeep,
    pattern = "P084",
    goalnetcolor = "NC00",
    n_of_strings = "1207",
    rod_position = "1207",
    sound_file = "SE_Move0001",
},
Norway = {
    bounce = net_bounce.nb20,
    movement = movement.EPL,
    physics = net_physics.IPL,
    net3d = net3D.Original,
    shape = Shape.NetOriginal,
    pattern = "0016",
    goalnetcolor = "0016",
    n_of_strings = "0016",
    rod_position = "0016",
    sound_file = "SE_Movement",
},
Sweden = {
    bounce = net_bounce.nb20,
    movement = movement.Porto,
    physics = net_physics.PortoLT,
    net3d = net3D.Original,
    shape = Shape.DeepLoseNet,
    pattern = "1583",
    goalnetcolor = "1583",
    n_of_strings = "1583",
    rod_position = "1583",
    sound_file = "SE_Movement",
},
Finland = {
    bounce = net_bounce.nb20,
    movement = movement.EPL,
    physics = net_physics.IPL,
    net3d = net3D.Original,
    shape = Shape.NetOriginal,
    pattern = "0018",
    goalnetcolor = "0018",
    n_of_strings = "0018",
    rod_position = "0018",
    sound_file = "SE_Movement",
},
Poland = {
    bounce = net_bounce.nb2021,
    movement = movement.Balanced3,
    physics = net_physics.ItalyNT,
    net3d = net3D.OriginalH1,
    shape = Shape.ImprovedMidDeep,
    pattern = "P078",
    goalnetcolor = "NC00",
    n_of_strings = "0019",
    rod_position = "0019",
    sound_file = "SE_Movement",
},
Slovakia = {
    bounce = net_bounce.nb20,
    movement = movement.FirmSnappy5,
    physics = net_physics.ItalyNT,
    net3d = net3D.Original,
    shape = Shape.NetOriginal,
    pattern = "P021",
    goalnetcolor = "NC00",
    n_of_strings = "0020",
    rod_position = "0020",
    sound_file = "SE_Movement",
},
Austria = {
    bounce = net_bounce.nb2021,
    movement = movement.FirmSnappy2,
    physics = net_physics.ItalyNT,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "P010",
    goalnetcolor = "0021",
    n_of_strings = "0021",
    rod_position = "0021",
    sound_file = "SE_Movement",
},
Hungary = {
    bounce = net_bounce.nb19,
    movement = movement.Balanced2,
    physics = net_physics.ItalyNT,
    net3d = net3D.Original,
    shape = Shape.NetOriginal,
    pattern = "P078",
    goalnetcolor = "0022",
    n_of_strings = "0022",
    rod_position = "0022",
    sound_file = "SE_Movement",
},
Slovenia = {
    bounce = net_bounce.nbMed5,
    movement = movement.Balanced2,
    physics = net_physics.Italy,
    net3d = net3D.SmallNet,
    shape = Shape.Antwerp,
    pattern = "P088",
    goalnetcolor = "0023",
    n_of_strings = "0023",
    rod_position = "0023",
    sound_file = "SE_Movement",
},
Croatia = {
    bounce = net_bounce.nb18,
    movement = movement.Firm3,
    physics = net_physics.PIPL,
    net3d = net3D.OriginalT1L1,
    shape = Shape.NetOriginal,
    pattern = "P078",
    goalnetcolor = "1203",
    n_of_strings = "1203",
    rod_position = "1203",
    sound_file = "SE_Movement",
},
Romania = {
    bounce = net_bounce.nb2021,
    movement = movement.Balanced2,
    physics = net_physics.PL,
    net3d = net3D.Original,
    shape = Shape.NetOriginalS,
    pattern = "1216",
    goalnetcolor = "NC00",
    n_of_strings = "1216",
    rod_position = "1216",
    sound_file = "SE_Move0004",
},
Bulgaria = {
    bounce = net_bounce.nbx,
    movement = movement.FirmSnappy2,
    physics = net_physics.PItalyN,
    net3d = net3D.SmallNet,
    shape = Shape.SmallNetTriangle,
    pattern = "P078",
    goalnetcolor = "NC00",
    n_of_strings = "1203",
    rod_position = "1203",
    sound_file = "SE_Movement",
},
Greece = {
    bounce = net_bounce.nb17,
    movement = movement.Balanced3,
    physics = net_physics.ItalyNT,
    net3d = net3D.OriginalT2,
    shape = Shape.NetOriginal,
    pattern = "P078",
    goalnetcolor = "NC00",
    n_of_strings = "0133",
    rod_position = "0133",
    sound_file = "SE_Movement",
},
Turkey = {
    bounce = net_bounce.nb20,
    movement = movement.Bouncy,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},
Ukraine = {
    bounce = net_bounce.nb20,
    movement = movement.Bouncy,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},
Russia = {
    bounce = net_bounce.nb21,
    movement = movement.Bouncy,
    physics = net_physics.PL,
    net3d = net3D.Original,
    shape = Shape.PerfectSquareL,
    pattern = "P003",
    goalnetcolor = "NC00",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Move0004",
},
Latvia = {
    bounce = net_bounce.nb20,
    movement = movement.Bouncy,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},
Israel = {
    bounce = net_bounce.nb20,
    movement = movement.Bouncy,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},
Albania = {
    bounce = net_bounce.nbVeryHigh1,
    movement = movement.FirmSnappy2,
    physics = net_physics.VeryStiff,
    net3d = net3D.SmallNet,
    shape = Shape.SmallNet,
    pattern = "P078",
    goalnetcolor = "1165",
    n_of_strings = "1165",
    rod_position = "1165",
    sound_file = "SE_Movement",
},
Andorra = {
    bounce = net_bounce.nbMed2,
    movement = movement.Firm3,
    physics = net_physics.SItalyNT,
    net3d = net3D.OriginalT1L1,
    shape = Shape.MidTriangleNet,
    pattern = "P078",
    goalnetcolor = "1166",
    n_of_strings = "1166",
    rod_position = "1166",
    sound_file = "SE_Movement",
},
Armenia = {
    bounce = net_bounce.nbMed1,
    movement = movement.Firm3,
    physics = net_physics.ItalyN,
    net3d = net3D.Belly,
    shape = Shape.Belly,
    pattern = "P081",
    goalnetcolor = "1167",
    n_of_strings = "1167",
    rod_position = "1167",
    sound_file = "SE_Movement",
},
Azerbaijan = {
    bounce = net_bounce.nbMed1,
    movement = movement.FirmSnappy2,
    physics = net_physics.SItalyN,
    net3d = net3D.Belly,
    shape = Shape.Belly,
    pattern = "P078",
    goalnetcolor = "1168",
    n_of_strings = "1168",
    rod_position = "1168",
    sound_file = "SE_Movement",
},
Belarus = {
    bounce = net_bounce.nb20,
    movement = movement.Bouncy,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "P078",
    goalnetcolor = "NC00",
    n_of_strings = "1169",
    rod_position = "1169",
    sound_file = "SE_Movement",
},
Bosnia_and_Herzegovina = {
    bounce = net_bounce.nb20,
    movement = movement.NXTOg,
    physics = net_physics.SItalyN,
    net3d = net3D.Original,
    shape = Shape.ImprovedMidDeep,
    pattern = "P010",
    goalnetcolor = "1170",
    n_of_strings = "1170",
    rod_position = "1170",
    sound_file = "SE_Movement",
},
Cyprus = {
    bounce = net_bounce.nb15,
    movement = movement.Porto,
    physics = net_physics.PortoLT,
    net3d = net3D.Original,
    shape = Shape.MidDeepNet,
    pattern = "2178",
    goalnetcolor = "2178",
    n_of_strings = "2178",
    rod_position = "2178",
    sound_file = "SE_Movement",
},
Estonia = {
    bounce = net_bounce.nbMed5,
    movement = movement.FirmSnappy2,
    physics = net_physics.SItalyN,
    net3d = net3D.OriginalT3L1,
    shape = Shape.DeepLoseNet2,
    pattern = "P021",
    goalnetcolor = "1172",
    n_of_strings = "1172",
    rod_position = "1172",
    sound_file = "SE_Move0004",
},
Faroe_Islands = {
    bounce = net_bounce.nb20,
    movement = movement.Bouncy,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},
Georgia = {
    bounce = net_bounce.nb20,
    movement = movement.Bouncy,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},
Iceland = {
    bounce = net_bounce.nb21,
    movement = movement.Porto,
    physics = net_physics.PortoLT,
    net3d = net3D.Original,
    shape = Shape.MidDeepNet,
    pattern = "1175",
    goalnetcolor = "1175",
    n_of_strings = "1175",
    rod_position = "1175",
    sound_file = "SE_Movement",
},
Kazakhstan = {
    bounce = net_bounce.nb18,
    movement = movement.EPL2,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},
Liechtenstein = {
    bounce = net_bounce.nb18,
    movement = movement.EPL2,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},
Lithuania = {
    bounce = net_bounce.nb18,
    movement = movement.EPL2,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},
Luxembourg = {
    bounce = net_bounce.nb18,
    movement = movement.EPL2,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},
North_Macedonia = {
    bounce = net_bounce.nb18,
    movement = movement.EPL2,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},
Malta = {
    bounce = net_bounce.nb18,
    movement = movement.EPL2,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},
Moldova = {
    bounce = net_bounce.nb18,
    movement = movement.EPL2,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},
San_Marino = {
    bounce = net_bounce.nb05_10,
    movement = movement.FirmSnappy20,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},
Uzbekistan = {
    bounce = net_bounce.nb18,
    movement = movement.EPL2,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},
Serbia = {
    bounce = net_bounce.nb20,
    movement = movement.Bouncy,
    physics = net_physics.PL,
    net3d = net3D.Original,
    shape = Shape.NetOriginalS,
    pattern = "1550",
    goalnetcolor = "1550",
    n_of_strings = "1550",
    rod_position = "1550",
    sound_file = "SE_Movement",
},
Montenegro = {
    bounce = net_bounce.nb18,
    movement = movement.EPL2,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},
Gibraltar = {
    bounce = net_bounce.nb18,
    movement = movement.EPL2,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},
Kosovo = {
    bounce = net_bounce.nb18,
    movement = movement.EPL2,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},


--AFCON (AFRICA)
  
Morocco = {
    bounce = net_bounce.nb18,
    movement = movement.EPL2,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},
Tunisia = {
    bounce = net_bounce.nb18,
    movement = movement.EPL2,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},
Egypt = {
    bounce = net_bounce.nb18,
    movement = movement.EPL2,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},
Nigeria = {
    bounce = net_bounce.nb18,
    movement = movement.EPL2,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},
Cameroon = {
    bounce = net_bounce.nb18,
    movement = movement.EPL2,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},
South_Africa = {
    bounce = net_bounce.nb18,
    movement = movement.EPL2,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},
Senegal = {
    bounce = net_bounce.nb18,
    movement = movement.EPL2,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},
Algeria = {
    bounce = net_bounce.nb18,
    movement = movement.EPL2,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},
Angola = {
    bounce = net_bounce.nb18,
    movement = movement.EPL2,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},
Benin = {
    bounce = net_bounce.nb18,
    movement = movement.EPL2,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},
Burkina_Faso = {
    bounce = net_bounce.nb18,
    movement = movement.EPL2,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},
Cape_Verde = {
    bounce = net_bounce.nb18,
    movement = movement.EPL2,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},
Congo_Dr = {
    bounce = net_bounce.nb18,
    movement = movement.EPL2,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},
Cote_D_Ivoire = {
    bounce = net_bounce.nb18,
    movement = movement.EPL2,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},
Gabon = {
    bounce = net_bounce.nb18,
    movement = movement.EPL2,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},
Ghana = {
    bounce = net_bounce.nb18,
    movement = movement.EPL2,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},
Guinea = {
    bounce = net_bounce.nb18,
    movement = movement.EPL2,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},
Kenya = {
    bounce = net_bounce.nb18,
    movement = movement.EPL2,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},
Madagascar = {
    bounce = net_bounce.nb18,
    movement = movement.EPL2,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},
Mali = {
    bounce = net_bounce.nb18,
    movement = movement.EPL2,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},
Tanzania = {
    bounce = net_bounce.nb18,
    movement = movement.EPL2,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},
Togo = {
    bounce = net_bounce.nb18,
    movement = movement.EPL2,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},
Uganda = {
    bounce = net_bounce.nb18,
    movement = movement.NXT6,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},
Zambia = {
    bounce = net_bounce.nb18,
    movement = movement.EPL2,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},
Zimbabwe = {
    bounce = net_bounce.nb18,
    movement = movement.EPL2,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},
Congo = {
    bounce = net_bounce.nb18,
    movement = movement.EPL2,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},

  --AMERICAS (NORTH, CENTRAL and SOUTH)
  
United_States = {
    bounce = net_bounce.nb18,
    movement = movement.EPL2,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},
Mexico = {
    bounce = net_bounce.nb18,
    movement = movement.EPL2,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},
Jamaica = {
    bounce = net_bounce.nb18,
    movement = movement.EPL2,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},
Costa_Rica = {
    bounce = net_bounce.nb18,
    movement = movement.EPL2,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},
Honduras = {
    bounce = net_bounce.nb18,
    movement = movement.EPL2,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},
Canada = {
    bounce = net_bounce.nb18,
    movement = movement.EPL2,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},
El_Salvador = {
    bounce = net_bounce.nb18,
    movement = movement.EPL2,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},
Haiti = {
    bounce = net_bounce.nb18,
    movement = movement.EPL2,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},
Panama = {
    bounce = net_bounce.nb18,
    movement = movement.EPL2,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},
Trinidad_and_Tobago = {
    bounce = net_bounce.nb18,
    movement = movement.EPL2,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},
Curacao = {
    bounce = net_bounce.nb18,
    movement = movement.EPL2,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},
Colombia = {
    bounce = net_bounce.nb18,
    movement = movement.EPL2,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},
Brazil = {
    bounce = net_bounce.nb18,
    movement = movement.EPL2,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},
Peru = {
    bounce = net_bounce.nb18,
    movement = movement.EPL2,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},
Chile = {
    bounce = net_bounce.nb18,
    movement = movement.Bouncy,
    physics = net_physics.PL,
    net3d = net3D.OriginalH1,
    shape = Shape.PerfectCube,
    pattern = "2209",
    goalnetcolor = "2209",
    n_of_strings = "2209",
    rod_position = "2209",
    sound_file = "SE_Movement",
},
Paraguay = {
    bounce = net_bounce.nb03_10,
    movement = movement.FirmSnappy2,
    physics = net_physics.OriginalNL1Low,
    net3d = net3D.Original,
    shape = Shape.WC26_Net3,
    pattern = "P089",
    goalnetcolor = "6303",
    n_of_strings = "6303",
    rod_position = "6301",
    sound_file = "SE_Movement",
},
Uruguay = {
    bounce = net_bounce.nb18,
    movement = movement.EPL2,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},
Argentina = {
    bounce = net_bounce.nb18,
    movement = movement.EPL2,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},
Ecuador = {
    bounce = net_bounce.nb18,
    movement = movement.EPL2,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},
Bolivia = {
    bounce = net_bounce.nb18,
    movement = movement.EPL2,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},
Venezuela = {
    bounce = net_bounce.nb18,
    movement = movement.EPL2,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},

 -- ASIA and OCEANIA
Japan = {
    bounce = net_bounce.nb19,
    movement = movement.EPL,
    physics = net_physics.PL,
    net3d = net3D.Original,
    shape = Shape.DeepLoseNet,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},
South_Korea = {
    bounce = net_bounce.nb18,
    movement = movement.EPL2,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},
China = {
    bounce = net_bounce.nb18,
    movement = movement.EPL2,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},
Iran = {
    bounce = net_bounce.nb18,
    movement = movement.EPL2,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},
Saudi_Arabia = {
    bounce = net_bounce.nb18,
    movement = movement.EPL2,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},
Australia = {
    bounce = net_bounce.nb18,
    movement = movement.EPL2,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},
New_Zealand = {
    bounce = net_bounce.nb18,
    movement = movement.EPL2,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},
Afghanistan = {
    bounce = net_bounce.nb18,
    movement = movement.EPL2,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},
Bahrain = {
    bounce = net_bounce.nb18,
    movement = movement.EPL2,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},
Bangladesh = {
    bounce = net_bounce.nb18,
    movement = movement.EPL2,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},
Cambodia = {
    bounce = net_bounce.nb18,
    movement = movement.EPL2,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},
India = {
    bounce = net_bounce.nb18,
    movement = movement.EPL2,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},
Indonesia = {
    bounce = net_bounce.nb18,
    movement = movement.EPL2,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},
Iraq = {
    bounce = net_bounce.nb18,
    movement = movement.EPL2,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},
Jordan = {
    bounce = net_bounce.nb18,
    movement = movement.EPL2,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},
North_Korea = {
    bounce = net_bounce.nb18,
    movement = movement.EPL2,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},
Kuwait = {
    bounce = net_bounce.nb18,
    movement = movement.EPL2,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},
Lebanon = {
    bounce = net_bounce.nb18,
    movement = movement.EPL2,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},
Malaysia = {
    bounce = net_bounce.nb18,
    movement = movement.EPL2,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},
Myanmar = {
    bounce = net_bounce.nb18,
    movement = movement.EPL2,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},
Nepal = {
    bounce = net_bounce.nb18,
    movement = movement.EPL2,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},
Oman = {
    bounce = net_bounce.nb18,
    movement = movement.EPL2,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},
Pakistan = {
    bounce = net_bounce.nb18,
    movement = movement.EPL2,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},
Palestine = {
    bounce = net_bounce.nb18,
    movement = movement.EPL2,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},
Philippines = {
    bounce = net_bounce.nb18,
    movement = movement.EPL2,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},
Qatar = {
    bounce = net_bounce.nb18,
    movement = movement.EPL2,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},
Singapore = {
    bounce = net_bounce.nb18,
    movement = movement.EPL2,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},
Syria = {
    bounce = net_bounce.nb18,
    movement = movement.EPL2,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},
Thailand = {
    bounce = net_bounce.nb18,
    movement = movement.EPL2,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},
United_Arab_Emirates = {
    bounce = net_bounce.nb18,
    movement = movement.EPL2,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},
Vietnam = {
    bounce = net_bounce.nb18,
    movement = movement.EPL2,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},
Tajikistan = {
    bounce = net_bounce.nb18,
    movement = movement.EPL2,
    physics = net_physics.ItalyN,
    net3d = net3D.Original,
    shape = Shape.PerfectCube,
    pattern = "goal",
    goalnetcolor = "goal",
    n_of_strings = "goal",
    rod_position = "goal",
    sound_file = "SE_Movement",
},

-- IMTERNATIONAL COMPETITIONS 

-- EURO 24
EURO24_Berlin = {
    bounce = net_bounce.nb20,
    movement = movement.FIFA2,
    physics = net_physics.FIFA,
    net3d = net3D.OriginalT3L1,
    shape = Shape.Real,
    pattern = "P003",
    goalnetcolor = "NC00",
    n_of_strings = "8000",
    rod_position = "8000",
    sound_file = "SE_Movement",
},
EURO24_Munchen = {
    bounce = net_bounce.nb20,
    movement = movement.FIFA2,
    physics = net_physics.FIFA,
    net3d = net3D.OriginalT2,
    shape = Shape.NetOriginal,
    pattern = "P003",
    goalnetcolor = "NC00",
    n_of_strings = "8001",
    rod_position = "8001",
    sound_file = "SE_Movement",
},
EURO24_Dortmund = {
    bounce = net_bounce.nb20,
    movement = movement.FIFA2,
    physics = net_physics.IPLow,
    net3d = net3D.OriginalT2,
    shape = Shape.NetOriginal,
    pattern = "P063",
    goalnetcolor = "NC00",
    n_of_strings = "8002",
    rod_position = "8002",
    sound_file = "SE_Move0003",
},
EURO24_Gelsenkirchen = {
    bounce = net_bounce.nb17,
    movement = movement.FIFA2,
    physics = net_physics.PL,
    net3d = net3D.OriginalT3,
    shape = Shape.PerfectSquareL,
    pattern = "P003",
    goalnetcolor = "NC00",
    n_of_strings = "8003",
    rod_position = "8003",
    sound_file = "SE_Movement",
},
EURO24_Leipzig = {
    bounce = net_bounce.nb18,
    movement = movement.FIFA2,
    physics = net_physics.Italy2,
    net3d = net3D.OriginalT1L1,
    shape = Shape.NetOriginalS,
    pattern = "P003",
    goalnetcolor = "NC00",
    n_of_strings = "8004",
    rod_position = "8004",
    sound_file = "SE_Move0004",
},
EURO24_Hamburg = {
    bounce = net_bounce.nb10,
    movement = movement.EPL,
    physics = net_physics.PortoLT,
    net3d = net3D.OriginalH1,
    shape = Shape.CurveNet6,
    pattern = "P012",
    goalnetcolor = "NC00",
    n_of_strings = "8005",
    rod_position = "8005",
    sound_file = "SE_Move0004",
},
EURO24_Stuttgart = {
    bounce = net_bounce.nb19,
    movement = movement.FIFA2,
    physics = net_physics.IPL,
    net3d = net3D.OriginalT3,
    shape = Shape.PerfectSquareL,
    pattern = "P003",
    goalnetcolor = "NC00",
    n_of_strings = "8006",
    rod_position = "8006",
    sound_file = "SE_Move0004",
},
EURO24_Koln = {
    bounce = net_bounce.nb17,
    movement = movement.NXT4,
    physics = net_physics.PortoLT,
    net3d = net3D.OriginalT2,
    shape = Shape.MidDeepNet,
    pattern = "P003",
    goalnetcolor = "NC00",
    n_of_strings = "8007",
    rod_position = "8007",
    sound_file = "SE_Move0004",
},
EURO24_Dusseldorf = {
    bounce = net_bounce.nb17,
    movement = movement.Italy,
    physics = net_physics.Porto,
    net3d = net3D.OriginalT1,
    shape = Shape.NetOriginal,
    pattern = "P003",
    goalnetcolor = "NC00",
    n_of_strings = "8008",
    rod_position = "8008",
    sound_file = "SE_Move0004",
},
EURO24_Frankfurt = {
    bounce = net_bounce.nb18,
    movement = movement.FIFA2,
    physics = net_physics.Porto,
    net3d = net3D.OriginalT1H1,
    shape = Shape.MidDeepNet,
    pattern = "P003",
    goalnetcolor = "NC00",
    n_of_strings = "8009",
    rod_position = "8009",
    sound_file = "SE_Move0004",
},

-- FIFA WORLD CUP 2026
WC_GA_Lumen_Field = { 
    bounce = net_bounce.nb03_5,
    movement = movement.FirmSnappy2,
    physics = net_physics.PItalyN,
    net3d = net3D.OriginalT1,
    shape = Shape.WC26_Net1,
    pattern = "P082",
    goalnetcolor = "NC00",
    n_of_strings = "6301",
    rod_position = "6301",
    sound_file = "SE_Movement",
},
WC_GB_Lincoln_Financial_Field = {
    bounce = net_bounce.nb01_7,
    movement = movement.FirmSnappy2,
    physics = net_physics.PItalyN,
    net3d = net3D.OriginalT1,
    shape = Shape.WC26_Net2,
    pattern = "P089",
    goalnetcolor = "NC00",
    n_of_strings = "6302",
    rod_position = "6302",
    sound_file = "SE_Movement",
},
WC_GC_Rose_Bowl = {
    bounce = net_bounce.nb03_10,
    movement = movement.FirmSnappy2,
    physics = net_physics.OriginalNL1Low,
    net3d = net3D.Original,
    shape = Shape.WC26_Net3,
    pattern = "P089",
    goalnetcolor = "NC00",
    n_of_strings = "6303",
    rod_position = "6301",
    sound_file = "SE_Movement",
},
WC_GD = {
    bounce = net_bounce.nbVeryHigh2,
    movement = movement.FirmSnappy2,
    physics = net_physics.PItalyN,
    net3d = net3D.OriginalT1,
    shape = Shape.WC26_Net1,
    pattern = "P089",
    goalnetcolor = "NC00",
    n_of_strings = "6301",
    rod_position = "6301",
    sound_file = "SE_Movement",
},
WC_GE = {
    bounce = net_bounce.nb2021,
    movement = movement.FirmSnappy8,
    physics = net_physics.OriginalNL1Low,
    net3d = net3D.Original,
    shape = Shape.WC26_Net5,
    pattern = "P003",
    goalnetcolor = "NC00",
    n_of_strings = "6301",
    rod_position = "6301",
    sound_file = "SE_Movement",
},
WC_GF = {
    bounce = net_bounce.nb20,
    movement = movement.FirmSnappy10,
    physics = net_physics.OriginalNL3,
    net3d = net3D.Original,
    shape = Shape.Belly,
    pattern = "P081",
    goalnetcolor = "NC00",
    n_of_strings = "8022",
    rod_position = "8022",
    sound_file = "SE_Movement",
},
WC_GG = {
    bounce = net_bounce.nb2021,
    movement = movement.Balanced4,
    physics = net_physics.OriginalNL2,
    net3d = net3D.Original,
    shape = Shape.WC26_Net7,
    pattern = "P081",
    goalnetcolor = "NC00",
    n_of_strings = "8022",
    rod_position = "8022",
    sound_file = "SE_Movement",
},
WC_GH = {
    bounce = net_bounce.nb01_7,
    movement = movement.FirmSnappy9,
    physics = net_physics.OriginalNT3Low,
    net3d = net3D.Original,
    shape = Shape.WC26_Net8,
    pattern = "P003",
    goalnetcolor = "NC00",
    n_of_strings = "8022",
    rod_position = "8022",
    sound_file = "SE_Movement",
},

}


--//================================================================================================//
--// PARSING FUNCTIONS
--//================================================================================================//

local team_assignments = {}
local competition_assignments = {}


local function split_presets(line)
    local presets = {}
    for token in line:gmatch("[^,]+") do
        table.insert(presets, token:match("^%s*(.-)%s*$")) -- Trim whitespace
    end
    return presets
end

-- Parses a list of presets
local function parse_team_map()
    for k in pairs(team_assignments) do team_assignments[k] = nil end
    local path = sider_path .. "modules\\goalnets\\map_clubs.txt"
    local file = io.open(path, "r")
    if not file then log("[goalnets] map_clubs.txt not found.") return end
    for line in file:lines() do
        if not line:match("^#") and line:match("%S") then
            local id_str, presets_str = line:match("([^,]+),(.*)")
            if id_str and presets_str then
                local id = tonumber(id_str)
                team_assignments[id] = split_presets(presets_str)
            end
        end
    end
    file:close()
end


local function parse_competition_map()
  for k in pairs(competition_assignments) do competition_assignments[k] = nil end
  local path = sider_path .. "modules\\goalnets\\map_competitions.txt"
  local file = io.open(path, "r")
  if not file then log("[goalnets] map_competitions.txt not found.") return end
  for raw in file:lines() do
    local line = raw:gsub("%s*#.*$", "")
    if line:match("%S") then
      local id_str, stage, presets_str = line:match("([^,]+),([^,]+),(.*)")
      if id_str and stage and presets_str then
        local id = tonumber(id_str)
        stage = stage:match("^%s*(.-)%s*$")
        if id then
          competition_assignments[id] = competition_assignments[id] or {}
          competition_assignments[id][stage] = split_presets(presets_str)
        end
      end
    end
  end
  file:close()
end


-- StadiumServer folder
local function get_stadium_preset_list(ctx)

  if not ctx or not ctx.stadium_server or not ctx.stadium_server.path then
    return nil
  end

  local sider_root = ctx.sider_dir or ".\\"

-- 2 most common roots of stadium server:
  --  1) content\stadium-server\      (EvoWeb/MP/UML, most patches)
  --  2) content\stadiums\            (SP/vanilla setup)
  local ss_roots = {
    sider_root .. "content\\stadium-server\\",
    sider_root .. "content\\stadiums\\",
  }


  local rel = ctx.stadium_server.path
  rel = rel:gsub("^[/\\]+", ""):gsub("[/\\]+$", "")

-- Try multiple roots
  local file
  for _, root in ipairs(ss_roots) do
    local candidate = root .. rel .. "\\goalnets_preset.txt"
    log(string.format("[goalnets] Trying stadium preset: %s", candidate))
    local f = io.open(candidate, "r")
    if f then
      file = f
      break
    end
  end

  if not file then
    if not Goalnets.path_warning_shown then
      log("[goalnets] INFO: goalnets_preset.txt not found for this stadium folder.")
      log("[goalnets] INFO: Checked both 'content\\stadium-server' and 'content\\stadiums'.")
      Goalnets.path_warning_shown = true
    end
    return nil
  end

  Goalnets.path_warning_shown = false
  local line = file:read("*l")
  file:close()

  if line and line:match("%S") then
    local presets = split_presets(line)
    if #presets > 0 then
      log("[goalnets] Found preset list from stadium: " .. table.concat(presets, ", "))
      return presets
    end
  end

  return nil
end


--//================================================================================================//
--// MAIN LOGIC
--//================================================================================================//

-- Function to detect game version and set active addresses
function Goalnets.detect_and_set_addresses()
    log("[goalnets] Starting game version detection...")
    for patch_name, data in pairs(patch_data) do
        log("[goalnets] Probing for " .. patch_name .. "...")
        local bytes_in_memory = memory.read(data.signature_address, #data.signature_value)
        if bytes_in_memory == data.signature_value then
            log("[goalnets] SUCCESS: Detected " .. patch_name .. ". Activating its memory addresses.")
            active_addresses = data.addresses
            return -- Exit function as soon as a match is found
        end
    end
    log("[goalnets] ERROR: Could not detect a supported game version. The module may not work correctly.")
end

-- Applies preset by writing to memory using detected addresses
function Goalnets.apply_preset(preset_name)
    if not active_addresses then
        log("[goalnets] Cannot apply preset: no active addresses found. Game version might be unsupported.")
        return
    end

    if not preset_name then return end
    
    current_preset = team_presets[preset_name] or team_presets.Default
    if not team_presets[preset_name] then
        log("[goalnets] WARNING: Preset '" .. preset_name .. "' not found. Using Default.")
    end
    
    memory.write(active_addresses.netbounce, current_preset.bounce)
    memory.write(active_addresses.netmovement, current_preset.movement)
    memory.write(active_addresses.netphysics, current_preset.physics)
    memory.write(active_addresses.net3d, current_preset.net3d)
    memory.write(active_addresses.netshape, current_preset.shape)
    memory.write(active_addresses.netpattern, current_preset.pattern)
    
    if current_preset.color_id then
        memory.write(active_addresses.goalnetcolor, current_preset.color_id)
        memory.write(active_addresses.n_of_strings, current_preset.color_id)
        memory.write(active_addresses.rod_position, current_preset.color_id)
    else
        memory.write(active_addresses.goalnetcolor, current_preset.goalnetcolor)
        memory.write(active_addresses.n_of_strings, current_preset.n_of_strings)
        memory.write(active_addresses.rod_position, current_preset.rod_position)
    end
end

-- Determines the list of presets and applies the first one
function Goalnets.determine_and_apply_nets(ctx)
    local thid = ctx.home_team
    local tid = ctx.tournament_id
    if not thid or not tid then
        current_available_presets = {"Default"}
        current_preset_index = 1
        current_preset_info = { name = "Default", source = "N/A" }
        Goalnets.apply_preset("Default")
        return 
    end

    local preset_list = nil
    local source = "Default"

    -- 1. STADIUM
    preset_list = get_stadium_preset_list(ctx)
    if preset_list then
        source = "Stadium"
    else
        -- 2. COMPETITION
        if competition_assignments[tid] then
            local stage_key = tostring(ctx.match_info)
            preset_list = competition_assignments[tid][stage_key] or competition_assignments[tid]["*"]
            if preset_list then source = "Competition" end
        end
        -- 3. TEAM
        if not preset_list and team_assignments[thid] then
            preset_list = team_assignments[thid]
            if preset_list then source = "Team" end
        end
    end

    current_available_presets = preset_list or {"Default"}
    current_preset_index = 1
    
    local preset_name = current_available_presets[current_preset_index]
    current_preset_info = { name = preset_name, source = source }

    Goalnets.apply_preset(preset_name)
    log("[goalnets] Initial preset set. Source: " .. source .. ". Preset: " .. preset_name)
end

function Goalnets.rewrite_livecpk_paths(ctx, filename)
  if not current_preset or not filename then return end
  if string.match(filename, "Asset\\model\\bg\\common\\goal\\") then
      local rod_id = current_preset.rod_position or current_preset.color_id or team_presets.Default.rod_position
      local rod_color_path = "\\common\\" .. rod_id .. "\\"
      return string.gsub(filename, "\\common\\goal\\", rod_color_path)
  elseif string.match(filename, "\\acb\\SE_Movement.acb") then
      return string.gsub(filename, "SE_Movement", current_preset.sound_file or team_presets.Default.sound_file)
  end
end

--//================================================================================================//
--// OVERLAY & HOTKEY FUNCTIONS
--//================================================================================================//

-- Information display
function overlay_on(ctx)
    local final_message = ""

    if message_timer > 0 then
        message_timer = message_timer - 1
        final_message = temporary_message .. "\n\n" 
    end

    local preset_display = string.format("Current Preset: %s (%s)", current_preset_info.name, current_preset_info.source)
    local options_display = ""
    if #current_available_presets > 1 then
        options_display = string.format("\nSelection: %d / %d (PageUp/PageDown to change)", current_preset_index, #current_available_presets)
    end

    return final_message .. preset_display .. options_display .. "\npress [0] to reload maps"
end

-- Controls for preset switching
function key_down(ctx, vkey)
    if vkey == 0x30 then -- '0' key
        log("[goalnets] Reloading maps...")
        parse_team_map()
        parse_competition_map()
        Goalnets.determine_and_apply_nets(ctx) -- Re-apply preset after reload
        temporary_message = "Maps reloaded successfully!"
        message_timer = 180 
    elseif vkey == KEY_PREVIOUS then -- Page Up
        if #current_available_presets > 1 then
            current_preset_index = current_preset_index - 1
            if current_preset_index < 1 then current_preset_index = #current_available_presets end
            local new_preset = current_available_presets[current_preset_index]
            current_preset_info.name = new_preset
            Goalnets.apply_preset(new_preset)
        end
    elseif vkey == KEY_NEXT then -- Page Down
        if #current_available_presets > 1 then
            current_preset_index = current_preset_index + 1
            if current_preset_index > #current_available_presets then current_preset_index = 1 end
            local new_preset = current_available_presets[current_preset_index]
            current_preset_info.name = new_preset
            Goalnets.apply_preset(new_preset)
        end
    end
end

--//================================================================================================//
--// INITIALIZATION
--//================================================================================================//

function Goalnets.init(ctx)
	sider_path = ctx.sider_dir
    
    -- First, detect the game version to set the correct memory addresses
    Goalnets.detect_and_set_addresses()

    Goalnets.path_warning_shown = false

    parse_team_map()
    parse_competition_map()

    ctx.register("after_set_conditions", Goalnets.determine_and_apply_nets)
    ctx.register("livecpk_get_filepath", Goalnets.rewrite_livecpk_paths)
    ctx.register("livecpk_rewrite", Goalnets.rewrite_livecpk_paths)
    ctx.register("overlay_on", overlay_on)
    ctx.register("key_down", key_down)
end

return Goalnets