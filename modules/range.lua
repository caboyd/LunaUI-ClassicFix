local Range = {}
AceLibrary("AceHook-2.1"):embed(Range)
AceLibrary("AceEvent-2.0"):embed(Range)
local L = LunaUF.L
local BS = LunaUF.BS
local BZ = AceLibrary("Babble-Zone-2.2")
local ScanTip = LunaUF.ScanTip
local rosterLib = AceLibrary("RosterLib-2.0")
LunaUF:RegisterModule(Range, "range", L["Range"])
local roster = {}
local _, playerClass = UnitClass("player")

local HealSpells = {
    ["DRUID"] = {
		[string.lower(BS["Healing Touch"])] = true,
		[string.lower(BS["Regrowth"])] = true,
		[string.lower(BS["Rejuvenation"])] = true,
	},
    ["PALADIN"] = {
		[string.lower(BS["Flash of Light"])] = true,
		[string.lower(BS["Holy Light"])] = true,
	},
    ["PRIEST"] = {
		[string.lower(BS["Flash Heal"])] = true,
		[string.lower(BS["Lesser Heal"])] = true,
		[string.lower(BS["Heal"])] = true,
		[string.lower(BS["Greater Heal"])] = true,
		[string.lower(BS["Renew"])] = true,
	},
    ["SHAMAN"] = {
		[string.lower(BS["Chain Heal"])] = true,
		[string.lower(BS["Lesser Healing Wave"])] = true,
		[string.lower(BS["Healing Wave"])] = true,
	},
}

-- This table needs to be localized, of course
local events

if ( GetLocale() == "koKR" ) then
	events = {
		CHAT_MSG_COMBAT_PARTY_HITS = "(.+)|1이;가; .-|1을;를; 공격하여 %d+의 [^%s]+ 입혔습니다",
		CHAT_MSG_COMBAT_FRIENDLYPLAYER_HITS = "(.+)|1이;가; .-|1을;를; 공격하여 %d+의 [^%s]+ 입혔습니다",
		CHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS = ".-의 공격을 받아 %d+의 [^%s]+ 입었습니다",
		CHAT_MSG_COMBAT_CREATURE_VS_PARTY_HITS = ".+|1이;가; ([^%s]+)|1을;를; 공격하여 %d+의 [^%s]+ 입혔습니다",
		CHAT_MSG_COMBAT_CREATURE_VS_CREATURE_HITS = ".+|1이;가; ([^%s]+)|1을;를; 공격하여 %d+의 [^%s]+ 입혔습니다",

		CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE = {".-|1이;가; .+|1으로;로; 당신에게 %d+의 .- 입혔습니다", ".-|1이;가; .-|1으로;로; 공격했지만 저항했습니다"},
		CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE = {".-|1이;가; .+|1으로;로; (.-)에게 %d+의 .- 입혔습니다", ".-|1이;가; .-|1으로;로; (.-)|1을;를; 공격했지만 저항했습니다"},
		CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE = {".-|1이;가; .+|1으로;로; (.-)에게 %d+의 .- 입혔습니다", ".-|1이;가; .-|1으로;로; (.-)|1을;를; 공격했지만 저항했습니다"},

		CHAT_MSG_SPELL_FRIENDLYPLAYER_BUFF = "([^%s]+)의 .+%.",
		CHAT_MSG_SPELL_FRIENDLYPLAYER_DAMAGE = "(.-)|1이;가; .+|1으로;로; .-에게 %d+의 .- 입혔습니다",
		CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE = ".-|1이;가; .+|1으로;로; (.-)에게 %d+의 .- 입혔습니다",
		CHAT_MSG_SPELL_PARTY_BUFF = "([^%s]+)의 .+%.",
		CHAT_MSG_SPELL_PARTY_DAMAGE = "(.-)|1이;가; .+|1으로;로; .-에게 %d+의 .- 입혔습니다",
		--CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE = ".-|1이;가; ([^%s]+)의 .-에 의해 %d+의 .+",
		CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_BUFFS = "([^%s]+)|1이;가; .+%.",
		CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE = "([^%s]+)|1이;가; .-에 의해 %d+의 .+",
		CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE = "([^%s]+)|1이;가; .-에 의해 %d+의 .+",
		CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE = "([^%s]+)|1이;가; .-에 의해 %d+의 .+",
		CHAT_MSG_SPELL_PERIODIC_PARTY_BUFFS = "([^%s]+)|1이;가; .+%.",
	}
