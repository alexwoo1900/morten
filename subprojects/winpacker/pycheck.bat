@echo off

%Python Check%

:pycheck

echo Checking if python has been installed...

for /f "tokens=1,2" %%a in ('python --version 2^>^&1 ^| findstr /c:"Python"') do (
    
    set PYKW=%%a
    set PYVER=%%b
    
    if "%PYKW%" == "Python" (
        echo python v%PYVER% installed
        goto pipcheck
    ) else (
        echo python: command not found
    )
    
)

goto checkfail

%PIP Check%

:pipcheck

echo Checking if pip has been installed...

for /f "tokens=1,2" %%a in ('pip --version ^| findstr /c:"pip"') do (

    set PIPKW=%%a
    set PIPVER=%%b
    
    if "%PIPKW%" == "pip" (
        echo pip v%PIPVER% installed
        goto pyicheck
    ) else (
        echo pip: command not found
    )
    
)

goto checkfail

%Pyinstaller Check%

:pyicheck

echo Checking if pyinstaller has been installed...

for /f "tokens=1" %%a in ('pyinstaller --version 2^>^&1') do (
    
    set PYIVER=%%a
    if "%PYIVER%" neq "" (
        echo pyinstaller v%PYIVER% installed
        exit /b 0
    ) else (
        echo pyinstaller: command not found
    )
    
)

goto checkfail


%Check failed%

:checkfail

exit /b 1

%Begin to pack%

