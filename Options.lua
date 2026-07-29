local L = LibStub("AceLocale-3.0"):GetLocale("ReadyCheckAccept")

ReadyCheckAccept.defaults = {
    profile = {
        enabled = true,
        afk = true,
        delayMin = 0.5,
        delayMax = 1,
        party = {enabled = true, inInstance = true, outOfInstance = true, dead = false},
        raid = {enabled = true, inInstance = true, outOfInstance = true, dead = false},
    },
}

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
            get = function(info)
                local n = ReadyCheckAccept.db.profile.delayMin
                if n > ReadyCheckAccept.db.profile.delayMax then ReadyCheckAccept.db.profile.delayMax = n end
                return n
            end,
            set = function(info, value)
                local n = value
                if n > ReadyCheckAccept.db.profile.delayMax then ReadyCheckAccept.db.profile.delayMax = n end
                ReadyCheckAccept.db.profile.delayMin = n
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
            get = function(info)
                local n = ReadyCheckAccept.db.profile.delayMax
                if n < ReadyCheckAccept.db.profile.delayMin then n = ReadyCheckAccept.db.profile.delayMin end
                return n
            end,
            set = function(info, value)
                local n = value
                if n < ReadyCheckAccept.db.profile.delayMin then n = ReadyCheckAccept.db.profile.delayMin end
                ReadyCheckAccept.db.profile.delayMax = n
            end,
        },

        party = {
            type = "group",
            inline = true,
            order = 4,
            name = L["Party Settings"],
            get = "GetValueWithParent",
            set = "SetValueWithParent",
            args = {
                enabled = {type = "toggle", order = 1, name = L["Enabled"], desc = L["Enable in party"]},
                inInstance = {type = "toggle", order = 2, name = L["In Instance"], desc = L["Accept when in instance"]},
                outOfInstance = {type = "toggle", order = 3, name = L["Out of Instance"], desc = L["Accept when out of instance"]},
                dead = {type = "toggle", order = 4, name = L["Dead / Ghost"], desc = L["Accept when dead / ghost"]},
            },
        },
        raid = {
            type = "group",
            inline = true,
            order = 4,
            name = L["Raid Settings"],
            get = "GetValueWithParent",
            set = "SetValueWithParent",
            args = {
                enabled = {type = "toggle", order = 1, name = L["Enabled"], desc = L["Enable in raid"]},
                inInstance = {type = "toggle", order = 2, name = L["In Instance"], desc = L["Accept when in instance"]},
                outOfInstance = {type = "toggle", order = 3, name = L["Out of Instance"], desc = L["Accept when out of instance"]},
                dead = {type = "toggle", order = 4, name = L["Dead / Ghost"], desc = L["Accept when dead / ghost"]},
            },
        },

    },
}

function ReadyCheckAccept:GetValue(info) return self.db.profile[info[#info]] end
function ReadyCheckAccept:SetValue(info, value) self.db.profile[info[#info]] = value end

function ReadyCheckAccept:GetValueWithParent(info) return self.db.profile[info[#info - 1]][info[#info]] end
function ReadyCheckAccept:SetValueWithParent(info, value) self.db.profile[info[#info - 1]][info[#info]] = value end
