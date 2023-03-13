

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
TIMESTAMP=$(echo $DATETIMESTAMP | cut -d ":" -f1)
TIMESTAMP=$(echo $TIMESTAMP | cut -d " " -f2)
TIMESTAMP=$DATETIMESTAMP"_"$TIMESTAMP

echo "----------------------------------------------" >> $LOG_FILE 2>>&1
echo "EXTRACT PROCESS Started AT $(date +"%T"), $(date +"%D")" >> $LOG_FILE 2>>&1
echo "" >> $LOG_FILE 2>>&1

if [ "$DAY" == "Tue" ]; then
  job_name=$XML_DIR/jbs001_calculate_model_Mon
  $FWK_DIR/run_process.sh jbs001_calculate_model_Mon
  echo "Monday Calculate Model process Completed" >> $LOG_FILE 2>>&1
fi

echo "PROCESS Ended AT $(date +"%T"), $(date +"%D")" >> $LOG_FILE 2>>&1
echo "----------------------------------------------" >> $LOG_FILE 2>>&1

if [ $? -ne 0 ]; then
  echo "" >> $LOG_FILE 2>>&1
  echo "*** FAILURE ***" >> $LOG_FILE 2>>&1
  echo "*** Process Failed at $(date +"%T")" >> $LOG_FILE 2>>&1
  echo "*** Return Code = $?" >> $LOG_FILE 2>>&1
  exit 1
else
  echo "" >> $LOG_FILE 2>>&1
  echo "Process Ended Successfully at $(date +"%T")" >> $LOG_FILE 2>>&1
  echo "Return Code = $?" >> $LOG_FILE 2>>&1
  exit 0
fi

echo "************************** PROCESS ENDED************************************************"  >> $LOG_FILE 2>>&1