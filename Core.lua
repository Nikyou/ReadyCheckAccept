ReadyCheckAccept = LibStub("AceAddon-3.0"):NewAddon("ReadyCheckAccept", "AceEvent-3.0", "AceConsole-3.0")
local AC = LibStub("AceConfig-3.0")
local ACD = LibStub("AceConfigDialog-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("ReadyCheckAccept")

function ReadyCheckAccept:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("ReadyCheckAcceptDB", self.defaults, true)
    AC:RegisterOptionsTable("ReadyCheckAccept_Options", self.options)

    self.optionsFrame = ACD:AddToBlizOptions("ReadyCheckAccept_Options", "Ready Check Accept")

    self:RegisterChatCommand("rca", "SlashCommand")
end

function ReadyCheckAccept:OpenSettings(inCombat) if not inCombat then Settings.OpenToCategory(self.optionsFrame.name) end end

function ReadyCheckAccept:SlashCommand(input, editbox)
    if input == "on" then
        self.db.profile.enabled = true
        print(L["Ready Check Accept is |cFF00FF00turned on|r"])
    elseif input == "off" then
        self.db.profile.enabled = false
        print(L["Ready Check Accept is |cFFFF0000turned off|r"])
    else
        self:OpenSettings(UnitAffectingCombat("player"))
    end
end

function ReadyCheckAccept:OnEnable() self:RegisterEvent("READY_CHECK") end

function ReadyCheckAccept:READY_CHECK(event, initiatorName, readyCheckTimeLeft)
    if not self.db.profile.enabled then return end

    if self.db.profile.afk and UnitIsAFK("player") then return end

    if IsInRaid() then
        if not self.db.profile.raid.enabled then return end
        if not self.db.profile.raid.dead and UnitIsDeadOrGhost("player") then return end
        if IsInInstance() then
            if not self.db.profile.raid.inInstance then return end
        else
            if not self.db.profile.raid.outOfInstance then return end
        end
    elseif IsInGroup() then
        if not self.db.profile.party.enabled then return end
        if not self.db.profile.party.dead and UnitIsDeadOrGhost("player") then return end
        if IsInInstance() then
            if not self.db.profile.party.inInstance then return end
        else
            if not self.db.profile.party.outOfInstance then return end
        end
    end

    local min = self.db.profile.delayMin * 10
    local max = self.db.profile.delayMax * 10
    local delay = math.random(min, max) / 10
    print(min/ 10, max/ 10, delay)
    C_Timer.After(delay, function()
        ConfirmReadyCheck(1)
        if ReadyCheckFrame and ReadyCheckFrame:IsShown() then ReadyCheckFrame:Hide() end
    end)

end
