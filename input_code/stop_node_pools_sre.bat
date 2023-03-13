@echo on
rem ##################################################################################################
rem FileName:            stop_node_pools_sre.bat
rem Description:        This is the generic batch script to stop Node pools
rem Last Modified:      (See Modification History)
rem ################################################################################################################################################
rem
rem Modification History
rem
rem Date                               Author                                              Modifications
rem -----------------------------------------------------------------------------------------------------------------------------------------------rem ################################################################################################################################################


ECHO **************************Batch Job Started******************************  >> %LOG_FILE% 2>>&1
echo *************************************************************************  >> %LOG_FILE% 2>>&1

rem -----------------------------------------------------------------------
rem Stop JDA Node pools
rem -----------------------------------------------------------------------
ECHO ******************* stop Node pools **************************  >> %LOG_FILE% 2>>&1

net stop JDA-NodePool-Batch-Service  >> %LOG_FILE% 2>>&1

set batch_status=%errorlevel%

If NOT %batch_status% == 0 goto error

net stop JDA-NodePool-WorksheetRead-Service  >> %LOG_FILE% 2>>&1

set batch_status=%errorlevel%

If NOT %batch_status% == 0 goto error


rem -----------------------------------------------------------------------
rem Add 2 Min delay to provide time for node pools shutdown
rem -----------------------------------------------------------------------
rem ping -n 1 -w 12000 1.1.1.1 > NUL

goto end

:error

echo Error Occured in node pool stop >> %LOG_FILE% 2>>&1
goto end


:end
ECHO **************************Batch Job Ended********************************  >> %LOG_FILE% 2>>&1
echo Batch Job %file_name% Ended : %date% %time% >> %LOG_FILE% 2>>&1
Echo *************************************************************************  >> %LOG_FILE% 2>>&1
pushd %BATCH_PATH%\
exit /b 0
