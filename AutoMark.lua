local f = CreateFrame("Frame")

f:RegisterEvent("PARTY_LOOT_METHOD_CHANGED")
f:SetScript("OnEvent", function()
  if IsPartyLeader() then
    -- Get party members
    local partyMembers = {"player"}
    for n = 1, GetNumPartyMembers() do
      table.insert(partyMembers, "party"..n)
    end
    -- Get available markers
    local raidTarget = {1, 1, 1, 1, 1, 1, 1, 1}
    -- Mark function
    function Mark(k, v, i)
      if raidTarget[i] == 1 then
        if i == 4 then
          v = string.gsub(string.gsub(v, "player", "pet"), "party", "partypet")
        else
          partyMembers[k] = nil
        end
        SetRaidTarget(v, i)
        raidTarget[i] = 0
      end
    end
    -- Priority marking by class
    for k, v in pairs(partyMembers) do
      local _, c = UnitClass(v)
      if c == "MAGE" or c == "ROGUE" then
        Mark(k, v, 1)
      elseif c == "WARRIOR" then
        Mark(k, v, 2)
      elseif c == "HUNTER" or c == "WARLOCK" then
        Mark(k, v, 3)
        Mark(k, v, 4)
      elseif c == "PRIEST" or c == "DRUID" then
        Mark(k, v, 5)
      else
        Mark(k, v, 6)
      end
    end
    -- Triangle for pet only
    raidTarget[4] = 0
    -- Using the remaining markers
    for k, v in pairs(partyMembers) do
      if v then
        for i in pairs(raidTarget) do
          if raidTarget[i] == 1 then
            SetRaidTarget(v, i)
            raidTarget[i] = 0
            break
          end
        end
      end
    end
  end
end)
