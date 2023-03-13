
#!/bin/bash

echo "**************************Batch Job Started******************************" >> $LOG_FILE 2>&1
echo "*************************************************************************" >> $LOG_FILE 2>&1

echo "******************* stop Node pools **************************" >> $LOG_FILE 2>&1

sudo service JDA-NodePool-Batch-Service stop >> $LOG_FILE 2>&1

batch_status=$?

if [ ! $batch_status -eq 0 ]; then
    goto error
fi

sudo service JDA-NodePool-WorksheetRead-Service stop >> $LOG_FILE 2>&1

batch_status=$?

if [ ! $batch_status -eq 0 ]; then
    goto error
fi

# Add 2 Min delay to provide time for node pools shutdown
sleep 120

goto end

:error
echo "Error Occured in node pool stop" >> $LOG_FILE 2>&1
goto end

:end
echo "**************************Batch Job Ended********************************" >> $LOG_FILE 2>&1
echo "Batch Job $file_name Ended : $(date)" >> $LOG_FILE 2>&1
echo "*************************************************************************" >> $LOG_FILE 2>&1
cd $BATCH_PATH
exit 0