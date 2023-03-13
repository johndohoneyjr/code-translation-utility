
ECHO **************************Batch Job Started******************************  >> %LOG_FILE% 2>>&1
echo *************************************************************************  >> %LOG_FILE% 2>>&1

# -----------------------------------------------------------------------
# Start JDA Node pools
# -----------------------------------------------------------------------
ECHO ******************* start Node pools **************************  >> %LOG_FILE% 2>>&1

sudo service JDA-NodePool-Batch-Service start  >> %LOG_FILE% 2>>&1
batch_status=$?

if [ ! $batch_status -eq 0 ]; then
    goto error
fi


sudo service JDA-NodePool-WorksheetRead-Service start  >> %LOG_FILE% 2>>&1
batch_status=$?

if [ ! $batch_status -eq 0 ]; then
    goto error
fi


# -----------------------------------------------------------------------
# Add 2 Min delay to provide time for node pools shutdown
# -----------------------------------------------------------------------
# ping -c 1 -W 12000 1.1.1.1 > /dev/null

goto end

:error

echo Error Occured in node pool start >> %LOG_FILE% 2>>&1
goto end


:end
ECHO **************************Batch Job Ended********************************  >> %LOG_FILE% 2>>&1
echo Batch Job %file_name% Ended : %date% %time% >> %LOG_FILE% 2>>&1
Echo *************************************************************************  >> %LOG_FILE% 2>>&1
cd %BATCH_PATH%
exit 0