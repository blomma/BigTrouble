--[[
	A big thanks to otravi and his castingbar, most of the bar code is taken 
	from his addon and warped for my evil purposes here.
	
	To whom it may concern, if you feel the need to make changes to this mod, please
	make a patch for it and send it to me as either a message on the wowace boards or just mail
	it to me at blomma@fastmail.fm
	
	Do not just go ahead and apply it, not because im anal and possesive, but because it makes
	it harder for me to merge it with my changes.
--]]

--[[
Credits

Author of oCB for textures and code.
Author of agUF for textures.
Adirelle for frFR translation and code for steadyshot inclusion as well as
	various other code fixes/addtitions.
Tumetom for deDE translation.
Thx to the translators and to anyone else that ive forgotten.
--]]

local L = AceLibrary("AceLocale-2.2"):new("BigTrouble")

local monitored_spells = {
	[L["Aimed Shot"]] = 'aimedShotBar',
	[L["Steady Shot"]] = 'steadyShotBar',
	[L["Auto Shot"]] = 'autoShotBar',
	[L["Multi-Shot"]] = false,
}

local reset_autoshot = {
	[L["Aimed Shot"]] = 1,
	[L["Auto Shot"]] = 0,
}

local delay_autoshot = {
	[L["Multi-Shot"]] = 0.5,
	[L["Arcane Shot"]] = 0.5,
	[L["Steady Shot"]] = 0.5,
}

local surface = AceLibrary("Surface-1.0")

surface:Register("Perl", "Interface\\AddOns\\BigTrouble\\textures\\perl")
surface:Register("Smooth", "Interface\\AddOns\\BigTrouble\\textures\\smooth")
surface:Register("Glaze", "Interface\\AddOns\\BigTrouble\\textures\\glaze")
surface:Register("BantoBar", "Interface\\AddOns\\BigTrouble\\textures\\BantoBar")
surface:Register("Gloss", "Interface\\AddOns\\BigTrouble\\textures\\Gloss")

BigTrouble = AceLibrary("AceAddon-2.0"):new("AceEvent-2.0", "AceDB-2.0", "AceConsole-2.0")

BigTrouble.defaults = {
	width		= 255,
	height		= 25,
	timeSize	= 12,
	spellSize	= 12,
	delaySize	= 14,
	borderStyle = "Classic",
	texture		= "BantoBar",
	pos			= {},
	autoShotBar = true,
	aimedShotBar	= true,
	steadyShotBar = true,
	multiShotBar = true,
	colors = 
	{
		complete	= {r=0, g=1, b=0},
		autoshot	= {r=1, g=.7, b=0},
		casting		= {r=.3, g=.3, b=1},
		failed		= {r=1, g=0, b=0},
	}
}

