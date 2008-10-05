local L = AceLibrary("AceLocale-2.2"):new("BigTrouble")
L:RegisterTranslations("koKR", function()
return {
	["UNIT_SPELLCAST_FAILED"] = "실패",
	["UNIT_SPELLCAST_INTERRUPTED"] = "방해를 받아 취소되었습니다",

	["lock"] = "잠금",
	["Lock/Unlock the casting bar."] = "시전바를 고정/이동합니다.",
	["Unlocked"] = "이동",
	["Locked"] = "고정",
	["autoshot"] = "자동사격",
	["Toggle Auto Shot casting bar."] = "자동사격 시전바를 토글합니다.",
	["On"] = "켬",
	["Off"] = "끔",
	["aimedshot"] = "조준사격",
	["Toggle Aimed Shot casting bar."] = "조준사격 시전바를 토글합니다.",
	["texture"] = "텍스쳐",
	["Set the texture."] = "텍스쳐를 설정합니다.",
	["border"] = "외곽선",
	["Set the border for the bar."] = "Set the border for the bar.",
	["width"] = "너비", 
	["Set the width of the casting bar."] = "시전바의 너비를 설정합니다.",
	["height"] = "높이", 
	["Set the height of the casting bar."] = "시전바의 높이를 설정합니다.",
	["font"] = "폰트",
	["Set the font size of different elements."] = "각각의 요소의 폰트 크기를 설정합니다.",
	["spell"] = "주문", 
	["Set the font size of the spellname."] = "주문명의 폰트 크기를 설정합니다.",
	["time"] = "시전시간", 
	["Set the font size of the spell time."] = "시전 시간의 폰트 크기를 설정합니다.",
	["delay"] = "지연시간", 
	["Set the font size on the delay time."] = "지연 시간의 폰트 크기를 설정합니다.",
	["Son of a bitch must pay!"] = "인과응보!",

	-- spells
	["Aimed Shot"] = "조준 사격",
	["Arcane Shot"] = "신비한 사격",
	["Auto Shot"] = "자동 사격",
	["Multi-Shot"] = "일제 사격",
	["Steady Shot"] = "고정 사격",
	
	-- font options
	["font"] = "font",
	["Set the font size of different elements."] = "Set the font size of different elements.",
	["spell"] = "spell",
	["Set the font size of the spellname."] = "Set the font size of the spellname.",
	["time"] = "time", 
	["Set the font size of the spell time."] = "Set the font size of the spell time.",
	["delay"] = "delay",
	["Set the font size on the delay time."] = "Set the font size on the delay time.",
		
	-- color options
	["color"] = "color",
	["Set the color of the different bars."] = "Set the color of the different bars.",
	["complete"] = "complete",
	["Set the color of the completed bar."] = "Set the color of the completed bar.",
	["casting"] = "casting",
	["Set the color of the casting bar."] = "Set the color of the casting bar.",
	["failed"] = "failed",
	["Set the color of the failed bar."] = "Set the color of the failed bar.",
	["autoshot"] = "autoshot",
	["Set the color of the autoshot bar."] = "Set the color of the autoshot bar."
}
end)