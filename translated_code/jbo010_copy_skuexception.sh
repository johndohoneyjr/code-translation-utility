

echo **************************skuexception EXTRACT ENDED************************************************  >> %LOG_FILE% 2>>&1
echo  %DATE% %TIME% >> %LOG_FILE% 2>>&1
echo *************************************************************************************  >> %LOG_FILE% 2>>&1

echo **************************skuexception EXTRACT STARTED************************************************  >> $LOG_FILE 2>>&1
echo  $(date +"%Y-%m-%d %H:%M") >> $LOG_FILE 2>>&1
echo *************************************************************************************  >> $LOG_FILE 2>>&1

run_date=$(date +"%Y%m%d")
run_time=$(date +"%H%M%S_%Y%m%d")

export NLS_DATE_FORMAT=RRRR-MM-DD-HH24:MI

cd_date=$(date +"%d %b %Y")
cd_month=$(date +"%b %Y")
cd_date_no_space=$(date +"%Y%m%d")
cd_timestamp=$(date +"%Y%m%d_%H%M%S")

datafile="JDA_SKUEXCEPTION_$run_time"

echo ---------------------------------------------- >> $LOG_FILE 2>>&1
echo EXTRACT PROCESS Started AT $(date +"%H:%M"), $(date +"%d %b %Y") >> $LOG_FILE 2>>&1
echo Output will be written TO FILE $datafile.dat>> $LOG_FILE 2>>&1
echo. >> $LOG_FILE 2>>&1
sqlplus -s $BATCH_LOGIN @$SQL_DIR/jbo010_skuexception_extract.sql $datafile >> $LOG_FILE 2>>&1

echo EXTRACT PROCESS Ended AT $(date +"%H:%M"), $(date +"%d %b %Y") >> $LOG_FILE 2>>&1
echo ---------------------------------------------- >> $LOG_FILE 2>>&1

if [ $? -ne 0 ]; then
    echo.  >> $LOG_FILE 2>>&1
    echo *** FAILURE ***  >> $LOG_FILE 2>>&1
    echo *** Extract Process Failed at $(date +"%H:%M") >> $LOG_FILE 2>>&1
    echo *** Return Code = $? >> $LOG_FILE 2>>&1
    exit 1
fi

echo Extract file successfully generated at $(date +"%H:%M") >> $LOG_FILE 2>>&1

if [ ! -f $SFTP_OUT_DIR/$datafile.dat ]; then
    echo.  >> $LOG_FILE 2>>&1
    echo Extract File doesn't exist, please investigate... >> $LOG_FILE 2>>&1
    exit 1
fi

echo Zipping extract file >> $LOG_FILE 2>>&1
cd $SFTP_OUT_DIR

/usr/java/jdk1.8.0_181/bin/jar -cMf $datafile.zip $datafile.dat >> $LOG_FILE 2>>&1

echo Zipped extract file >> $LOG_FILE 2>>&1

rm $datafile.dat >> $LOG_FILE 2