-- Find icon names at https://classic.wowhead.com/icons?filter=2;2;0

function kuri_tank() 
	Zorlen_MakeMacro("KDPS-Duals", "/run kuri_fury_dual_strike()", 0, "Ability_Warrior_Challange", nil, 1)
	Zorlen_MakeMacro("KDPS-AoE", "/run kuri_fury_aoe()", 0, "Spell_Fire_SelfDestruct", nil, 1)
	Zorlen_MakeMacro("KTank", "/run kuri_tank()", 0, "Ability_Warrior_InnerRage", nil, 1)
	Zorlen_MakeMacro("KOff-Tank", "/run kuri_tank_off()", 0, "Spell_Nature_Reincarnation", nil, 1)
	Zorlen_MakeMacro("KSetAssist", "/run Zorlen_changeAssist()", 0, "Spell_Holy_DivineSpirit", nil, 1)
	Zorlen_MakeMacro("KAssist", "/run Zorlen_assist()", 0, "Spell_Holy_PrayerofSpirit", nil, 1)
	Zorlen_MakeMacro("KClearAssist", "/run Zorlen_clearAssist()", 0, "Ability_BullRush", nil, 1)
end

function kuri_we_want_aggro()
	Zorlen_debug("We will TAUNT!", 1)
	WE_WANT_AGGRO = 1
end

function kuri_we_dont_want_aggro()
	Zorlen_debug("We will NOT taunt!", 1)
	WE_WANT_AGGRO = 0
end