else
	events = {
		CHAT_MSG_COMBAT_PARTY_HITS = {L["CHAT_MSG_COMBAT_HITS"],L["CHAT_MSG_COMBAT_CRITS"]},
		CHAT_MSG_COMBAT_FRIENDLYPLAYER_HITS = {L["CHAT_MSG_COMBAT_HITS"],L["CHAT_MSG_COMBAT_CRITS"]},
		CHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS = {L["CHAT_MSG_COMBAT_CREATURE_VS_HITS"],L["CHAT_MSG_COMBAT_CREATURE_VS_CRITS"]},
		CHAT_MSG_COMBAT_CREATURE_VS_PARTY_HITS = {L["CHAT_MSG_COMBAT_CREATURE_VS_HITS"],L["CHAT_MSG_COMBAT_CREATURE_VS_CRITS"]},
		CHAT_MSG_COMBAT_CREATURE_VS_CREATURE_HITS = {L["CHAT_MSG_COMBAT_CREATURE_VS_HITS"],L["CHAT_MSG_COMBAT_CREATURE_VS_CRITS"],L["CHAT_MSG_COMBAT_CREATURE_VS_CRITS2"]},

		CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE = {L["CHAT_MSG_SPELL_CREATURE_VS_DAMAGE1"], L["CHAT_MSG_SPELL_CREATURE_VS_DAMAGE2"], L["CHAT_MSG_SPELL_CREATURE_VS_DAMAGE3"]},
		CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE = {L["CHAT_MSG_SPELL_CREATURE_VS_DAMAGE1"], L["CHAT_MSG_SPELL_CREATURE_VS_DAMAGE2"], L["CHAT_MSG_SPELL_CREATURE_VS_DAMAGE3"]},
		CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE = {L["CHAT_MSG_SPELL_CREATURE_VS_DAMAGE1"], L["CHAT_MSG_SPELL_CREATURE_VS_DAMAGE2"], L["CHAT_MSG_SPELL_CREATURE_VS_DAMAGE3"]},

		CHAT_MSG_SPELL_FRIENDLYPLAYER_BUFF = L["CHAT_MSG_SPELL_FRIENDLYPLAYER_BUFF"],
		CHAT_MSG_SPELL_FRIENDLYPLAYER_DAMAGE = {L["CHAT_MSG_SPELL_FRIENDLYPLAYER_DAMAGE"],L["CHAT_MSG_SPELL_FRIENDLYPLAYER_DAMAGE2"]},
		CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE = L["CHAT_MSG_SPELL_CREATURE_VS_DAMAGE1"],
		CHAT_MSG_SPELL_PARTY_BUFF = L["CHAT_MSG_SPELL_FRIENDLYPLAYER_BUFF"],
		CHAT_MSG_SPELL_PARTY_DAMAGE = {L["CHAT_MSG_SPELL_FRIENDLYPLAYER_DAMAGE"],L["CHAT_MSG_SPELL_FRIENDLYPLAYER_DAMAGE2"]},
		CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_BUFFS = L["CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_BUFFS"],
		CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE = {L["CHAT_MSG_SPELL_PERIODIC_DAMAGE"], L["CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE"]},
		CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE = {L["CHAT_MSG_SPELL_PERIODIC_DAMAGE"], L["CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE"]},
		CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE = L["CHAT_MSG_SPELL_PERIODIC_DAMAGE"],
		CHAT_MSG_SPELL_PERIODIC_PARTY_BUFFS = {L["CHAT_MSG_SPELL_PERIODIC_PARTY_BUFFS1"], L["CHAT_MSG_SPELL_PERIODIC_PARTY_BUFFS2"]},

		CHAT_MSG_COMBAT_CREATURE_VS_PARTY_MISSES = {L["CHAT_MSG_COMBAT_CREATURE_VS_PARTY_MISSES1"], L["CHAT_MSG_COMBAT_CREATURE_VS_PARTY_MISSES2"], L["CHAT_MSG_COMBAT_CREATURE_VS_PARTY_MISSES3"], L["CHAT_MSG_COMBAT_CREATURE_VS_PARTY_MISSES4"]},
		CHAT_MSG_SPELL_HOSTILEPLAYER_BUFF = {L["CHAT_MSG_SPELL_HOSTILEPLAYER_BUFF1"], L["CHAT_MSG_SPELL_FRIENDLYPLAYER_BUFF"]},
	}
end

local function ParseCombatMessage(eventstr, clString)
	local unit
	if type(eventstr) == "string" then
		local _, _, unitname = string.find(clString, eventstr)
		if unitname and (unitname ~= L["you"] and unitname ~= L["You"]) then
			unit = rosterLib:GetUnitIDFromName(unitname)
			if unit then
				roster[unit] = GetTime()
			end
		end
	elseif type(eventstr) == "table" then
		for _,val in pairs(eventstr) do
			local _, _, unitname = string.find(clString, val)
			if unitname and (unitname ~= L["you"] and unitname ~= L["You"]) then
				unit = rosterLib:GetUnitIDFromName(unitname)
				if unit then
					roster[unit] = GetTime()
					return
				end
			end
		end
	end
end

local function OnUpdate()
	Range:FullUpdate(this:GetParent())
end

function Range:GetRange(UnitID)
    if UnitExists(UnitID) and UnitIsVisible(UnitID) then

		-- try to read distance via superwow first
		if LunaUF.isSuperWoW then
			local x1, y1, z1 = UnitPosition("player")
			local x2, y2, z2 = UnitPosition(UnitID)
			-- only continue if we got position values
			if x1 and y1 and z1 and x2 and y2 and z2 then
				local distance = ((x2 - x1)^2 + (y2 - y1)^2 + (z2 - z1)^2)^.5
				return distance < 45 and distance or 45
			end
		end

		if CheckInteractDistance(UnitID, 1) then
			return 10
		elseif CheckInteractDistance(UnitID, 3) then
			return 10
		elseif CheckInteractDistance(UnitID, 4) then
			return 30
		elseif (GetTime() - (roster[UnitID] or 0)) < 4 then
			return 40
		else
			return 45
		end
    end
	return 100
