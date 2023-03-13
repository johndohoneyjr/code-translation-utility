ECHO ON
REM ####################################################################
REM FileName:          jbs003_call_recon_promo_up_level1_Mon.bat
REM Description:       Call Reconcile Processes
REM Note:
REM ####################################################################
REM Modification History
REM
REM Date            Author                    Modifications
REM --------------------------------------------------------------------
REM
REM ####################################################################



ECHO ************************** PROCESS STARTED************************************************  >> %LOG_FILE% 2>>&1
ECHO  %DATE% %TIME% >> %LOG_FILE% 2>>&1
ECHO *************************************************************************************  >> %LOG_FILE% 2>>&1


SET run_date=%date:~10,4%%date:~4,2%%date:~7,2%
SET run_time=%date:~4,2%%date:~7,2%%date:~10,4%_%time:~0,2%%time:~3,2%%time:~6,2%
SET run_time=%run_time: =0%


SET NLS_DATE_FORMAT=RRRR-MM-DD-HH24:MI

FOR /F "TOKENS=1* DELIMS= " %%A IN ('DATE/T') DO SET CDATE=%%B
FOR /F "TOKENS=1,2 eol=/ DELIMS=/ " %%A IN ('DATE/T') DO SET mm=%%B
FOR /F "TOKENS=1,2 DELIMS=/ eol=/" %%A IN ('ECHO %CDATE%') DO SET dd=%%B
FOR /F "TOKENS=2,3 DELIMS=/ " %%A IN ('ECHO %CDATE%') DO SET yyyy=%%B
for /f %%a in ('date /t') do set DAY=%%a
echo DOW IS %DAY%>> %LOG_FILE% 2>>&1
SET todaysdate=%yyyy%%mm%%dd%
SET WORKFLOWLOGMONTH=%mm%%yyyy%
SET DATETIMESTAMP=%todaysdate%
FOR /f "tokens=1-3 delims=:." %%A IN ("%time%") DO SET TIMESTAMP=%%A%%b%%C
FOR /f "tokens=1-3 delims= " %%A IN ("%timestamp%") DO SET trimmed_timestamp=%%A%%b%%C
SET TIMESTAMP=%DATETIMESTAMP%_%trimmed_timestamp%

ECHO ---------------------------------------------- >> %LOG_FILE% 2>>&1
ECHO EXTRACT PROCESS Started AT %TIME%, %DATE% >> %LOG_FILE% 2>>&1
ECHO. >> %LOG_FILE% 2>>&1

  
if %DAY%==Tue ( 
SET job_name=%XML_DIR%\jbs003_recon_promo_up_level1_Mon
call %FWK_DIR%\run_process.bat jbs003_recon_promo_up_level1_Mon
echo Monday Reconcile Promo up lvl1 process Completed >> %LOG_FILE% 2>>&1
)

ECHO PROCESS Ended AT %TIME%, %DATE% >> %LOG_FILE% 2>>&1
ECHO ---------------------------------------------- >> %LOG_FILE% 2>>&1


IF NOT %ERRORLEVEL% == 0 GOTO errorblock

GOTO end

:errorblock
POPD
ECHO.  >> %LOG_FILE% 2>>&1
ECHO *** FAILURE ***  >> %LOG_FILE% 2>>&1
ECHO *** Process Failed at %time% >> %LOG_FILE% 2>>&1
ECHO *** Return Code = %ERRORLEVEL% >> %LOG_FILE% 2>>&1
EXIT /B 1

:end
ECHO.  >> %LOG_FILE% 2>>&1
ECHO Process Ended Successfully at %time% >> %LOG_FILE% 2>>&1
ECHO Return Code = %ERRORLEVEL% >> %LOG_FILE% 2>>&1
POPD
EXIT /B 0

POPD