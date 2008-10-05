local L = AceLibrary("AceLocale-2.2"):new("BigTrouble")
L:RegisterTranslations("frFR", function()
return {
	["UNIT_SPELLCAST_FAILED"] = "Echec",
	["UNIT_SPELLCAST_INTERRUPTED"] = "Interrompu",
		
	["lock"] = "Verrouiller",
	["Lock/Unlock the casting bar."] = "Verrouile la barre d'incantation",
	["Unlocked"] = "Déverouillée",
	["Locked"] = "Verouillée",
	["autoshot"] = "tirAuto",
	["Toggle Auto Shot casting bar."] = "Active la barre d'incantation du tir automatique.",
	["steadyshot"] = "tirAssure",
	["Toggle Steady Shot casting bar."] = "Active la barre d'incantation du tir assuré.",
	["On"] = "Activé",
	["Off"] = "Désactivé",
	["aimedshot"] = "visee",
	["Toggle Aimed Shot casting bar."] = "Active la barre d'incantation de visée.",
	["texture"] = "Texture",
	["Set the texture."] = "Définit la texture.",
	["border"] = "bordure",
	["Set the border for the bar."] = "Définit la bordure de la barre.",
	["width"] = "largeur", 
	["Set the width of the casting bar."] = "Définit la largeur de la barre.",
	["height"] = "hauteur", 
	["Set the height of the casting bar."] = "Définit la hauteur de la barre.",
	["Son of a bitch must pay!"] = "Gné ?",

	-- spells -- ripped from Babble-Spell-2.2 r29140
	["Aimed Shot"] = "Vis\195\169e",
	["Arcane Shot"] = "Tir des arcanes",
	["Auto Shot"] = "Tir automatique",
	["Multi-Shot"] = "Fl\195\168ches multiples",
	["Steady Shot"] = "Tir assur\195\169",

	-- font options
	["font"] = "police",
	["Set the font size of different elements."] = "Définit la taille de police des différents éléments.",
	["spell"] = "sort", 
	["Set the font size of the spellname."] = "Définit la taille de la police du nom du sort.",
	["time"] = "temps", 
	["Set the font size of the spell time."] = "Définit la taille de la police du temps d'incantation.",
	["delay"] = "delai", 
	["Set the font size on the delay time."] = "Définit la taille de la police du du délai.",
		
	-- color options
	["color"] = "couleur",
	["Set the color of the different bars."] = "Définit la couleur des différents barres.",
	["complete"] = "termine",
	["Set the color of the completed bar."] = "Définit la couleur de la barre lors qu'un sort réussit.",
	["casting"] = "incantation",
	["Set the color of the casting bar."] = "Définit la couleur de la barre d'incantation d'un sort",
	["failed"] = "echec",
	["Set the color of the failed bar."] = "Définit la couleur de la barre en cas d'échec d'un sort.",
	["autoshot"] = "tirAuto",
	["Set the color of the autoshot bar."] = "Définit la couleur de la barre pour le tir automatique."
}
end)