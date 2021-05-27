-- Glossary :
-- TPR             = Threat Per Rage.
--       Number of threat generated for each rage point used.
--       Example : Revenge Rank 6 for 355 Threat, at the cost of 5 Rage.
--                 It equals to 355 / 5 = 71 TPR.
-- Threat Modifier = Conversion of threat per damage done.
--                   Defense stance                = 1.30 (1.00 + 10%)
--                   Defense stance + 5/5 Defiance = 1.45
--                   1000 damage hit = 1000 * 1.45 = 1450 threat.

WE_WANT_AGGRO = 0

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
	local percent = (UnitHealth("player") / UnitHealthMax("player")) * 100

	-- If we are on low HP, we want to use Last Stand if available
	if percent <= 30 then
		castLastStand()
	end

	if WE_WANT_AGGRO == 1 then
		return
	end

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

	-- If we want aggro, we are tanking.
	-- In this case, we use Def stance.
	-- Otherwise, we want Zerk!
	if      WE_WANT_AGGRO == 1 then

		-- If target has less than 20% HP, we want to full execute him
		if Zorlen_TargetIsDieingEnemy() then
			if not isBattleStance() then
				castBattleStance()
			end
			castOverpower()
			castExecute()
		else
			if not isDefensiveStance() then
				castDefensiveStance()
			end
		end
	else
		if not isBerserkerStance() then
			castBerserkerStance()
		end
	end

	if     not WE_WANT_AGGRO == 1
	   and     (ZorlenConfig[ZORLEN_ZPN][ZORLEN_ASSIST]) then
		Zorlen_assist()
	end

	-- Taunt will be cast if target is not targetting you
	if WE_WANT_AGGRO == 1 then
		castTaunt()
	end

	castAttack()
	
	if isDefensiveStance() then
		if not isDisarm() then
			castDisarm()
		end
	end

	if WE_WANT_AGGRO == 1 then
		-- Taunt will be cast if target is not targetting you
		castTaunt()

		-- Revenge : 71 TPR, we want to use it every time its possible as its only 5 Rage point.
		-- As we dont wear a shield, it will not happen so often.
		castRevenge()
	end

	-- Use Bloodthirst as main skill.
	-- 1500 damage Bloodthirst equals to 2175 Threat for 30 Rage = 72.5 TPR
	castBloodthirst()

	-- Dump extra rage
	if UnitMana("player") >= 60 then
		castWhirlwind()

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

	-- If we want aggro, we are tanking.
	-- In this case, we use Def stance.
	-- Otherwise, we want Zerk!
	if      WE_WANT_AGGRO == 1 then

		-- If target has less than 20% HP, we want to full execute him
		if Zorlen_TargetIsDieingEnemy() then
			if not isBattleStance() then
				castBattleStance()
			end
			castOverpower()
			castExecute()
		else
			if not isDefensiveStance() then
				castDefensiveStance()
			end
		end
	else
		if not isBerserkerStance() then
			castBerserkerStance()
		end
	end

	if     not WE_WANT_AGGRO == 1
	   and     (ZorlenConfig[ZORLEN_ZPN][ZORLEN_ASSIST]) then
		Zorlen_assist()
	end

	castAttack()
	
	if isDefensiveStance() then
		if not isDisarm() then
			castDisarm()
		end
	end

	if WE_WANT_AGGRO == 1 then
		-- Taunt will be cast if target is not targetting you
		castTaunt()

		-- Revenge : 71 TPR, we want to use it every time its possible as its only 5 Rage point.
		-- As we dont wear a shield, it will not happen so often.
		castRevenge()
	end

	-- Use Bloodthirst as main skill.
	-- 1500 damage Bloodthirst equals to 2175 Threat for 30 Rage = 72.5 TPR
	castBloodthirst()

	-- Dump extra rage
	if UnitMana("player") >= 60 then
		if not isDefensiveStance() then
			castWhirlwind()
		else
			
			-- 35 TPR
			castBattleShout()
			
			-- 17TPR - Lets hope we never use it
			castUnlimitedSunderArmor()
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

	-- If we get here, we have less than 30 rage, or Bloodthirst is in CD.

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


function kuri_arms()
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

	if     not WE_WANT_AGGRO == 1
	   and     (ZorlenConfig[ZORLEN_ZPN][ZORLEN_ASSIST]) then
		Zorlen_assist()
	end

	castAttack()

	-- Overpower is our best instant skill because of its high crit rate for very low rage cost.
	castOverpower()
	
	-- Use execute when mob is dieing
	castExecute()

	-- If target is not slowed, we harmstring it
	if not isHamstring() then
		castHamstring()
	end

	castMortalStrike()

	-- Dump extra rage
	if UnitMana("player") >= 60 then
		castCleave()
		castHeroicStrike()
	end

	-- Use rend as kind of last resort
	if not isRend() then
		castRend()
	end
end
