local WARRIOR_TANK_ROTATION = {}

table.insert(WARRIOR_TANK_ROTATION,
{
  name      = "Taunt",
  execution = function()
    castTaunt()
  end,
  condition = function()
    if        WE_WANT_TAUNT == 0
       or not Zorlen_checkCooldownByName(LOCALIZATION_ZORLEN.Taunt) then
      return false
    end
    return true
  end
})

table.insert(WARRIOR_TANK_ROTATION,
{
  name      = "Shield Block",
  execution = function()
	  -- Will only be called if :
	  --   - You are targetted
	  --   - You are in defensive stance
	  --   - You have a shield equipped
    castShieldBlock()
  end,
  condition = function()
    if        UnitMana("player") < 10
       or not Zorlen_checkCooldownByName(LOCALIZATION_ZORLEN.ShieldBlock) then
      return false
    end
    return true
  end
})

table.insert(WARRIOR_TANK_ROTATION,
{
  name      = "Regenge",
  execution = function()
    castRevenge()
  end,
  -- Revenge : 71 TPR, we want to use it every time its possible as its only 5 Rage point.
  condition = function()
    if        UnitMana("player") < 5
       or not Zorlen_checkCooldownByName(LOCALIZATION_ZORLEN.Revenge) then
      return false
    end
    return true
  end
})

table.insert(WARRIOR_TANK_ROTATION,
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
    if UnitMana("player") <= 45
      return false
    end
    return true
  end
})

function kuri_warrior_tank()
	-- If enemy is at correct distance, lets charge it
	if Zorlen_GiveMaxTargetRange(8, 25) then
		swapChargeAndIntercept()
	end

  -- If we take aggro on a raid, we switch to defensive stance to survive
  if not isDefensiveStance() then
    castDefensiveStance()
	end

  for key, value in next,WARRIOR_TANK_ROTATION,nil do
    if value.condition() == true then
      value.execution()
    end
  end
end
