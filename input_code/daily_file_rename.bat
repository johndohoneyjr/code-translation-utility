echo on
rem ################################################################################################################################################
rem FileName:          daily_file_rename.bat
rem Description:       
rem Author:            
rem Date Created:       
rem Last Modified:      (See Modification History)
rem ################################################################################################################################################
rem
rem Modification History
rem
rem Date                               Author                                              Modifications
rem -----------------------------------------------------------------------------------------------------------------------------------------------
rem  18-Apr-2018                    				                                         Initial Version
rem  29-Mar-2019                    				                                         Added JDA_IFC_PO_OUT file
rem ################################################################################################################################################

cd /d D:\JDABatch\batch\cmd

call D:\JDABatch\fwk\batchenv.bat

set sftp_inbox=D:\SFTP\inbox
set batch_inbox=D:\JDABatch\data\in
set batch_log=D:\JDABatch\log
set batch_inbox_archive=D:\JDABatch\data\in\archive

set run_date=%date:~4,2%%date:~7,2%%date:~10,4%
set run_time=%date:~10,4%%date:~4,2%%date:~7,2%_%time:~0,2%%time:~3,2%%time:~6,2%
set run_time=%run_time: =0%
set log_file=DAILY_FILE_RENAME_%run_time%.log

rem for /f %%a in ('powershell "[DateTime]::Today.AddDays(-1).ToString("""MMddyyyy""")"') do set run_date=%%a
 
echo %run_date%  >> %batch_log%\%log_file% 2>>&1

