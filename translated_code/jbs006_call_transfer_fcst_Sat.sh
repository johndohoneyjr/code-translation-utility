

echo ************************** PROCESS STARTED************************************************  >> "$LOG_FILE" 2>&1
echo $(date +"%Y%m%d %H%M%S") >> "$LOG_FILE" 2>&1
echo *************************************************************************************  >> "$LOG_FILE" 2>&1

run_date=$(date +"%Y%m%d")
run_time=$(date +"%m%d%Y_%H%M%S")
run_time=${run_time// /0}

export NLS_DATE_FORMAT="RRRR-MM-DD-HH24:MI"

CDATE=$(date +"%m/%d/%Y")
mm=$(echo $CDATE | cut -d'/' -f1)
dd=$(echo $CDATE | cut -d'/' -f2)
yyyy=$(echo $CDATE | cut -d'/' -f3)
DAY=$(date +"%a")
echo "DOW IS $DAY" >> "$LOG_FILE" 2>&1
todaysdate=$yyyy$mm$dd
WORKFLOWLOGMONTH=$mm$yyyy
DATETIMESTAMP=$todaysdate
TIMESTAMP=$(date +"%H%M%S")
trimmed_timestamp=${TIMESTAMP// /0}
TIMESTAMP=$DATETIMESTAMP"_"$trimmed_timestamp

echo ---------------------------------------------- >> "$LOG_FILE" 2>&1
echo EXTRACT PROCESS Started AT $(date +"%H:%M:%S"), $(date +"%m/%d/%Y") >> "$LOG_FILE" 2>&1
echo. >> "$LOG_FILE" 2>&1

if [ "$DAY" == "Sun" ]; then
  job_name="$XML_DIR/jbs006_transfer_fcst_weekly"
  "$FWK_DIR/run_process.sh" jbs006_transfer_fcst_weekly
  echo "Weekly Transfer Forecast process Completed" >> "$LOG_FILE" 2>&1
else
  job_name="$XML_DIR/jbs006_transfer_fcst_daily"
  "$FWK_DIR/run_process.sh" jbs006_transfer_fcst_daily
  echo "Daily Transfer Forecast process Completed" >> "$LOG_FILE" 2>&1
fi

echo "PROCESS Ended AT $(date +"%H:%M:%S"), $(date +"%m/%d/%Y")" >> "$LOG_FILE" 2>&1
echo ---------------------------------------------- >> "$LOG_FILE" 2>&1

if [ $? -ne 0 ]; then
  echo.  >> "$LOG_FILE" 2>&1
  echo "*** FAILURE ***"  >> "$LOG_FILE" 2>&1
  echo "*** Process Failed at $(date +"%H:%M:%S")" >> "$LOG_FILE" 2>&1
  echo "*** Return Code = $?" >> "$LOG_FILE" 2>&1
  exit 1
fi

echo.  >> "$LOG_FILE" 2>&1
echo "Process Ended Successfully at $(date +"%H:%M:%S")" >> "$LOG_FILE" 2>&1
echo "Return Code = $?" >> "$LOG_FILE" 2>&1
popd
exit 0