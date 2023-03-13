

echo **************************Recshiprpt EXTRACT ENDED************************************************  >> %LOG_FILE% 2>>&1
echo  %DATE% %TIME% >> %LOG_FILE% 2>>&1
echo *************************************************************************************  >> %LOG_FILE% 2>>&1

ECHO ON

echo **************************Recshiprpt EXTRACT STARTED************************************************  >> %LOG_FILE% 2>>&1
echo  $(date +"%Y-%m-%d %H:%M") >> %LOG_FILE% 2>>&1
echo *************************************************************************************  >> %LOG_FILE% 2>>&1

run_date=$(date +"%Y%m%d")
run_time=$(date +"%Y%m%d_%H%M%S")
run_time=${run_time// /0}

export NLS_DATE_FORMAT=RRRR-MM-DD-HH24:MI

mm=$(date +"%m")
dd=$(date +"%d")
yyyy=$(date +"%Y")
todaysdate="$yyyy$mm$dd"
WORKFLOWLOGMONTH="$mm$yyyy"
DATETIMESTAMP="$todaysdate"
TIMESTAMP=$(echo "$DATETIMESTAMP"_"$(date +"%H%M%S" | tr -d ' ')")
datafile="JDA_DARECSHIPRPT_$run_time"

echo ---------------------------------------------- >> %LOG_FILE% 2>>&1
echo EXTRACT PROCESS Started AT $(date +"%H:%M"), $(date +"%d-%m-%Y") >> %LOG_FILE% 2>>&1
echo Output will be written TO FILE $datafile.dat>> %LOG_FILE% 2>>&1
echo. >> %LOG_FILE% 2>>&1
sqlplus -s %BATCH_LOGIN% @%SQL_DIR%\jbo024_extract_da_recshiprpt.sql $datafile >> %LOG_FILE% 2>>&1

echo EXTRACT PROCESS Ended AT $(date +"%H:%M"), $(date +"%d-%m-%Y") >> %LOG_FILE% 2>>&1
echo ---------------------------------------------- >> %LOG_FILE% 2>>&1

if [ $? -ne 0 ]; then
    echo.  >> %LOG_FILE% 2>>&1
    echo *** FAILURE ***  >> %LOG_FILE% 2>>&1
    echo *** Extract Process Failed at $(date +"%H:%M") >> %LOG_FILE% 2>>&1
    echo *** Return Code = $? >> %LOG_FILE% 2>>&1
    exit 1
fi

if [ ! -f "$SFTP_OUT_DIR/$data