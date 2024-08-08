@echo off
color f2
echo Safe mode will prevent external DLLs from loading and start with an empty User Data.
ping -n 3 127.0.0.1>nul
rem "--cb-safemode-empty-user-data --flag-switches-begin --disable-direct-write --flag-switches-end" may be added
start chrome.exe --cb-safemode --cb-disable-components-auto-update -disable-gpu
exit