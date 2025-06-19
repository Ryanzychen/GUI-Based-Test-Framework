Func Test_add_device()

    Local $appPath = "C:\Program Files (x86)\Mircom Group of Companies\MGC-400 Series Configuration Tools\MGC-400_Config.exe"
    Local $winTitle = "Job4-01: 400 Sample Job 1 - MGC-400 Series Configurator Utility"

    LogToFile("Starting Test Case 2: Add Output Zone")

    If Not LaunchApp($appPath, $winTitle) Then
        LogToFile("Failed to launch application.")
        Return
    EndIf
    LogToFile("Application launched successfully.")

    ; === STEP 1: Click "Output Zone" tab ===
    If ClickRelative($winTitle, 70, 140) Then ; 
        LogToFile("Clicked 'Output Zone' tab.")
    Else
        LogToFile("Failed to click 'Output Zone' tab.")
    EndIf

    ; === STEP 2: Click "Insert" menu ===
    If ClickRelative($winTitle, 85, 45) Then ; 
        LogToFile("Clicked 'Insert' menu.")
    Else
        LogToFile("Failed to click 'Insert' menu.")
    EndIf

    ; === STEP 3: Click "Add Zone" ===
    If ClickRelative($winTitle, 155, 135) Then ; 
        LogToFile("Clicked 'Add Zone' option.")
    Else
        LogToFile("Failed to click 'Add Zone'.")
    EndIf

    ; === STEP 4: Handle "Writable?" prompt ===
    If WinWaitActive("MGC-400 Series Configurator Utility", "Do you wish to make it writeable", 3) Then
        Send("!y") ; Alt+Y or simply Send("{ENTER}") if 'Yes' is default
        LogToFile("Confirmed 'Writable' prompt.")
    Else
        LogToFile("Writable prompt did not appear.")
    EndIf

    ; === STEP 5: Change Type to "Signal" === 
    If WinWaitActive("Add Output Zone", "", 3) Then
        LogToFile("'Add Output Zone' dialog detected.")

        ; Move to Type dropdown 
        ClickRelative("Add Output Zone", 145, 65) ; 
        Sleep(300)
        ClickRelative("Add Output Zone", 145, 88) ; 
        Sleep(300)

        ; Click "Add" button 
        ClickRelative("Add Output Zone", 80, 145)
        LogToFile("Set type to 'Signal' and clicked 'Add'.")
        Sleep(1000)

        ; === STEP 6: Verify device type ===
        VerifyDeviceType("Signal", $winTitle)

        ; === Close the Add Output Zone dialog ===
        ClickRelative("Add Output Zone", 165, 145) 
        LogToFile("Closed 'Add Output Zone' dialog.")
    Else
        LogToFile("'Add Output Zone' dialog not detected.")
    EndIf

    ; === STEP 6: Close Application ===
    LogToFile("Closing application.")
    WinActivate($winTitle)
    Sleep(300)
    Send("!{F4}")
    If WinWaitClose($winTitle, "", 5) Then
        LogToFile("Application closed successfully.")
    Else
        LogToFile("Application did not close properly.")
    EndIf
ENDFunc
