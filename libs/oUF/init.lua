local parent, ns = ...
ns.oUF = {}
ns.oUF.Private = {}

ns.oUF.isClassic = WOW_PROJECT_ID == (WOW_PROJECT_CLASSIC or 2)
ns.oUF.isTBC = WOW_PROJECT_ID == (WOW_PROJECT_BURNING_CRUSADE_CLASSIC or 5)

if(ns.oUF.isClassic and LE_EXPANSION_LEVEL_CURRENT == LE_EXPANSION_BURNING_CRUSADE) then
    -- TBC 2026 appears to use Classic project ID with BC expansion
    ns.oUF.isClassic =  false
    ns.oUF.isTBC = true
end

ns.oUF.isClassicSoD = ns.oUF.isClassic and C_Seasons.HasActiveSeason() and (C_Seasons.GetActiveSeason() == Enum.SeasonID.SeasonOfDiscovery)
ns.oUF.isWrath = WOW_PROJECT_ID == (WOW_PROJECT_WRATH_CLASSIC or 11)
ns.oUF.isRetail = WOW_PROJECT_ID == (WOW_PROJECT_MAINLINE or 1)
