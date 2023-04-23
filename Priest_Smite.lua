local PRIEST_SMITE_ROTATION = {}

WE_WANT_DOTS  = 0

function kuri_priest_dots_switch()
	if WE_WANT_DOTS == 0 then
		Zorlen_debug("We will USE DOTS!", 1)
		WE_WANT_DOTS = 1
	else
		Zorlen_debug("We will NOT USE DOTS!", 1)
		WE_WANT_DOTS = 0
	end
end

table.insert(PRIEST_SMITE_ROTATION,
{
  name      = "Holy Fire",
  execution = function()
    castHolyFire()
  end,
  condition = function()
    if WE_WANT_DOTS == 0 then
      return false
    end


    if         isHolyFire()
       and not Zorlen_TargetIsDieingEnemy()
    then
      return false
    end
    return true
  end
})

table.insert(PRIEST_SMITE_ROTATION,
{
  name      = "Mind Blast",
  execution = function()
    castMindBlast()
  end,
  condition = function()
    return true
  end
})

table.insert(PRIEST_SMITE_ROTATION,
{
  name      = "Shadow Word : Pain",
  execution = function()
    castShadowWordPain()
  end,
  condition = function()
    if WE_WANT_DOTS == 0 then
      return false
    end
    if isShadowWordPain() then
      return false
    end
    return true
  end
})

table.insert(PRIEST_SMITE_ROTATION,
{
  name      = "Smite",
  execution = function()
    castSmite()
  end,
  condition = function()
    return true
  end
})


function kuri_priest_smite()
  for key, value in next,PRIEST_SMITE_ROTATION,nil do
    if value.condition() == true then
      value.execution()
    end
  end
end
