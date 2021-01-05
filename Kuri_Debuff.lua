function kuri_debuff_attack()
	-- We debuff Power Attack if target is at distance
	-- And not already affected
	if not Zorlen_checkDebuffByName(LOCALIZATION_KURI_DPS.DemoralizingShout) then
		castDemoralizingShout()
	end

	-- We debuff Attack Speed
	if not Zorlen_checkDebuffByName(LOCALIZATION_KURI_DPS.ThunderClap) then
		castThunderClap()
	end
end