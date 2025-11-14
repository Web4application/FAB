; TrayAI.au3
#include <GUIConstantsEx.au3>
#include <MsgBoxConstants.au3>

Global $hAI_GUI, $txtInput, $txtOutput

Func AI_Open()
    If Not IsDeclared($hAI_GUI) Then
        $hAI_GUI = GUICreate("KubuTray AI Assistant", 400, 300)
        $txtOutput = GUICtrlCreateEdit("", 10, 10, 380, 200, $ES_AUTOVSCROLL + $ES_READONLY)
        $txtInput = GUICtrlCreateInput("", 10, 220, 300, 25)
        GUICtrlCreateButton("Send", 320, 220, 70, 25)
        GUISetState(@SW_SHOW, $hAI_GUI)
        HotKeySet("^!A", "AI_Open") ; Ctrl+Alt+A opens
        AI_Loop()
    Else
        GUISetState(@SW_SHOW, $hAI_GUI)
    EndIf
EndFunc

Func AI_Loop()
    While 1
        Local $msg = GUIGetMsg()
        If $msg = $GUI_EVENT_CLOSE Then ExitLoop
        If $msg = $GUI_EVENT_PRIMARYDOWN Then ; send button
            Local $input = GUICtrlRead($txtInput)
            GUICtrlSetData($txtOutput, GUICtrlRead($txtOutput) & @CRLF & "You: " & $input)
            ; Example backend response (replace with actual API call)
            GUICtrlSetData($txtOutput, GUICtrlRead($txtOutput) & @CRLF & "AI: " & $input & " [echo]")
            GUICtrlSetData($txtInput, "")
        EndIf
        Sleep(100)
    WEnd
EndFunc
