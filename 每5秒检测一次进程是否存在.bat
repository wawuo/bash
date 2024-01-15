@echo off
:loop
    tasklist | find /i "iVMS-4200.Framework.C.exe" > nul
    if errorlevel 1 (
        echo Process is not running, starting process.
        start "" "C:\Program Files (x86)\iVMS-4200 Site\iVMS-4200 Client\Client\iVMS-4200.Framework.C.exe"
    ) else (
        echo Process is running.
    )
    timeout /t 5
goto loop
