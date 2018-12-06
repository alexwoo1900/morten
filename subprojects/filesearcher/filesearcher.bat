@echo off
echo *****************************
echo *                           *
echo *    File Search Helper     *
echo *    Version: 0.1           *
echo *    Author: Alex           *
echo *    Update: 2018/12/5      *
echo *                           *
echo *****************************
set /a tn=0
:LOOP
set /a tn=%tn%+1
set /p path="Enter your file path: "
set /p kw="Enter your keyword for searching: "
echo =============================
echo Task %tn% processing
echo File: %path%
for /f "delims=" %%i in ('type %path% ^| find /v /c ""') do set lc=%%i
echo Line Count: %lc%
echo Keyword: %kw%
for /f "delims=" %%i in ('type %path% ^| find /c "%kw%"') do set kwc=%%i
echo Keyword Count: %kwc%
echo Task %tn% done
echo =============================

set /p choice="Do you want to start another task? (yes/no,default yes)"
if not "%choice%"=="no" goto LOOP