

echo **************************SKUProjStatic EXTRACT ENDED************************************************  >> %LOG_FILE% 2>>&1

#!/bin/bash

echo "**************************SKUProjStatic EXTRACT STARTED************************************************"  >> $LOG_FILE 2>>&1
echo "$(date)" >> $LOG_FILE 2>>&1
echo "*************************************************************************************"  >> $LOG_FILE 2>>&1

run_date=$(date +"%Y%m%d")
run_time=$(date +"%m%d%Y_%H%M%S")
run_time=${run_time// /0}

export NLS_DATE_FORMAT="RRRR-MM-DD-HH24:MI"

CDATE=$(date +"%D")
mm=$(echo $CDATE | cut -d'/' -f1)
dd=$(echo $CDATE | cut -d'/' -f2)
yyyy=$(echo $CDATE | cut -d'/' -f3)
todaysdate="$yyyy$mm$dd"
WORKFLOWLOGMONTH="$mm$yyyy"
DATETIMESTAMP="$todaysdate"
TIMESTAMP=$(echo $DATETIMESTAMP | cut -d'_' -f2)
datafile="JDA_SKUPROJSTATIC_$run_time"

echo "----------------------------------------------" >> $LOG_FILE 2>>&1
echo "EXTRACT PROCESS Started AT $(date +"%T"), $(date +"%D")" >> $LOG_FILE 2>>&1
echo "Output will be written TO FILE $datafile.dat">> $LOG_FILE 2>>&1
echo "" >> $LOG_FILE 2>>&1
sqlplus -s $BATCH_LOGIN @$SQL_DIR/jbo007_extract_skuprojstatic.sql $datafile >> $LOG_FILE 2>>&1

echo "EXTRACT PROCESS Ended AT $(date +"%T"), $(date +"%D")" >> $LOG_FILE 2>>&1
echo "----------------------------------------------" >> $LOG_FILE 2>>&1

if [ $? -ne 0 ]; then
    echo "" >> $LOG_FILE 2>>&1
    echo "*** FAILURE ***"  >> $LOG_FILE 2>>&1
    echo "*** Extract Process Failed at $(date +"%T")" >> $LOG_FILE 2>>&1
    echo "*** Return Code = $?" >> $LOG_FILE 2>>&1
    exit 1
fi

if [ ! -f $SFTP_OUT_DIR/$datafile.dat ]; then
    echo "" >> $LOG_FILE 2>>&1
    echo "Extract File doesn't exist, please investigate..." >> $LOG_FILE 2>>&1
    exit 1
fi

echo "Extract file successfully generated at $(date +"%T")" >> $LOG_FILE 2>>&1

echo "Zipping extract file" >> $LOG_FILE 2>>&1
cd $SF