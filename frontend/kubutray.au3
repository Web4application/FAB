#include "TrayCore.au3"
#include "TrayDashboard.au3"
#include "TrayAI.au3"
#include "TrayNotify.au3"
#include "TrayIconFX.au3"

; Build main menu
Local $menu = [
    ["Dashboard", "Dashboard_Show"],
    ["AI Assistant", "AI_Open"],
    ["Notify Test", "FuncTestNotify"],
    ["Exit", "FuncExit"]
]

TrayCore_CreateMenu($menu)

While 1
    Local $msg = TrayGetMsg()
    TrayCore_HandleMsg($msg)
WEnd

Func FuncTestNotify()
    Notify_Show("This is a KubuTray notification!", 2000)
EndFunc

Func FuncExit()
    Exit
EndFunc
