function kuri_OnLoad()
  KuriFrame:RegisterEvent("CHAT_MSG_COMBAT_SELF_MISSES")
  KuriFrame:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE")
  KuriFrame:RegisterEvent("SPELLCAST_STOP")
end

function kuri_OnEvent(event, arg1, arg2, arg3)
	if (event == "CHAT_MSG_COMBAT_SELF_MISSES") then
    kuri_warrior_OnEvent_CHAT_MSG_COMBAT_SELF_MISSES(arg1, arg2, arg3)
  elseif (event == "CHAT_MSG_SPELL_SELF_DAMAGE") then
    kuri_warrior_OnEvent_CHAT_MSG_SPELL_SELF_DAMAGE(arg1, arg2, arg3)
  elseif (event == "SPELLCAST_STOP") then
    kuri_warrior_OnEvent_SPELLCAST_STOP(arg1, arg2, arg3)
  end
end

function kuri_rotation()
  if Zorlen_UnitClass("player") == "Warrior" then
    kuri_warrior_rotation()
  end
end
