

echo **************************FCST EXTRACT ENDED************************************************  >> %LOG_FILE% 2>>&1
echo  %DATE% %TIME% >> %LOG_FILE% 2>>&1
echo *************************************************************************************  >> %LOG_FILE% 2>>&1

ECHO ON

#!/bin/bash

echo "**************************FCST EXTRACT STARTED************************************************"  >> $LOG_FILE 2>>&1
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
DAY=$(date +"%A")
todaysdate=$yyyy$mm$dd
WORKFLOWLOGMONTH=$mm$yyyy
DATETIMESTAMP=$todaysdate
TIMESTAMP=$(echo $DATETIMESTAMP"_"$(date +"%H%M%S"))
datafile="JDA_FCST_$run_time"

echo "----------------------------------------------" >> $LOG_FILE 2>>&1
echo "EXTRACT PROCESS Started AT $(date +"%T"), $(date +"%D")" >> $LOG_FILE 2>>&1
echo "Output will be written TO FILE $datafile.dat">> $LOG_FILE 2>>&1
echo "" >> $LOG_FILE 2>>&1

if [ "$DAY" == "Sun" ]; then
  sqlplus -s $BATCH_LOGIN @$SQL_DIR/jbo022_extract_fcst.sql $datafile >> $LOG_FILE 2>>&1
  echo "Weekly FCST Extract Completed" >> $LOG_FILE 2>>&1
else
  echo "