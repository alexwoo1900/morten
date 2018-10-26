@echo off

set YEAR=%date:~0,4%
set MONTH=%date:~5,2%
set DAY=%date:~8,2%

set HOUR=%time:~0,2%
set MINUTE=%time:~3,2%
set SECOND=%time:~6,2%
set MILLISECOND=%time:~9,2%

set TMP_HOUR=%time:~1,1%
set NINE=9
set ZERO=0

%Fix hour%
if %HOUR% LEQ %NINE% set HOUR=%ZERO%%TMP_HOUR%

set CURTIME=%YEAR%/%MONTH%/%DAY% %HOUR%:%MINUTE%:%SECOND%.%MILLISECOND%
echo %CURTIME%
