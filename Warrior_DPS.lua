local WARRIOR_DPS_ROTATION = {}

table.insert(WARRIOR_DPS_ROTATION,
{
  name      = "Execute",
  execution = function()
    castExecute()
  end,
  condition = function()
    -- Use execute if target's HP below 20%
    if    not Zorlen_TargetIsDieingEnemy()
       or     isDefensiveStance() then
      return false
    end
    return true
  end
})

table.insert(WARRIOR_DPS_ROTATION,
{
  name      = "Bloodthirst",
  execution = function()
    castBloodthirst()
  end,
  -- We want to use Bloodthirst ASAP, it is our main skill.
  -- Se we want to use it whenever it is ready.
  condition = function()
    if        UnitMana("player") < 30
       or not Zorlen_checkCooldownByName(LOCALIZATION_ZORLEN.Bloodthirst) then
      return false
    end
    return true
  end
})

table.insert(WARRIOR_DPS_ROTATION,
{
  name      = "WhirlWind",
  execution = function()
    castWhirlwind()
  end,
  -- We want to use WhirldWind when Bloodthirst is not ready.
  -- During execution phase, it is a waste to use it.
  condition = function()
    local SpellButton    = Zorlen_Button[LOCALIZATION_ZORLEN.Bloodthirst]
    local _, duration, _ = GetActionCooldown(SpellButton)

    if        UnitMana("player") < 25
       or not Zorlen_checkCooldownByName(LOCALIZATION_ZORLEN.Whirlwind) then
      return false
    end

    if    isDefensiveStance()
       or Zorlen_TargetIsDieingEnemy() then
      return false
    end

    if duration < 2 then
      return false
    end
    return true
  end
})

table.insert(WARRIOR_DPS_ROTATION,
{
  name      = "Slam",
  execution = function()
    castSlam()
  end,
  condition = function()
    -- It is only good to use slam with 2 handed weapons.
    if not isTwoHanded() then
      return false
    end
      
    -- If next swing is in more than 1.5s, using Slam IS a DPS boost.
    if st_timer < 1.5 then
      return false
    end
  end
})

table.insert(WARRIOR_DPS_ROTATION,
{
  name      = "Hamstring",
  execution = function()
    castHamstring()
  end,
  condition = function()
    -- We want to use Hamstring because:
    --   - This is an instant skill.
    --   - It can proc WF.
    --   - It can crit.
    -- This means :
    --   - We can trigger WF and Flurry.
    -- We should use it when:
    --   - We have WF buff (to get more chances to trigger it).
    --   - We dont have WF buff, but we also dont have Flurry buff.
    --   - Our other instant skills are on cooldown.
    if isDefensiveStance() then
      return false
    end
    
    if         UnitIsPlayer("target")
       and not isHamstring() then
      return true
    end

    if UnitMana("player") < 40 then
      if Zorlen_checkItemBuffByName(LOCALIZATION_ZORLEN.WindfuryWeapon) then
        return true
      end

      if not Zorlen_checkBuffByName("Flurry", "player", 0, 1) then
        return true
      end
    end
    return false
  end
})

table.insert(WARRIOR_DPS_ROTATION,
{
  name      = "Heroic Strike / Cleave",
  execution = function()
    if WE_WANT_CLEAVE == 1 then
      castCleave()
    else
      castHeroicStrike()
    end
  end,
  condition = function()
    -- Heroic Strike is good to dump excess rage, and will improve your DPS.
    -- It is a last resort technique when all your Insta skills are on CD.
    if UnitMana("player") <= 45 then
      return false
    end
    return true
  end
})

function kuri_warrior_dps()
	-- We do not touch CC targets
--	if Zorlen_isNoDamageCC("target") then
--		backOff()
--		return true
--	end

	-- If enemy is at correct distance, lets charge it
	if Zorlen_GiveMaxTargetRange(8, 25) then
		swapChargeAndIntercept()
	end

  -- If we take aggro on a raid, we switch to defensive stance to survive
--  if         UnitInRaid("player")
--	   and     Zorlen_isEnemyTargetingYou()
--     and not isDefensiveStance() then
--    castDefensiveStance()
--  else
    castBerserkerStance()
--	end

  for key, value in next,WARRIOR_DPS_ROTATION,nil do
    if value.condition() == true then
      value.execution()
    end
  end
end
