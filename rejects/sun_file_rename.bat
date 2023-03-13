******************************************************************{
  "error": {
    "message": "You requested a length 0 completion, but you did not set the 'echo' parameter. That means that we will return no data to you. (HINT: set 'echo' to true in order for the API to echo back the prompt to you.)",
    "type": "invalid_request_error",
    "param": null,
    "code": null
  }
}
******************************************************************
echo off
rem ################################################################################################################################################
rem FileName:          sun_file_rename.bat
rem Description:       
rem Author:            
rem Date Created:       
rem Last Modified:      (See Modification History)
rem ################################################################################################################################################
rem
rem Modification History
rem
rem Date                               Author                                              Modifications
rem -----------------------------------------------------------------------------------------------------------------------------------------------
rem  18-MAY-2017                   KAMALESH MISHRA                                         Initial Version
rem ################################################################################################################################################

cd /d D:\JDABatch\batch\cmd

call D:\JDABatch\fwk\batchenv.bat

set sftp_inbox=D:\SFTP\inbox
set batch_inbox=D:\JDABatch\data\in
set batch_log=D:\JDABatch\log
set batch_inbox_archive=D:\JDABatch\data\in\archive

set run_date=%date:~10,4%%date:~4,2%%date:~7,2%
set run_time=%date:~4,2%%date:~7,2%%date:~10,4%_%time:~0,2%%time:~3,2%%time:~6,2%
set run_time=%run_time: =0%
set log_file=SUN_FILE_RENAME_%run_time%.log

ECHO ************************** SUN_FILE_RENAME STARTED ************************************************  > %batch_log%\%log_file% 2>>&1
echo SUN_FILE_RENAME STARTED: %date% %time% >> %batch_log%\%log_file% 2>>&1
Echo *************************************************************************************   >> %batch_log%\%log_file% 2>>&1
IF EXIST %sftp_inbox%\JDA_DMDUNIT_%run_date%*.dat IF EXIST %sftp_inbox%\JDA_LOC_%run_date%*.dat IF EXIST %sftp_inbox%\JDA_DFUVIEW_%run_date%*.dat IF EXIST %sftp_inbox%\JDA_NPI_%run_date%*.dat IF EXIST %sftp_inbox%\JDA_POSHIST_%run_date%*.dat IF EXIST %sftp_inbox%\JDA_REFUSAL_SAP_%run_date%*.dat IF EXIST %sftp_inbox%\JDA_REFUSAL_COMPUTAC_%run_date%*.dat IF EXIST %sftp_inbox%\JDA_STORECREDIT_SAP_%run_date%*.dat IF EXIST %sftp_inbox%\JDA_STORECREDIT_COMPUTAC_%run_date%*.dat IF EXIST %sftp_inbox%\JDA_SCHEDRCPTS_SAP_%run_date%*.dat IF EXIST %sftp_inbox%\JDA_SCHEDRCPTS_COMPUTAC_%run_date%*.dat IF EXIST %sftp_inbox%\JDA_OHAUDIT_%run_date%*.dat (

del %batch_inbox%\*.dat >> %batch_log%\%log_file%
echo OLD DAT FILES ARE DELETED FROM BATCH INBOX: %date% %time% >> %batch_log%\%log_file% 2>>&1

COPY /b %sftp_inbox%\JDA_DMDUNIT_%run_date%*.dat %batch_inbox%\jbi001_load_dmdunit.dat >> %batch_log%\%log_file% 2>>&1
COPY /b %sftp_inbox%\JDA_LOC_%run_date%*.dat %batch_inbox%\jbi002_load_loc.dat >> %batch_log%\%log_file% 2>>&1
COPY /b %sftp_inbox%\JDA_DFUVIEW_%run_date%*.dat %batch_inbox%\jbi003_load_dfuview.dat >> %batch_log%\%log_file% 2>>&1
COPY /b %sftp_inbox%\JDA_NPI_%run_date%*.dat %batch_inbox%\jbi014_load_npi.dat >> %batch_log%\%log_file% 2>>&1
COPY /b %sftp_inbox%\JDA_POSHIST_%run_date%*.dat %batch_inbox%\jbi010_load_pos.dat >> %batch_log%\%log_file% 2>>&1
COPY /b %sftp_inbox%\JDA_REFUSAL_SAP_%run_date%*.dat %batch_inbox%\jbi012_load_refusal_sap.dat >> %batch_log%\%log_file% 2>>&1
COPY /b %sftp_inbox%\JDA_REFUSAL_COMPUTAC_%run_date%*.dat %batch_inbox%\jbi012_load_refusal_computac.dat >> %batch_log%\%log_file% 2>>&1
COPY /b %sftp_inbox%\JDA_STORECREDIT_SAP_%run_date%*.dat %batch_inbox%\jbi011_load_storecredit_sap.dat >> %batch_log%\%log_file% 2>>&1
COPY /b %sftp_inbox%\JDA_STORECREDIT_COMPUTAC_%run_date%*.dat %batch_inbox%\jbi011_load_storecredit_computac.dat >> %batch_log%\%log_file% 2>>&1
COPY /b %sftp_inbox%\JDA_SCHEDRCPTS_SAP_%run_date%*.dat %batch_inbox%\jbi015_load_schedrcpts_sap.dat >> %batch_log%\%log_file% 2>>&1
COPY /b %sftp_inbox%\JDA_SCHEDRCPTS_COMPUTAC_%run_date%*.dat %batch_inbox%\jbi015_load_schedrcpts_computac.dat >> %batch_log%\%log_file% 2>>&1
COPY /b %sftp_inbox%\JDA_OHAUDIT_%run_date%*.dat %batch_inbox%\jbi013_load_ohaudit.dat >> %batch_log%\%log_file% 2>>&1

MOVE /Y %sftp_inbox%\JDA_DMDUNIT_%run_date%*.dat %batch_inbox_archive% >> %batch_log%\%log_file% 2>>&1
MOVE /Y %sftp_inbox%\JDA_LOC_%run_date%*.dat %batch_inbox_archive% >> %batch_log%\%log_file% 2>>&1
MOVE /Y %sftp_inbox%\JDA_DFUVIEW_%run_date%*.dat %batch_inbox_archive% >> %batch_log%\%log_file% 2>>&1
MOVE /Y %sftp_inbox%\JDA_NPI_%run_date%*.dat %batch_inbox_archive% >> %batch_log%\%log_file% 2>>&1
MOVE /Y %sftp_inbox%\JDA_POSHIST_%run_date%*.dat %batch_inbox_archive% >> %batch_log%\%log_file% 2>>&1
MOVE /Y %sftp_inbox%\JDA_REFUSAL_SAP_%run_date%*.dat %batch_inbox_archive% >> %batch_log%\%log_file% 2>>&1
MOVE /Y %sftp_inbox%\JDA_REFUSAL_COMPUTAC_%run_date%*.dat %batch_inbox_archive% >> %batch_log%\%log_file% 2>>&1
MOVE /Y %sftp_inbox%\JDA_STORECREDIT_SAP_%run_date%*.dat %batch_inbox_archive% >> %batch_log%\%log_file% 2>>&1
MOVE /Y %sftp_inbox%\JDA_STORECREDIT_COMPUTAC_%run_date%*.dat %batch_inbox_archive% >> %batch_log%\%log_file% 2>>&1
MOVE /Y %sftp_inbox%\JDA_SCHEDRCPTS_SAP_%run_date%*.dat %batch_inbox_archive% >> %batch_log%\%log_file% 2>>&1
MOVE /Y %sftp_inbox%\JDA_SCHEDRCPTS_COMPUTAC_%run_date%*.dat %batch_inbox_archive% >> %batch_log%\%log_file% 2>>&1
MOVE /Y %sftp_inbox%\JDA_OHAUDIT_%run_date%*.dat %batch_inbox_archive% >> %batch_log%\%log_file% 2>>&1


echo SUN_FILE_RENAME COMPLETED: %date% %time% >> %batch_log%\%log_file% 2>>&1
ECHO ************************** SUN_FILE_RENAME ENDED ******************************  >> %batch_log%\%log_file% 2>>&1
echo SUN_FILE_RENAME ENDED: %date% %time% >> %batch_log%\%log_file% 2>>&1
Echo *************************************************************************************   >> %batch_log%\%log_file% 2>>&1

GOTO success
)

