

echo **************************HISTORY EXTRACT ENDED************************************************  >> %LOG_FILE% 2>>&1
echo  %DATE% %TIME% >> %LOG_FILE% 2>>&1
echo *************************************************************************************  >> %LOG_FILE% 2>>&1

ECHO ON

#!/bin/bash

echo "**************************HISTORY EXTRACT STARTED************************************************"  >> "$LOG_FILE" 2>&1
echo "$(date)" >> "$LOG_FILE" 2>&1
echo "*************************************************************************************"  >> "$LOG_FILE" 2>&1

run_date=$(date +%Y%m%d)
run_time=$(date +%m%d%Y_%H%M%S)
run_time=${run_time// /0}

export NLS_DATE_FORMAT="RRRR-MM-DD-HH24:MI"

CDATE=$(date +%m/%d/%Y)
mm=$(echo $CDATE | cut -d'/' -f1)
dd=$(echo $CDATE | cut -d'/' -f2)
yyyy=$(echo $CDATE | cut -d'/' -f3)
DAY=$(date +%a)
echo "DOW IS $DAY" >> "$LOG_FILE" 2>&1
todaysdate=$yyyy$mm$dd
WORKFLOWLOGMONTH=$mm$yyyy
DATETIMESTAMP=$todaysdate
TIMESTAMP=$(echo $DATETIMESTAMP | cut -d'_' -f1)
datafile="JDA_HISTFULL