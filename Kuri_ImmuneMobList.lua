function Kuri_ImmuneMobList_Taunt()
	local name = UnitName("target")
	if name and not UnitIsPlayer("target") and not UnitIsPet("target") then
		if
		(name == LOCALIZATION_KURI_DPS.Hakkar)
		or
		(name == LOCALIZATION_KURI_DPS.Ossirian)
		then
			Zorlen_debug("Target is Immune to taunt: "..name);
			return true
		end
	end
	return false
end
