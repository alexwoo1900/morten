@echo off
setlocal EnableDelayedExpansion
echo ***************************************************
echo *                                                 *
echo *               Image Convertor                   *
echo *               Version: 0.1                      *
echo *               Author: Alex                      *
echo *               Update: 2019/8/27                 *
echo *                                                 *
echo ***************************************************
echo.
echo [STATE] Image Convertor starting...
for %%a in (%*) do set /a argc+=1
if defined argc (
    echo [STATE] Argument found
) else (
    echo [STATE] Argument not found
    echo Usage: 
    echo       imgConvertor.bat {targetFolderPath^(Contained CH/EN^)}
    pause
    exit /b 2
)

set FLAG_CH=1
set FLAG_EN=1

if exist "%tmp%\GetImgInfo.vbs" (
    echo [STATE] GetImgInfo script found
) else (
    echo [STATE] GetImgInfo script not found
    echo [STATE] Preparing to create GetImgInfo in your temperary folder
    call :CreateGetImgInfo
    echo [STATE] GetImgInfo script created
)

if exist "%~1\CH" (
    echo [STATE] CH folder found
) else (
    echo [STATE] CH folder not found
    set FLAG_CH=0
)

if exist "%~1\EN" (
    echo [STATE] EN folder found
) else (
    echo [STATE] EN folder not found
    set FLAG_EN=0
)

if %FLAG_CH% == 0 (
    if %FLAG_EN% == 0 (
        echo [STATE] No target folder
        pause
        exit /b 1
    )
)
echo.
echo ---------------------------------------------------
echo.
echo                   Task list
echo.
if %FLAG_CH% == 1 (
    echo [c] Convert images in CH folder
)
if %FLAG_EN% == 1 (
    echo [e] Convert images in EN folder
)
echo [a] Convert images in all target folders ^(default^)
echo.
set /p MODE="Please enter your action: "
:Processing

set PREF_ADDR=NFADDR_
set PREF_PIC=PICADD_
set PREF=NF_
set FORMAT=*.bmp


if "%MODE%"=="e" goto ProcessingEN

:ProcessingCH
echo.
echo Converting...
set TARGET=CH
set SUBF=_CH
set /a CH_IMAGE_COUNT=0
set /a CH_IMAGE_INDEX=0
set /a CH_IMAGE_HANDLE_PERCENTAGE=0

cd /d %~1\%TARGET%

for /f "delims=" %%a in ('dir /a-d/s/b %FORMAT%') do (
    set /a CH_IMAGE_COUNT+=1
)

set /p=[<nul 1>con
(for /f "delims=" %%a in ('dir /a-d/s/b %FORMAT%') do (
    for /f "tokens=1-4 delims=x" %%b in ('cscript -nologo "%tmp%\GetImgInfo.vbs" "%%~sa"') do (
        set /a CH_IMAGE_INDEX+=1
        set /a CH_IMAGE_CURRENT_PERCENTAGE=!CH_IMAGE_INDEX!00/%CH_IMAGE_COUNT%
        set /a CH_IMAGE_CURRENT_PROGRESS=!CH_IMAGE_CURRENT_PERCENTAGE!-!CH_IMAGE_HANDLE_PERCENTAGE!
        if !CH_IMAGE_CURRENT_PROGRESS! == 4 (
            set /p=■<nul 1>con
            set /a CH_IMAGE_HANDLE_PERCENTAGE+=4
        )
        echo #define %PREF_ADDR%%%~na%SUBF% ^(%PREF_ADDR%%%~na%SUBF% +  ^(%%~b * %%~c^) *POINTPIXEL_SIZE^) ^{%PREF%%%~na, %%~b, %%~c, %PREF_ADDR%%%~na%SUBF% , %PREF_PIC%%%~na%SUBF%^}, 文件名: %%~nxa   路径: %%~dpa
    )
))>"%~1\%TARGET%\CH.txt"
set /p=]<nul 1>con

echo.
echo Task ^(%TARGET%^) Finished!

if "%MODE%"=="c" goto Finished

:ProcessingEN
echo.
echo Converting...
set TARGET=EN
set SUBF=_EN
set /a EN_IMAGE_COUNT=0
set /a EN_IMAGE_INDEX=0
set /a EN_IMAGE_HANDLE_PERCENTAGE=0

cd /d %~1\%TARGET%

for /f "delims=" %%a in ('dir /a-d/s/b %FORMAT%') do (
    set /a EN_IMAGE_COUNT+=1
)

set /p=[<nul 1>con
(for /f "delims=" %%a in ('dir /a-d/s/b %FORMAT%') do (
    for /f "tokens=1-4 delims=x" %%b in ('cscript -nologo "%tmp%\GetImgInfo.vbs" "%%~sa"') do (
        set /a EN_IMAGE_INDEX+=1
        set /a EN_IMAGE_CURRENT_PERCENTAGE=!EN_IMAGE_INDEX!00/%EN_IMAGE_COUNT%
        set /a EN_IMAGE_CURRENT_PROGRESS=!EN_IMAGE_CURRENT_PERCENTAGE!-!EN_IMAGE_HANDLE_PERCENTAGE!
        if !EN_IMAGE_CURRENT_PROGRESS! == 4 (
            set /p=■<nul 1>con
            set /a EN_IMAGE_HANDLE_PERCENTAGE+=4
        )
        echo #define %PREF_ADDR%%%~na%SUBF% ^(%PREF_ADDR%%%~na%SUBF% +  ^(%%~b * %%~c^) *POINTPIXEL_SIZE^) ^{%PREF%%%~na, %%~b, %%~c, %PREF_ADDR%%%~na%SUBF% , %PREF_PIC%%%~na%SUBF%^}, 文件名: %%~nxa   路径: %%~dpa
    )
))>"%~1\%TARGET%\EN.txt"
set /p=]<nul 1>con

echo.
echo Task ^(%TARGET%^) Finished!

:Finished
echo.
echo ---------------------------------------------------

echo.
set /p FLAG_CLEAN="Do you want to delete GetImgInfo script? [y/n(default)]"
if "%FLAG_CLEAN%"=="y" del /a "%tmp%\GetImgInfo.vbs"
pause
exit /b 0

:CreateGetImgInfo
(echo On Error Resume Next
echo Dim Img
echo Set Img = CreateObject^("WIA.ImageFile"^)
echo Img.LoadFile WScript.Arguments^(0^)
echo Wscript.Echo Img.Width ^& "x" ^& Img.Height ^& "x" ^& Img.HorizontalResolution)>"%tmp%\GetImgInfo.vbs"
goto :eof