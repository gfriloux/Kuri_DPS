function castSlam(test)
	local z = {}
	z.Test = test
	z.SpellName = LOCALIZATION_KURI_DPS.Slam
	if not Zorlen_Button[z.SpellName] then
		if not Zorlen_isMainHandEquipped() then
			return false
		end
		z.ManaNeeded = 15
	end
	return Zorlen_CastCommonRegisteredSpell(z)
end

function kuri_survive()
	if     UnitInRaid("player")
	       -- If we take aggro, we need to quickly use survival techniques
	   and Zorlen_isEnemyTargetingYou() then

		-- Check for invulnerability buff
		if Zorlen_checkBuffByName(LOCALIZATION_KURI_DPS.Invulnerability, "player") then
			return
		end

		-- Take invuln potion
		if Zorlen_useItemByName(LOCALIZATION_KURI_DPS.LimitedInvulnerabilityPotion) then
			return
		end
	end
end

function kuri_fury_twohand()
	-- We do not touch CC targets
	if Zorlen_isNoDamageCC("target") then
		backOff()
		return true
	end
	
	-- If enemy is at correct distance, lets charge it
	if Zorlen_GiveMaxTargetRange(8, 25) then
		swapChargeAndIntercept()
	end

	kuri_fury_buff()
	kuri_survive()
	kuri_debuff_attack()

	-- If we are not in zerk stance, and overpower is not available
	-- we have no reason to not be in zerk stance!
	if     not isBerserkerStance()
	   and     Zorlen_isActionInRangeBySpellName(LOCALIZATION_KURI_DPS.Overpower)
	then
		castBerserkerStance()
	end

	if (ZorlenConfig[ZORLEN_ZPN][ZORLEN_ASSIST]) then
		Zorlen_assist()
	end
	castAttack()

	-- Use Bloodthirst as main skill
	castBloodthirst()

	-- Dump extra rage
	if UnitMana("player") >= 60 then
		-- If no near ennemy is CC, we can use WhirlWind
--		local danger = 0
--		local t      = UnitName("target")
--		for i = 1, 4 do
--			TargetNearestEnemy()
--			if not CheckInteractDistance("target", 9) then
--				break
--			end
--			if Zorlen_isNoDamageCC("target") then
--				danger = 1
--			end
--		end
--		TargetByName(t, true)
--		if danger == 0 then
			castWhirlwind()
--		end
		
		-- It seems WhirlWind did not cast (cooldown or danger)
		-- Lets continue dump techniques

		-- If next swing is in more than 1.5s, using Slam IS a DPS boost.
		if st_timer > 1.5 then
			castSlam()
		end
	end

	-- If we get here, we have less than 30 rage, or Bloodthirst is in CD.

	-- Use execute if target's HP below 20%
	if Zorlen_TargetIsDieingEnemy() then
		castExecute()
	end
	
	return true
end

function kuri_fury_dual_strike()
	-- We do not touch CC targets
	if Zorlen_isNoDamageCC("target") then
		backOff()
		return true
	end
	
	-- If enemy is at correct distance, lets charge it
	if Zorlen_GiveMaxTargetRange(8, 25) then
		swapChargeAndIntercept()
	end

	kuri_fury_buff()
	kuri_survive()
	kuri_debuff_attack()

	-- If we are not in zerk stance, and overpower is not available
	-- we have no reason to not be in zerk stance!
	if     not isBerserkerStance()
	   and     Zorlen_isActionInRangeBySpellName(LOCALIZATION_KURI_DPS.Overpower)
	then
		castBerserkerStance()
	end

	if (ZorlenConfig[ZORLEN_ZPN][ZORLEN_ASSIST]) then
		Zorlen_assist()
	end
	castAttack()

	-- Dump extra rage
	if UnitMana("player") >= 60 then
		-- If no near ennemy is CC, we can use WhirlWind
		local danger = 0
		for i = 1, 4 do
			TargetNearestEnemy()
			if not CheckInteractDistance("target", 9) then
				break
			end

			if Zorlen_isNoDamageCC("target") then
				danger = 1
			end
		end

		if not danger then
			castWhirlwind()
		end
		
		-- It seems WhirlWind did not cast (cooldown or danger)
		-- Lets continue dump techniques

		-- If we have Flurry UP, we can use next attack skill for more damage
		if Zorlen_checkBuffByName(LOCALIZATION_KURI_DPS.Flurry, "player") then
			castHeroicStrike()
		-- Otherwise, we want an instant skill to proc Flurry
		else
			castHamstring()
		end
	end

	-- Use Bloodthirst as main skill
	castBloodthirst()
	
	-- If we get here, we have less than 30 rage, or Bloodthirst is in CD.
	-- If we have 25 rage of less, we can change stance without loosing rage.
	-- If overpower is available, let's use it!
	if     UnitMana("player") <= 25
	   and Zorlen_GetTimer("TargetDodgedYou_Overpower", nil, "InternalZorlenSpellTimers") > 1
	then
		castBattleStance()
		castOverpower()
	end

	-- Use execute if target's HP below 20%
	if Zorlen_TargetIsDieingEnemy() then
		castExecute()
	end
	
	return true
end

function kuri_fury_aoe()
	zTargetNearestActiveEnemyWithHighestHealth()
	Zorlen_WarriorAOE()
end

