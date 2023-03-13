
ECHO **************************Batch Job Started******************************  >> $LOG_FILE 2>&1
echo *************************************************************************  >> $LOG_FILE 2>&1

# Start JDA Node pools
ECHO ******************* start Node pools **************************  >> $LOG_FILE 2>&1

sudo service JDA-NodePool-Batch-Service start  >> $LOG_FILE 2>&1
batch_status=$?

if [ ! $batch_status -eq 0 ]; then
    echo "Error Occured in node pool start" >> $LOG_FILE 2>&1
    exit 1
fi

sudo service JDA-NodePool-WorksheetRead-Service start  >> $LOG_FILE 2>&1
batch_status=$?

if [ ! $batch_status -eq 0 ]; then
    echo "Error Occured in node pool start" >> $LOG_FILE 2>&1
    exit 1
fi

# Add 2 Min delay to provide time for node pools shutdown
sleep 120

echo **************************Batch Job Ended********************************  >> $LOG_FILE 2>&1
echo Batch Job $file_name Ended : $(date) >> $LOG_FILE 2>&1
echo *************************************************************************  >> $LOG_FILE 2>&1
cd $BATCH_PATH
exit 0