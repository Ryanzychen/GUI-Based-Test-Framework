Func TestCase2()
    Local $exePath = "notepad.exe"
    Local $winTitle = "Untitled - Notepad"

    LogToFile("Launching Notepad")
    If Not LaunchApp($exePath, $winTitle, 10) Then
        LogToFile("Failed to launch Notepad")
        MsgBox(16, "Error", "Notepad window not found or not active.")
        Exit
    EndIf
    LogToFile("Notepad launched successfully")

    WinSetState($winTitle, "", @SW_RESTORE)
    WinActivate($winTitle)
    Sleep(500)

    Local $textToWrite = "This is an automated test text input."
    Send($textToWrite)
    LogToFile("Typed text into Notepad")
    Sleep(500)

    Send("!f")  ; Alt + F to open File menu
    Sleep(300)
    Send("a")   ; Press 'a' for Save As
    LogToFile("Triggered Save As dialog")
    Sleep(500)

    If Not WinWaitActive("Save As", "", 10) Then
        LogToFile("Save As dialog did not appear")
        MsgBox(16, "Error", "'Save As' dialog did not appear.")
        Exit
    EndIf

    Local $savePath = @ScriptDir & "\TestFile.txt"
    ControlSetText("Save As", "", "Edit1", $savePath)
    LogToFile("Entered filename: " & $savePath)
    Sleep(500)

    Send("{ENTER}")
    Sleep(500)

    ; Handle the "Confirm Save As" overwrite dialog if it appears
    If WinWaitActive("Confirm Save As", "", 3) Then
        LogToFile("Confirm Save As dialog detected - confirming overwrite")
        ControlClick("Confirm Save As", "", "Button1") ; Click "Yes"
        Sleep(1000)
    EndIf

    LogToFile("File saved or overwritten")

    ; Close Notepad using window handle
    Local $hWnd = WinGetHandle("[CLASS:Notepad]")
    WinClose($hWnd)
    LogToFile("Notepad close requested")

    ; If the 'Save changes' prompt appears, select 'Don't Save'
    If WinWaitActive("Notepad", "Do you want to save", 5) Then
        Send("!n") ; Alt + N to choose 'Don't Save'
        LogToFile("Dismissed 'Save changes' prompt")
    EndIf
EndFunc
