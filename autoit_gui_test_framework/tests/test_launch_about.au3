Func Test_launch_about()

    Local $appPath = "C:\Program Files (x86)\Mircom Group of Companies\MGC-400 Series Configuration Tools\MGC-400_Config.exe"
    Local $winTitle = "Job4-01: 400 Sample Job 1 - MGC-400 Series Configurator Utility"

    LogToFile("Starting test: Launching application.")

    ; Launch the app
    If Not LaunchApp($appPath, $winTitle) Then
        LogToFile("Failed to launch application or main window did not appear.")
        Return
    EndIf
    LogToFile("Application launched successfully and main window is active.")

    Sleep(1000)

    ; Click "Help" menu
    If ClickRelative($winTitle, 205, 40) Then
        LogToFile("Clicked 'Help' menu.")
    Else
        LogToFile("Failed to click 'Help' menu.")
    EndIf

    ; Click "About MGC-400 Configurator Utility"
    If ClickRelative($winTitle, 325, 90) Then
        LogToFile("Clicked 'About MGC-400 Configurator Utility'.")
    Else
        LogToFile("Failed to click 'About' menu item.")
    EndIf

    ; Wait for About dialog and close it
    If WinWaitActive("[CLASS:#32770]", "", 3) Then
        Sleep(500)
        Send("{ENTER}")
        LogToFile("About dialog opened and closed successfully.")
    Else
        LogToFile("About dialog did not appear.")
    EndIf

    ; Close the Configurator using Alt+F4
    LogToFile("Closing application with Alt+F4.")
    WinActivate($winTitle)
    Sleep(300)
    Send("!{F4}")

    ; Confirm window closed
    If WinWaitClose($winTitle, "", 5) Then
        LogToFile("Application closed successfully.")
    Else
        LogToFile("Application did not close within timeout.")
    EndIf
EndFunc
