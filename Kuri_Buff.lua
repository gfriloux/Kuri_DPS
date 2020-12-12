function kuri_fury_buff_burst()
		-- If we have Diamond Flask, use it
		if not Zorlen_checkBuffByName(LOCALIZATION_KURI_DPS.DiamondFlaskEffect, "player") then
			Zorlen_useTrinketByName(LOCALIZATION_KURI_DPS.DiamondFlask)
		end

		-- If we have Cloudkeeper Legplates, use it
		if not Zorlen_checkBuffByName(LOCALIZATION_KURI_DPS.HeavenBlessing, "player") then
			Zorlen_useItemByName(LOCALIZATION_KURI_DPS.CloudkeeperLegplates)
		end

		-- Bursts limited to raids due to cost.
		if UnitInRaid("player") then
			-- If we have low rage, we can spend Migthy Rage Potion
			if         UnitMana("player") <= 50
		   	   and not Zorlen_checkBuffByName(LOCALIZATION_KURI_DPS.MightyRage, "player")
			then
				Zorlen_useItemByName(LOCALIZATION_KURI_DPS.MightRagePotion)
			end
		end
end

function kuri_fury_buff()
	-- If we are feared, we want to neutralize it
	if Zorlen_isCrowedControlled("player") then
		forceBerserkerRage()
	end

	-- We want more rage
	if UnitMana("player") < 10 then
		castBloodrage()
	end

	-- We need Battle Shout to always be up
	if not isBattleShoutActive() then
		castBattleShout()
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

		if not Zorlen_checkBuffByName(LOCALIZATION_KURI_DPS.JujuPower, "player") then
			Zorlen_useItemByName(LOCALIZATION_KURI_DPS.JujuPower)
		end
	end

	-- Under specific circumtances, we need to burst our PA.
	      -- Primal Blessing proc
	if    Zorlen_checkBuffByName(LOCALIZATION_KURI_DPS.PrimalBlessing, "player")
		  -- Recklessness ultimate
	   or Zorlen_checkBuffByName(LOCALIZATION_KURI_DPS.Recklessness, "player")
	then
		kuri_fury_buff_burst()
	end
end


function kuri_buff_tank()
	-- We want Gift of Arthas if available
	if UnitInRaid("player") then
		if not Zorlen_checkBuffByName(LOCALIZATION_KURI_DPS.GiftArthas, "player") then
			Zorlen_useItemByName(LOCALIZATION_KURI_DPS.GiftArthas)
		end
	end
	
	-- We use berserker rage when available to gain more rage
	-- but only if we are on low rage to avoid losing much
	if UnitMana("player") <= 10 then
		castBerserkerRageSwap()
	end
	
	-- If we are under 50% HP, it is time to cast our racial
	-- if not on CD
	if percent <= 50 then
		Zorlen_castSpellByName(LOCALIZATION_KURI_DPS.Berserking)
	end
end