BigTrouble.options = {
	type = "group",
	args = {
		[L["autoshot"]] = {
			name = L["autoshot"],
			type = "toggle",
			desc = L["Toggle Auto Shot casting bar."],
			get = function() return BigTrouble.db.profile.autoShotBar end,
			set = "SetAutoShot",
			map = {[false] = L["Off"], [true] = L["On"]},
		},
		[L["aimedshot"]] = {
			name = L["aimedshot"],
			type = "toggle",
			desc = L["Toggle Aimed Shot casting bar."],
			get = function() return BigTrouble.db.profile.aimedShotBar end,
			set = function(v) BigTrouble.db.profile.aimedShotBar = v end,
			map = {[false] = L["Off"], [true] = L["On"]},
		},
		[L["steadyshot"]] = {
			name = L["steadyshot"],
			type = "toggle",
			desc = L["Toggle Steady Shot casting bar."],
			get = function() return BigTrouble.db.profile.steadyShotBar end,
			set = function(v) BigTrouble.db.profile.steadyShotBar = v end,
			map = {[false] = L["Off"], [true] = L["On"]},
		},
		[L["lock"]] = {
			name = L["lock"],
			type = "toggle",
			desc = L["Lock/Unlock the casting bar."],
			get = function() return BigTrouble.locked end,
			set = function(v)
				BigTrouble.locked = v
				if( not v and not ( BigTrouble.isCasting or BigTrouble.isAutoShot )) then
					BigTrouble.master:SetScript( "OnUpdate", nil )
					BigTrouble.master:Show()
					BigTrouble.master.Bar:SetStatusBarColor(.3, .3, .3)
					BigTrouble.master.Time:SetText("1.3")
					BigTrouble.master.Delay:SetText("+0.8")
					BigTrouble.master.Spell:SetText(L["Son of a bitch must pay!"])
				else
					BigTrouble.master:SetScript( "OnUpdate", BigTrouble.OnCasting )
				end
			end,
			map = {[false] = L["Unlocked"], [true] = L["Locked"]},
			guiNameIsMap = true,
		},
		[L["texture"]] = {
			name = L["texture"], 
			type = "text",
			desc = L["Set the texture."],
			get = function() return BigTrouble.db.profile.texture end,
			set = function(v)
				BigTrouble.db.profile.texture = v
				BigTrouble:Layout()
			end,
			validate = surface:List(),
		},
		[L["border"]] = {
			name = L["border"],
			type = "text",
			desc = L["Set the border for the bar."],
			get = function() return BigTrouble.db.profile.borderStyle end,
			set = function(v)
				BigTrouble.db.profile.borderStyle = v 
				BigTrouble:BorderBackground()
			end,
			validate = {"Classic", "Black", "Hidden"},
		},
		[L["width"]] = {
			name = L["width"], 
			type = "range", 
			min = 10, 
			max = 5000, 
			step = 1,
			desc = L["Set the width of the casting bar."],
			get = function() return BigTrouble.db.profile.width end,
			set = function(v)
				BigTrouble.db.profile.width = v
				BigTrouble:Layout()
			end,
		},
		[L["height"]] = {
			name = L["height"], 
			type = "range", 
			min = 5, 
			max = 50, 
			step = 1,
			desc = L["Set the height of the casting bar."],
			get = function() return BigTrouble.db.profile.height end,
			set = function(v)
				BigTrouble.db.profile.height = v
				BigTrouble:Layout()
			end,
		},
		[L["font"]] = {
			name = L["font"],
			type = "group",
			desc = L["Set the font size of different elements."],
			args = {
				[L["spell"]] = {
					name = L["spell"], 
					type = "range", 
					min = 6,
					max = 32,
					step = 1,
					desc = L["Set the font size of the spellname."],
					get = function() return BigTrouble.db.profile.spellSize end,
					set = function(v)
						BigTrouble.db.profile.spellSize = v
						BigTrouble:Layout()
					end,
				},
				[L["time"]] = {
					name = L["time"], 
					type = "range", 
					min = 6, 
					max = 32, 
					step = 1,
					desc = L["Set the font size of the spell time."],
					get = function() return BigTrouble.db.profile.timeSize end,
					set = function(v)
						BigTrouble.db.profile.timeSize = v
						BigTrouble:Layout()
					end,
				},
				[L["delay"]] = {
					name = L["delay"], 
					type = "range", 
					min = 6,
					max = 32,
					step = 1,
					desc = L["Set the font size on the delay time."],
					get = function() return BigTrouble.db.profile.delaySize end,
					set = function(v)
						BigTrouble.db.profile.delaySize = v
						BigTrouble:Layout()
					end,
				}
			}
		},
		[L["color"]] = {
			name = L["font"], 
			type = 'group',
			desc = L["Set the color of the different bars."],
			args = {
				[L["complete"]] = {
					name = L["complete"],
					type = 'color',
					desc = L["Set the color of the completed bar."],
					get = function()
						local v = BigTrouble.db.profile.colors.complete
						return v.r, v.g, v.b, v.a
					end,
					set = function(r,g,b,a) 
						BigTrouble.db.profile.colors.complete = {r=r,g=g,b=b,a=a}
					end
				},
				[L["casting"]] = {
					name = L["casting"], 
					type = 'color',
					desc = L["Set the color of the casting bar."],
					get = function()
						local v = BigTrouble.db.profile.colors.casting
						return v.r, v.g, v.b, v.a
					end,
					set = function(r,g,b,a) 
						BigTrouble.db.profile.colors.casting = {r=r,g=g,b=b,a=a} 
					end
				},
				[L["failed"]] = {
					name = L["failed"], 
					type = 'color',
					desc = L["Set the color of the failed bar."],
					get = function()
						local v = BigTrouble.db.profile.colors.failed
						return v.r, v.g, v.b, v.a
					end,
					set = function(r,g,b,a) 
						BigTrouble.db.profile.colors.failed = {r=r,g=g,b=b,a=a} 
					end
				},
				[L["autoshot"]] = {
					name = L["autoshot"], 
					type = 'color',
					desc = L["Set the color of the autoshot bar."],
					get = function()
						local v = BigTrouble.db.profile.colors.autoshot
						return v.r, v.g, v.b, v.a
					end,
					set = function(r,g,b,a) 
						BigTrouble.db.profile.colors.autoshot = {r=r,g=g,b=b,a=a} 
					end
				}
			}
		}
	}
}

