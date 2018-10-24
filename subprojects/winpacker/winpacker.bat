@echo off

call %~dp0pycheck.bat

if %ERRORLEVEL% == 0 (
    call %~dp0pypack.bat %~1
    echo Packed
) else (
    echo Cannot satisfy presupposition condition of packing Python program in Windows
)