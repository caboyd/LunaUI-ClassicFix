local _, ns = ...
local oUF = ns.oUF


--https://github.com/wardz/ClassicCastbars/blob/master/ClassicCastbars/core/SavedVariables.lua

if oUF.isClassic then
    local GetSpellInfo = _G.GetSpellInfo
    -- NPC spells that can't be interrupted. (Sensible defaults, doesn't include all)
    -- These are tied to npcIDs. See also uninterruptibleList in ClassicSpellData.lua
    oUF.npcCastUninterruptibleCache = {
        ["12459" .. GetSpellInfo(25417)] = true, -- Blackwing Warlock Shadowbolt
        ["12264" .. GetSpellInfo(1449)] = true, -- Shazzrah Arcane Explosion
        ["11983" .. GetSpellInfo(18500)] = true, -- Firemaw Wing Buffet
        ["12265" .. GetSpellInfo(133)] = true, -- Lava Spawn Fireball
        ["10438" .. GetSpellInfo(116)] = true, -- Maleki the Pallid Frostbolt
        ["12465" .. GetSpellInfo(22425)] = true, -- Death Talon Wyrmkin Fireball Volley
        ["14020" .. GetSpellInfo(23310)] = true, -- Chromaggus Time Lapse
        ["14020" .. GetSpellInfo(23316)] = true, -- Chromaggus Ignite Flesh
        ["14020" .. GetSpellInfo(23309)] = true, -- Chromaggus Incinerate
        ["14020" .. GetSpellInfo(23187)] = true, -- Chromaggus Frost Burn
        ["14020" .. GetSpellInfo(23314)] = true, -- Chromaggus Corrosive Acid
        ["12468" .. GetSpellInfo(2120)] = true, -- Death Talon Hatcher Flamestrike
        ["13020" .. GetSpellInfo(9573)] = true, -- Vaelastrasz the Corrupt Flame Breath
        ["12435" .. GetSpellInfo(22425)] = true, -- Razorgore the Untamed Fireball Volley
        ["12118" .. GetSpellInfo(20604)] = true, -- Lucifron Dominate Mind
        ["10184" .. GetSpellInfo(9573)] = true, -- Onyxia Flame Breath
        ["10184" .. GetSpellInfo(133)] = true, -- Onyxia Fireball
        ["11492" .. GetSpellInfo(9616)] = true, -- Alzzin the Wildshaper Wild Regeneration
        ["11359" .. GetSpellInfo(16430)] = true, -- Soulflayer Soul Tap
        ["11372" .. GetSpellInfo(24011)] = true, -- Razzashi Adder Venom Spit
        ["14834" .. GetSpellInfo(24322)] = true, -- Hakkar Blood Siphon
        ["12259" .. GetSpellInfo(686)] = true, -- Gehennas Shadow Bolt
        ["14507" .. GetSpellInfo(14914)] = true, -- High Priest Venoxis Holy Fire
        ["12119" .. GetSpellInfo(20604)] = true, -- Flamewaker Protector Dominate Mind
        ["12557" .. GetSpellInfo(14515)] = true, -- Grethok the Controller Dominate Mind
        ["15276" .. GetSpellInfo(26006)] = true, -- Emperor Vek'lor Shadow Bolt
        ["12397" .. GetSpellInfo(15245)] = true, -- Lord Kazzak Shadow Bolt Volley
        ["14887" .. GetSpellInfo(16247)] = true, -- Ysondre Curse of Thorns
        ["15246" .. GetSpellInfo(11981)] = true, -- Qiraji Mindslayer Mana Burn
        ["15246" .. GetSpellInfo(17194)] = true, -- Qiraji Mindslayer Mind Blast
        ["15246" .. GetSpellInfo(22919)] = true, -- Qiraji Mindslayer Mind Flay
        ["15311" .. GetSpellInfo(26069)] = true, -- Anubisath Warder Silence
        ["15311" .. GetSpellInfo(11922)] = true, -- Anubisath Warder Entangling Roots
        ["15311" .. GetSpellInfo(12542)] = true, -- Anubisath Warder Fear
        ["15311" .. GetSpellInfo(26072)] = true, -- Anubisath Warder Dust Cloud
        ["15335" .. GetSpellInfo(21067)] = true, -- Flesh Hunter Poison Bolt
        ["15247" .. GetSpellInfo(11981)] = true, -- Qiraji Brainwasher Mana Burn
        ["15247" .. GetSpellInfo(16568)] = true, -- Qiraji Brainwasher Mind Flay
        ["11729" .. GetSpellInfo(19452)] = true, -- Hive'Zora Hive Sister Toxic Spit
        ["16146" .. GetSpellInfo(17473)] = true, -- Death Knight Raise Dead
        ["16368" .. GetSpellInfo(9081)] = true, -- Necropolis Acolyte Shadow Bolt Volley
        ["16022" .. GetSpellInfo(16568)] = true, -- Surgical Assistant Mind Flay
        ["16021" .. GetSpellInfo(1397)] = true, -- Living Monstrosity Fear
        ["16021" .. GetSpellInfo(1339)] = true, -- Living Monstrosity Chain Lightning
        ["16021" .. GetSpellInfo(28294)] = true, -- Living Monstrosity Lightning Totem
        ["16215" .. GetSpellInfo(1467)] = true, -- Unholy Staff Arcane Explosion
        ["16452" .. GetSpellInfo(1467)] = true, -- Necro Knight Guardian Arcane Explosion
        ["16452" .. GetSpellInfo(11829)] = true, -- Necro Knight Guardian Flamestrike
        ["16165" .. GetSpellInfo(1467)] = true, -- Necro Knight Arcane Explosion
        ["16165" .. GetSpellInfo(11829)] = true, -- Necro Knight Flamestrike
        ["8519" .. GetSpellInfo(16554)] = true, -- Blighted Surge Toxic Bolt
    }
end