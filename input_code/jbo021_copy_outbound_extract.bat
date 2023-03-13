ECHO ON
REM ####################################################################
REM FileName:          jbo021_copy_outboundextract.bat
REM Description:       Prepare the Fcst Export for TNG
REM Note:
REM ####################################################################
REM Modification History
REM
REM Date            Author                    Modifications
REM --------------------------------------------------------------------
rem  04-Jul-2018    REDACTED            Initial Version
rem  02-Jun-2020	REDACTED	Added delete to remove previous day Planning_Extract file from Outbox
REM
REM ####################################################################



ECHO **************************outboundextract EXTRACT STARTED************************************************  >> %LOG_FILE% 2>>&1
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
SET todaysdate=%yyyy%%mm%%dd%
SET WORKFLOWLOGMONTH=%mm%%yyyy%
SET DATETIMESTAMP=%todaysdate%
FOR /f "tokens=1-3 delims=:." %%A IN ("%time%") DO SET TIMESTAMP=%%A%%b%%C
FOR /f "tokens=1-3 delims= " %%A IN ("%timestamp%") DO SET trimmed_timestamp=%%A%%b%%C
SET TIMESTAMP=%DATETIMESTAMP%_%trimmed_timestamp%
SET datafile=JDA_PLANNING_EXTRACT_%run_time%

ECHO -------------------------------------------------------- >> %LOG_FILE% 2>>&1
ECHO Removing previous day Planning_Extract file from Outbox AT %TIME%, %DATE% >> %LOG_FILE% 2>>&1
DEL %SFTP_OUT_DIR%\JDA_PLANNING_EXTRACT*.dat  >> %LOG_FILE% 2>>&1
ECHO Previous day Planning_Extract file has been deleted  AT %TIME%, %DATE% >> %LOG_FILE% 2>>&1
ECHO ---------------------------------------------- >> %LOG_FILE% 2>>&1

ECHO ---------------------------------------------- >> %LOG_FILE% 2>>&1
ECHO EXTRACT PROCESS Started AT %TIME%, %DATE% >> %LOG_FILE% 2>>&1
ECHO Output will be written TO FILE %DATAFILE%.dat>> %LOG_FILE% 2>>&1
ECHO. >> %LOG_FILE% 2>>&1
CALL sqlplus -s %BATCH_LOGIN% @%SQL_DIR%\jbo021_outbound_extract.sql %datafile% >> %LOG_FILE% 2>>&1

ECHO EXTRACT PROCESS Ended AT %TIME%, %DATE% >> %LOG_FILE% 2>>&1
ECHO ---------------------------------------------- >> %LOG_FILE% 2>>&1



IF NOT %ERRORLEVEL% == 0 GOTO errorblock

IF NOT EXIST %SFTP_OUT_DIR%\%datafile%.dat (
ECHO.  >> %LOG_FILE% 2>>&1
ECHO Extract File does not exist, please investigate... >> %LOG_FILE% 2>>&1
GOTO errorblock
)

ECHO Extract file successfully generated at %time% >> %LOG_FILE% 2>>&1

COPY /b %SFTP_OUT_DIR%\%datafile%.dat %OUT_ARCH_DIR%\%datafile%.dat >> %LOG_FILE% 2>>&1

IF NOT %ERRORLEVEL%  == 0 GOTO errorblock

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