ECHO ************************** DAILY_FILE_RENAME STARTED ************************************************  > %batch_log%\%log_file% 2>>&1
echo DAILY_FILE_RENAME STARTED: %date% %time% >> %batch_log%\%log_file% 2>>&1
Echo *************************************************************************************   >> %batch_log%\%log_file% 2>>&1
IF EXIST %sftp_inbox%\JDA_DMDUNIT_%run_date%*.dat IF EXIST %sftp_inbox%\JDA_LOC_%run_date%*.dat IF EXIST %sftp_inbox%\JDA_VENDORSKU_%run_date%*.dat IF EXIST %sftp_inbox%\JDA_SKU_%run_date%*.dat IF EXIST %sftp_inbox%\JDA_SOURCING_%run_date%*.dat IF EXIST %sftp_inbox%\JDA_DMDTODATE_%run_date%*.zip IF EXIST %sftp_inbox%\JDA_ONHAND_%run_date%*.dat IF EXIST %sftp_inbox%\JDA_SCHEDRCPTS_%run_date%*.zip IF EXIST %sftp_inbox%\JDA_CUSTORDER_%run_date%*.zip IF EXIST %sftp_inbox%\JDA_VEHICLELOAD_%run_date%*.dat IF EXIST %sftp_inbox%\JDA_VEHICLELOADLINE_%run_date%*.dat IF EXIST %sftp_inbox%\JDA_DFUTOSKUMAP_%run_date%*.zip IF EXIST %sftp_inbox%\JDA_PI_FORECAST_%run_date%*.zip IF EXIST %sftp_inbox%\JDA_SOURCINGUOMCONVFACTOR_%run_date%*.zip IF EXIST %sftp_inbox%\JDA_UOMCATEGORYCONVFACTOR_%run_date%*.zip IF EXIST %sftp_inbox%\JDA_NETWORKCAP_%run_date%*.dat IF EXIST %sftp_inbox%\JDA_IFC_PO_OUT_%run_date%*.dat IF EXIST %sftp_inbox%\JDA_PLANNING_%run_date%*.done (
del %batch_inbox%\*.dat >> %batch_log%\%log_file%
echo OLD DAT FILES ARE DELETED FROM BATCH INBOX: %date% %time% >> %batch_log%\%log_file% 2>>&1

COPY /b %sftp_inbox%\JDA_DMDUNIT_%run_date%*.dat %batch_inbox%\jbi001_load_dmdunit.dat >> %batch_log%\%log_file% 2>>&1
COPY /b %sftp_inbox%\JDA_LOC_%run_date%*.dat %batch_inbox%\jbi002_load_loc.dat >> %batch_log%\%log_file% 2>>&1
COPY /b %sftp_inbox%\JDA_VENDORSKU_%run_date%*.dat %batch_inbox%\jbi015_load_vendorsku.dat >> %batch_log%\%log_file% 2>>&1
COPY /b %sftp_inbox%\JDA_SKU_%run_date%*.dat %batch_inbox%\jbi005_load_sku.dat >> %batch_log%\%log_file% 2>>&1
COPY /b %sftp_inbox%\JDA_SOURCING_%run_date%*.dat %batch_inbox%\jbi007_load_stg_sourcing.dat >> %batch_log%\%log_file% 2>>&1
COPY /b %sftp_inbox%\JDA_ONHAND_%run_date%*.dat %batch_inbox%\jbi008_load_onhand.dat >> %batch_log%\%log_file% 2>>&1
COPY /b %sftp_inbox%\JDA_VEHICLELOAD_%run_date%*.dat %batch_inbox%\jbi012_load_vehicleload.dat >> %batch_log%\%log_file% 2>>&1
COPY /b %sftp_inbox%\JDA_VEHICLELOADLINE_%run_date%*.dat %batch_inbox%\jbi013_load_vehicleloadline.dat >> %batch_log%\%log_file% 2>>&1
cd D:\SFTP\inbox
D:\java8\bin\jar xf JDA_PI_FORECAST_%run_date%*.zip >> %batch_log%\%log_file% 2>>&1
D:\java8\bin\jar xf JDA_DMDTODATE_%run_date%*.zip >> %batch_log%\%log_file% 2>>&1
D:\java8\bin\jar xf JDA_SCHEDRCPTS_%run_date%*.zip >> %batch_log%\%log_file% 2>>&1
D:\java8\bin\jar xf JDA_CUSTORDER_%run_date%*.zip >> %batch_log%\%log_file% 2>>&1
D:\java8\bin\jar xf JDA_DFUTOSKUMAP_%run_date%*.zip >> %batch_log%\%log_file% 2>>&1
D:\java8\bin\jar xf JDA_UOMCATEGORYCONVFACTOR_%run_date%*.zip >> %batch_log%\%log_file% 2>>&1
D:\java8\bin\jar xf JDA_SOURCINGUOMCONVFACTOR_%run_date%*.zip >> %batch_log%\%log_file% 2>>&1
cd /d D:\JDABatch\batch\cmd
COPY /b %sftp_inbox%\JDA_PI_FORECAST_%run_date%*.dat %batch_inbox%\jbi009_load_piforecast.dat >> %batch_log%\%log_file% 2>>&1
COPY /b %sftp_inbox%\JDA_DMDTODATE_%run_date%*.dat %batch_inbox%\jbi011_load_dmdtodate.dat >> %batch_log%\%log_file% 2>>&1
COPY /b %sftp_inbox%\JDA_SCHEDRCPTS_%run_date%*.dat %batch_inbox%\jbi016_load_schedrcpts.dat >> %batch_log%\%log_file% 2>>&1
COPY /b %sftp_inbox%\JDA_CUSTORDER_%run_date%*.dat %batch_inbox%\jbi014_load_custorder.dat >> %batch_log%\%log_file% 2>>&1
COPY /b %sftp_inbox%\JDA_DFUTOSKUMAP_%run_date%*.dat %batch_inbox%\jbi010_load_dfutosku.dat >> %batch_log%\%log_file% 2>>&1
COPY /b %sftp_inbox%\JDA_UOMCATEGORYCONVFACTOR_%run_date%*.dat %batch_inbox%\jbi006_load_uomcatconvfactor.dat >> %batch_log%\%log_file% 2>>&1
COPY /b %sftp_inbox%\JDA_SOURCINGUOMCONVFACTOR_%run_date%*.dat %batch_inbox%\jbi017_load_srcuomconv.dat >> %batch_log%\%log_file% 2>>&1
COPY /b %sftp_inbox%\JDA_NETWORKCAP_%run_date%*.dat %batch_inbox%\jbi018_load_networkcap.dat >> %batch_log%\%log_file% 2>>&1
COPY /b %sftp_inbox%\JDA_IFC_PO_OUT_%run_date%*.dat %batch_inbox%\jbi019_load_udt_ifc_po.dat >> %batch_log%\%log_file% 2>>&1
COPY /b %sftp_inbox%\JDA_PLANNING_%run_date%*.done %batch_inbox%\JDA_PLANNING.dat >> %batch_log%\%log_file% 2>>&1

del %sftp_inbox%\JDA_PI_FORECAST_%run_date%*.dat >> %batch_log%\%log_file%
del %sftp_inbox%\JDA_DMDTODATE_%run_date%*.dat >> %batch_log%\%log_file%
del %sftp_inbox%\JDA_SCHEDRCPTS_%run_date%*.dat >> %batch_log%\%log_file%
del %sftp_inbox%\JDA_CUSTORDER_%run_date%*.dat >> %batch_log%\%log_file%
del %sftp_inbox%\JDA_DFUTOSKUMAP_%run_date%*.dat >> %batch_log%\%log_file%
del %sftp_inbox%\JDA_UOMCATEGORYCONVFACTOR_%run_date%*.dat >> %batch_log%\%log_file%
del %sftp_inbox%\JDA_SOURCINGUOMCONVFACTOR_%run_date%*.dat >> %batch_log%\%log_file%

MOVE /Y %sftp_inbox%\JDA_DMDUNIT_%run_date%*.dat %batch_inbox_archive% >> %batch_log%\%log_file% 2>>&1
MOVE /Y %sftp_inbox%\JDA_LOC_%run_date%*.dat %batch_inbox_archive% >> %batch_log%\%log_file% 2>>&1
MOVE /Y %sftp_inbox%\JDA_VENDORSKU_%run_date%*.dat %batch_inbox_archive% >> %batch_log%\%log_file% 2>>&1
MOVE /Y %sftp_inbox%\JDA_SKU_%run_date%*.dat %batch_inbox_archive% >> %batch_log%\%log_file% 2>>&1
MOVE /Y %sftp_inbox%\JDA_SOURCING_%run_date%*.dat %batch_inbox_archive% >> %batch_log%\%log_file% 2>>&1
MOVE /Y %sftp_inbox%\JDA_DMDTODATE_%run_date%*.zip %batch_inbox_archive% >> %batch_log%\%log_file% 2>>&1
MOVE /Y %sftp_inbox%\JDA_ONHAND_%run_date%*.dat %batch_inbox_archive% >> %batch_log%\%log_file% 2>>&1
MOVE /Y %sftp_inbox%\JDA_SCHEDRCPTS_%run_date%*.zip %batch_inbox_archive% >> %batch_log%\%log_file% 2>>&1
MOVE /Y %sftp_inbox%\JDA_CUSTORDER_%run_date%*.zip %batch_inbox_archive% >> %batch_log%\%log_file% 2>>&1
MOVE /Y %sftp_inbox%\JDA_VEHICLELOAD_%run_date%*.dat %batch_inbox_archive% >> %batch_log%\%log_file% 2>>&1
MOVE /Y %sftp_inbox%\JDA_VEHICLELOADLINE_%run_date%*.dat %batch_inbox_archive% >> %batch_log%\%log_file% 2>>&1
MOVE /Y %sftp_inbox%\JDA_DFUTOSKUMAP_%run_date%*.zip %batch_inbox_archive% >> %batch_log%\%log_file% 2>>&1
MOVE /Y %sftp_inbox%\JDA_PI_FORECAST_%run_date%*.zip %batch_inbox_archive% >> %batch_log%\%log_file% 2>>&1
MOVE /Y %sftp_inbox%\JDA_SOURCINGUOMCONVFACTOR_%run_date%*.zip %batch_inbox_archive% >> %batch_log%\%log_file% 2>>&1
MOVE /Y %sftp_inbox%\JDA_UOMCATEGORYCONVFACTOR_%run_date%*.zip %batch_inbox_archive% >> %batch_log%\%log_file% 2>>&1
MOVE /Y %sftp_inbox%\JDA_NETWORKCAP_%run_date%*.dat %batch_inbox_archive% >> %batch_log%\%log_file% 2>>&1
MOVE /Y %sftp_inbox%\JDA_IFC_PO_OUT_%run_date%*.dat %batch_inbox_archive% >> %batch_log%\%log_file% 2>>&1
MOVE /Y %sftp_inbox%\JDA_PLANNING_%run_date%*.done %batch_inbox_archive% >> %batch_log%\%log_file% 2>>&1



echo DAILY_FILE_RENAME COMPLETED: %date% %time% >> %batch_log%\%log_file% 2>>&1
ECHO ************************** DAILY_FILE_RENAME ENDED ******************************  >> %batch_log%\%log_file% 2>>&1
echo DAILY_FILE_RENAME ENDED: %date% %time% >> %batch_log%\%log_file% 2>>&1
Echo *************************************************************************************   >> %batch_log%\%log_file% 2>>&1

GOTO success
)

