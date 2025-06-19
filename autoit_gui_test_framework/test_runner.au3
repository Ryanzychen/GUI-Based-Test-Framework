#include "lib/utils.au3"
#include "tests/test_launch_about.au3"
#include "tests/test_add_device.au3"
#include "tests/test_toolsmenu_build.au3"

LogToFile("Test Runner started.")

LogToFile("Running Test Launch About")
Test_launch_about()

Sleep(1000) ; short pause between tests

LogToFile("Running Test Add Device")
Test_add_device()

Sleep(1000) ; short pause between tests

LogToFile("Running Test Tools Menu and Build")
Test_toolsmenu_build()

LogToFile("All tests completed.")

MsgBox(64, "Test Runner", "All tests completed. See log file for details: " & $g_logFile)
