AutoIt GUI Test Automation Framework
====================================

Author: Yichen Zhao  
Date: June 2025

Overview
--------
This project is a GUI-based test automation framework developed using AutoIt. It is designed to automate user interactions with the **Configurator application**, such as launching the software, handling initial popups, building the job, adding devices through the GUI, and verifying results using OCR (Optical Character Recognition). 

The framework demonstrates how coordinate-based GUI automation can be combined with external tools like Tesseract OCR to validate UI content when traditional control-based automation is not feasible.

The goal of this project is to showcase a lightweight, script-driven, and extendable testing solution for Windows desktop applications that lack object-level accessibility.

Project Structure
-----------------
.
├── lib/
│   └── utils.au3          ; Utility functions (logging, launching apps, relative clicks, OCR check)
├── tests/
│   ├── test_launch_about.au3     ; Test_launch_about: Launch Configurator and handle tool bar (About Section)
│   ├── test_add_device.au3     ; Test_add_device: Add a device and verify its type via OCR
     ├── test_toolsmenu_build.au3     ; Test_toolsmenu_build: Verify visibility of Tools menu, enable if hidden, then build job
├── test_runner.au3        ; Entry point that runs all test cases in order
└── test_log.txt           ; Test execution log (auto-generated)

How to Set Up and Run
---------------------
1. **System Requirements:**
   - Windows OS
   - [AutoIt v3](https://www.autoitscript.com/site/autoit/downloads/) installed
   - [Tesseract OCR (UB Mannheim build)](https://github.com/UB-Mannheim/tesseract/wiki) installed

2. **Setup Instructions:**
   - Download or clone all project files and preserve the folder structure as shown above.
   - Install Tesseract OCR from: https://github.com/UB-Mannheim/tesseract/wiki  
     Make sure the default installation path is:  
     `"C:\Program Files\Tesseract-OCR\tesseract.exe"`
   - Open any of the `.au3` scripts with **SciTE (AutoIt Script Editor)** or right-click and select “Run Script”.

3. **To Run the Full Test Suite:**
     - Execute `test_runner.au3`. This will:
     - Clear and initialize the test log file
     - Execute Test_launch_about, Test_add_device, Test_toolsmenu_build and OCR device check
        **Important:** The OCR device check may currently produce inaccurate results due to variations in the window size of the MGC-400 Configurator across different desktops. This does not impact the structure 
        of our code or the execution of other automated operations. However, it is an important consideration for future automation work.
     - Display completion messages with color-coded popups
     - Write detailed logs to `test_log.txt` in the same directory

Log File Details
----------------
- Log file location: `<project_directory>\test_log.txt`
- Each log entry includes a timestamp and step description.
- Errors (like window not found or Save As dialog not appearing) are also logged for debugging.

Test Case Descriptions
----------------------
- **Test_launch_about:**  
  Launches the Configurator application, handles the initial user preference popup (if present), and verifies entry into the main window to handle tool bar.

- **Test_add_device:**  
  Adds a new device inside the Configurator UI, then captures and reads the device type using OCR. Verifies that the added device type matches the expected value (e.g., "Signal").

  Captures a specific GUI region (based on window-relative coordinates), uses Tesseract OCR to read the device type from the screen, and compares it to an expected value.  
  If the result matches, a green “PASS” popup appears for 3 seconds; otherwise, a red “FAIL” popup appears with the detected value.

- **Test_toolsmenu_build:**  
  Checks if the "Tools" menu is visible on the main Configurator window by performing OCR on the menu area.
  If the "Tools" menu is not detected, it opens the User Preferences window, enables the "Show Tools Menu" checkbox, and confirms the selection.
  After ensuring the Tools menu is visible, it proceeds to click the Tools menu and then the Build Job section, verifying the job has been loaded.

Customization and Extension
---------------------------
- More test cases can be added under the `tests/` folder and included in `test_runner.au3`.
- Coordinates used for mouse and screen capture interactions may require adjustments based on screen resolution and UI layout.
- You can customize OCR test regions by editing the `VerifyDeviceType()` function in `utils.au3`.

Limitations and Challenges
--------------------------
- This framework relies on coordinate-based mouse and screen interactions, which can break with resolution changes or UI layout differences.
- OCR results can be sensitive to font size, contrast, and rendering — test region must be carefully aligned.
- Some dialogs or windows may not behave identically across Windows versions.
- No use of accessibility IDs or object recognition—this is by design to suit applications with owner-drawn controls.
- For dynamic or complex UI automation, extensions using ControlClick, OCR tuning, or additional DLLs may be required.

Acknowledgments
---------------
This project was developed by **Yichen Zhao** for demonstrating GUI test automation using AutoIt, in the context of a test framework assignment.