BigTrouble.Borders = {
	["Classic"]		= {
		["texture"] = "Interface\\Tooltips\\UI-Tooltip-Border",["size"] = 16,["insets"] = 5,
		["bc"] = {r=0,g=0,b=0,a=1},
		["bbc"] = {r=TOOLTIP_DEFAULT_COLOR.r,g=TOOLTIP_DEFAULT_COLOR.g,b=TOOLTIP_DEFAULT_COLOR.b,a=1},
	},
	["Black"]		= {
		["texture"] = "Interface\\Tooltips\\UI-Tooltip-Border",["size"] = 16,["insets"] = 4,
		["bc"] = {r=0,g=0,b=0,a=1},
		["bbc"] = {r=0,g=0,b=0,a=1},
	},
	["Hidden"]		= {
		["texture"] = "",["size"] = 0,["insets"] = 4,
		["bc"] = {r=0,g=0,b=0,a=1},
		["bbc"] = {r=0,g=0,b=0,a=1},
	},
}

function BigTrouble:SetAutoShot( value )
	self.db.profile.autoShotBar = value
	
	if( value ) then
		self:RegisterEvent("START_AUTOREPEAT_SPELL", "StartAutoRepeat")
		self:RegisterEvent("STOP_AUTOREPEAT_SPELL", "StopAutoRepeat")
	else
		if( self:IsEventRegistered("START_AUTOREPEAT_SPELL")) then
			self:UnregisterEvent("START_AUTOREPEAT_SPELL")
		end
		
		if( self:IsEventRegistered("STOP_AUTOREPEAT_SPELL")) then
			self:UnregisterEvent("STOP_AUTOREPEAT_SPELL")
		end
	end
end

BigTrouble:RegisterDB("BigTroubleDB")
BigTrouble:RegisterDefaults('profile', BigTrouble.defaults)
BigTrouble:RegisterChatCommand( {"/btrouble"}, BigTrouble.options )

function BigTrouble:OnInitialize()
	self.locked = true
end

function BigTrouble:OnEnable()
	self:CreateFrameWork()

	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED", "SpellCastSucceeded")
	
	if( self.db.profile.autoShotBar ) then
		self:RegisterEvent("START_AUTOREPEAT_SPELL", "StartAutoRepeat")
		self:RegisterEvent("STOP_AUTOREPEAT_SPELL", "StopAutoRepeat")
	end
	
	self:RegisterEvent("UNIT_SPELLCAST_START", "SpellCastStart")
	self:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED","SpellCastFailed")
	self:RegisterEvent("UNIT_SPELLCAST_DELAYED", "SpellCastDelayed")
	self:RegisterEvent("UNIT_SPELLCAST_FAILED", "SpellCastFailed")
end

function BigTrouble:SetDelay(newDelay)
	if newDelay and newDelay > 0 then
		self.master.Delay:SetText( string.format( "+%.1f", newDelay ) ) 
		self.master.Delay:Show()
	else
		newDelay = nil
		self.master.Delay:Hide()
	end
	self.delayTime = newDelay
end

function BigTrouble:SetupAutoShot(reset, forceDuration, delay)
	if not self.db.profile.autoShotBar or not self.isAutoShot or self.isCasting then
		return
	end
	local resetDelay = type(reset) == 'number' and reset or 0

	if reset then
		self.autoShotStart = GetTime()
		self.autoShotMaxValue = self.autoShotStart + (forceDuration or UnitRangedDamage("player")) + resetDelay
		self.delayTime = nil	
	end
	
	if delay and self.autoShotMaxValue then
		local newMax = GetTime() + delay
		if newMax > self.autoShotMaxValue then
			local delayed = newMax - self.autoShotMaxValue
			self:SetDelay((self.delayTime or 0) + delayed)
			self.autoShotStart = self.autoShotStart + delayed
			self.autoShotMaxValue = newMax
		end
	end

	if self.autoShotMaxValue and GetTime() > self.autoShotMaxValue and not reset then
		self.autoShotMaxValue = nil
		self.autoShotStart = nil
	end
	
	self.startTime = self.autoShotStart
	self.maxValue = self.autoShotMaxValue
	
	if not self.autoShotStart then
		self.thresHold = true
		return
	end
	
	local color = self.db.profile.colors.autoshot
	self.master.Bar:SetStatusBarColor( color.r, color.g, color.b )
	self:BarCreate(L["Auto Shot"])
	self:SetDelay(self.delayTime)
end

