

echo ************************** PROCESS ENDED************************************************  >> %LOG_FILE% 2>>&1

#!/bin/bash

echo "************************** PROCESS STARTED************************************************"  >> "$LOG_FILE" 2>&1
echo "$(date +%Y-%m-%d-%H:%M)" >> "$LOG_FILE" 2>&1
echo "*************************************************************************************"  >> "$LOG_FILE" 2>&1

run_date=$(date +%Y%m%d)
run_time=$(date +%H%M%S)

export NLS_DATE_FORMAT="RRRR-MM-DD-HH24:MI"

CDATE=$(date +%D)
mm=$(date +%m)
dd=$(date +%d)
yyyy=$(date +%Y)
DAY=$(date +%a)
echo "DOW IS $DAY" >> "$LOG_FILE" 2>&1
todaysdate="$yyyy$mm$dd"
WORKFLOWLOGMONTH="$mm$yyyy"
DATETIMESTAMP="$todaysdate"
TIMESTAMP=$(echo "$DATETIMESTAMP"_"$(date +%H%M%S | tr -d ' ')")

echo "----------------------------------------------" >> "$LOG_FILE" 2>&1
echo "EXTRACT PROCESS Started AT $(date +%H:%M), $(date +%D)" >> "$LOG_FILE" 2>&1
echo "" >> "$LOG_FILE" 2>&1

if [ "$DAY" == "Tue" ]; then
  job_name="$XML_DIR/jbs003_recon_dc_lift_1_Mon"
  "$FWK_DIR/run_process.sh" jbs003_recon_dc_lift_1_Mon
  echo "Monday Reconcile DC Lift1 process Completed" >> "$LOG_FILE" 2>&1
fi

echo "PROCESS Ended AT $(date +%H:%M), $(date +%D)" >> "$LOG_FILE" 2>&1
echo "----------------------------------------------" >> "$LOG_FILE" 2>&1

if [ "$?" -ne 0 ]; then
  echo "" >> "$LOG_FILE" 2>&1
  echo "*** FAILURE ***" >> "$LOG_FILE" 2>&1
  echo "*** Process Failed at $(date +%H:%M)" >> "$LOG_FILE" 2>&1
  echo "*** Return Code = $?" >> "$LOG_FILE" 2>&1
  exit 1
else
  echo "" >> "$LOG_FILE" 2>&1
  echo "Process Ended Successfully at $(date +%H:%M)" >> "$LOG_FILE" 2>&1
  echo "Return Code = $?" >> "$LOG_FILE" 2>&1
  exit 0
fi

echo "" >> "$LOG_FILE" 2>&1
echo "************************** PROCESS ENDED************************************************" >> "$LOG_FILE" 2>&1