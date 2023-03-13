

echo "************************** PROCESS STARTED************************************************" >> $LOG_FILE 2>&1
echo "$(date +"%Y-%m-%d %H:%M")" >> $LOG_FILE 2>&1
echo "*************************************************************************************" >> $LOG_FILE 2>&1

run_date=$(date +"%Y%m%d")
run_time=$(date +"%H%M%S")

export NLS_DATE_FORMAT="RRRR-MM-DD-HH24:MI"

day=$(date +"%a")
todaysdate=$(date +"%Y%m%d")
WORKFLOWLOGMONTH=$(date +"%m%Y")
DATETIMESTAMP=$todaysdate
TIMESTAMP=$(date +"%H%M%S")

echo "----------------------------------------------" >> $LOG_FILE 2>&1
echo "EXTRACT PROCESS Started AT $(date +"%H:%M"), $(date +"%Y-%m-%d")" >> $LOG_FILE 2>&1
echo "" >> $LOG_FILE 2>&1

if [ "$day" == "Tue" ]; then
  job_name="$XML_DIR/jbs003_recon_promo_down_level1_Mon"
  "$FWK_DIR/run_process.sh" jbs003_recon_promo_down_level1_Mon
  echo "Monday Reconcile Promo down lvl1 process Completed" >> $LOG_FILE 2>&1
fi

echo "PROCESS Ended AT $(date +"%H:%M"), $(date +"%Y-%m-%d")" >> $LOG_FILE 2>&1
echo "----------------------------------------------" >> $LOG_FILE 2>&1

if [ $? -ne 0 ]; then
  echo "" >> $LOG_FILE 2>&1
  echo "*** FAILURE ***" >> $LOG_FILE 2>&1
  echo "*** Process Failed at $(date +"%H:%M")" >> $LOG_FILE 2>&1
  echo "*** Return Code = $?" >> $LOG_FILE 2>&1
  exit 1
fi

echo "" >> $LOG_FILE 2>&1
echo "Process Ended Successfully at $(date +"%H:%M")" >> $LOG_FILE 2>&1
echo "Return Code = $?" >> $LOG_FILE 2>&1

popd

exit 0