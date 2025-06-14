Func TestCase1()
    Local $exe = "notepad.exe"
    Local $title = "Untitled - Notepad"

    If Not LaunchApp($exe, $title) Then Return
    LogToFile("Notepad launched successfully. Window title: " & $title)

    ; Click "Help" menu
    Local $helpOffsetX = 175
    Local $helpOffsetY = 40
    If ClickRelative($title, $helpOffsetX, $helpOffsetY) Then
        LogToFile("Clicked Help menu")
    Else
        LogToFile("Failed to click Help menu")
        Return
    EndIf

    ; Click "About Notepad"
    Local $aboutOffsetX = 195
    Local $aboutOffsetY = 110
    If ClickRelative($title, $aboutOffsetX, $aboutOffsetY) Then
        LogToFile("Clicked About Notepad")
    Else
        LogToFile("Failed to click About Notepad")
        Return
    EndIf

    ; Close "About Notepad" dialog
    If WinWaitActive("About Notepad", "", 3) Then
        Local $aboutWinPos = WinGetPos("About Notepad")
        If IsArray($aboutWinPos) Then
            Local $okX = $aboutWinPos[0] + $aboutWinPos[2] / 2
            Local $okY = $aboutWinPos[1] + $aboutWinPos[3] - 50
            MouseMove($okX, $okY, 10)
            Sleep(200)
            MouseClick("left")
            LogToFile("Closed About Notepad dialog")
        EndIf
    Else
        LogToFile("About Notepad dialog not detected")
    EndIf

    ; Close Notepad without saving
    WinClose($title)
    If WinWaitActive("Notepad", "Do you want to save", 3) Then
        Send("!n") ; Alt + N
        LogToFile("Closed Notepad without saving")
    EndIf
EndFunc
