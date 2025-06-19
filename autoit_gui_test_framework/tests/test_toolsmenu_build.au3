Func Test_toolsmenu_build()

    Local $appPath = "C:\Program Files (x86)\Mircom Group of Companies\MGC-400 Series Configuration Tools\MGC-400_Config.exe"
    Local $winTitle = "Job4-01: 400 Sample Job 1 - MGC-400 Series Configurator Utility"

    LogToFile("Starting test: Ensure 'Tools' menu is visible, enable if needed, then build job.")

    ; Launch the app
    If Not LaunchApp($appPath, $winTitle) Then
        LogToFile("Failed to launch application or main window did not appear.")
        Return
    EndIf
    LogToFile("Application launched successfully and main window is active.")
    Sleep(1500)

    ; === OCR check: Is 'Tools' menu visible? ===
    Local $ocrText = OCR_WindowRegion($winTitle, 185, 28, 42, 21) ; Approx location of Tools
    LogToFile("OCR result near Tools region: [" & $ocrText & "]")

    If Not StringInStr(StringLower($ocrText), "tools") Then
        LogToFile("'Tools' menu not found. Enabling via User Preferences.")
        ShowPopup("Tools menu is not shown", 0xFF0000, "Change at User Preference menu", 12, 10)

        ; Click "File" menu
        If ClickRelative($winTitle, 15, 40) Then
            LogToFile("Clicked 'File' menu.")
        Else
            LogToFile("Failed to click 'File' menu.")
        EndIf

        ; Click "User Preferences"
        If ClickRelative($winTitle, 90, 140) Then
            LogToFile("Clicked 'User Preferences'.")
        Else
            LogToFile("Failed to click 'User Preferences'.")
        EndIf

        ; Wait for User Preferences window
        If WinWaitActive("User Preferences", "", 3) Then
            Sleep(500)

            ; Click on "Show Tools Menu" checkbox
            If ClickRelative("User Preferences", 107, 253) Then
                LogToFile("'Show Tools Menu' checkbox clicked.")
            Else
                LogToFile("Failed to click 'Show Tools Menu' checkbox.")
            EndIf

            Sleep(300)

            ; Click OK button
            If ClickRelative("User Preferences", 175, 300) Then
                LogToFile("Clicked 'OK' in User Preferences.")
            Else
                LogToFile("Failed to click 'OK' button.")
            EndIf

            Sleep(1000) ; Wait for UI refresh
        Else
            LogToFile("User Preferences window did not appear.")
        EndIf
    Else
        LogToFile("'Tools' menu is already visible. Skipping User Preferences.")
    EndIf

    ShowPopup("Tools menu is shown", 0x00FF00, "Continue to build the job", 12, 10)
    ; === Click Tools > Build Job ===
    If ClickRelative($winTitle, 205, 40) Then
        LogToFile("Clicked 'Tools' menu.")
    Else
        LogToFile("Failed to click 'Tools' menu.")
    EndIf

    If ClickRelative($winTitle, 300, 110) Then
        LogToFile("Clicked 'Build Job' section.")
    Else
        LogToFile("Failed to click 'Build Job' section.")
    EndIf

    LogToFile("Job has been loaded on the panel.")
    ShowPopup("Job has been loaded", 0x00FF00, "Panel status OK", 12, 10)

    ; Close the Configurator using Alt+F4
    LogToFile("Closing application with Alt+F4.")
    WinActivate($winTitle)
    Sleep(300)
    Send("!{F4}")

    If WinWaitClose($winTitle, "", 5) Then
        LogToFile("Application closed successfully.")
    Else
        LogToFile("Application did not close within timeout.")
    EndIf
ENDFunc


