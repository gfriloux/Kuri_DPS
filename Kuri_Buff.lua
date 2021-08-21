function kuri_fury_buff()
	local percent = (UnitHealth("player") / UnitHealthMax("player")) * 100

	-- If we are feared, we want to neutralize it
	if Zorlen_isCrowedControlled("player") then
		forceBerserkerRage()
	end

	-- If we are under 50% HP, it is time to cast our racial
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
		if not Zorlen_checkBuffByName(LOCALIZATION_KURI_DPS.DiamondFlaskEffect, "player") then
			Zorlen_useItemByName(LOCALIZATION_KURI_DPS.DiamondFlask)
		end
	end

	-- If we are in a raid, we use consumables.
	-- Let's manage the most basic ones.
	if UnitInRaid("player") then
		if not Zorlen_checkBuffByName(LOCALIZATION_KURI_DPS.ElixirGiants, "player") then
			Zorlen_useItemByName(LOCALIZATION_KURI_DPS.ElixirGiantsPotion)
		end
		
		if not Zorlen_checkBuffByName(LOCALIZATION_KURI_DPS.ElixirMongoose, "player") then
			Zorlen_useItemByName(LOCALIZATION_KURI_DPS.ElixirMongoose)
		end

--		if not Zorlen_checkBuffByName(LOCALIZATION_KURI_DPS.JujuPower, "player") then
--			Zorlen_useItemByName(LOCALIZATION_KURI_DPS.JujuPower)
--		end

		-- We want more rage
		if UnitMana("player") < 10 then
			castBloodrage()
		end

		if Zorlen_inCombat() then
			if not Zorlen_checkBuffByName(LOCALIZATION_KURI_DPS.MightyRage, "player") then
				Zorlen_useItemByName(LOCALIZATION_KURI_DPS.MightyRagePotion)
			end
		end

		-- Take tanking buffs
		if WE_WANT_AGGRO == 1 then
			if not Zorlen_checkBuffByName(LOCALIZATION_KURI_DPS.GiftArthas, "player") then
				Zorlen_useItemByName(LOCALIZATION_KURI_DPS.GiftArthas)
			end
			
			if Zorlen_inCombat() then
				-- We use berserker rage when available to gain more rage
				-- but only if we are on low rage to avoid losing much
				if UnitMana("player") <= 10 then
					castBerserkerRageSwap()
				end
			end
		end
	end
end
