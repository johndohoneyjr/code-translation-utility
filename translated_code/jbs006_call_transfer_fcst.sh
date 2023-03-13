

echo "************************** PROCESS STARTED************************************************"  >> $LOG_FILE 2>&1
echo "$(date +"%Y-%m-%d %H:%M")" >> $LOG_FILE 2>&1
echo "*************************************************************************************"  >> $LOG_FILE 2>&1

run_date=$(date +"%Y%m%d")
run_time=$(date +"%H%M%S_%Y%m%d")
run_time=${run_time// /0}

export NLS_DATE_FORMAT="RRRR-MM-DD-HH24:MI"

day=$(date +"%a")
todaysdate=$(date +"%Y%m%d")
WORKFLOWLOGMONTH=$(date +"%m%Y")
DATETIMESTAMP=$todaysdate
TIMESTAMP=$(date +"%H%M%S")

echo "----------------------------------------------" >> $LOG_FILE 2>&1
echo "EXTRACT PROCESS Started AT $(date +"%H:%M"), $(date +"%d-%m-%Y")" >> $LOG_FILE 2>&1
echo "" >> $LOG_FILE 2>&1

if [ "$day" == "Tue" ]; then
  job_name="$XML_DIR/jbs006_transfer_fcst_weekly"
  "$FWK_DIR/run_process.sh" jbs006_transfer_fcst_weekly
  echo "Weekly Transfer Forecast process Completed" >> $LOG_FILE 2>&1
else
  job_name="$XML_DIR/jbs006_transfer_fcst_daily"
  "$FWK_DIR/run_process.sh" jbs006_transfer_fcst_daily
  echo "Daily Transfer Forecast process Completed" >> $LOG_FILE 2>&1
fi

echo "PROCESS Ended AT $(date +"%H:%M"), $(date +"%d-%m-%Y")" >> $LOG_FILE 2>&1
echo "----------------------------------------------" >> $LOG_FILE 2>&1

if [ $? -ne 0 ]; then
  echo "" >> $LOG_FILE 2>&1
  echo "*** FAILURE ***" >> $LOG_FILE 2>&1
  echo "*** Process Failed at $(date +"%H:%M")" >> $LOG_FILE 2>&1
  echo "*** Return Code = $?" >> $LOG_FILE 2>&1
  exit 1
else
  echo "" >> $LOG_FILE 2>&1
  echo "Process Ended Successfully at $(date +"%H:%M")" >> $LOG_FILE 2>&1
  echo "Return Code = $?" >> $LOG_FILE 2>&1
  exit 0
fi