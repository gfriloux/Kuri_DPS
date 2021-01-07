function kuri_debuff_attack()
	-- We debuff Power Attack if target is at distance
	-- And not already affected
	if not isDemoralized("target") then
		castDemoralizingShout()
	end

	-- We debuff Attack Speed
	if not isThunderClap("target") then
		castThunderClap()
	end

	-- We want max sunder armor for maximum DPS ASAP
	if UnitInRaid("player") then
		castSunderArmor()
	end
end