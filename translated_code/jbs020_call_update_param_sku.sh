

echo ************************** PROCESS STARTED************************************************  >> "$LOG_FILE" 2>&1
echo "$(date +"%Y-%m-%d %H:%M")" >> "$LOG_FILE" 2>&1
echo *************************************************************************************  >> "$LOG_FILE" 2>&1

run_date=$(date +"%Y%m%d")
run_time=$(date +"%m%d%Y_%H%M%S")
run_time=${run_time// /0}

export NLS_DATE_FORMAT="RRRR-MM-DD-HH24:MI"

todaysdate=$(date +"%Y%m%d")
WORKFLOWLOGMONTH=$(date +"%m%Y")
DATETIMESTAMP=$todaysdate
TIMESTAMP=$(echo "$DATETIMESTAMP"_"${run_time:0:6}")

echo "----------------------------------------------" >> "$LOG_FILE" 2>&1
echo "EXTRACT PROCESS Started AT $(date +"%H:%M"), $(date +"%Y-%m-%d")" >> "$LOG_FILE" 2>&1
echo "" >> "$LOG_FILE" 2>&1

job_name="$XML_DIR/jbs020_update_param_sku"
"$FWK_DIR/run_process.sh" jbs020_update_param_sku
echo "Update Param SKU process Completed" >> "$LOG_FILE" 2>&1

echo "PROCESS Ended AT $(date +"%H:%M"), $(date +"%Y-%m-%d")" >> "$LOG_FILE" 2>&1
echo "----------------------------------------------" >> "$LOG_FILE" 2>&1

echo "" >> "$LOG_FILE" 2>&1
echo "Process Ended Successfully at $(date +"%H:%M")" >> "$LOG_FILE" 2>&1
echo "Return Code = $?" >> "$LOG_FILE" 2>&1
popd
exit 0