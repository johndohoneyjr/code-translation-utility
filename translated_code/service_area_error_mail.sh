

#!/bin/bash

cd /d D:\JDABatch/batch/cmd

source D:\JDABatch/fwk/batchenv.sh

echo **************************Batch Job Started****************************** >> $LOG_FILE 2>&1
echo **********************************

error_sub='Service Area to Zone mapping error'
error_mail_rec="REDACTED"
run_date=$(date +"%m%d%Y")
sftp_outbox=D:\SFTP\outbox

batch_outbox=D:\JDABatch\data\out\archive

FWK_DIR=D:\JDABatch\fwk

number=$(grep -c "^.*" $batch_outbox/JDA_NO_ZONE_MAPPING_$run_date*.csv)
echo $number >> $LOG_FILE 2>&1

if [ $number -gt 1 ]; then
  # COPY /b %sftp_outbox%\JDA_NO_ZONE_MAPPING_%run_date%*.dat %batch_outbox%\JDA_ERROR_SUMMARY_%run_date%*.csv>> %LOG_FILE% 2>>&1

  # powershell .\error_extract_mail.ps1 %FWK_DIR%\email_body.log 'Error Extract Summary for JDA Flow' "REDACTED" REDACTED REDACTED %batch_outbox% JDA_ERROR_SUMMARY_%run_date%*.csv>> %LOG_FILE% 2>>&1
  powershell .\error_extract_mail.ps1 $FWK_DIR/email_body.log $error_sub $error_mail_rec REDACTED REDACTED $batch_outbox JDA_NO_ZONE_MAPPING_$run_date*.csv>> $LOG_FILE 2>&1

  # Note: SMTP servers are different for Kansas and Dallas below are details
  # For Dallas use REDACTED
  # For Kansas use REDACTED
fi

batch_status=$?

if [ ! $batch_status -eq 0 ]; then
  echo Error Occured while sending email >> $LOG_FILE 2>&1
  pushd $BATCH_PATH/
  exit 1
fi

rm $batch_outbox/JDA_NO_ZONE_MAPPING_$run_date*.csv>> $LOG_FILE 2>&1 


echo **************************Batch Job Ended******************************** >> $LOG_FILE 2>&1
echo Batch Job  Ended : $(date) >> $LOG_FILE 2>&1
echo ************************************************************************* >> $LOG_FILE 2>&1
pushd $BATCH_PATH/
exit 0