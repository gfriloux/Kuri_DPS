local WARRIOR_DEBUFF_ROTATION = {}
local DemoTime = 0

table.insert(WARRIOR_DEBUFF_ROTATION,
{
  name      = "Sunder Armor",
  execution = function()
    castSunderArmor()
  end,
  
  -- Using Sunder Armor helps to maximize overall DPS.
  -- It also helps the tank to spend his rage on more efficient threat/mitigation skills.
  condition = function()
    if    UnitMana("player") < 15
       or isSunderFull("target") then
      return false
    end
    return true
  end
})

table.insert(WARRIOR_DEBUFF_ROTATION,
{
  name      = "Hamstring",
  execution = function()
    castHamstring()
  end,
  
  -- We want to use Hamstring on players (PVP)
  condition = function()
    if     UnitIsPlayer("target")
       and not isHamstring()
    then
      return true
    end
    return false
  end
})

table.insert(WARRIOR_DEBUFF_ROTATION,
{
  name      = "Demoralizing Shout",
  execution = function()
    DemoTime = GetTime();
    castDemoralizingShout()
  end,
  
  condition = function()
    local now = GetTime();
    if    not UnitInRaid("player")
       or     isDemoralized("target")
       or     now - DemoTime < 20
    then
      return false
    end

    return true
  end
})

table.insert(WARRIOR_DEBUFF_ROTATION,
{
  name      = "Rend",
  execution = function()
    castRend()
  end,
  
  -- We want to use Rend on players (PVP) (interrupts, anti camouflage)
  condition = function()
    if     UnitIsPlayer("target")
       and not isRend()
    then
      return true
    end
    return false
  end
})

table.insert(WARRIOR_DEBUFF_ROTATION,
{
  name      = "Disarm",
  execution = function()
    castDisarm()
  end,
  condition = function()
    if        isDisarm() 
       or not isDefensiveStance()
    then
      return false
    end

    return true
  end
})

function kuri_warrior_debuff()
  for key, value in next,WARRIOR_DEBUFF_ROTATION,nil do
    if value.condition() == true then
      value.execution()
    end
  end
end
