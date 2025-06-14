; lib/utils.au3

; Define a global log file path (accessible by other files)
Global $g_logFile = @ScriptDir & "\test_log.txt"

#include <FileConstants.au3>

Func LaunchApp($exePath, ByRef $windowTitle, $timeout = 10)
    Run($exePath)
    If WinWaitActive($windowTitle, "", $timeout) Then
        Return True
    Else
        MsgBox(16, "Error", "Cannot activate window: " & $windowTitle)
        Return False
    EndIf
EndFunc

Func ClickRelative($winTitle, $offsetX, $offsetY, $sleepAfter = 300)
    Local $pos = WinGetPos($winTitle)
    If @error Then
        LogToFile("Failed to get window position: " & $winTitle)
        Return False
    EndIf
    Local $x = $pos[0] + $offsetX
    Local $y = $pos[1] + $offsetY
    MouseMove($x, $y, 10)
    Sleep(100)
    MouseClick("left")
    Sleep($sleepAfter)
    Return True
EndFunc

; Log message by appending to the existing log file
Func LogToFile($msg)
    Local $timestamp = "[" & @YEAR & "/" & StringFormat("%02d", @MON) & "/" & StringFormat("%02d", @MDAY) & " " & _
                       StringFormat("%02d", @HOUR) & ":" & StringFormat("%02d", @MIN) & ":" & StringFormat("%02d", @SEC) & "] "

    Local $file = FileOpen($g_logFile, $FO_APPEND)
    If $file = -1 Then
        MsgBox(16, "Error", "Cannot open log file: " & $g_logFile)
        Return False
    EndIf

    FileWriteLine($file, $timestamp & $msg)
    FileClose($file)
    Return True
EndFunc

; Optional: Clear log file at the start of a test run
Func ClearLogFile()
    Local $file = FileOpen($g_logFile, $FO_OVERWRITE)
    If $file = -1 Then
        MsgBox(16, "Error", "Cannot clear log file: " & $g_logFile)
        Return False
    EndIf
    FileWriteLine($file, "[" & @YEAR & "/" & StringFormat("%02d", @MON) & "/" & StringFormat("%02d", @MDAY) & "] Log cleared.")
    FileClose($file)
    Return True
EndFunc


