; TrayCore.au3
#include <TrayConstants.au3>
#include <GuiMenu.au3>

Global $g_TrayMenu = []
Global $g_Callbacks = []

Func TrayCore_CreateMenu($aMenuArray)
    _TrayCore_ClearMenu()
    For $i = 0 To UBound($aMenuArray) - 1
        Local $text = $aMenuArray[$i][0]
        Local $callback = $aMenuArray[$i][1]
        Local $id = TrayCreateItem($text)
        $g_TrayMenu[$i] = $id
        $g_Callbacks[$id] = $callback
    Next
    TraySetState($TRAY_ICONSTATE_SHOW)
EndFunc

Func TrayCore_HandleMsg($id)
    If IsDeclared($g_Callbacks[$id]) Then
        Local $cb = $g_Callbacks[$id]
        If StringLen($cb) > 0 Then
            Call($cb)
        EndIf
    EndIf
EndFunc

Func _TrayCore_ClearMenu()
    For $i = 0 To UBound($g_TrayMenu) - 1
        If $g_TrayMenu[$i] Then TrayItemDelete($g_TrayMenu[$i])
    Next
    ReDim $g_TrayMenu[0]
    ReDim $g_Callbacks[0]
EndFunc
