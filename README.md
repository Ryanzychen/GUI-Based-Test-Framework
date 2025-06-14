AutoIt GUI Test Automation Framework
====================================

Author: Yichen Zhao  
Date: June 2025

Overview
--------
This project is a GUI-based test automation framework developed using AutoIt. It automates interactions with Windows Notepad as a demonstration of simulating user behaviors such as clicking menus and saving files. While Notepad is used as the target application, the framework is designed to be extendable to other Windows desktop applications.

The goal of this project is to showcase how AutoIt can be used to implement an efficient, script-driven, coordinate-based GUI testing solution with logging capabilities and modular test structure.

Project Structure
-----------------
.
├── lib/
│   └── utils.au3          ; Utility functions (logging, launching apps, relative clicks)
├── tests/
│   ├── test_case1.au3     ; Test Case 1: Click "Help > About Notepad" and close it
│   └── test_case2.au3     ; Test Case 2: Type and save text, handle overwrite confirmation
├── test_runner.au3        ; Entry point that runs all test cases
└── test_log.txt           ; Test execution log (auto-generated)

How to Set Up and Run
---------------------
1. **System Requirements:**
   - Windows OS
   - [AutoIt v3](https://www.autoitscript.com/site/autoit/downloads/) installed

2. **Setup Instructions:**
   - Download or clone all project files and preserve the folder structure as shown above.
   - Open any of the `.au3` scripts with **SciTE (AutoIt Script Editor)** or right-click and select “Run Script”.

3. **To Run the Full Test Suite:**
   - Execute `test_runner.au3`. This will:
     - Clear and initialize the test log file
     - Execute Test Case 1 and Test Case 2 sequentially
     - Display a completion message
     - Write detailed logs to `test_log.txt` in the same directory

Log File Details
----------------
- Log file location: `<project_directory>\test_log.txt`
- Each log entry includes a timestamp and step description.
- Errors (like window not found or Save As dialog not appearing) are also logged for debugging.

Test Case Descriptions
----------------------
- **Test Case 1:**  
  Launches Notepad, simulates clicking on “Help” > “About Notepad”, verifies the dialog, and closes it.

- **Test Case 2:**  
  Launches Notepad, types a line of text, saves the file to the current directory as `TestFile.txt`, and handles overwrite confirmation if the file already exists.

Customization and Extension
---------------------------
- To test other Windows applications, replace `"notepad.exe"` and update window titles and UI coordinates.
- More test cases can be added under the `tests/` folder and included in `test_runner.au3`.
- Coordinates used for mouse interactions may require adjustments based on screen resolution and UI changes.

Limitations and Challenges
--------------------------
- This framework relies on coordinate-based mouse interactions, which can break with resolution changes or UI layout differences.
- Some dialogs or windows may not behave identically across Windows versions.
- No use of accessibility IDs or object recognition—this is by design to suit applications with owner-drawn controls.
- For dynamic or complex UI automation, extensions using ControlClick or additional DLLs may be required.

Acknowledgments
---------------
This project was developed by **Yichen Zhao** for demonstrating GUI test automation using AutoIt, in the context of a test framework assignment.