end

function Range:ScanRoster()
	if not SpellIsTargeting() then return end
	-- We have a valid 40y spell on the cursor so we can now easily check the range.
	for i=1,40 do
		local unit = "raid"..i
		if not UnitExists(unit) then
			break
		end
		if SpellCanTargetUnit(unit) then
			roster[unit] = GetTime()
		end
		unit = "raidpet"..i
		if UnitExists(unit) and SpellCanTargetUnit(unit) then
			roster[unit] = GetTime()
		end
	end
	for i=1,4 do
		local unit = "party"..i
		if not UnitExists(unit) then
			break
		end
		if SpellCanTargetUnit(unit) then
			roster[unit] = GetTime()
		end
		unit = "partypet"..i
		if UnitExists(unit) and SpellCanTargetUnit(unit) then
			roster[unit] = GetTime()
		end
	end
end

function Range:CastSpell(spellId, spellbookTabNum)
	self.hooks.CastSpell(spellId, spellbookTabNum)
	if SpellIsTargeting() then
		local spell = GetSpellName(spellId, spellbookTabNum)
		spell = string.lower(spell)
		if HealSpells[playerClass] and HealSpells[playerClass][spell] then
			if not self:IsEventScheduled("ScanRoster") then
				self:ScheduleRepeatingEvent("ScanRoster", self.ScanRoster, 2)
			end
			self:ScanRoster()
		end
	end
end

function Range:CastSpellByName(spellName, onSelf)
	self.hooks.CastSpellByName(spellName, onSelf)
	if SpellIsTargeting() then
		local _,_,spell = string.find(spellName, "^([^%(]+)")
		spell = string.lower(spell)
		if HealSpells[playerClass] and HealSpells[playerClass][spell] then
			if not self:IsEventScheduled("ScanRoster") then
				self:ScheduleRepeatingEvent("ScanRoster", self.ScanRoster, 2)
			end
			self:ScanRoster()
		end
	end
end

function Range:UseAction(slot, checkCursor, onSelf)
	self.hooks.UseAction(slot, checkCursor, onSelf)
	if not GetActionText(slot) and SpellIsTargeting() then
		ScanTip:ClearLines()
		ScanTip:SetAction(slot)
		local spell = LunaScanTipTextLeft1:GetText()
		spell = string.lower(spell)
		if HealSpells[playerClass] and HealSpells[playerClass][spell] then
			if not self:IsEventScheduled("ScanRoster") then
				self:ScheduleRepeatingEvent("ScanRoster", self.ScanRoster, 2)
			end
			self:ScanRoster()
		end
	end
end

function Range:SpellStopTargeting()
	self.hooks.SpellStopTargeting()
	if self:IsEventScheduled("ScanRoster") then
		self:CancelScheduledEvent("ScanRoster")
	end
end

function Range:OnEnable(frame)
	if not frame.range then
		frame.range = CreateFrame("Frame", nil, frame)
	end
	frame.range.lastUpdate = GetTime() - 5
	frame.range:SetScript("OnUpdate", OnUpdate)
end

function Range:OnDisable(frame)
	if frame.range then
		frame.range:SetScript("OnUpdate", nil)
	end
end

function Range:FullUpdate(frame)
	if frame.DisableRangeAlpha or (GetTime() - frame.range.lastUpdate) < (LunaUF.db.profile.RangePolRate or 1.5) then return end
	frame.range.lastUpdate = GetTime()
	local range = self:GetRange(frame.unit)

	local healththreshold = LunaUF.db.profile.units.raid.healththreshold
	if (not healththreshold.enabled) then
		if range <= 40 then
			frame:SetAlpha(LunaUF.db.profile.units[frame.unitGroup].fader.enabled and LunaUF.db.profile.units[frame.unitGroup].fader.combatAlpha or 1)
		else
			frame:SetAlpha(LunaUF.db.profile.units[frame.unitGroup].range.alpha)
		end
	else -- TODO Remove dependency on the Range module for healththreshold.
		local percent = UnitHealth(frame.unit) / UnitHealthMax(frame.unit)
		if (range <= 40) then
			if (percent <= healththreshold.threshold) then				
				frame:SetAlpha(healththreshold.inRangeBelowAlpha)
			else
				frame:SetAlpha(healththreshold.inRangeAboveAlpha)
			end
		else
			if (percent <= healththreshold.threshold) then
				frame:SetAlpha(healththreshold.outOfRangeBelowAlpha)
			else
				frame:SetAlpha(LunaUF.db.profile.units[frame.unitGroup].range.alpha)
			end
		end
	end


end

if not LunaUF.isSuperWoW then
	if HealSpells[playerClass] then -- only hook on healing classes
		Range:Hook("CastSpell")
		Range:Hook("CastSpellByName")
		Range:Hook("UseAction")
		Range:Hook("SpellStopTargeting")
	end
end
