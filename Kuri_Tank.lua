function kuri_tank_off()
	local percent = (UnitHealth("player") / UnitHealthMax("player")) * 100
	
	kuri_buff_tank()
	kuri_fury_buff()

	-- If we are under 50% HP, it is time to cast our racial
	-- if not on CD
	if percent <= 50 then
		Zorlen_castSpellByName(Berserking)
	end
	
	-- We need 5 stacks of SunderArmor()
	castSunderArmor()
	
	-- Dump extra rage on heroic strike to create threat
	if UnitMana("player") >= 60 then
		castHeroicStrike()
	end
	
	-- Use Bloodthirst as main skill
	castBloodthirst()
end


function kuri_tank()
	local percent = (UnitHealth("player") / UnitHealthMax("player")) * 100
	
	kuri_buff_tank()
	kuri_fury_buff()
	
	-- Make sure we are in defensive stance
	if not isDefensiveStance() then
		castDefensiveStance()
	end

	-- If we are under 50% HP, it is time to cast our racial
	-- if not on CD
	if percent <= 50 then
		Zorlen_castSpellByName(Berserking)
	end

	-- Taunt will be cast if target is not targetting you
	castTaunt()

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
	
	-- Use Bloodthirst as main skill
	castBloodthirst()
	
	-- If we get here, we lack rage for Bloodthirst or it is on CD
	-- Every main tanking skills were used
	
	-- Use execute if target's HP below 20%
	if Zorlen_TargetIsDieingEnemy() then
		castExecute()
	end
end