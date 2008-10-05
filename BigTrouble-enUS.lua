local L = AceLibrary("AceLocale-2.2"):new("BigTrouble")
L:RegisterTranslations("enUS", function()
return {
	["UNIT_SPELLCAST_FAILED"] = "Failed",
	["UNIT_SPELLCAST_INTERRUPTED"] = "Interrupted",
		
	["lock"] = true,
	["Lock/Unlock the casting bar."] = true,
	["Unlocked"] = true,
	["Locked"] = true,
	["autoshot"] = true,
	["Toggle Auto Shot casting bar."] = true,
	["steadyshot"] = true,
	["Toggle Steady Shot casting bar."] = true,
	["On"] = true,
	["Off"] = true,
	["aimedshot"] = true,
	["Toggle Aimed Shot casting bar."] = true,
	["texture"] = true,
	["Set the texture."] = true,
	["border"] = true,
	["Set the border for the bar."] = true,
	["width"] = true, 
	["Set the width of the casting bar."] = true,
	["height"] = true, 
	["Set the height of the casting bar."] = true,
	["Son of a bitch must pay!"] = true,

	-- spells
	["Aimed Shot"] = true,
	["Arcane Shot"] = true,
	["Auto Shot"] = true,
	["Multi-Shot"] = true,
	["Steady Shot"] = true,

	-- font options
	["font"] = true,
	["Set the font size of different elements."] = true,
	["spell"] = true, 
	["Set the font size of the spellname."] = true,
	["time"] = true, 
	["Set the font size of the spell time."] = true,
	["delay"] = true, 
	["Set the font size on the delay time."] = true,
		
	-- color options
	["color"] = true,
	["Set the color of the different bars."] = true,
	["complete"] = true,
	["Set the color of the completed bar."] = true,
	["casting"] = true,
	["Set the color of the casting bar."] = true,
	["failed"] = true,
	["Set the color of the failed bar."] = true,
	["autoshot"] = true,
	["Set the color of the autoshot bar."] = true
}
end)