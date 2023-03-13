

#!/bin/bash

echo "************************** PROCESS STARTED************************************************" >> "$LOG_FILE" 2>&1
echo "$(date +"%Y-%m-%d %H:%M")" >> "$LOG_FILE" 2>&1
echo "*************************************************************************************" >> "$LOG_FILE" 2>&1

run_date=$(date +"%Y%m%d")
run_time=$(date +"%m%d%Y_%H%M%S")
run_time=${run_time// /0}

export NLS_DATE_FORMAT="RRRR-MM-DD-HH24:MI"

CDATE=$(date +"%m/%d/%Y")
mm=$(echo $CDATE | cut -d'/' -f1)
dd=$(echo $CDATE | cut -d'/' -f2)
yyyy=$(echo $CDATE | cut -d'/' -f3)
DAY=$(date +"%A")
echo "DOW IS $DAY" >> "$LOG_FILE" 2>&1
todaysdate="$yyyy$mm$dd"
WORKFLOWLOGMONTH="$mm$yyyy"
DATETIMESTAMP="$todaysdate"
TIMESTAMP=$(echo $DATETIMESTAMP | cut -d'_' -f2)

echo "----------------------------------------------" >> "$LOG_FILE" 2>&1
echo "EXTRACT PROCESS Started AT $(date +"%H:%M"), $(date +"%m/%d/%Y")" >> "$LOG_FILE" 2>&1
echo "" >> "$LOG_FILE" 2>&1

if [ "$DAY" == "Tue" ]; then
  job_name="$XML_DIR/jbs003_recon_promo_up_level2_Mon"
  "$FWK_DIR/run_process.sh" jbs003_recon_promo_up_level2_Mon
  echo "Monday Reconcile Promo up lvl2 process Completed" >> "$LOG_FILE" 2>&1
fi

echo "PROCESS Ended AT $(date +"%H:%M"), $(date +"%m/%d/%Y")" >> "$LOG_FILE" 2>&1
echo "----------------------------------------------" >> "$LOG_FILE" 2>&1

if [ "$ERRORLEVEL" -ne 0 ]; then
  echo "" >> "$LOG_FILE" 2>&1
  echo "*** FAILURE ***" >> "$LOG_FILE" 2>&1
  echo "*** Process Failed at $(date +"%H:%M")" >> "$LOG_FILE" 2>&1
  echo "*** Return Code = $ERRORLEVEL" >> "$LOG_FILE" 2>&1
  exit 1
else
  echo "" >> "$LOG_FILE" 2>&1
  echo "Process Ended Successfully at $(date +"%H:%M")" >> "$LOG_FILE" 2>&1
  echo "Return Code = $ERRORLEVEL" >> "$LOG_FILE" 2>&1
  exit 0
fi