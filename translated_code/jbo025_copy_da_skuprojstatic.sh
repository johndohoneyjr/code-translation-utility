

echo **************************SKUPROJSTATIC EXTRACT ENDED************************************************  >> %LOG_FILE% 2>>&1

echo on
echo **************************SKUPROJSTATIC EXTRACT STARTED************************************************  >> %LOG_FILE% 2>>&1
echo  $(date +"%Y-%m-%d %H:%M") >> %LOG_FILE% 2>>&1
echo *************************************************************************************  >> %LOG_FILE% 2>>&1

run_date=$(date +"%Y%m%d")
run_time=$(date +"%Y%m%d_%H%M%S")
run_time=${run_time// /0}

echo ---------------------------------------------- >> %LOG_FILE% 2>>&1
echo EXTRACT PROCESS Started AT $(date +"%H:%M"), $(date +"%Y-%m-%d") >> %LOG_FILE% 2>>&1
echo Output will be written TO FILE $datafile.dat>> %LOG_FILE% 2>>&1
echo. >> %LOG_FILE% 2>>&1
sqlplus -s %BATCH_LOGIN% @%SQL_DIR%/jbo025_extract_da_skuprojstatic.sql $datafile >> %LOG_FILE% 2>>&1

echo EXTRACT PROCESS Ended AT $(date +"%H:%M"), $(date +"%Y-%m-%d") >> %LOG_FILE% 2>>&1
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
cd $SFTP_OUT_DIR

/d/java8/bin/jar -cMf $datafile.zip $datafile.dat >> %LOG_FILE% 2>>&1

echo Zipped extract file >> %LOG_FILE% 2>>&1

rm $datafile.dat >> %LOG_FILE% 2>>&1

echo Deleted original file >> %LOG_FILE% 2>>&1

cp /b $SFTP_OUT_DIR/$datafile.zip $OUT_ARCH_DIR/$datafile.zip >> %LOG_FILE% 2>>&1

echo Copies Zipped file to Archive folder >> %LOG_FILE%