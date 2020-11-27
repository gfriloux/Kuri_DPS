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

	-- If Primal Blessing procs, we want to burst our PA
	if Zorlen_checkBuffByName("Primal Blessing", "player") then

		-- If we have Diamond Flask, use it
		if not Zorlen_checkBuffByName("Diamond Flask", "player") then
			Zorlen_useTrinketByName("Diamond Flask")
		end

		-- If we have low rage, we can spend Migthy Rage Potion
		if not Zorlen_checkBuffByName("Migthy Rage", "player") then
			if UnitMana("player") <= 50 then
				Zorlen_useItemByName("Mighty Rage Potion")
			end
		end
	end
end

function kuri_fury_dual_strike()
	-- We do not touch CC targets
	if Zorlen_isNoDamageCC("target") then
		-- print('We dont touch CC targets')
		return true
	end

	kuri_fury_buff()
	
	-- If enemy is at correct distance, lets charge it
	if Zorlen_GiveMaxTargetRange(8, 25) then
		swapChargeAndIntercept()
	end

	-- We want max sunder armor for maximum DPS ASAP
	if UnitInRaid("player") then
		castSunderArmor()
	end

	-- Dump extra rage
	if UnitMana("player") >= 60 then
		-- If we have Flurry UP, we can use next attack skill for more damage
		if Zorlen_checkBuffByName("Flurry", "player") then
			castHeroicStrike()
		-- Otherwise, we want an instant skill to proc Flurry
		else
			castHamstring()
		end
	end

	-- Use Bloodthirst as main skill
	castBloodthirst()

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

