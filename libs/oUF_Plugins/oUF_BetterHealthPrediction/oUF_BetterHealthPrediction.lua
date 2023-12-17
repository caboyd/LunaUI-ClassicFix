--[[
# Element: Better Health Prediction Bars

Handles the visibility and updating of incoming heals and heal/damage absorbs. With 

## Widget

BetterHealthPrediction - A `table` containing references to sub-widgets and options.

## Sub-Widgets

otherBeforeBar - A `StatusBar` used to represent incoming heals from others that will land before mine.
myBar          - A `StatusBar` used to represent incoming heals from the player.
otherAfterBar  - A `StatusBar` used to represent incoming heals from others that will land after mine.
hotBar         - A `StatusBar` used to represent healing over time.

## Notes

A default texture will be applied to the StatusBar widgets if they don"t have a texture set.
A default texture will be applied to the Texture widgets if they don"t have a texture or a color set.

## Options


.blizzDirectHeals - Use Blizzard GetIncomingHeals API for Direct Heals over LibHealComm
.disableHots - Disable heal over time effects
.timeFrame   - The amount of time into the future used for healing prediction. Defaults to 4 (number)
.maxOverflow - The maximum amount of overflow past the end of the health bar. Set this to 1 to disable the overflow.
               Defaults to 1.05 (number)

## Examples

    -- Position and size
    local otherBeforeBar = CreateFrame("StatusBar", nil, self.Health)
    otherBeforeBar:SetPoint("TOP")
    otherBeforeBar:SetPoint("BOTTOM")
    otherBeforeBar:SetPoint("LEFT", self.Health:GetStatusBarTexture(), "RIGHT")
    otherBeforeBar:SetWidth(self.Health:GetWidth())

    local myBar = CreateFrame("StatusBar", nil, self.Health)
    myBar:SetPoint("TOP")
    myBar:SetPoint("BOTTOM")
    myBar:SetPoint("LEFT", otherBeforeBar:GetStatusBarTexture(), "RIGHT")
    myBar:SetWidth(self.Health:GetWidth())

    local otherAfterBar = CreateFrame("StatusBar", nil, self.Health)
    otherAfterBar:SetPoint("TOP")
    otherAfterBar:SetPoint("BOTTOM")
    otherAfterBar:SetPoint("LEFT", myBar:GetStatusBarTexture(), "RIGHT")
    otherAfterBar:SetWidth(self.Health:GetWidth())

    -- Register with oUF
    self.BetterHealthPrediction = {
        otherBeforeBar = otherBeforeBar,
        myBar = myBar,
        otherAfterBar = otherAfterBar,
        maxOverflow = 1.05,
    }
--]]

local _, ns = ...
local oUF = ns.oUF
local myGUID = UnitGUID("player")
local HealComm = LibStub("LibHealComm-4.0")
local UnitGetIncomingHeals = _G.UnitGetIncomingHeals
local isBlizzDirectHeals = false
local isDisableHoTs = false



local function GetMyHeal(unit, guid, timeFrame)
	local myHeal = (HealComm:GetHealAmount(guid, HealComm.DIRECT_HEALS, timeFrame, myGUID) or 0)
	if isBlizzDirectHeals then
		--When casting on players outside of party, libhealcomm returns 0 heal
		local myBlizzHeal = UnitGetIncomingHeals(unit, "player") or 0
		if myBlizzHeal > myHeal then myHeal = myBlizzHeal end
	end
	return myHeal
end

local function GetTotalHeal(unit, guid, timeFrame, myHeal)
	local totalHeal = (HealComm:GetHealAmount(guid, HealComm.DIRECT_HEALS, timeFrame) or 0)
	-- UnitGetIncomingHeals is bugged for Paladins and doesn't apply +healing
	-- Only use blizzard heals if value is greater than healcomms
	if isBlizzDirectHeals then
		--[[Example. 
		Me: 	paladin healing for 50 base + 950 healing
		other:  paladin healing for 50 base + 950 healing without libhealcomm
		myHeal: 		1000
		myBlizzHeal: 	50
		otherHeal: 		0 	--no libhealcomm
		otherBlizzHeal: 50
		totalHeal: 		1000
		totalBlizzHeal: 100
		totalHealCorrected: 1050 myHeal + otherBlizzHeal 
		--]]
		local myBlizzHeal = UnitGetIncomingHeals(unit, "player") or 0
		local otherBlizzHeal = (UnitGetIncomingHeals(unit) or 0) - myBlizzHeal
		local totalHealCorrected = otherBlizzHeal + myHeal
		if totalHealCorrected > totalHeal then return totalHealCorrected end
	end
	return totalHeal
end

