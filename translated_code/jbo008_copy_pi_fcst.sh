

echo **************************PIFcst EXTRACT ENDED************************************************  >> %LOG_FILE% 2>>&1
echo  %DATE% %TIME% >> %LOG_FILE% 2>>&1
echo *************************************************************************************  >> %LOG_FILE% 2>>&1

ECHO ON

echo **************************PIFcst EXTRACT STARTED************************************************  >> %LOG_FILE% 2>>&1
echo  $(date +"%Y-%m-%d %H:%M") >> %LOG_FILE% 2>>&1
echo *************************************************************************************  >> %LOG_FILE% 2>>&1

run_date=$(date +"%Y%m%d")
run_time=$(date +"%m%d%Y_%H%M%S")
run_time=${run_time// /0}

export NLS_DATE_FORMAT=RRRR-MM-DD-HH24:MI

CDATE=$(date +"%m/%d/%Y")
mm=$(date +"%m")
dd=$(date +"%d")
yyyy=$(date +"%Y")
todaysdate=${yyyy}${mm}${dd}
WORKFLOWLOGMONTH=${mm}${yyyy}
DATETIMESTAMP=${todaysdate}
TIMESTAMP=$(date +"%m%d%Y_%H%M")
trimmed_timestamp=${TIMESTAMP// /0}
TIMESTAMP=${DATETIMESTAMP}_${trimmed_timestamp}
datafile=JDA_PI_FCST_EXTRACT_${run_time}

echo ---------------------------------------------- >> %LOG_FILE% 2>>&1
echo EXTRACT PROCESS Started AT $(date +"%H:%M"), $(date +"%m/%d/%Y") >> %LOG_FILE% 2>>&1
echo Output will be written TO FILE ${datafile}.dat>> %LOG_FILE% 2>>&1
echo. >> %LOG_FILE% 2>>&1
sqlplus -s ${BATCH_LOGIN} @${SQL_DIR}/jbo008_pi_fcst_extract.sql ${datafile} >> %LOG_FILE% 2>>&1

echo EXTRACT PROCESS Ended AT $(date +"%H:%M"), $(date +"%m/%d/%Y") >> %LOG_FILE% 2>>&1
echo ---------------------------------------------- >> %LOG_FILE% 2>>&1

if [ $? -ne 0 ]; then
    echo.  >> %LOG_FILE% 2>>&1
    echo *** FAILURE ***  >> %LOG_FILE% 2>>&1
    echo *** Extract Process Failed at $(date +"%H:%M") >> %LOG_FILE% 2>>&1
    echo *** Return Code = $? >> %LOG_FILE% 2>>&1
    exit 1
fi

echo Extract file successfully generated at $(date +"%H:%M") >> %LOG_FILE% 2>>&1

echo Zipping extract file >> %LOG_FILE% 2>>&1
cd ${SFTP_OUT_DIR}

D:\java8\bin\jar -cMf ${datafile}.zip ${datafile}.