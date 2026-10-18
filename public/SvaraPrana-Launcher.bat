@echo off
title SvaraPrana - Ambient Acoustic Care Bridge
color 0A
echo ======================================================================
echo   SvaraPrana (स्वरप्राण) - Zero-Hardware Ambient Acoustic Care Bridge
echo   SaarthiX Hackathon 2026 - Production Engine
echo ======================================================================
echo.
echo Launching SvaraPrana FastAPI Telephony Backend and Web Suite...
start http://localhost:8000
python server.py
pause
