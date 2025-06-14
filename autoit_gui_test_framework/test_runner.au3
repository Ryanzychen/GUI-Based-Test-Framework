#include "lib/utils.au3"
#include "tests/test_case1.au3"
#include "tests/test_case2.au3"

LogToFile("Test Runner started.")

LogToFile("Running Test Case 1")
TestCase1()

Sleep(1000)

LogToFile("Running Test Case 2")
TestCase2()

MsgBox(64, "Test Runner", "All tests completed. See " & $g_logFile & " for details.")