IF NOT EXIST %sftp_inbox%\JDA_DMDUNIT_%run_date%*.dat GOTO end
IF NOT EXIST %sftp_inbox%\JDA_LOC_%run_date%*.dat GOTO end
IF NOT EXIST %sftp_inbox%\JDA_VENDORSKU_%run_date%*.dat GOTO end
IF NOT EXIST %sftp_inbox%\JDA_SKU_%run_date%*.dat GOTO end
IF NOT EXIST %sftp_inbox%\JDA_SOURCING_%run_date%*.dat GOTO end
IF NOT EXIST %sftp_inbox%\JDA_DMDTODATE_%run_date%*.zip GOTO end
IF NOT EXIST %sftp_inbox%\JDA_ONHAND_%run_date%*.dat GOTO end
IF NOT EXIST %sftp_inbox%\JDA_SCHEDRCPTS_%run_date%*.zip GOTO end
IF NOT EXIST %sftp_inbox%\JDA_CUSTORDER_%run_date%*.zip GOTO end
IF NOT EXIST %sftp_inbox%\JDA_VEHICLELOAD_%run_date%*.dat GOTO end
IF NOT EXIST %sftp_inbox%\JDA_VEHICLELOADLINE_%run_date%*.dat GOTO end
IF NOT EXIST %sftp_inbox%\JDA_DFUTOSKUMAP_%run_date%*.zip GOTO end
IF NOT EXIST %sftp_inbox%\JDA_PI_FORECAST_%run_date%*.zip GOTO end
IF NOT EXIST %sftp_inbox%\JDA_SOURCINGUOMCONVFACTOR_%run_date%*.zip GOTO end
IF NOT EXIST %sftp_inbox%\JDA_UOMCATEGORYCONVFACTOR_%run_date%*.zip GOTO end
IF NOT EXIST %sftp_inbox%\JDA_NETWORKCAP_%run_date%*.dat GOTO end
IF NOT EXIST %sftp_inbox%\JDA_IFC_PO_OUT_%run_date%*.dat GOTO end
IF NOT EXIST %sftp_inbox%\JDA_PLANNING_%run_date%*.done GOTO end



:success

EndLocal
exit /B 0

:end 
echo *** DAILY_FILE_RENAME DAT FILES ARE MISSING: %date% %time% >> %batch_log%\%log_file% 2>>&1
ECHO ************************** DAILY_FILE_RENAME ENDED ******************************  >> %batch_log%\%log_file% 2>>&1
echo DAILY_FILE_RENAME ENDED: %date% %time% >> %batch_log%\%log_file% 2>>&1
Echo *************************************************************************************   >> %batch_log%\%log_file% 2>>&1
EndLocal
exit /B 99