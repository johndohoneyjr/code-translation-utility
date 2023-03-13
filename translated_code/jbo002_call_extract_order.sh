

# Translated to Linux Bash

#!/bin/bash

cd /d D:/JDABatch/batch/cmd

source D:/JDABatch/fwk/batchenv.sh

run_date=$(date +"%Y%m%d")
run_time=$(date +"%H%M%S_%Y%m%d")

export NLS_DATE_FORMAT="RRRR-MM-DD-HH24:MI"

CDATE=$(date +"%D")
mm=$(date +"%m")
dd=$(date +"%d")
yyyy=$(date +"%Y")
todaysdate="$yyyy$mm$dd"
WORKFLOWLOGMONTH="$mm$yyyy"
DATETIMESTAMP="$todaysdate"
timestamp=$(date +"%H%M%S")
trimmed_timestamp=$(echo $timestamp | tr -d ' ')
TIMESTAMP="$DATETIMESTAMP"_"$trimmed_timestamp"

batch_home="D:/JDABatch"
sql_home="$batch_home/batch/sql"
batch_out_arch="$batch_home/data/out/archive"
sftp_outbox="D:/SFTP/outbox"

datafile="JDA_RECSHIP_$run_time"
logfile="$batch_home/log/jbo002_call_extract_order_$TIMESTAMP.log"

echo "----------------------------------------------" >> $logfile 2>>&1
echo "Extract Process Started at $(date +"%T"), $(date +"%D")" >> $logfile 2>>&1
echo "Output will be written to file $datafile.dat" >> $logfile 2>>&1
echo ""  >> $logfile 2>>&1

sqlplus -s $BATCHUSER/$BATCHPWD@$ORACLE_SID @$sql_home/jbo002_extract_order.sql $datafile >> $logfile 2>>&1

if [ $? -ne 0 ]; then
    echo ""  >> $logfile 2>>&1
    echo "*** FAILURE ***"  >> $logfile 2>>&1
    echo "*** Extract Process Failed at $(date +"%T")" >> $logfile 2>>&1
    echo "*** Return Code = $?" >> $logfile 2>>&1
    exit 1
fi

if [ ! -f $sftp_outbox/$datafile.dat ]; then
    echo ""  >> $logfile 2>>&1
    echo "Extract File doesn't exist, please investigate..." >> $logfile 2>>&1
    exit 1
fi

echo "Extract file successfully generated at $(date +"%T")" >> $logfile 2>>&1

cp /b $sftp_outbox/$datafile.dat $batch_out_arch/$datafile.dat >> $logfile 2>>&1

if [ $? -ne 0 ]; then
    echo ""  >> $logfile 2>>&1
    echo "*** FAILURE ***"  >> $logfile 2>>&1
    echo "*** Extract Process Failed at $(date +"%T")" >> $logfile 2>>&1
    echo "*** Return Code = $?" >> $logfile 2>>&1
    exit 1
fi

echo ""  >> $logfile 2>>&1
echo "Extract Process Ended Successfully at $(date +"%T")" >> $logfile 2>>&1
echo "Return Code = $?" >> $logfile 2>>&1
exit 0