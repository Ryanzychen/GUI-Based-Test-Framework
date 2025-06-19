; lib/utils.au3

Global $g_logFile = @ScriptDir & "\test_log.txt"

#include <FileConstants.au3>
#include <MsgBoxConstants.au3>
#include <WinAPIFiles.au3>
#include <ScreenCapture.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>

Func LogToFile($text)
    Local $hFile = FileOpen($g_logFile, $FO_APPEND)
    If $hFile = -1 Then
        MsgBox($MB_ICONERROR, "Error", "Failed to open log file.")
        Return
    EndIf
    Local $timestamp = "[" & @YEAR & "/" & @MON & "/" & @MDAY & " " & @HOUR & ":" & @MIN & ":" & @SEC & "] "
    FileWriteLine($hFile, $timestamp & $text)
    FileClose($hFile)
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

Func HandleUserPreferenceWindow()
    Local $prefTitle = "User Preferences" 

    If WinWait($prefTitle, "", 5) Then
        LogToFile("User Preferences window detected.")
        WinActivate($prefTitle)
        WinWaitActive($prefTitle, "", 3)

        ; Enter dummy username
        Send("TestUser")
        Sleep(300)

        ; Confirm by pressing Enter
        Send("{ENTER}")
        Sleep(1000)
        Return True
    Else
        LogToFile("User Preferences window not detected.")
        Return False
    EndIf
EndFunc

Func LaunchApp($exePath, $windowTitle, $timeout = 10)
    Run($exePath)
    HandleUserPreferenceWindow() ; Added to deal with first-time login
    If Not WinWaitActive($windowTitle, "", $timeout) Then
        MsgBox(16, "Error", "Window not found: " & $windowTitle)
        Return False
    EndIf
    If Not WinActive($windowTitle) Then
        MsgBox(16, "Error", "Can't activate window: " & $windowTitle)
        Return False
    EndIf
    Return True
EndFunc

Func VerifyDeviceType($expectedType, $winTitle)
    Local $pos = WinGetPos($winTitle)
    If @error Or Not IsArray($pos) Then
        LogToFile("Failed to get window position for " & $winTitle)
        Return False
    EndIf

    Local $x_offset = 265
    Local $y_offset = 98
    Local $w = 300
    Local $h = 19

    Local $screenshotPath = @TempDir & "\type_check.png"
    Local $tesseractPath = "C:\Program Files\Tesseract-OCR\tesseract.exe"

    ; Calculate absolute coordinates
    Local $absX1 = $pos[0] + $x_offset
    Local $absY1 = $pos[1] + $y_offset
    Local $absX2 = $absX1 + $w
    Local $absY2 = $absY1 + $h

    ; Capture screenshot
    _ScreenCapture_Capture($screenshotPath, $absX1, $absY1, $absX2, $absY2)
    Sleep(500)

    ; Run OCR
    Local $cmd = '"' & $tesseractPath & '" "' & $screenshotPath & '" stdout -l eng --psm 6'
    Local $pid = Run($cmd, "", @SW_HIDE, $STDOUT_CHILD)
    If $pid = 0 Then
        LogToFile("Failed to run Tesseract.")
        FileDelete($screenshotPath)
        Return False
    EndIf

    ; Read OCR output
    Local $ocrText = ""
    While True
        Local $line = StdoutRead($pid)
        If @error Then ExitLoop
        $ocrText &= $line
    WEnd

    FileDelete($screenshotPath)
    $ocrText = StringStripWS($ocrText, 7)
    LogToFile("OCR raw result: [" & $ocrText & "]")

    ; Get first 3 characters of expected type (lowercase)
    Local $expectedSub = StringLower(StringLeft($expectedType, 3))
    Local $ocrLower = StringLower($ocrText)

    If StringInStr($ocrLower, $expectedSub) Then
        LogToFile("PASS: OCR result contains expected prefix '" & $expectedSub & "'. Full OCR: '" & $ocrText & "'")
        ShowPopup("PASS", 0x00FF00, "",16,10)
        Return True
    Else
        LogToFile("FAIL: Device type mismatch. Detected: " & $ocrText)
        ShowPopup("FAIL", 0xFF0000, "Detected: " & $ocrText & @CRLF & "Expected prefix: '" & $expectedType & "'")
        Return False
    EndIf
EndFunc

; Show test result and close
Func ShowPopup($title, $bgColor, $msg = "", $titleFontSize = 22, $msgFontSize = 9)
    Local $width = 360, $height = 150
    ; Use numeric values for window styles to avoid undeclared constant errors
    Local $WS_POPUP = 0x80000000
    Local $WS_EX_TOPMOST = 0x00000008
    Local $SS_CENTER = 0x00000001

    Local $gui = GUICreate($title, $width, $height, -1, -1, $WS_POPUP, $WS_EX_TOPMOST)
    GUISetBkColor($bgColor, $gui)

    Local $lblTitle = GUICtrlCreateLabel($title, 20, 20, ($width - 40), 40, $SS_CENTER)
    GUICtrlSetFont($lblTitle, $titleFontSize, 800)

    If $msg <> "" Then
        Local $lblMsg = GUICtrlCreateLabel($msg, 20, 80, ($width - 40), 40, $SS_CENTER)
        GUICtrlSetFont($lblMsg, $msgFontSize, 400)
    EndIf

    GUISetState(@SW_SHOW, $gui)
    Sleep(3000)
    GUIDelete($gui)
EndFunc

Func OCR_WindowRegion($winTitle, $offsetX, $offsetY, $width, $height)
    Local $pos = WinGetPos($winTitle)
    If @error Then
        LogToFile("Failed to get window position for OCR.")
        Return ""
    EndIf

    Local $x1 = $pos[0] + $offsetX
    Local $y1 = $pos[1] + $offsetY
    Local $x2 = $x1 + $width
    Local $y2 = $y1 + $height

    Local $screenshotPath = @TempDir & "\ocr_tools_check.png"
    _ScreenCapture_Capture($screenshotPath, $x1, $y1, $x2, $y2)
    Sleep(300)

    Local $tesseractPath = "C:\Program Files\Tesseract-OCR\tesseract.exe"
    Local $cmd = '"' & $tesseractPath & '" "' & $screenshotPath & '" stdout -l eng --psm 6'
    Local $pid = Run($cmd, "", @SW_HIDE, $STDOUT_CHILD)
    If $pid = 0 Then
        LogToFile("Failed to run Tesseract for Tools OCR.")
        FileDelete($screenshotPath)
        Return ""
    EndIf

    Local $ocrResult = ""
    While True
        Local $line = StdoutRead($pid)
        If @error Then ExitLoop
        $ocrResult &= $line
    WEnd

    FileDelete($screenshotPath)
    Return StringStripWS($ocrResult, 7)
EndFunc



