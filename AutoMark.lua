local f = CreateFrame("Frame")
local s = string.gsub(JOINED_PARTY, "%%s", "")

function Mark(unit)
  local _, n = UnitClass(unit)
  if n == "WARRIOR" or n == "PALADIN" then
    SetRaidTarget(unit, 2)
  elseif n == "HUNTER" or n == "ROGUE" then
    SetRaidTarget(unit, 3)
  elseif n == "PRIEST" or n == "DRUID" then
    SetRaidTarget(unit, 5)
  elseif n == "MAGE" or n == "WARLOCK" then
    SetRaidTarget(unit, 1)
  else
    SetRaidTarget(unit, 6)
  end
end

f:RegisterEvent("CHAT_MSG_SYSTEM")
f:SetScript("OnEvent", function()
  local i = string.find(arg1, s)
  if i and IsPartyLeader() then
    Mark("player")
    for n = 1, GetNumPartyMembers() do
      Mark("party"..n)
    end
  end
end)
