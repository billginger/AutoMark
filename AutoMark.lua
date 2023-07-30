local f = CreateFrame("Frame")

f:RegisterEvent("PARTY_LOOT_METHOD_CHANGED")
f:SetScript("OnEvent", function()
  if IsPartyLeader() then
    local t = {"player", "pet"}
    for n = 1, GetNumPartyMembers() do
      table.insert(t, "party"..n)
      table.insert(t, "partypet"..n)
    end
    for k, v in pairs(t) do
      local _, c = UnitClass(v)
      if c == "WARRIOR" then
        SetRaidTarget(v, 2)
      elseif c == "HUNTER" or c == "WARLOCK" then
        SetRaidTarget(v, 3)
      elseif c == "PRIEST" or c == "DRUID" then
        SetRaidTarget(v, 5)
      elseif c == "MAGE" or c == "ROGUE" then
        SetRaidTarget(v, 1)
      else
        SetRaidTarget(v, 6)
      end
    end
  end
end)
