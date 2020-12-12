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

function kuri_fury_dual_strike()
	-- We do not touch CC targets
	if Zorlen_isNoDamageCC("target") then
		backOff()
		return true
	end

	kuri_fury_buff()
	kuri_survive()

	-- If enemy is at correct distance, lets charge it
	if Zorlen_GiveMaxTargetRange(8, 25) then
		swapChargeAndIntercept()
	end

	-- If we are not in zerk stance, and overpower is not available
	-- we have no reason to not be in zerk stance!
	if     not isBerserkerStance()
	   and     Zorlen_isActionInRangeBySpellName(LOCALIZATION_KURI_DPS.Overpower)
	then
		castBerserkerStance()
	end

	castAttack()

	-- We want max sunder armor for maximum DPS ASAP
	--if UnitInRaid("player") then
	--	castSunderArmor()
	--end

	-- Dump extra rage
	if UnitMana("player") >= 60 then
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
		castDeathWish()
		castExecute()
	end
	
	return true
end

function kuri_fury_aoe()
	zTargetNearestActiveEnemyWithHighestHealth()
	Zorlen_WarriorAOE()
end

