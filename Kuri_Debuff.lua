local DemoTime    = 0;
local ThunderTime = 0;

function kuri_debuff_attack()
	local now = GetTime();

	if UnitInRaid("player") then
		-- We debuff Power Attack if target is at distance
		-- And not already affected
		if not isDemoralized("target") then
			if now - DemoTime > 20 then
				DemoTime = now
				castDemoralizingShout()
			end
		end

		-- We debuff Attack Speed
		if not isThunderClap("target") then
			if now - ThunderTime > 20 then
				ThunderTime = now
				castThunderClap()
			end
		end

		-- We want max sunder armor for maximum DPS ASAP
		castSunderArmor()
	end
end