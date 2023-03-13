@echo on
rem ##################################################################################################
rem FileName:            service_area_error_mail.bat
rem Description:        This is the generic batch script to send error extract to users
rem Last Modified:      (See Modification History)
rem ################################################################################################################################################
rem
rem Modification History
rem
rem Date                               Author                                              Modifications
rem -----------------------------------------------------------------------------------------------------------------------------------------------rem ################################################################################################################################################

cd /d D:\JDABatch\batch\cmd

call D:\JDABatch\fwk\batchenv.bat

ECHO **************************Batch Job Started******************************  >> %LOG_FILE% 2>>&1
echo **********************************

set error_sub='Service Area to Zone mapping error'
rem set error_mail_rec="REDACTED"
set error_mail_rec="REDACTED"
set run_date=%date:~4,2%%date:~7,2%%date:~10,4%
set sftp_outbox=D:\SFTP\outbox

set batch_outbox=D:\JDABatch\data\out\archive

set FWK_DIR=D:\JDABatch\fwk

set "cmd=FINDSTR /R /N "^.*" %batch_outbox%\JDA_NO_ZONE_MAPPING_%run_date%*.csv | FIND /C ":""

for /f %%a in ('!cmd!') do set number=%%a
echo %number% >> %LOG_FILE% 2>>&1

if %number% gtr 1 (
rem COPY /b %sftp_outbox%\JDA_NO_ZONE_MAPPING_%run_date%*.dat %batch_outbox%\JDA_ERROR_SUMMARY_%run_date%*.csv>> %LOG_FILE% 2>>&1

rem powershell .\error_extract_mail.ps1 %FWK_DIR%\email_body.log 'Error Extract Summary for JDA Flow' "REDACTED" REDACTED REDACTED %batch_outbox% JDA_ERROR_SUMMARY_%run_date%*.csv>> %LOG_FILE% 2>>&1
powershell .\error_extract_mail.ps1 %FWK_DIR%\email_body.log %error_sub% %error_mail_rec% REDACTED REDACTED %batch_outbox% JDA_NO_ZONE_MAPPING_%run_date%*.csv>> %LOG_FILE% 2>>&1

rem Note: SMTP servers are different for Kansas and Dallas below are details
rem For Dallas use REDACTED
rem For Kansas use REDACTED
)

set batch_status=%errorlevel%

If NOT %batch_status% == 0 goto error

del %batch_outbox%\JDA_NO_ZONE_MAPPING_%run_date%*.csv>> %LOG_FILE% 2>>&1 


goto end


:end
ECHO **************************Batch Job Ended********************************  >> %LOG_FILE% 2>>&1
echo Batch Job  Ended : %date% %time% >> %LOG_FILE% 2>>&1
Echo *************************************************************************  >> %LOG_FILE% 2>>&1
pushd %BATCH_PATH%\
exit /b 0


:error
echo Error Occured while sending email >> %LOG_FILE% 2>>&1
pushd %BATCH_PATH%\
exit /b 1