function BigTrouble:SpellCastStart( unit )
	if( unit ~= "player" ) then return end
	
	local name, _, text, _, startTime, endTime, _ = UnitCastingInfo(unit)
	local bar = monitored_spells[name]
	if bar and reset_autoshot[name] then
		self.isAutoShot = true
	end
	if not bar or not self.db.profile[bar] then 
		self.thresHold = ( bar == 'aimedShotBar' )
		return 
	end
	
	local color = self.db.profile.colors.casting
	self.master.Bar:SetStatusBarColor( color.r, color.g, color.b )
	
	self.startTime = startTime / 1000
	self.maxValue = endTime / 1000
	self:SetDelay(nil)
	self.isCasting = name
	self:BarCreate( text )
end

function BigTrouble:SpellCastSucceeded( unit, spell, rank )
	if unit ~= "player" then return end

	if self.isCasting and self.master:IsShown()	 then
		self.isCasting = nil
		self:SetDelay()
		
		self.master.Spark:Hide()
		self.master.Time:Hide()
		
		self.master.Bar:SetValue( self.maxValue )
		local color = self.db.profile.colors.complete
		self.master.Bar:SetStatusBarColor( color.r, color.g, color.b )
	end
		
	self:SetupAutoShot(reset_autoshot[spell], nil, delay_autoshot[spell])
end

function BigTrouble:SpellCastFailed(unit)
	if unit ~= "player" then return end
	
	if self.master:IsShown() and self.isCasting then
		self.isCasting = nil
	
		self.master.Spark:Hide()
		self.master.Time:Hide()
		self.master.Delay:Hide()

		self.master.Bar:SetValue( self.maxValue )
		local color = self.db.profile.colors.failed
		self.master.Bar:SetStatusBarColor( color.r, color.g, color.b )
		self.master.Spell:SetText( L[event] )
	end
	
	self:SetupAutoShot(false)	
end

function BigTrouble:SpellCastDelayed( unit )
	if unit ~= "player" or not self.isCasting then return end
 
	if self.master:IsShown() then
		local _, _, _, _, startTime, endTime, _, oldStart = UnitCastingInfo(unit)
		
		oldStart = self.startTime
		self.startTime = startTime / 1000
		self.maxValue = endTime / 1000
		
		self:SetDelay((self.delayTime or 0) + ( self.startTime - oldStart ))
		self.master.Bar:SetMinMaxValues( self.startTime, self.maxValue )
	end
end
 
function BigTrouble:StartAutoRepeat()
	if not self.isAutoShot then
		self.isAutoShot = true
		self:SetupAutoShot(true, 0.5)
	end
end

function BigTrouble:StopAutoRepeat()
	self.isAutoShot = nil
end

function BigTrouble:BarCreate(s)
	self.master.Bar:SetMinMaxValues( self.startTime, self.maxValue )
	self.master.Bar:SetValue( GetTime() )
	self.master.Spell:SetText(s)
	self.master:SetAlpha(1)
	self.master.Time:SetText("")
	self.master.Delay:SetText("")
	
	self.thresHold = nil
	
	self.master:Show()
	self.master.Spark:Show()
	self.master.Time:Show()
end

function BigTrouble:SavePosition()
	local x, y = self.master:GetLeft(), self.master:GetTop()
	local s = self.master:GetEffectiveScale()

	self.db.profile.pos.x = x * s
	self.db.profile.pos.y = y * s
end

function BigTrouble:SetPosition()
	if self.db.profile.pos.x then
		local x = self.db.profile.pos.x
		local y = self.db.profile.pos.y
	
		local s = self.master:GetEffectiveScale()

		self.master:ClearAllPoints()
		self.master:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x / s, y / s)
	else
		self.master:ClearAllPoints()
		self.master:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	end
end

function BigTrouble:CreateFrameWork()
	self.master = CreateFrame("Frame", "BigTroubleFrame", UIParent)
	self.master:Hide()
	
	self.master:SetScript( "OnUpdate", self.OnCasting )
	self.master:SetMovable(true)
	self.master:EnableMouse(true)
	self.master:RegisterForDrag("LeftButton")
	self.master:SetScript("OnDragStart", function() if not self.locked then self["master"]:StartMoving() end end)
	self.master:SetScript("OnDragStop", function() self["master"]:StopMovingOrSizing() self:SavePosition() end)

	self.master.Bar	  = CreateFrame("StatusBar", nil, self.master)
	self.master.Spark = self.master.Bar:CreateTexture(nil, "OVERLAY")
	self.master.Time  = self.master.Bar:CreateFontString(nil, "OVERLAY")
	self.master.Spell = self.master.Bar:CreateFontString(nil, "OVERLAY")
	self.master.Delay = self.master.Bar:CreateFontString(nil, "OVERLAY")
	
	self:Layout()
