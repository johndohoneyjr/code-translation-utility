echo off
rem ################################################################################################################################################
rem FileName:          onetime_file_rename.bat
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
rem ################################################################################################################################################

cd /d D:\JDABatch\batch\cmd

call D:\JDABatch\fwk\batchenv.bat

set sftp_inbox=D:\SFTP\one_time_load
set batch_inbox=D:\JDABatch\data\in
set batch_log=D:\JDABatch\log
set batch_inbox_archive=D:\JDABatch\data\in\archive

rem set run_date=%date:~10,4%%date:~4,2%%date:~7,2%
set run_date=%date:~4,2%%date:~7,2%%date:~10,4%
set run_time=%date:~4,2%%date:~7,2%%date:~10,4%_%time:~0,2%%time:~3,2%%time:~6,2%
set run_time=%run_time: =0%
set log_file=ONETIME_FILE_RENAME%run_time%.log

ECHO ************************** ONETIME_FILE_RENAME STARTED ************************************************  > %batch_log%\%log_file% 2>>&1
echo ONETIME_FILE_RENAME STARTED: %date% %time% >> %batch_log%\%log_file% 2>>&1
Echo *************************************************************************************   >> %batch_log%\%log_file% 2>>&1
IF EXIST %sftp_inbox%\JDA_DFUVIEW_ONETIME_%run_date%*.dat IF EXIST %sftp_inbox%\JDA_POSHIST_ONETIME_%run_date%*.dat IF EXIST %sftp_inbox%\JDA_ORDERHIST_SAP_ONETIME_%run_date%*.dat IF EXIST %sftp_inbox%\JDA_STORECREDIT_SAP_ONETIME_%run_date%*.dat (

del %batch_inbox%\jbi003_load_dfuview_onetime.dat >> %batch_log%\%log_file%
del %batch_inbox%\jbi017_insert_orderhist_onetime.dat >> %batch_log%\%log_file%
del %batch_inbox%\jbi016_insert_poshist_onetime.dat >> %batch_log%\%log_file%
del %batch_inbox%\jbi018_insert_storecredit_onetime.dat >> %batch_log%\%log_file%


echo OLD DAT FILES ARE DELETED FROM BATCH INBOX ONE TIME: %date% %time% >> %batch_log%\%log_file% 2>>&1

COPY /b %sftp_inbox%\JDA_DFUVIEW_ONETIME_%run_date%*.dat %batch_inbox%\jbi003_load_dfuview_onetime.dat >> %batch_log%\%log_file% 2>>&1
COPY /b %sftp_inbox%\JDA_ORDERHIST_SAP_ONETIME_%run_date%*.dat %batch_inbox%\jbi017_insert_orderhist_onetime.dat >> %batch_log%\%log_file% 2>>&1
COPY /b %sftp_inbox%\JDA_POSHIST_ONETIME_%run_date%*.dat %batch_inbox%\jbi016_insert_poshist_onetime.dat >> %batch_log%\%log_file% 2>>&1
COPY /b %sftp_inbox%\JDA_STORECREDIT_SAP_ONETIME_%run_date%*.dat %batch_inbox%\jbi018_insert_storecredit_onetime.dat >> %batch_log%\%log_file% 2>>&1


MOVE /Y %sftp_inbox%\JDA_DFUVIEW_ONETIME_%run_date%*.dat %batch_inbox_archive% >> %batch_log%\%log_file% 2>>&1
MOVE /Y %sftp_inbox%\JDA_ORDERHIST_SAP_ONETIME_%run_date%*.dat %batch_inbox_archive% >> %batch_log%\%log_file% 2>>&1
MOVE /Y %sftp_inbox%\JDA_POSHIST_ONETIME_%run_date%*.dat %batch_inbox_archive% >> %batch_log%\%log_file% 2>>&1
MOVE /Y %sftp_inbox%\JDA_STORECREDIT_SAP_ONETIME_%run_date%*.dat %batch_inbox_archive% >> %batch_log%\%log_file% 2>>&1


echo ONETIME_FILE_RENAME COMPLETED: %date% %time% >> %batch_log%\%log_file% 2>>&1
ECHO ************************** ONETIME_FILE_RENAME ENDED ******************************  >> %batch_log%\%log_file% 2>>&1
echo ONETIME_FILE_RENAME ENDED: %date% %time% >> %batch_log%\%log_file% 2>>&1
Echo *************************************************************************************   >> %batch_log%\%log_file% 2>>&1

GOTO success
)

IF NOT EXIST %sftp_inbox%\JDA_DFUVIEW_ONETIME_%run_date%*.dat GOTO end
IF NOT EXIST %sftp_inbox%\JDA_ORDERHIST_SAP_ONETIME_%run_date%*.dat GOTO end
IF NOT EXIST %sftp_inbox%\JDA_POSHIST_ONETIME_%run_date%*.dat GOTO end
IF NOT EXIST %sftp_inbox%\JDA_STORECREDIT_SAP_ONETIME_%run_date%*.dat GOTO end



:success

EndLocal
exit /B 0

:end 
echo *** ONETIME_FILE_RENAME DAT FILES ARE MISSING: %date% %time% >> %batch_log%\%log_file% 2>>&1
ECHO ************************** ONETIME_FILE_RENAME ENDED ******************************  >> %batch_log%\%log_file% 2>>&1
echo ONETIME_FILE_RENAME ENDED: %date% %time% >> %batch_log%\%log_file% 2>>&1
Echo *************************************************************************************   >> %batch_log%\%log_file% 2>>&1
EndLocal
exit /B 99
