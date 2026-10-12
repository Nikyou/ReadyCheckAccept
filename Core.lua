ReadyCheckAccept = LibStub("AceAddon-3.0"):NewAddon("ReadyCheckAccept", "AceEvent-3.0", "AceConsole-3.0")
local AC = LibStub("AceConfig-3.0")
local ACD = LibStub("AceConfigDialog-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("ReadyCheckAccept")

-- Only listened to when idle check is on
local IDLE_WATCH_EVENTS = {
    PLAYER_REGEN_DISABLED = "UpdateIdleTracking",
    PLAYER_REGEN_ENABLED = "UpdateIdleTracking",
    GROUP_ROSTER_UPDATE = "UpdateIdleTracking",
    ENCOUNTER_END = "MarkActive", -- so dead players get the timer reset after the boss
}

function ReadyCheckAccept:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("ReadyCheckAcceptDB", self.defaults, true)
    AC:RegisterOptionsTable("ReadyCheckAccept_Options", self.options)

    self.optionsFrame = ACD:AddToBlizOptions("ReadyCheckAccept_Options", "Ready Check Accept")

    self:RegisterChatCommand("rca", "SlashCommand")
end

function ReadyCheckAccept:OpenSettings(inCombat) if not inCombat then Settings.OpenToCategory(self.optionsFrame.name) end end

function ReadyCheckAccept:SlashCommand(input)
    if input == "on" then
        self.db.profile.enabled = true
        print(L["Ready Check Accept is |cFF00FF00turned on|r"])
    elseif input == "off" then
        self.db.profile.enabled = false
        print(L["Ready Check Accept is |cFFFF0000turned off|r"])
    else
        self:OpenSettings(UnitAffectingCombat("player"))
    end
    self:UpdateIdleTracking()
end

function ReadyCheckAccept:OnEnable()
    self.lastActive = GetTime() -- login or /reload counts as being active
    self:RegisterEvent("READY_CHECK")
    self:UpdateIdleTracking()
end

function ReadyCheckAccept:MarkActive() self.lastActive = GetTime() end

-- Track movement only in a group and out of combat, so nothing runs while solo or fighting.
-- Whenever tracking starts again (combat ends, group joined, option on), the timer resets.
function ReadyCheckAccept:UpdateIdleTracking(event)
    local p = self.db.profile
    local watching = p.enabled and (p.party.idleCheck or p.raid.idleCheck)

    if watching ~= self.watching then
        self.watching = watching
        for watchEvent, handler in pairs(IDLE_WATCH_EVENTS) do
            if watching then
                self:RegisterEvent(watchEvent, handler)
            else
                self:UnregisterEvent(watchEvent)
            end
        end
    end

    -- combat flag might not be set yet when PLAYER_REGEN_DISABLED fires
    local inCombat = event == "PLAYER_REGEN_DISABLED" or UnitAffectingCombat("player")
    local tracking = watching and IsInGroup() and not inCombat

    if tracking ~= self.tracking then
        self.tracking = tracking
        if tracking then
            self:MarkActive()
            -- only need the stop, if still moving IsPlayerMoving() handles it
            self:RegisterEvent("PLAYER_STOPPED_MOVING", "MarkActive")
            self:RegisterEvent("PLAYER_STOPPED_TURNING", "MarkActive")
        else
            self:UnregisterEvent("PLAYER_STOPPED_MOVING")
            self:UnregisterEvent("PLAYER_STOPPED_TURNING")
        end
    end
end

function ReadyCheckAccept:GetIdleTime()
    if UnitAffectingCombat("player") or IsPlayerMoving() then return 0 end
    return GetTime() - self.lastActive
end

local function ConfirmReadyCheck()
    -- check could be over or already answered by now
    if GetReadyCheckStatus("player") ~= "waiting" then return end
    C_PartyInfo.ConfirmReadyCheck(true)
    if not UnitAffectingCombat("player") and ReadyCheckFrame and ReadyCheckFrame:IsShown() then ReadyCheckFrame:Hide() end
end

function ReadyCheckAccept:READY_CHECK()
    local p = self.db.profile
    if not p.enabled then return end

    if p.afk and UnitIsAFK("player") then return end

    local group = IsInRaid() and p.raid or p.party
    if not group.enabled then return end
    if not group.dead and UnitIsDeadOrGhost("player") then return end
    if not group[IsInInstance() and "inInstance" or "outOfInstance"] then return end

    if group.idleCheck then
        local idleTime = self:GetIdleTime()
        if idleTime >= group.idleTime then
            if p.idleMessage then
                print(L["Ready check was not accepted: you have not moved for %d seconds"]:format(idleTime))
            end
            return
        end
    end

    local delay = p.delayMin + math.random() * math.max(p.delayMax - p.delayMin, 0)
    C_Timer.After(delay, ConfirmReadyCheck)
end
