function kuri_tank_off()
	local percent = (UnitHealth("player") / UnitHealthMax("player")) * 100
	
	kuri_buff_tank()
	kuri_fury_buff()

	-- Make sure we are in defensive stance
	if not isDefensiveStance() then
		castDefensiveStance()
	end

	-- We need 5 stacks of SunderArmor()
	castSunderArmor()
	
	-- Dump extra rage on heroic strike to create threat
	if UnitMana("player") >= 60 then
		castHeroicStrike()
	end
	
	-- If we get here, every main threat skills were used
	
	-- Use execute if target's HP below 20%
	if Zorlen_TargetIsDieingEnemy() then
		castExecute()
	else
		castBloodthirst()
	end
end

function kuri_tank_main()
	local percent = (UnitHealth("player") / UnitHealthMax("player")) * 100

	kuri_buff_tank()
	kuri_fury_buff()
	kuri_debuff_attack()

	-- If enemy is at correct distance, lets charge it
	if Zorlen_GiveMaxTargetRange(8, 25) then
		swapChargeAndIntercept()
	end

	-- Make sure we are in defensive stance
	if not isDefensiveStance() then
		castDefensiveStance()
	end

	castAttack()

	-- Taunt will be cast if target is not targetting you
	if WE_WANT_AGGRO == 1 then
		castTaunt()
	end

	-- We want shield block to be up as much as possible
	castShieldBlock()
	
	-- We need 5 stacks of SunderArmor()
	castSunderArmor()
	
	-- Use Revenge when available
	castRevenge()

	-- Dump extra rage on heroic strike to create threat
	if UnitMana("player") >= 60 then
		castHeroicStrike()
	end
	
	-- If we get here, every main threat skills were used
	
	-- Use execute if target's HP below 20%
	if Zorlen_TargetIsDieingEnemy() then
		castExecute()
	else
		castBloodthirst()
	end
end