IF NOT EXIST %sftp_inbox%\JDA_DMDUNIT_%run_date%*.dat GOTO end
IF NOT EXIST %sftp_inbox%\JDA_LOC_%run_date%*.dat GOTO end
IF NOT EXIST %sftp_inbox%\JDA_DFUVIEW_%run_date%*.dat GOTO end
IF NOT EXIST %sftp_inbox%\JDA_NPI_%run_date%*.dat GOTO end
IF NOT EXIST %sftp_inbox%\JDA_POSHIST_%run_date%*.dat GOTO end
IF NOT EXIST %sftp_inbox%\JDA_REFUSAL_SAP_%run_date%*.dat GOTO end
IF NOT EXIST %sftp_inbox%\JDA_REFUSAL_COMPUTAC_%run_date%*.dat GOTO end
IF NOT EXIST %sftp_inbox%\JDA_STORECREDIT_SAP_%run_date%*.dat GOTO end
IF NOT EXIST %sftp_inbox%\JDA_STORECREDIT_COMPUTAC_%run_date%*.dat GOTO end
IF NOT EXIST %sftp_inbox%\JDA_SCHEDRCPTS_SAP_%run_date%*.dat GOTO end
IF NOT EXIST %sftp_inbox%\JDA_SCHEDRCPTS_COMPUTAC_%run_date%*.dat GOTO end
IF NOT EXIST %sftp_inbox%\JDA_OHAUDIT_%run_date%*.dat GOTO end

:success

EndLocal
exit /B 0

:end 
echo *** SUN_FILE_RENAME DAT FILES ARE MISSING: %date% %time% >> %batch_log%\%log_file% 2>>&1
ECHO ************************** SUN_FILE_RENAME ENDED ******************************  >> %batch_log%\%log_file% 2>>&1
echo SUN_FILE_RENAME ENDED: %date% %time% >> %batch_log%\%log_file% 2>>&1
Echo *************************************************************************************   >> %batch_log%\%log_file% 2>>&1
EndLocal
exit /B 99