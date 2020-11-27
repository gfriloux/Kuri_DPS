
LOCALIZATION_KURI_DPS = {}

local LOCALE = GetLocale()

if LOCALE == "frFR" then
	LOCALIZATION_KURI_DPS["PrimalBlessing"] = "Bénédiction primordiale"
	LOCALIZATION_KURI_DPS["DiamondFlaskEffect"] = "Flasque de diamant"
	LOCALIZATION_KURI_DPS["DiamondFlask"] = "Flacon de diamant"
	LOCALIZATION_KURI_DPS["MightyRage"] = "Rage puissante"
	LOCALIZATION_KURI_DPS["MightyRagePotion"] = "Potion de rage puissante"
	LOCALIZATION_KURI_DPS["Flurry"] = "Rafale"
	LOCALIZATION_KURI_DPS["ElixirGiants"] = "Elixir des géants"
	LOCALIZATION_KURI_DPS["ElixirMongoose"] = "Elixir de la Mangouste"
	LOCALIZATION_KURI_DPS["JujuPower"] = "Pouvoir de Juju"
	LOCALIZATION_KURI_DPS["CloudkeeperLegplates"] = "Jambières du Gardien des nuages"
	LOCALIZATION_KURI_DPS["HeavenBlessing"] = "Bénédiction céleste"
	LOCALIZATION_KURI_DPS["Overpower"] = "Fulgurance"
else
	LOCALIZATION_KURI_DPS["PrimalBlessing"] = "Primal Blessing"
	LOCALIZATION_KURI_DPS["DiamondFlaskEffect"] = "Diamond Flask"
	LOCALIZATION_KURI_DPS["DiamondFlask"] = "Diamond Flask"
	LOCALIZATION_KURI_DPS["MightyRage"] = "Mighty Rage"
	LOCALIZATION_KURI_DPS["MightyRagePotion"] = "Mighty Rage Potion"
	LOCALIZATION_KURI_DPS["Flurry"] = "Flurry"
	LOCALIZATION_KURI_DPS["ElixirGiants"] = "Elixir of Giants"
	LOCALIZATION_KURI_DPS["ElixirMongoose"] = "Elixir of the Mongoose"
	LOCALIZATION_KURI_DPS["JujuPower"] = "Juju Power"
	LOCALIZATION_KURI_DPS["CloudkeeperLegplates"] = "Cloudkeeper Legplates"
	LOCALIZATION_KURI_DPS["HeavenBlessing"] = "Heaven\'s Blessing"
	LOCALIZATION_KURI_DPS["Overpower"] = "Overpower"
end


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

	-- If we are in a raid, we use consumables.
	-- Let's manage the most basic ones.
	if UnitInRaid("player") then
		if not Zorlen_checkBuffByName(LOCALIZATION_KURI_DPS.ElixirGiants, "player") then
			Zorlen_useItemByName(LOCALIZATION_KURI_DPS.ElixirGiants)
		end
		
		if not Zorlen_checkBuffByName(LOCALIZATION_KURI_DPS.ElixirMongoose, "player") then
			Zorlen_useItemByName(LOCALIZATION_KURI_DPS.ElixirMongoose)
		end

		if not Zorlen_checkBuffByName(LOCALIZATION_KURI_DPS.JujuPower, "player") then
			Zorlen_useItemByName(LOCALIZATION_KURI_DPS.JujuPower)
		end
	end

	-- If Primal Blessing procs, we want to burst our PA
	if Zorlen_checkBuffByName(LOCALIZATION_KURI_DPS.PrimalBlessing, "player") then

		-- If we have Diamond Flask, use it
		if not Zorlen_checkBuffByName(LOCALIZATION_KURI_DPS.DiamondFlaskEffect, "player") then
			Zorlen_useTrinketByName(LOCALIZATION_KURI_DPS.DiamondFlask)
		end
		
		-- If we have Cloudkeeper Legplates, use it
		if not Zorlen_checkBuffByName(LOCALIZATION_KURI_DPS.HeavenBlessing, "player") then
			Zorlen_useItemByName(LOCALIZATION_KURI_DPS.CloudkeeperLegplates)
		end

		-- If we have low rage, we can spend Migthy Rage Potion
		-- Limited to raids
		if         UnitMana("player") <= 50
		   and not Zorlen_checkBuffByName(LOCALIZATION_KURI_DPS.MightyRage, "player")
		   and     UnitInRaid("player")
		then
			Zorlen_useItemByName(LOCALIZATION_KURI_DPS.MightRagePotion)
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
	if UnitInRaid("player") then
		castSunderArmor()
	end

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
	   and Zorlen_isActionInRangeBySpellName(LOCALIZATION_KURI_DPS.Overpower)
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

