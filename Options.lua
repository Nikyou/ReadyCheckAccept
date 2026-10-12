local L = LibStub("AceLocale-3.0"):GetLocale("ReadyCheckAccept")

ReadyCheckAccept.defaults = {
    profile = {
        enabled = true,
        afk = true,
        idleMessage = true,
        delayMin = 0.5,
        delayMax = 1,
        party = {enabled = true, inInstance = true, outOfInstance = true, dead = false, idleCheck = false, idleTime = 60},
        raid = {enabled = true, inInstance = true, outOfInstance = true, dead = false, idleCheck = false, idleTime = 60},
    },
}

local function IsIdleCheckDisabled(info) return not ReadyCheckAccept.db.profile[info[#info - 1]].idleCheck end
local function IsIdleMessageDisabled()
    local profile = ReadyCheckAccept.db.profile
    return not (profile.party.idleCheck or profile.raid.idleCheck)
end

local function GroupOptions(order, name, enableDesc)
    return {
        type = "group",
        inline = true,
        order = order,
        name = name,
        get = "GetValueWithParent",
        set = "SetValueWithParent",
        args = {
            enabled = {type = "toggle", order = 1, name = L["Enabled"], desc = enableDesc},
            inInstance = {type = "toggle", order = 2, name = L["In Instance"], desc = L["Accept when in instance"]},
            outOfInstance = {type = "toggle", order = 3, name = L["Out of Instance"], desc = L["Accept when out of instance"]},
            dead = {type = "toggle", order = 4, name = L["Dead / Ghost"], desc = L["Accept when dead / ghost"]},
            idleCheck = {
                type = "toggle",
                order = 5,
                name = L["Disable when idle"],
                desc = L["Will not accept ready check if you have not moved for the set time. The timer restarts when you leave combat, a boss encounter ends or you join a group"],
            },
            idleTime = {
                type = "range",
                order = 6,
                name = L["Idle Time"],
                desc = L["Seconds without movement after which ready checks are not accepted"],
                min = 1,
                softMin = 15,
                max = 3600,
                softMax = 300,
                step = 1,
                bigStep = 5,
                disabled = IsIdleCheckDisabled,
            },
        },
    }
end

ReadyCheckAccept.options = {
    type = "group",
    name = "Ready Check Accept",
    handler = ReadyCheckAccept,
    childGroups = "tree",
    args = {
        enabled = {
            type = "toggle",
            order = 1,
            width = 1.25,
            name = L["Enabled"],
            desc = L["Type \"/rca on\" or \"/rca off\" to change this setting without opening the settings menu"],
            get = "GetValue",
            set = "SetValue",
        },
        afk = {
            type = "toggle",
            order = 2,
            width = 1.25,
            name = L["Disable when AFK"],
            desc = L["Will not accept ready check when you are /afk"],
            get = "GetValue",
            set = "SetValue",
        },
        idleMessage = {
            type = "toggle",
            order = 2.1,
            width = 1.25,
            name = L["Idle Message"],
            desc = L["Print a chat message when a ready check is not accepted because you are idle"],
            disabled = IsIdleMessageDisabled,
            get = "GetValue",
            set = "SetValue",
        },
        breakLine1 = {type = "header", order = 3, name = ""},
        delayMin = {
            type = "range",
            order = 3.1,
            name = L["Minimal Delay"],
            desc = L["Minimal delay in seconds before accept"],
            min = 0.1,
            softMin = 0.5,
            max = 25,
            softMax = 5,
            step = 0.1,
            bigStep = 0.5,
            get = "GetValue",
            set = function(info, value)
                local profile = ReadyCheckAccept.db.profile
                profile.delayMin = value
                profile.delayMax = math.max(profile.delayMax, value)
            end,
        },
        delayMax = {
            type = "range",
            order = 3.2,
            name = L["Maximal Delay"],
            desc = L["Maximal delay in seconds before accept, must be greater or equal to minimal delay"],
            min = 0.1,
            softMin = 0.5,
            max = 25,
            softMax = 10,
            step = 0.1,
            bigStep = 0.5,
            get = "GetValue",
            set = function(info, value)
                local profile = ReadyCheckAccept.db.profile
                profile.delayMax = math.max(value, profile.delayMin)
            end,
        },

        party = GroupOptions(4, L["Party Settings"], L["Enable in party"]),
        raid = GroupOptions(5, L["Raid Settings"], L["Enable in raid"]),
    },
}

function ReadyCheckAccept:GetValue(info) return self.db.profile[info[#info]] end
function ReadyCheckAccept:SetValue(info, value)
    self.db.profile[info[#info]] = value
    self:UpdateIdleTracking()
end

function ReadyCheckAccept:GetValueWithParent(info) return self.db.profile[info[#info - 1]][info[#info]] end
function ReadyCheckAccept:SetValueWithParent(info, value)
    self.db.profile[info[#info - 1]][info[#info]] = value
    self:UpdateIdleTracking()
end
