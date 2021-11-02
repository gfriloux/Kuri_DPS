-- Find icon names at https://classic.wowhead.com/icons?filter=2;2;0

function kuri_tank() 
	Zorlen_MakeMacro("KFury", "/run kuri_fury()", 0, "Ability_Warrior_Challange", nil, 1)
	Zorlen_MakeMacro("KSetAssist", "/run Zorlen_changeAssist()", 0, "Spell_Holy_DivineSpirit", nil, 1)
	Zorlen_MakeMacro("KAssist", "/run Zorlen_assist()", 0, "Spell_Holy_PrayerofSpirit", nil, 1)
	Zorlen_MakeMacro("KClearAssist", "/run Zorlen_clearAssist()", 0, "Ability_BullRush", nil, 1)
end

function kuri_aggro_switch()
	if WE_WANT_AGGRO == 0 then
		Zorlen_debug("We will TAUNT!", 1)
		WE_WANT_AGGRO = 1
	else
		Zorlen_debug("We will NOT TAUNT!", 1)
		WE_WANT_AGGRO = 0
	end
end

function kuri_cleave_switch()
	if WE_WANT_CLEAVE == 0 then
		Zorlen_debug("We will CLEAVE!", 1)
		WE_WANT_CLEAVE = 1
	else
		Zorlen_debug("We will NOT CLEAVE!", 1)
		WE_WANT_CLEAVE = 0
	end
end
