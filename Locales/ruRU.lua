local L = LibStub("AceLocale-3.0"):NewLocale("ReadyCheckAccept", "ruRU")
if not L then return end

L["Ready Check Accept is |cFF00FF00turned on|r"] = "Принятие готовности |cFF00FF00включено|r"
L["Ready Check Accept is |cFFFF0000turned off|r"] = "Принятие готовности |cFFFF0000выключено|r"

L["Enabled"] = "Включено"
L["Type \"/rca on\" or \"/rca off\" to change this setting without opening the settings menu"] =
  "Напишите \"/rca on\" или \"/rca off\" чтобы изменить без открытия меню настроек"
L["Disable when AFK"] = "Выключить при АФК"
L["Will not accept ready check when you are /afk"] =
  "Готовность не будет приниматься когда вы /afk"
L["Minimal Delay"] = "Минимальная задержка"
L["Minimal delay in seconds before accept"] =
  "Минимальная задержка в секундах перед принятием"
L["Maximal Delay"] = "Максимальная задержка"
L["Maximal delay in seconds before accept, must be greater or equal to minimal delay"] =
  "Максимальная задержка в секундах перед принятием, должна быть больше или равна минимальной задержке"
L["Party Settings"] = "Настройки группы"
L["Raid Settings"] = "Настройки рейда"
L["Enable in party"] = "Включить в группе"
L["Enable in raid"] = "Включить в рейде"
L["In Instance"] = "В подземелье/рейде"
L["Accept when in instance"] = "Принимать в подземелье / рейде"
L["Out of Instance"] = "Вне подземелья/рейда"
L["Accept when out of instance"] = "Принимать вне подземелья / рейда"
L["Dead / Ghost"] = "Труп / призрак"
L["Accept when dead / ghost"] = "Принимать когда труп / призрак"
L["Disable when idle"] = "Выключить при бездействии"
L["Will not accept ready check if you have not moved for the set time. The timer restarts when you leave combat, a boss encounter ends or you join a group"] =
  "Готовность не будет приниматься, если вы не двигались заданное время. Отсчёт начинается заново после выхода из боя, окончания боя с боссом или вступления в группу"
L["Idle Time"] = "Время бездействия"
L["Seconds without movement after which ready checks are not accepted"] =
  "Секунды без движения, после которых готовность не принимается"
L["Ready check was not accepted: you have not moved for %d seconds"] =
  "Готовность не принята: вы не двигались %d сек."
L["Idle Message"] = "Сообщение о бездействии"
L["Print a chat message when a ready check is not accepted because you are idle"] =
  "Выводить сообщение в чат, если готовность не принята из-за бездействия"