local function GetPreHeal(guid, timeFrame, myHeal)
	local preHeal = 0
	-- We can only scout up to 2 direct heals that would land before ours but thats good enough for most cases
	local healTime, healFrom, healAmount = HealComm:GetNextHealAmount(guid, HealComm.DIRECT_HEALS, timeFrame)
	if healFrom and healFrom ~= myGUID and myHeal > 0 then
		preHeal = (healAmount or 0)
		healTime, healFrom, healAmount = HealComm:GetNextHealAmount(guid, HealComm.DIRECT_HEALS, timeFrame, healFrom)
		if healFrom and healFrom ~= myGUID then
			preHeal = preHeal + (healAmount or 0)
		end
	end
	return preHeal
end


local function GetHoTHeal(guid, timeFrame)
	if isDisableHoTs then return 0 end
	return (HealComm:GetHealAmount(guid, bit.bor(HealComm.HOT_HEALS, HealComm.CHANNEL_HEALS, HealComm.BOMB_HEALS), timeFrame) or 0)
end

local function Update(self, event, unit)
	if(self.unit ~= unit) then return end

	local element = self.BetterHealthPrediction

	--[[ Callback: BetterHealthPrediction:PreUpdate(unit)
	Called before the element has been updated.

	* self - the BetterHealthPrediction element
	* unit - the unit for which the update has been triggered (string)
	--]]
	if(element.PreUpdate) then
		element:PreUpdate(unit)
	end

	isBlizzDirectHeals = element.blizzDirectHeals
	isDisableHoTs = element.disableHots

	local guid = UnitGUID(unit)
	local timeFrame = GetTime() + element.timeFrame
	local health, maxHealth = UnitHealth(unit), UnitHealthMax(unit)
	local healMod 	= HealComm:GetHealModifier(guid) or 1
	local myHeal 	= GetMyHeal(unit, guid, timeFrame)
	local totalHeal = GetTotalHeal(unit, guid, timeFrame, myHeal)
	local preHeal 	= GetPreHeal(guid, timeFrame, myHeal)
	local hotHeal 	= GetHoTHeal(guid, timeFrame)
	local afterHeal = totalHeal - preHeal - myHeal
	totalHeal = totalHeal + hotHeal

	myHeal 		= healMod * myHeal
	preHeal 	= healMod * preHeal
	hotHeal 	= healMod * hotHeal
	afterHeal 	= healMod * afterHeal

	local maxBar = (maxHealth * element.maxOverflow - health)
	if preHeal >= maxBar then
		preHeal = maxBar
		myHeal = 0
		afterHeal = 0
		hotHeal = 0
	elseif (preHeal + myHeal) >= maxBar then
		myHeal = maxBar - preHeal
		afterHeal = 0
		hotHeal = 0
	elseif (preHeal + myHeal + afterHeal) >= maxBar then
		afterHeal = maxBar - preHeal - myHeal
		hotHeal = 0
	elseif (preHeal + myHeal + afterHeal + hotHeal) >= maxBar then
		hotHeal = maxBar - preHeal - myHeal - afterHeal
	end

	if(element.otherBeforeBar) then
		-- Bug introduced to Classic as of 1.15.0.52146
		-- BUG: As of 10.2, when the current value matches the min value the status bar texture
		-- despite not being visible is actually set to the max which is the opposite of what we
		-- want, and it breaks all the anchors on top of that. Setting the min value slightly below
		-- 0 allows us to imitate the original pre-10.2 behaviour.
		element.otherBeforeBar:SetMinMaxValues(-0.001, maxHealth)
		element.otherBeforeBar:SetValue(preHeal)
		-- This needs to be totalHeal because only shown bars are size updated and bars might depend on another like in the example
		element.otherBeforeBar:SetShown(totalHeal > 0)
		element.otherBeforeBar:SetAlpha(preHeal > 0 and 1 or 0)
	end

	if(element.myBar) then
		element.myBar:SetMinMaxValues(-0.001, maxHealth)
		element.myBar:SetValue(myHeal)
		element.myBar:SetShown(totalHeal > 0)
		element.myBar:SetAlpha(myHeal > 0 and 1 or 0)
	end

	if(element.otherAfterBar) then
		element.otherAfterBar:SetMinMaxValues(-0.001, maxHealth)
		element.otherAfterBar:SetValue(afterHeal)
		element.otherAfterBar:SetShown(totalHeal > 0)
		element.otherAfterBar:SetAlpha(afterHeal > 0 and 1 or 0)
	end

	if(element.hotBar) then
		element.hotBar:SetMinMaxValues(-0.001, maxHealth)
		element.hotBar:SetValue(hotHeal)
		element.hotBar:SetShown(totalHeal > 0)
		element.hotBar:SetAlpha(hotHeal > 0 and 1 or 0)
	end

	--[[ Callback: BetterHealthPrediction:PostUpdate(unit, myIncomingHeal, otherIncomingHeal, absorb, healAbsorb, hasOverAbsorb, hasOverHealAbsorb)
	Called after the element has been updated.

	* self              - the BetterHealthPrediction element
	* unit              - the unit for which the update has been triggered (string)
	* myIncomingHeal    - the amount of incoming healing done by the player (number)
	* otherIncomingHeal - the amount of incoming healing done by others (number)
	* otherIncomingHeal - the amount of incoming healing done by others (number)
	* hotHeal           - the amount of incoming healing done by others (number)
	--]]
	if(element.PostUpdate) then
		-- return element:PostUpdate(unit, myIncomingHeal, otherIncomingHeal, absorb, healAbsorb, hasOverAbsorb, hasOverHealAbsorb)
		return element:PostUpdate(unit, myHeal, totalHeal - myHeal)
	end
