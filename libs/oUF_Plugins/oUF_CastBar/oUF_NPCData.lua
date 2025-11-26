local _, ns = ...
local oUF = ns.oUF

local GetSpellInfo = C_Spell and C_Spell.GetSpellName or _G.GetSpellInfo

--https://github.com/wardz/ClassicCastbars/blob/master/ClassicCastbars/core/SavedVariables.lua


-- NPC spells that can't be interrupted. (Sensible defaults, doesn't include all)
-- These are tied to npcIDs. See also uninterruptibleList in ClassicSpellData.lua
oUF.npcCastUninterruptibleCache = {
    ["12459" .. GetSpellInfo(22336)] = true, -- Blackwing Warlock Shadowbolt
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
    ["16021" .. GetSpellInfo(27990)] = true, -- Living Monstrosity Fear
    ["16021" .. GetSpellInfo(28293)] = true, -- Living Monstrosity Chain Lightning
    ["16021" .. GetSpellInfo(28294)] = true, -- Living Monstrosity Lightning Totem
    ["16215" .. GetSpellInfo(28450)] = true, -- Unholy Staff Arcane Explosion
    ["16452" .. GetSpellInfo(30096)] = true, -- Necro Knight Guardian Arcane Explosion
    ["16452" .. GetSpellInfo(30091)] = true, -- Necro Knight Guardian Flamestrike
    ["16165" .. GetSpellInfo(15453)] = true, -- Necro Knight Arcane Explosion
    ["16165" .. GetSpellInfo(30091)] = true, -- Necro Knight Flamestrike
    ["8519" .. GetSpellInfo(16554)] = true, -- Blighted Surge Toxic Bolt
    ["4543" .. GetSpellInfo(9613)] = true, -- Bloodmage Thalnos Shadow Bolt
    ["4543" .. GetSpellInfo(8814)] = true, -- Bloodmage Thalnos Flame Spike
    ["3977" .. GetSpellInfo(9481)] = true, -- High Inquisitor Whitemane Holy Smite
    ["3977" .. GetSpellInfo(12039)] = true, -- High Inquisitor Whitemane Heal
    ["3977" .. GetSpellInfo(9232)] = true, -- High Inquisitor Whitemane Scarlet Resurrection
    ["7358" .. GetSpellInfo(15530)] = true, -- Amnennar the Coldbringer Frostbolt
    ["11487" .. GetSpellInfo(7645)] = true, -- Magister Kalendris Dominate Mind
    ["11487" .. GetSpellInfo(7645)] = true, -- Magister Kalendris Mind Blast
    ["11487" .. GetSpellInfo(15407)] = true, -- Magister Kalendris Mind Flay
    ["1853" .. GetSpellInfo(18702)] = true, -- Darkmaster Gandling Curse of the Darkmaster
    ["1853" .. GetSpellInfo(5143)] = true, -- Darkmaster Gandling Arcane Missiles
    ["10502" .. GetSpellInfo(14515)] = true, -- Lady Illucia Barov Dominate Mind
    ["10502" .. GetSpellInfo(12528)] = true, -- Lady Illucia Barov Silence
    ["10502" .. GetSpellInfo(12542)] = true, -- Lady Illucia Barov Fear
    ["10440" .. GetSpellInfo(17393)] = true, -- Baron Rivendare Shadow Bolt
    ["9029" .. GetSpellInfo(15245)] = true, -- Eviscerator Shadow Bolt Volley
    ["8983" .. GetSpellInfo(15305)] = true, -- Golem Lord Argelmach Chain Lightning
    ["15589" .. GetSpellInfo(26134)] = true, -- Eye of C'thun Eye Beam
    ["15727" .. GetSpellInfo(26134)] = true, -- C'thun Eye Beam
}
if CLIENT_IS_SOD then
    oUF.npcCastUninterruptibleCache["212969" .. GetSpellInfo(429825)] = true -- Kazragore Chain Lightning
    oUF.npcCastUninterruptibleCache["213334" .. GetSpellInfo(429168)] = true -- Aku'mai Corrosive Blast
    oUF.npcCastUninterruptibleCache["213334" .. GetSpellInfo(429356)] = true -- Aku'mai Void Blast
end
