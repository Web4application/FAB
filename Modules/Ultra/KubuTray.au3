#include <GUIConstantsEx.au3>
#include <TrayConstants.au3>
#include <MsgBoxConstants.au3>
#include <GDIPlus.au3>
#include <WindowsConstants.au3>

; ===============================
; GLOBAL VARIABLES
; ===============================
Global $g_TrayMenu = []
Global $g_Callbacks = []

Global $hAI_GUI, $txtInput, $txtOutput
Global $hDashboard, $lblCPU, $lblRAM, $pbCPU, $pbRAM
Global $g_TimerTrayIcon

; ===============================
; INIT FUNCTION
; ===============================
Func UltraKubuTray_Init()
    _GDIPlus_Startup()
    UltraTray_CreateMenu([ _
        ["Dashboard", "UltraDashboard_Show"], _
        ["AI Assistant", "UltraAI_Open"], _
        ["Notify Test", "UltraNotify_Test"], _
        ["Exit", "UltraTray_Exit"]])
    
    ; Hotkeys
    HotKeySet("^!D", "UltraDashboard_Show")
    HotKeySet("^!A", "UltraAI_Open")
    HotKeySet("^!N", "UltraNotify_Test")

    ; Start tray icon animation timer
    $g_TimerTrayIcon = TimerInit()
EndFunc

; ===============================
; DYNAMIC TRAY MENU
; ===============================
Func UltraTray_CreateMenu($aMenuArray)
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

Func UltraTray_HandleMsg($id)
    If IsDeclared($g_Callbacks[$id]) Then
        Local $cb = $g_Callbacks[$id]
        If StringLen($cb) > 0 Then Call($cb)
    EndIf
EndFunc

Func _TrayCore_ClearMenu()
    For $i = 0 To UBound($g_TrayMenu) - 1
        If $g_TrayMenu[$i] Then TrayItemDelete($g_TrayMenu[$i])
    Next
    ReDim $g_TrayMenu[0]
    ReDim $g_Callbacks[0]
EndFunc

; ===============================
; DASHBOARD
; ===============================
Func UltraDashboard_Show()
    If Not IsDeclared($hDashboard) Then
        $hDashboard = GUICreate("Aura System Dashboard", 300, 150)
        $lblCPU = GUICtrlCreateLabel("CPU: 0%", 10, 10, 100, 20)
        $pbCPU = GUICtrlCreateProgress(10, 30, 280, 20)
        $lblRAM = GUICtrlCreateLabel("RAM: 0%", 10, 60, 100, 20)
        $pbRAM = GUICtrlCreateProgress(10, 80, 280, 20)
        GUISetState(@SW_SHOW, $hDashboard)
        SetTimer("UltraDashboard_Update", 1000)
    Else
        GUISetState(@SW_SHOW, $hDashboard)
    EndIf
EndFunc

Func UltraDashboard_Update()
    Local $cpu = Ultra_GetCPU()
    Local $ram = Ultra_GetRAM()
    GUICtrlSetData($lblCPU, "CPU: " & $cpu & "%")
    GUICtrlSetData($pbCPU, $cpu)
    GUICtrlSetData($lblRAM, "RAM: " & $ram & "%")
    GUICtrlSetData($pbRAM, $ram)
EndFunc

Func Ultra_GetCPU()
    Local $s = RunWait("wmic cpu get loadpercentage /value", "", @SW_HIDE, $STDOUT_CHILD)
    Local $out = StdoutRead($s)
    Return Number(StringRegExpReplace($out, "\D", ""))
EndFunc

Func Ultra_GetRAM()
    Local $oMem = ObjGet("winmgmts:\\.\root\cimv2").ExecQuery("Select * from Win32_OperatingSystem")
    For $m In $oMem
        Return Round((($m.TotalVisibleMemorySize - $m.FreePhysicalMemory) / $m.TotalVisibleMemorySize) * 100, 1)
    Next
EndFunc

; ===============================
; AI ASSISTANT
; ===============================
Func UltraAI_Open()
    If Not IsDeclared($hAI_GUI) Then
        $hAI_GUI = GUICreate("Aura AI Assistant", 400, 300)
        $txtOutput = GUICtrlCreateEdit("", 10, 10, 380, 200, $ES_AUTOVSCROLL + $ES_READONLY)
        $txtInput = GUICtrlCreateInput("", 10, 220, 300, 25)
        GUICtrlCreateButton("Send", 320, 220, 70, 25)
        GUISetState(@SW_SHOW, $hAI_GUI)
    Else
        GUISetState(@SW_SHOW, $hAI_GUI)
    EndIf
EndFunc

Func UltraAI_Send($sInput)
    GUICtrlSetData($txtOutput, GUICtrlRead($txtOutput) & @CRLF & "You: " & $sInput)
    Local $response = Aura_AI_GetResponse($sInput)
    GUICtrlSetData($txtOutput, GUICtrlRead($txtOutput) & @CRLF & "AI: " & $response)
    GUICtrlSetData($txtInput, "")
EndFunc

; ===============================
; NOTIFICATIONS
; ===============================
Func UltraNotify_Test()
    Aura_Toast("Ultra KubuTray Notification!", 3000)
EndFunc

; ===============================
; DYNAMIC TRAY ICON
; ===============================
Func UltraTray_AnimateIcon()
    Local $cpu = Ultra_GetCPU()
    Local $ram = Ultra_GetRAM()
    
    Local $hBitmap = _GDIPlus_BitmapCreateFromScan0(16,16,0)
    Local $hGraphics = _GDIPlus_ImageGetGraphicsContext($hBitmap)
    
    ; CPU Bar (red)
    Local $hBrush = _GDIPlus_BrushCreateSolid(0xFFFF0000)
    _GDIPlus_GraphicsFillRectangle($hGraphics, 0, 16 - Int($cpu/6), 7, Int($cpu/6), $hBrush)
    
    ; RAM Bar (green)
    _GDIPlus_BrushDispose($hBrush)
    $hBrush = _GDIPlus_BrushCreateSolid(0xFF00FF00)
    _GDIPlus_GraphicsFillRectangle($hGraphics, 8, 16 - Int($ram/6), 7, Int($ram/6), $hBrush)
    
    _GDIPlus_BrushDispose($hBrush)
    _GDIPlus_GraphicsDispose($hGraphics)
    
    Local $tmpIcon = @ScriptFullPath
    TraySetIcon($tmpIcon)
    _GDIPlus_BitmapDispose($hBitmap)
EndFunc

; ===============================
; EXIT
; ===============================
Func UltraTray_Exit()
    _GDIPlus_Shutdown()
    Exit
EndFunc
