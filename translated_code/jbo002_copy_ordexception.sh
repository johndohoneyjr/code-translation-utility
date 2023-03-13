

echo **************************Recship EXTRACT ENDED************************************************  >> %LOG_FILE% 2>>&1

echo on

SET run_date=`date +%Y%m%d`
SET run_time=`date +%Y%m%d_%H%M%S`
SET NLS_DATE_FORMAT=RRRR-MM-DD-HH24:MI

CDATE=`date +"%D"`
mm=`echo $CDATE | awk -F "/" '{print $1}'`
dd=`echo $CDATE | awk -F "/" '{print $2}'`
yyyy=`echo $CDATE | awk -F "/" '{print $3}'`
todaysdate=$yyyy$mm$dd
WORKFLOWLOGMONTH=$mm$yyyy
DATETIMESTAMP=$todaysdate
TIMESTAMP=`echo $DATETIMESTAMP`_`date +"%H%M%S" | tr -d ' '`
datafile=JDA_ORDEREXCEPTIONS_$run_time

echo **************************Recship EXTRACT STARTED************************************************  >> $LOG_FILE 2>>&1
echo  `date` >> $LOG_FILE 2>>&1
echo *************************************************************************************  >> $LOG_FILE 2>>&1

echo ---------------------------------------------- >> $LOG_FILE 2>>&1
echo EXTRACT PROCESS Started AT `date +"%T"`, `date +"%D"` >> $LOG_FILE 2>>&1
echo Output will be written TO FILE $datafile.dat>> $LOG_FILE 2>>&1
echo. >> $LOG_FILE 2>>&1
sqlplus -s $BATCH_LOGIN @$SQL_DIR/jbo002_extract_ordexception.sql $datafile >> $LOG_FILE 2>>&1

echo EXTRACT PROCESS Ended AT `date +"%T"`, `date +"%D"` >> $LOG_FILE 2>>&1
echo ---------------------------------------------- >> $LOG_FILE 2>>&1

if [ $? -ne 0 ]; then
    echo.  >> $LOG_FILE 2>>&1
    echo *** FAILURE ***  >> $LOG_FILE 2>>&1
    echo *** Extract Process Failed at `date +"%T"` >> $LOG_FILE 2>>&1
    echo *** Return Code = $? >> $LOG_FILE 2>>&1
    exit 1
fi

if [ ! -f $SFTP_OUT_DIR/$datafile.dat ]; then
    echo.  >> $LOG_FILE 2>>&1
    echo Extract File doesn't exist, please investigate... >> $LOG_FILE 2>>&1
    exit 1
fi

echo Extract file successfully generated at `date +"%T"` >> $LOG_FILE 2>>&1

echo Zipping extract file >> $LOG_FILE 2>>&1
cd $SFTP_OUT_DIR

/usr/java/jdk1.8.0_181/bin/jar -cMf $datafile.zip $datafile.dat >> $LOG_FILE 2>>&1

echo Zipped extract file >> $LOG_