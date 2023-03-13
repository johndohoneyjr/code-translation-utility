******************************************************************{
  "error": {
    "message": "You requested a length 0 completion, but you did not set the 'echo' parameter. That means that we will return no data to you. (HINT: set 'echo' to true in order for the API to echo back the prompt to you.)",
    "type": "invalid_request_error",
    "param": null,
    "code": null
  }
}
******************************************************************
@ECHO OFF
REM ####################################################################
REM FileName:          jbo026_copy_duplicate_dfu.bat
REM Description:       Extract duplicate dfu
REM Note:
REM ####################################################################
REM Modification History
REM
REM Date            Author                    Modifications
REM --------------------------------------------------------------------
rem 17-Jun-2019    REDACTED         Initial Version
REM
REM ####################################################################



ECHO **************************Duplicate DFU EXTRACT STARTED************************************************  >> %LOG_FILE% 2>>&1
ECHO  %DATE% %TIME% >> %LOG_FILE% 2>>&1
ECHO *************************************************************************************  >> %LOG_FILE% 2>>&1


SET run_date=%date:~10,4%%date:~4,2%%date:~7,2%
SET run_time=%date:~4,2%%date:~7,2%%date:~10,4%_%time:~0,2%%time:~3,2%%time:~6,2%
SET run_time=%run_time: =0%
SET Extarct_dir="D:\jdabatch\batch\util"
set BLAT="D:\jdabatch\batch\util\blat.exe"
set CC=REDACTED.REDACTED@REDACTED.com,REDACTED.REDACTED@REDACTED.com
rem set RETURN_EMAIL=REDACTED.REDACTED@REDACTED.com,REDACTED.REDACTED@REDACTED.com,REDACTED.REDACTED@REDACTED.com,REDACTED.REDACTED@REDACTED.com,REDACTED.REDACTED@REDACTED.com,REDACTED.REDACTED@REDACTED.com,REDACTED.Tyran@REDACTED.com,REDACTED.REDACTED@REDACTED.com,REDACTED.REDACTED@REDACTED.com,REDACTED.REDACTED@REDACTED.com,REDACTED.REDACTED@REDACTED.com
set RETURN_EMAIL=REDACTED.REDACTED@REDACTED.com,REDACTED.REDACTED@REDACTED.com,REDACTED.REDACTED@REDACTED.com,REDACTED.REDACTED@REDACTED.com,REDACTED.REDACTED@REDACTED.com,REDACTED.REDACTED@REDACTED.com,REDACTED.REDACTED@REDACTED.com,REDACTED.REDACTED@REDACTED.com,REDACTED.REDACTED@REDACTED.com,REDACTED.REDACTED@REDACTED.com,REDACTED.REDACTED@REDACTED.com

SET NLS_DATE_FORMAT=RRRR-MM-DD-HH24:MI

FOR /F "TOKENS=1* DELIMS= " %%A IN ('DATE/T') DO SET CDATE=%%B
FOR /F "TOKENS=1,2 eol=/ DELIMS=/ " %%A IN ('DATE/T') DO SET mm=%%B
FOR /F "TOKENS=1,2 DELIMS=/ eol=/" %%A IN ('ECHO %CDATE%') DO SET dd=%%B
FOR /F "TOKENS=2,3 DELIMS=/ " %%A IN ('ECHO %CDATE%') DO SET yyyy=%%B
SET todaysdate=%yyyy%%mm%%dd%
SET WORKFLOWLOGMONTH=%mm%%yyyy%
SET DATETIMESTAMP=%todaysdate%
FOR /f "tokens=1-3 delims=:." %%A IN ("%time%") DO SET TIMESTAMP=%%A%%b%%C
FOR /f "tokens=1-3 delims= " %%A IN ("%timestamp%") DO SET trimmed_timestamp=%%A%%b%%C
SET TIMESTAMP=%DATETIMESTAMP%_%trimmed_timestamp%
SET datafile=JDA_Duplicate_DFU_%run_time%



ECHO ---------------------------------------------- >> %LOG_FILE% 2>>&1
ECHO EXTRACT PROCESS Started AT %TIME%, %DATE% >> %LOG_FILE% 2>>&1
ECHO Output will be written TO FILE %DATAFILE%.dat>> %LOG_FILE% 2>>&1
ECHO. >> %LOG_FILE% 2>>&1
CALL sqlplus -s %BATCH_LOGIN% @%SQL_DIR%\jbo026_extract_duplicate_dfu.sql %datafile% >> %LOG_FILE% 2>>&1

ECHO ---------------------------------------------- >> %LOG_FILE% 2>>&1
ECHO EXTRACT PROCESS Ended AT %TIME%, %DATE% >> %LOG_FILE% 2>>&1



IF NOT %ERRORLEVEL% == 0 GOTO errorblock

IF NOT EXIST %Extarct_dir%\%datafile%.dat (
ECHO.  >> %LOG_FILE% 2>>&1
ECHO Extract File doesn't exist, please investigate... >> %LOG_FILE% 2>>&1
GOTO errorblock
)

ECHO Extract file successfully generated at %time% >> %LOG_FILE% 2>>&1

COPY /b %Extarct_dir%\%datafile%.dat %OUT_ARCH_DIR%\%datafile%.dat >> %LOG_FILE% 2>>&1

echo Copies extarct file to Archive folder >> %LOG_FILE% 2>>&1

IF NOT %ERRORLEVEL%  == 0 GOTO errorblock


GOTO Notify

:Notify
SET /A maxlines= 2
set "cmd=findstr /R /N "^^" "%Extarct_dir%\%datafile%.dat" | find /C ":""
 for /f %%a in ('!cmd!') do set linecount=%%a
GOTO NEXT

:NEXT 
 IF %linecount% GEQ %maxlines% GOTO EMAIL

 

echo %Date% %Time% No data found >> %LOG_FILE% 2>>&1


%BLAT% -body "This is an automated mail. Please do not reply : No Duplicate DFU found " -subject "REDACTED-No Duplicate DFU found" -f %computername%@REDACTED.com -to "REDACTED.REDACTED@REDACTED.com" -server REDACTED.REDACTED.com

GOTO end

:EMAIL
%BLAT% -body "This is an automated mail. Please do not reply : Attached herewith the list of duplicate dfus found.Please delete one of DFU to avoid batch issue." -subject "REDACTED- Duplicate DFU Found" -f %computername%@REDACTED.com -to %RETURN_EMAIL% -c %CC% -attach %Extarct_dir%\%datafile%.dat -server REDACTED.REDACTED.com

GOTO end

:errorblock
POPD
ECHO.  >> %LOG_FILE% 2>>&1
ECHO *** FAILURE ***  >> %LOG_FILE% 2>>&1
ECHO *** Extract Process Failed at %time% >> %LOG_FILE% 2>>&1
ECHO *** Return Code = %ERRORLEVEL% >> %LOG_FILE% 2>>&1
EXIT /B 1

:end
ECHO.  >> %LOG_FILE% 2>>&1
ECHO Extract Process Ended Successfully at %time% >> %LOG_FILE% 2>>&1
ECHO Return Code = %ERRORLEVEL% >> %LOG_FILE% 2>>&1
POPD
EXIT /B 0

POPD