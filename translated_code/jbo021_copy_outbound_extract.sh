

echo **************************outboundextract EXTRACT ENDED************************************************  >> %LOG_FILE% 2>>&1
echo  %DATE% %TIME% >> %LOG_FILE% 2>>&1
echo *************************************************************************************  >> %LOG_FILE% 2>>&1

echo **************************outboundextract EXTRACT STARTED************************************************  >> $LOG_FILE 2>>&1
echo  $(date +"%Y-%m-%d %H:%M") >> $LOG_FILE 2>>&1
echo *************************************************************************************  >> $LOG_FILE 2>>&1

run_date=$(date +"%Y%m%d")
run_time=$(date +"%m%d%Y_%H%M%S")
run_time=${run_time// /0}

export NLS_DATE_FORMAT=RRRR-MM-DD-HH24:MI

mm=$(date +"%m")
dd=$(date +"%d")
yyyy=$(date +"%Y")
todaysdate="$yyyy$mm$dd"
WORKFLOWLOGMONTH="$mm$yyyy"
DATETIMESTAMP="$todaysdate"
timestamp=$(date +"%H%M")
trimmed_timestamp=${timestamp// /0}
TIMESTAMP="$DATETIMESTAMP"_"$trimmed_timestamp"
datafile="JDA_PLANNING_EXTRACT_$run_time"

echo -------------------------------------------------------- >> $LOG_FILE 2>>&1
echo Removing previous day Planning_Extract file from Outbox AT $(date +"%H:%M"), $(date +"%Y-%m-%d") >> $LOG_FILE 2>>&1
rm $SFTP_OUT_DIR/JDA_PLANNING_EXTRACT*.dat  >> $LOG_FILE 2>>&1
echo Previous day Planning_Extract file has been deleted  AT $(date +"%H:%M"), $(date +"%Y-%m-%d") >> $LOG_FILE 2>>&1
echo ---------------------------------------------- >> $LOG_FILE 2>>&1

echo ---------------------------------------------- >> $LOG_FILE 2>>&1
echo EXTRACT PROCESS Started AT $(date +"%H:%M"), $(date +"%Y-%m-%d") >> $LOG_FILE 2>>&1
echo Output will be written TO FILE $DATAFILE.dat>> $LOG_