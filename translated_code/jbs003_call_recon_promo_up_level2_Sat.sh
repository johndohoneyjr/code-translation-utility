

echo ************************** PROCESS ENDED************************************************  >> %LOG_FILE% 2>>&1

#!/bin/bash

echo "************************** PROCESS STARTED************************************************"  >> $LOG_FILE 2>>&1
echo "$(date)" >> $LOG_FILE 2>>&1
echo "*************************************************************************************"  >> $LOG_FILE 2>>&1

run_date=$(date +"%Y%m%d")
run_time=$(date +"%m%d%Y_%H%M%S")
run_time=${run_time// /0}

export NLS_DATE_FORMAT="RRRR-MM-DD-HH24:MI"

CDATE=$(date +"%D")
mm=$(date +"%m")
dd=$(echo $CDATE | cut -d "/" -f1)
yyyy=$(echo $CDATE | cut -d "/" -f3)
DAY=$(date +"%a")
echo "DOW IS $DAY" >> $LOG_FILE 2>>&1
todaysdate=$yyyy$mm$dd
WORKFLOWLOGMONTH=$mm$yyyy
DATETIMESTAMP=$todaysdate
TIMESTAMP=$(date +"%H%M%S")
trimmed_timestamp=${TIMESTAMP// /0}
TIMESTAMP=$DATETIMESTAMP"_"$trimmed_timestamp

echo "----------------------------------------------" >> $LOG_FILE 2>>&1
echo "EXTRACT PROCESS Started AT $(date +"%T"), $(date +"%D")" >> $LOG_FILE 2>>&1
echo "" >> $LOG_FILE 2>>&1

if [ "$DAY" == "Sun" ]; then
  job_name=$XML_DIR/jbs003_recon_promo_up_level2_Sat
  $FWK_DIR/run_process.sh jbs003_recon_promo_up_level2_Sat
  echo "Saturday Reconcile Promo up lvl2 process Completed" >> $LOG_FILE 2>>&1
fi

echo "PROCESS Ended AT $(date +"%T"), $(date +"%D")" >> $LOG_FILE 2>>&1
echo "----------------------------------------------" >> $LOG_FILE 2>>&1

if [ $? -ne 0 ]; then
  echo "" >> $LOG_FILE 2>>&1
  echo "*** FAILURE ***" >> $LOG_FILE 2>>&1
  echo "*** Process Failed at $(date +"%T")" >> $LOG_FILE 2>>&1
  echo "*** Return Code = $?" >> $LOG_FILE 2>>&1
  exit 1
fi

echo "" >> $LOG_FILE 2>>&1
echo "Process Ended Successfully at $(date +"%T")" >> $LOG_FILE 2>>&1
echo "Return Code = $?" >> $LOG_FILE 2>>&1

echo "************************** PROCESS ENDED************************************************"  >> $LOG_FILE 2>>&1