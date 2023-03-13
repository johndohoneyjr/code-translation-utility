

echo **************************Hist EXTRACT ENDED************************************************  >> %LOG_FILE% 2>>&1
echo  %DATE% %TIME% >> %LOG_FILE% 2>>&1
echo *************************************************************************************  >> %LOG_FILE% 2>>&1

ECHO ON

echo **************************Hist EXTRACT STARTED************************************************  >> "$LOG_FILE" 2>&1
echo  $(date +"%Y-%m-%d %H:%M") >> "$LOG_FILE" 2>&1
echo *************************************************************************************  >> "$LOG_FILE" 2>&1

run_date=$(date +"%Y%m%d")
run_time=$(date +"%d%m%Y_%H%M%S")
run_time=${run_time// /0}

export NLS_DATE_FORMAT="RRRR-MM-DD-HH24:MI"

CDATE=$(date +"%d/%m/%Y")
mm=$(date +"%m")
dd=$(date +"%d")
yyyy=$(date +"%Y")
todaysdate="$yyyy$mm$dd"
WORKFLOWLOGMONTH="$mm$yyyy"
DATETIMESTAMP="$todaysdate"
TIMESTAMP=$(echo "$DATETIMESTAMP"_$(date +"%H%M%S" | tr -d ' '))
datafile="JDA_HIST_$run_time"

echo ---------------------------------------------- >> "$LOG_FILE" 2>&1
echo EXTRACT PROCESS Started AT $(date +"%H:%M"), $(date +"%d/%m/%Y") >> "$LOG_FILE" 2>&1
echo Output will be written TO FILE "$datafile".dat>> "$LOG_FILE" 2>&1
echo. >> "$LOG_FILE" 2>&1
sqlplus -s "$BATCH_LOGIN" "@$SQL_DIR/jbo005_extract_hist.sql" "$datafile" >> "$LOG_FILE" 2>&1

echo EXTRACT PROCESS Ended AT $(date +"%H:%M"), $(date +"%d/%m/%Y") >> "$LOG_FILE" 2>&1
echo ---------------------------------------------- >> "$LOG_FILE" 2>&1

if [ $? -ne 0 ]; then
    echo.  >> "$LOG_FILE" 2>&1
    echo *** FAILURE ***  >> "$LOG_FILE" 2>&1
    echo *** Extract Process Failed at $(date +"%H:%M") >> "$LOG_FILE" 2>&1
    echo *** Return Code = $? >> "$LOG_FILE" 2>&1
    exit 1
fi

echo Extract file successfully generated at $(date +"%H:%M") >> "$LOG_FILE" 2>&1

echo Zipping extract file >> "$LOG_FILE" 2>&1

cd "$SFTP_OUT_DIR"

/usr/java/jdk1.8.0_181/bin/jar -cMf "$datafile".zip "$datafile".dat >> "$LOG_FILE" 2>&1

echo Zipped extract file >> "$LOG_FILE" 2>