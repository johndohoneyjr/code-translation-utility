

echo ************************** PROCESS ENDED************************************************  >> %LOG_FILE% 2>>&1
echo  %DATE% %TIME% >> %LOG_FILE% 2>>&1
echo *************************************************************************************  >> %LOG_FILE% 2>>&1

#!/bin/bash

echo "************************** PROCESS STARTED************************************************"  >> "$LOG_FILE" 2>&1
echo "$(date)" >> "$LOG_FILE" 2>&1
echo "*************************************************************************************"  >> "$LOG_FILE" 2>&1

run_date=$(date +%Y%m%d)
run_time=$(date +%H%M%S)

export NLS_DATE_FORMAT="RRRR-MM-DD-HH24:MI"

CDATE=$(date +"%D")
mm=$(date +"%m")
dd=$(date +"%d")
yyyy=$(date +"%Y")
DAY=$(date +"%A")
echo "DOW IS $DAY" >> "$LOG_FILE" 2>&1
todaysdate="$yyyy$mm$dd"
WORKFLOWLOGMONTH="$mm$yyyy"
DATETIMESTAMP="$todaysdate"
TIMESTAMP=$(date +"$DATETIMESTAMP"_"%H%M%S")

echo "----------------------------------------------" >> "$LOG_FILE" 2>&1
echo "EXTRACT PROCESS Started AT $(date +"%T"), $(date +"%D")" >> "$LOG_FILE" 2>&1
echo "" >> "$LOG_FILE" 2>&1

if [ "$DAY" == "Tue" ]; then
  job_name="$XML_DIR/jbs003_recon_promo_down_level2_Mon"
  "$FWK_DIR/run_process.sh" jbs003_recon_promo_down_level2_Mon
  echo "Monday Reconcile Promo down lvl2 process Completed" >> "$LOG_FILE" 2>&1
fi

echo "PROCESS Ended AT $(date +"%T"), $(date +"%D")" >> "$LOG_FILE" 2>&1
echo "----------------------------------------------" >> "$LOG_FILE" 2>&1

if [ "$ERRORLEVEL" -ne 0 ]; then
  echo "" >> "$LOG_FILE" 2>&1
  echo "*** FAILURE ***" >> "$LOG_FILE" 2>&1
  echo "*** Process Failed at $(date +"%T")" >> "$LOG_FILE" 2>&1
  echo "*** Return Code = $ERRORLEVEL" >> "$LOG_FILE" 2>&1
  exit 1
fi

echo "" >> "$LOG_FILE" 2>&1
echo "Process Ended Successfully at $(date +"%T")" >> "$LOG_FILE" 2>&1
echo "Return Code = $ERRORLEVEL" >> "$LOG_FILE" 2>&1

echo "************************** PROCESS ENDED************************************************"  >> "$LOG_FILE" 2>&1
echo "$(date)" >> "$LOG_FILE" 2>&1
echo "*************************************************************************************"  >> "$LOG_FILE" 2>&1