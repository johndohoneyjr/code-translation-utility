ECHO ON
REM ####################################################################
REM FileName:          jbo003_copy_vendororder.bat
REM Description:       Prepare the Vendor Order Export for HDS
REM Note:
REM ####################################################################
REM Modification History
REM
REM Date            Author                    Modifications
REM --------------------------------------------------------------------
rem  04-Apr-2018    REDACTED            Initial Version
REM  04-Nov-2018   REDACTED              Added steps to convert file type
REM
REM ####################################################################



ECHO **************************Recship EXTRACT STARTED************************************************  >> %LOG_FILE% 2>>&1
ECHO  %DATE% %TIME% >> %LOG_FILE% 2>>&1
ECHO *************************************************************************************  >> %LOG_FILE% 2>>&1


SET run_date=%date:~10,4%%date:~4,2%%date:~7,2%
SET run_time=%date:~4,2%%date:~7,2%%date:~10,4%_%time:~0,2%%time:~3,2%%time:~6,2%
SET run_time=%run_time: =0%


SET NLS_DATE_FORMAT=RRRR-MM-DD-HH24:MI

FOR /F "TOKENS=1* DELIMS= " %%A IN ('DATE/T') DO SET CDATE=%%B
FOR /F "TOKENS=1,2 eol=/ DELIMS=/ " %%A IN ('DATE/T') DO SET mm=%%B
FOR /F "TOKENS=1,2 DELIMS=/ eol=/" %%A IN ('ECHO %CDATE%') DO SET dd=%%B
FOR /F "TOKENS=2,3 DELIMS=/ " %%A IN ('ECHO %CDATE%') DO SET yyyy=%%B
SET todaysdate=%yyyy%%mm%%dd%
SET WORKFLOWLOGMONTH=%mm%%yyyy%
SET DATETIMESTAMP=%todaysdate%
FOR /f "tokens=1-3 delims=:." %%A IN ("%time%") DO SET TIMESTAMP=%%A%%b%%C
FOR /f "tokens=1-3 delims= " %%A IN ("%timestamp%") DO SET trimmed_timestamp=%%A%%b%%C
SET TIMESTAMP=%DATETIMESTAMP%_%trimmed_timestamp%
SET datafile=JDA_VENDORORDER_%run_time%



ECHO ---------------------------------------------- >> %LOG_FILE% 2>>&1
ECHO EXTRACT PROCESS Started AT %TIME%, %DATE% >> %LOG_FILE% 2>>&1
ECHO Output will be written TO FILE %DATAFILE%.dat>> %LOG_FILE% 2>>&1
ECHO. >> %LOG_FILE% 2>>&1
CALL sqlplus -s %BATCH_LOGIN% @%SQL_DIR%\jbo003_extract_vendororder.sql %datafile% >> %LOG_FILE% 2>>&1

ECHO EXTRACT PROCESS Ended AT %TIME%, %DATE% >> %LOG_FILE% 2>>&1
ECHO ---------------------------------------------- >> %LOG_FILE% 2>>&1



IF NOT %ERRORLEVEL% == 0 GOTO errorblock

IF NOT EXIST %SFTP_OUT_DIR%\%datafile%.dat (
ECHO.  >> %LOG_FILE% 2>>&1
ECHO Extract File doesn
      't exist, please investigate... >> %LOG_FILE% 2>>&1
GOTO errorblock
)

ECHO Extract file successfully generated at %time% >> %LOG_FILE% 2>>&1

ECHO File conversion from ANSI to UTF-8 started >> %LOG_FILE% 2>>&1
echo copy original file to temp file for conversion >> %LOG_FILE% 2>>&1
copy %SFTP_OUT_DIR%\%datafile%.dat %SFTP_OUT_DIR%\tmp.dat
echo converting file type of temp file to utf-8 >> %LOG_FILE% 2>>&1
powershell.exe -ExecutionPolicy Bypass -Command  D:\jdabatch\batch\cmd\conv_file_type.ps1 at %time% >> %LOG_FILE% 2>>&1
echo file type converted >> %LOG_FILE% 2>>&1
echo copying temp file to original file with utf-8 format >> %LOG_FILE% 2>>&1
copy %SFTP_OUT_DIR%\tmp1.dat %SFTP_OUT_DIR%\%datafile%.dat
echo file type conversion completed. >> %LOG_FILE% 2>>&1
echo deleting temp files >> %LOG_FILE% 2>>&1
del %SFTP_OUT_DIR%\tmp*.dat
echo temp files deleted >> %LOG_FILE% 2>>&1

echo Zipping extract file >> %LOG_FILE% 2>>&1
cd /d %SFTP_OUT_DIR%

D:\java8\bin\jar -cMf %datafile%.zip %datafile%.dat >> %LOG_FILE% 2>>&1

echo Zipped extract file >> %LOG_FILE% 2>>&1

del %datafile%.dat >> %LOG_FILE% 2>>&1

echo Deleted original file >> %LOG_FILE% 2>>&1

COPY /b %SFTP_OUT_DIR%\%datafile%.zip %OUT_ARCH_DIR%\%datafile%.zip >> %LOG_FILE% 2>>&1

echo Copies Zipped file to Archive folder >> %LOG_FILE% 2>>&1

IF NOT %ERRORLEVEL%  == 0 GOTO errorblock

GOTO end

:errorblock
POPD
ECHO.  >> %LOG_FILE% 2>>&1
ECHO *** FAILURE ***  >> %LOG_FILE% 2>>&1
ECHO *** Extract Process Failed at %time% >> %LOG_FILE% 2>>&1
ECHO *** Return Code = %ERRORLEVEL% >> %LOG_FILE% 2>>&1
EXIT /B 1

:end
ECHO.  >> %LOG_FILE% 2>>&1
ECHO Extract Process Ended Successfully at %time% >> %LOG_FILE% 2>>&1
ECHO Return Code = %ERRORLEVEL% >> %LOG_FILE% 2>>&1
POPD
EXIT /B 0

POPD