end

local function Path(self, ...)
	--[[ Override: BetterHealthPrediction.Override(self, event, unit)
	Used to completely override the internal update function.

	* self  - the parent object
	* event - the event triggering the update (string)
	* unit  - the unit accompanying the event
	--]]
	return (self.BetterHealthPrediction.Override or Update) (self, ...)
end

local function ForceUpdate(element)
	return Path(element.__owner, "ForceUpdate", element.__owner.unit)
end

local function Enable(self)
	local element = self.BetterHealthPrediction
	if(element) then
		element.__owner = self
		element.ForceUpdate = ForceUpdate

		self:RegisterEvent("UNIT_HEALTH_FREQUENT", Path)
		self:RegisterEvent("UNIT_MAXHEALTH", Path)
		self:RegisterEvent("UNIT_HEAL_PREDICTION", Path)

		local function HealCommUpdate(...)
			if self.BetterHealthPrediction and self:IsVisible() then
				for i = 1, select("#", ...) do
					if self.unit and UnitGUID(self.unit) == select(i, ...) then
						Path(self, nil, self.unit)
					end
				end
			end
		end

		local function HealComm_Heal_Update(event, casterGUID, spellID, healType, _, ...)
			HealCommUpdate(...)
		end

		local function HealComm_Modified(event, guid)
			HealCommUpdate(guid)
		end

		HealComm.RegisterCallback(element, "HealComm_HealStarted", HealComm_Heal_Update)
		HealComm.RegisterCallback(element, "HealComm_HealUpdated", HealComm_Heal_Update)
		HealComm.RegisterCallback(element, "HealComm_HealDelayed", HealComm_Heal_Update)
		HealComm.RegisterCallback(element, "HealComm_HealStopped", HealComm_Heal_Update)
		HealComm.RegisterCallback(element, "HealComm_ModifierChanged", HealComm_Modified)
		HealComm.RegisterCallback(element, "HealComm_GUIDDisappeared", HealComm_Modified)

		if(not element.timeFrame) then
			element.timeFrame = 4
		end

		if(not element.maxOverflow) then
			element.maxOverflow = 1.05
		end

		if(element.otherBeforeBar) then
			if(element.otherBeforeBar:IsObjectType("StatusBar") and not element.otherBeforeBar:GetStatusBarTexture()) then
				element.otherBeforeBar:SetStatusBarTexture([[Interface\TargetingFrame\UI-StatusBar]])
			end
		end

		if(element.myBar) then
			if(element.myBar:IsObjectType("StatusBar") and not element.myBar:GetStatusBarTexture()) then
				element.myBar:SetStatusBarTexture([[Interface\TargetingFrame\UI-StatusBar]])
			end
		end

		if(element.otherAfterBar) then
			if(element.otherAfterBar:IsObjectType("StatusBar") and not element.otherAfterBar:GetStatusBarTexture()) then
				element.otherAfterBar:SetStatusBarTexture([[Interface\TargetingFrame\UI-StatusBar]])
			end
		end

		if(element.hotBar) then
			if(element.hotBar:IsObjectType("StatusBar") and not element.hotBar:GetStatusBarTexture()) then
				element.hotBar:SetStatusBarTexture([[Interface\TargetingFrame\UI-StatusBar]])
			end
		end

		return true
	end
end

local function Disable(self)
	local element = self.BetterHealthPrediction
	if(element) then
		if(element.otherBeforeBar) then
			element.otherBeforeBar:Hide()
		end

		if(element.myBar) then
			element.myBar:Hide()
		end

		if(element.otherAfterBar) then
			element.otherAfterBar:Hide()
		end

		if(element.hotBar) then
			element.hotBar:Hide()
		end

		HealComm.UnregisterCallback(element, "HealComm_HealStarted")
		HealComm.UnregisterCallback(element, "HealComm_HealUpdated")
		HealComm.UnregisterCallback(element, "HealComm_HealDelayed")
		HealComm.UnregisterCallback(element, "HealComm_HealStopped")
		HealComm.UnregisterCallback(element, "HealComm_ModifierChanged")
		HealComm.UnregisterCallback(element, "HealComm_GUIDDisappeared")

		self:UnregisterEvent("UNIT_MAXHEALTH", Path)
		self:UnregisterEvent("UNIT_HEALTH_FREQUENT", Path)
		self:UnregisterEvent("UNIT_HEAL_PREDICTION", Path)
	end
end

oUF:AddElement("BetterHealthPrediction", Path, Enable, Disable)
