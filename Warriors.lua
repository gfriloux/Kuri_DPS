WE_WANT_AGGRO  = 0
WE_WANT_CLEAVE = 0
WE_WANT_TAUNT  = 0

function kuri_warrior_aggro_switch()
	if WE_WANT_AGGRO == 0 then
		Zorlen_debug("We will TANK!", 1)
		WE_WANT_AGGRO = 1
	else
		Zorlen_debug("We will NOT TANK!", 1)
		WE_WANT_AGGRO = 0
	end
end

function kuri_warrior_cleave_switch()
	if WE_WANT_CLEAVE == 0 then
		Zorlen_debug("We will CLEAVE!", 1)
		WE_WANT_CLEAVE = 1
	else
		Zorlen_debug("We will NOT CLEAVE!", 1)
		WE_WANT_CLEAVE = 0
	end
end

function kuri_warrior_taunt_switch()
	if WE_WANT_TAUNT == 0 then
		Zorlen_debug("We will TAUNT!", 1)
		WE_WANT_TAUNT = 1
	else
		Zorlen_debug("We will NOT TAUNT!", 1)
		WE_WANT_TAUNT = 0
	end
end


function kuri_warrior_rotation()
  kuri_warrior_buff()
  kuri_warrior_debuff()

  if WE_WANT_AGGRO == 0 then
    if Zorlen_HasTalent(LOCALIZATION_ZORLEN.MortalStrike) then
      kuri_warrior_arms()
    else
      kuri_warrior_dps()
    end
  else
    kuri_warrior_tank()
  end
end

function kuri_warrior_macros()
  Zorlen_MakeMacro("Warrior Rotation", "/script kuri_warrior_rotation()", 1, "Racial_Troll_Berserk", nil, 1)
end
