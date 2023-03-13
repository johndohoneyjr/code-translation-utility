

echo ************************** PROCESS STARTED************************************************  >> $LOG_FILE 2>>&1
echo $(date +"%Y-%m-%d %H:%M") >> $LOG_FILE 2>>&1
echo *************************************************************************************  >> $LOG_FILE 2>>&1

run_date=$(date +"%Y%m%d")
run_time=$(date +"%H%M%S_%Y%m%d")

echo ---------------------------------------------- >> $LOG_FILE 2>>&1
echo EXTRACT PROCESS Started AT $(date +"%H:%M"), $(date +"%Y-%m-%d") >> $LOG_FILE 2>>&1
echo. >> $LOG_FILE 2>>&1

job_name="$XML_DIR/jbs020_update_param_dmdunit"
$FWK_DIR/run_process.sh jbs020_update_param_dmdunit
echo Update Param Dmdunit process Completed >> $LOG_FILE 2>>&1

echo PROCESS Ended AT $(date +"%H:%M"), $(date +"%Y-%m-%d") >> $LOG_FILE 2>>&1
echo ---------------------------------------------- >> $LOG_FILE 2>>&1

echo.  >> $LOG_FILE 2>>&1
echo Process Ended Successfully at $(date +"%H:%M") >> $LOG_FILE 2>>&1
echo Return Code = $? >> $LOG_FILE 2>>&1
popd
exit 0