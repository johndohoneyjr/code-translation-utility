

#!/bin/bash

echo "************************** PROCESS STARTED************************************************" >> "$LOG_FILE" 2>&1
echo "$(date +"%Y-%m-%d %H:%M")" >> "$LOG_FILE" 2>&1
echo "*************************************************************************************" >> "$LOG_FILE" 2>&1

run_date=$(date +"%Y%m%d")
run_time=$(date +"%H%M%S_%Y%m%d")

export NLS_DATE_FORMAT="RRRR-MM-DD-HH24:MI"

CDATE=$(date +"%d/%m/%Y")
mm=$(date +"%m")
dd=$(date +"%d")
yyyy=$(date +"%Y")
DAY=$(date +"%A")
echo "DOW IS $DAY" >> "$LOG_FILE" 2>&1
todaysdate="$yyyy$mm$dd"
WORKFLOWLOGMONTH="$mm$yyyy"
DATETIMESTAMP="$todaysdate"
TIMESTAMP=$(date +"$DATETIMESTAMP_%H%M%S")

echo "----------------------------------------------" >> "$LOG_FILE" 2>&1
echo "EXTRACT PROCESS Started AT $(date +"%H:%M"), $(date +"%d/%m/%Y")" >> "$LOG_FILE" 2>&1
echo "" >> "$LOG_FILE" 2>&1

if [ "$DAY" == "Tue" ]; then
  job_name="$XML_DIR/jbs003_recon_promo_up_level3_Mon"
  "$FWK_DIR/run_process.sh" jbs003_recon_promo_up_level3_Mon
  echo "Monday Reconcile Promo Up lvl3 process Completed" >> "$LOG_FILE" 2>&1
fi

echo "PROCESS Ended AT $(date +"%H:%M"), $(date +"%d/%m/%Y")" >> "$LOG_FILE" 2>&1
echo "----------------------------------------------" >> "$LOG_FILE" 2>&1

if [ "$ERRORLEVEL" -ne 0 ]; then
  echo "" >> "$LOG_FILE" 2>&1
  echo "*** FAILURE ***" >> "$LOG_FILE" 2>&1
  echo "*** Process Failed at $(date +"%H:%M")" >> "$LOG_FILE" 2>&1
  echo "*** Return Code = $ERRORLEVEL" >> "$LOG_FILE" 2>&1
  exit 1
fi

echo "" >> "$LOG_FILE" 2>&1
echo "Process Ended Successfully at $(date +"%H:%M")" >> "$LOG_FILE" 2>&1
echo "Return Code = $ERRORLEVEL" >> "$LOG_FILE" 2>&1
exit 0