end

function BigTrouble:Layout()
	local gameFont, _, _ = GameFontHighlightSmall:GetFont()
	local db = self.db.profile
	
	self.master:SetWidth( db.width + 9 )
	self.master:SetHeight( db.height + 10 )

	self:BorderBackground()

	self.master.Bar:ClearAllPoints()
	self.master.Bar:SetPoint("CENTER", self.master, "CENTER", 0, 0)
	self.master.Bar:SetWidth( db.width )
	self.master.Bar:SetHeight( db.height )
	self.master.Bar:SetStatusBarTexture( surface:Fetch( db.texture ))

	self.master.Spark:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
	self.master.Spark:SetWidth(16)
	self.master.Spark:SetHeight( db.height*2.44 )
	self.master.Spark:SetBlendMode("ADD")

	self.master.Time:SetJustifyH("RIGHT")
	self.master.Time:SetFont( gameFont, db.timeSize )
	self.master.Time:SetText("X.Y")
	self.master.Time:ClearAllPoints()
	self.master.Time:SetPoint("RIGHT", self.master.Bar, "RIGHT",-10,0)
	self.master.Time:SetShadowOffset(.8, -.8)
	self.master.Time:SetShadowColor(0, 0, 0, 1)

	self.master.Spell:SetJustifyH("CENTER")
	self.master.Spell:SetWidth( db.width - self.master.Time:GetWidth() )
	self.master.Spell:SetFont( gameFont, db.spellSize )
	self.master.Spell:ClearAllPoints()
	self.master.Spell:SetPoint("LEFT", self.master, "LEFT",10,0)
	self.master.Spell:SetShadowOffset(.8, -.8)
	self.master.Spell:SetShadowColor(0, 0, 0, 1)

	self.master.Delay:SetJustifyH("RIGHT")
	self.master.Delay:SetFont( gameFont, db.delaySize )
	self.master.Delay:SetTextColor(1,0,0,1)
	self.master.Delay:SetText("X.Y")
	self.master.Delay:ClearAllPoints()
	self.master.Delay:SetPoint("TOPRIGHT", self.master.Bar, "TOPRIGHT",-10,20)
	self.master.Delay:SetShadowOffset(.8, -.8)
	self.master.Delay:SetShadowColor(0, 0, 0, 1)

	self:SetPosition()
end

function BigTrouble:BorderBackground()
	local borderstyle = self.db.profile.borderStyle
	local color = self.Borders[borderstyle]
	
	self.master:SetBackdrop({
		bgFile = "Interface\\ChatFrame\\ChatFrameBackground", 
		tile = true, 
		tileSize = 16,
		edgeFile = self.Borders[borderstyle].texture,
		edgeSize = self.Borders[borderstyle].size,
		insets = {
			left = self.Borders[borderstyle].insets, 
			right = self.Borders[borderstyle].insets, 
			top = self.Borders[borderstyle].insets, 
			bottom = self.Borders[borderstyle].insets
		},
	})
	
	self.master:SetBackdropColor(color.bc.r,color.bc.g,color.bc.b,color.bc.a)
	self.master:SetBackdropBorderColor(color.bbc.r,color.bbc.g,color.bbc.b,color.bbc.a)
end

function BigTrouble:OnCasting()
	if( ( BigTrouble.isCasting or BigTrouble.isAutoShot ) and not BigTrouble.thresHold ) then
		local currentTime = GetTime()
		
		if( currentTime > BigTrouble.maxValue ) then
			currentTime = BigTrouble.maxValue
			BigTrouble.thresHold = true
		end
		
		BigTrouble.master.Bar:SetValue( currentTime )		
		local sparkProgress = (( currentTime - BigTrouble.startTime ) / ( BigTrouble.maxValue - BigTrouble.startTime )) * BigTrouble.db.profile.width
		BigTrouble.master.Spark:SetPoint("CENTER", BigTrouble.master.Bar, "LEFT", sparkProgress, 0)
		
		BigTrouble.master.Time:SetText( string.format( "%.1f", ( BigTrouble.maxValue - currentTime )))

	else
		local a = BigTrouble.master:GetAlpha() - .05

		if( a > 0 ) then
			BigTrouble.master:SetAlpha(a)
		else
			BigTrouble.master:Hide()
			BigTrouble.master:SetAlpha(1)
		end
	end
end