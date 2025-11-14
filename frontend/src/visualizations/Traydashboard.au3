; TrayDashboard.au3
#include <GUIConstantsEx.au3>
#include <ProgressConstants.au3>
#include <WindowsConstants.au3>

Global $hGUI, $lblCPU, $lblRAM, $pbCPU, $pbRAM

Func Dashboard_Show()
    If Not IsDeclared($hGUI) Then
        $hGUI = GUICreate("KubuTray Dashboard", 300, 150)
        $lblCPU = GUICtrlCreateLabel("CPU: 0%", 10, 10, 100, 20)
        $pbCPU = GUICtrlCreateProgress(10, 30, 280, 20)
        $lblRAM = GUICtrlCreateLabel("RAM: 0%", 10, 60, 100, 20)
        $pbRAM = GUICtrlCreateProgress(10, 80, 280, 20)
        GUISetState(@SW_SHOW, $hGUI)
        Dashboard_Update()
    Else
        GUISetState(@SW_SHOW, $hGUI)
    EndIf
EndFunc

Func Dashboard_Update()
    While GUIGetMsg() <> $GUI_EVENT_CLOSE
        Local $cpu = Round(_Performance_GetCPU(), 1)
        Local $ram = Round(_Performance_GetRAM(), 1)
        GUICtrlSetData($lblCPU, "CPU: " & $cpu & "%")
        GUICtrlSetData($pbCPU, $cpu)
        GUICtrlSetData($lblRAM, "RAM: " & $ram & "%")
        GUICtrlSetData($pbRAM, $ram)
        Sleep(1000)
    WEnd
EndFunc

Func _Performance_GetCPU()
    Local $perf = RunWait("wmic cpu get loadpercentage /value", "", @SW_HIDE, $STDOUT_CHILD)
    Local $out = StdoutRead($perf)
    Return Number(StringRegExpReplace($out, "\D", ""))
EndFunc

Func _Performance_GetRAM()
    Local $oMem = ObjGet("winmgmts:\\.\root\cimv2").ExecQuery("Select * from Win32_OperatingSystem")
    For $m In $oMem
        Return Round((($m.TotalVisibleMemorySize - $m.FreePhysicalMemory) / $m.TotalVisibleMemorySize) * 100, 1)
    Next
EndFunc
