

#!/bin/bash

echo "************************** PROCESS STARTED************************************************" >> "$LOG_FILE" 2>&1
echo "$(date +"%Y-%m-%d %H:%M")" >> "$LOG_FILE" 2>&1
echo "*************************************************************************************" >> "$LOG_FILE" 2>&1

run_date=$(date +"%Y%m%d")
run_time=$(date +"%m%d%Y_%H%M%S")

export NLS_DATE_FORMAT="RRRR-MM-DD-HH24:MI"

CDATE=$(date +"%m/%d/%Y")
mm=$(date +"%m")
dd=$(date +"%d")
yyyy=$(date +"%Y")
DAY=$(date +"%A")
todaysdate="$yyyy$mm$dd"
WORKFLOWLOGMONTH="$mm$yyyy"
DATETIMESTAMP="$todaysdate"
TIMESTAMP=$(date +"$DATETIMESTAMP_%H%M%S")

echo "----------------------------------------------" >> "$LOG_FILE" 2>&1
echo "EXTRACT PROCESS Started AT $(date +"%H:%M"), $(date +"%m/%d/%Y")" >> "$LOG_FILE" 2>&1
echo "" >> "$LOG_FILE" 2>&1

job_name="$XML_DIR/jbs020_update_param_loc"
$FWK_DIR/run_process.sh jbs020_update_param_loc
echo "Update Param Location process Completed" >> "$LOG_FILE" 2>&1

echo "PROCESS Ended AT $(date +"%H:%M"), $(date +"%m/%d/%Y")" >> "$LOG_FILE" 2>&1
echo "----------------------------------------------" >> "$LOG_FILE" 2>&1

echo "" >> "$LOG_FILE" 2>&1
echo "Process Ended Successfully at $(date +"%H:%M")" >> "$LOG_FILE" 2>&1
echo "Return Code = $?" >> "$LOG_FILE" 2>&1
popd
exit 0