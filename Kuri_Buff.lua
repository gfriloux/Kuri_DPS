function kuri_fury_buff()
	local percent = (UnitHealth("player") / UnitHealthMax("player")) * 100

	-- If we are feared, we want to neutralize it
	if Zorlen_isCrowedControlled("player") then
		forceBerserkerRage()
	end

	-- If we are under 50% HP, it is time to cast troll's racial
	-- if not on CD
	if percent <= 50 then
		Zorlen_castSpellByName(LOCALIZATION_KURI_DPS.Berserking)
	end

	-- We need Battle Shout to always be up
	if not isBattleShoutActive() then
		castBattleShout()
	end
	
	if Zorlen_inCombat() then
		if not isDefensiveStance() then
			castDeathWish()
		end
	end

	-- If we are in a raid, we use consumables.
	-- Let's manage the most basic ones.
	if UnitInRaid("player") then
		-- We want more rage
		if UnitMana("player") < 10 then
			castBloodrage()
		end
	end
end
