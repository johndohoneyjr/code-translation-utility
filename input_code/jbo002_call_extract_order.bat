echo on
rem ####################################################################
rem FileName:          jbo002_call_extract_order.bat
rem Description:       Prepare the Order Export for TNG
rem Note:           
rem #################################################################### 
rem Modification History
rem
rem Date			Author					Modifications
rem --------------------------------------------------------------------
rem  28-APR-2017	REDACTED			Initial Version
rem 
rem ####################################################################

cd /d D:\JDABatch\batch\cmd

call D:\JDABatch\fwk\batchenv.bat

set run_date=%date:~10,4%%date:~4,2%%date:~7,2%
set run_time=%date:~4,2%%date:~7,2%%date:~10,4%_%time:~0,2%%time:~3,2%%time:~6,2%
set run_time=%run_time: =0%

SET NLS_DATE_FORMAT=RRRR-MM-DD-HH24:MI

FOR /F "TOKENS=1* DELIMS= " %%A IN ('DATE/T') DO SET CDATE=%%B
FOR /F "TOKENS=1,2 eol=/ DELIMS=/ " %%A IN ('DATE/T') DO SET mm=%%B
FOR /F "TOKENS=1,2 DELIMS=/ eol=/" %%A IN ('echo %CDATE%') DO SET dd=%%B
FOR /F "TOKENS=2,3 DELIMS=/ " %%A IN ('echo %CDATE%') DO SET yyyy=%%B
SET todaysdate=%yyyy%%mm%%dd%
SET WORKFLOWLOGMONTH=%mm%%yyyy%
SET DATETIMESTAMP=%todaysdate%
for /f "tokens=1-3 delims=:." %%a in ("%time%") do SET timestamp=%%a%%b%%c
for /f "tokens=1-3 delims= " %%a in ("%timestamp%") do SET trimmed_timestamp=%%a%%b%%c
SET TIMESTAMP=%DATETIMESTAMP%_%trimmed_timestamp%

set batch_home=D:\JDABatch
set sql_home=%batch_home%\batch\sql
rem set batch_outbox=%batch_home%\data\out
set batch_out_arch=%batch_home%\data\out\archive
set sftp_outbox=D:\SFTP\outbox

set datafile=JDA_RECSHIP_%run_time%
set logfile=%batch_home%\log\jbo002_call_extract_order_%TIMESTAMP%.log

echo ---------------------------------------------- >> %logfile% 2>>&1
echo Extract Process Started at %time%, %date% >> %logfile% 2>>&1
echo Output will be written to file %datafile%.dat >> %logfile% 2>>&1
echo.  >> %logfile% 2>>&1

rem call %batch_home%\fwk\run_process.bat jbo002_extract_order %datafile% >> %logfile% 2>>&1
call sqlplus -s %BATCHUSER%/%BATCHPWD%@%ORACLE_SID% @%sql_home%\jbo002_extract_order.sql %datafile% >> %logfile% 2>>&1

IF NOT %ERRORLEVEL% == 0 GOTO errorblock

if not exist %sftp_outbox%\%datafile%.dat (
echo.  >> %logfile% 2>>&1
echo Extract File doesn't exist, please investigate... >> %logfile% 2>>&1
GOTO errorblock
)

echo Extract file successfully generated at %time% >> %logfile% 2>>&1

copy /b %sftp_outbox%\%datafile%.dat %batch_out_arch%\%datafile%.dat >> %logfile% 2>>&1

IF NOT %ERRORLEVEL%  == 0 GOTO errorblock

goto end

:errorblock
popd
echo.  >> %logfile% 2>>&1
echo *** FAILURE ***  >> %logfile% 2>>&1
echo *** Extract Process Failed at %time% >> %logfile% 2>>&1
echo *** Return Code = %ERRORLEVEL% >> %logfile% 2>>&1
exit /B 1

:end
echo.  >> %logfile% 2>>&1
echo Extract Process Ended Successfully at %time% >> %logfile% 2>>&1
echo Return Code = %ERRORLEVEL% >> %logfile% 2>>&1
popd
exit /B 0

popd