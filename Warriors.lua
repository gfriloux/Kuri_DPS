WE_WANT_AGGRO  = 0
WE_WANT_CLEAVE = 0

function kuri_warrior_rotation()
  if WE_WANT_AGGRO == 0 then
    kuri_warrior_dps()
  end
end
