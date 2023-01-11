local WARRIOR_BUFF_ROTATION = {}

table.insert(WARRIOR_BUFF_ROTATION,
{
  name      = "Berserker Rage",
  execution = function()
    forceBerserkerRage()
  end,
  -- If we are feared, we want to neutralize it
  condition = function()
    if not Zorlen_isCrowedControlled("player") then
      return false
    end
    return true
  end
})

table.insert(WARRIOR_BUFF_ROTATION,
{
  name      = "Battle Shout",
  execution = function()
    castBattleShout()
  end,
  -- We need Battle Shout to always be up
  condition = function()
    if isBattleShoutActive() then
      return false
    end
    return true
  end
})

table.insert(WARRIOR_BUFF_ROTATION,
{
  name      = "Blood Rage",
  execution = function()
    castBloodrage()
  end,
  -- We want to maximize our rage to be able to cast instant skills
  condition = function()
    if        UnitMana("player") > 30
       or     Zorlen_notInCombat()
       or not Zorlen_checkCooldownByName(LOCALIZATION_ZORLEN.Bloodrage)
    then
      return false
    end
    return true
  end
})

-- Need to find a way to get the cooldown timer of item
table.insert(WARRIOR_BUFF_ROTATION,
{
  name      = "Earthstrike",
  execution = function()
    Zorlen_useEquippedItemByName("Earthstrike")
  end,
  -- If Earthstrike is equiped, we use it when it is UP.
  condition = function()
    if   not Zorlen_isItemByNameEquipped("Earthstrike")
      or     Zorlen_notInCombat()
    then
      return false
    end
    return true
  end
})

table.insert(WARRIOR_BUFF_ROTATION,
{
  name      = "Blood Fury",
  execution = function()
    Zorlen_castSpellByName("Blood Fury")
  end,
  -- Use blood fury when possible
  condition = function()
    local percent = (UnitHealth("player") / UnitHealthMax("player")) * 100

    if    not Zorlen_inCombat()
       or     percent                  < 80
       or     WE_WANT_AGGRO           ==  1
       or not Zorlen_isCurrentRaceOrc ==  1
       or not Zorlen_checkCooldownByName(LOCALIZATION_ZORLEN.BloodFury)
    then
      return false
    end
    return true
  end
})

function kuri_warrior_buff()
  for key, value in next,WARRIOR_BUFF_ROTATION,nil do
    if value.condition() == true then
      value.execution()
    end
  end
end
