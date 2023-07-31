local f = CreateFrame("Frame")

f:RegisterEvent("PARTY_LOOT_METHOD_CHANGED")
f:SetScript("OnEvent", function()
  if IsPartyLeader() then
    -- Get party members
    local partyMembers = {{"player", 0}}
    if UnitExists("pet") then
      table.insert(partyMembers, {"pet", 0})
    end
    for n = 1, GetNumPartyMembers() do
      table.insert(partyMembers, {"party"..n, 0})
      if UnitExists("partypet"..n) then
        table.insert(partyMembers, {"partypet"..n, 0})
      end
    end
    -- Get available markers and used markers
    local raidTarget = {0, 0, 0, 0, 0, 0, 0, 0}
    for k, v in pairs(partyMembers) do
      local i = GetRaidTargetIndex(v[1])
      if i then
        v[2] = i
      end
    end
    -- Mark function
    function Mark(k, v, i)
      if raidTarget[i] == 0 then
        if (v[2] == 0) then
          v[2] = i
        else
          i = v[2]
        end
        SetRaidTarget(v[1], i)
        raidTarget[i] = 1
      end
    end
    -- Priority marking by class
    for k, v in pairs(partyMembers) do
      local _, c = UnitClass(v[1])
      if string.find(v[1], "pet") then
        Mark(k, v, 4)
      elseif c == "MAGE" or c == "ROGUE" then
        Mark(k, v, 1)
      elseif c == "WARRIOR" then
        Mark(k, v, 2)
      elseif c == "HUNTER" or c == "WARLOCK" then
        Mark(k, v, 3)
      elseif c == "PRIEST" or c == "DRUID" then
        Mark(k, v, 5)
      else
        Mark(k, v, 6)
      end
    end
    -- Triangle for pet only
    raidTarget[4] = 1
    -- Using the remaining markers
    for k, v in pairs(partyMembers) do
      if v[2] == 0 then
        for i in pairs(raidTarget) do
          if raidTarget[i] == 0 then
            SetRaidTarget(v[1], i)
            raidTarget[i] = 1
            break
          end
        end
      end
    end
  end
end)
