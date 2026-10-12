local L = LibStub("AceLocale-3.0"):NewLocale("ReadyCheckAccept", "deDE")
if not L then return end

L["Ready Check Accept is |cFF00FF00turned on|r"] = "Ready Check Accept ist |cFF00FF00eingeschaltet|r"
L["Ready Check Accept is |cFFFF0000turned off|r"] = "Ready Check Accept ist |cFFFF0000ausgeschaltet|r"

L["Enabled"] = "Aktiviert"
L["Type \"/rca on\" or \"/rca off\" to change this setting without opening the settings menu"] =
  "Gib „/rca on“ oder „/rca off“ ein, um diese Einstellung zu ändern, ohne das Einstellungsmenü zu öffnen."
L["Disable when AFK"] = "Bei AFK deaktivieren"
L["Will not accept ready check when you are /afk"] = "Akzeptiert keine Ready-Checks, wenn du /afk bist"
L["Minimal Delay"] = "Minimale Verzögerung"
L["Minimal delay in seconds before accept"] = "Minimale Verzögerung in Sekunden vor der Annahme"
L["Maximal Delay"] = "Maximale Verzögerung"
L["Maximal delay in seconds before accept, must be greater or equal to minimal delay"] =
  "Maximale Verzögerung in Sekunden bis der Annahme; muss größer oder gleich der minimalen Verzögerung sein"
L["Party Settings"] = "Gruppen Einstellungen"
L["Raid Settings"] = "Raid Einstellungen"
L["Enable in party"] = "In Gruppe aktivieren"
L["Enable in raid"] = "Im Raid aktivieren"
L["In Instance"] = "In Instanz"
L["Accept when in instance"] = "In Instanz annehmen"
L["Out of Instance"] = "Außerhalb Instanz"
L["Accept when out of instance"] = "Außerhalb Instanz annehmen"
L["Dead / Ghost"] = "Tot / Geist"
L["Accept when dead / ghost"] = "Bei Tod / Geist annehmen"
L["Disable when idle"] = "Bei Untätigkeit deaktivieren"
L["Will not accept ready check if you have not moved for the set time. The timer restarts when you leave combat, a boss encounter ends or you join a group"] =
  "Akzeptiert keine Ready-Checks, wenn du dich für die eingestellte Zeit nicht bewegt hast. Der Timer startet neu, wenn du den Kampf verlässt, ein Bosskampf endet oder du einer Gruppe beitrittst"
L["Idle Time"] = "Untätigkeitsdauer"
L["Seconds without movement after which ready checks are not accepted"] =
  "Sekunden ohne Bewegung, nach denen Ready-Checks nicht mehr akzeptiert werden"
L["Ready check was not accepted: you have not moved for %d seconds"] =
  "Ready-Check nicht akzeptiert: Du hast dich seit %d Sekunden nicht bewegt"
L["Idle Message"] = "Untätigkeitsmeldung"
L["Print a chat message when a ready check is not accepted because you are idle"] =
  "Eine Chatnachricht ausgeben, wenn ein Ready-Check wegen Untätigkeit nicht akzeptiert wird"
