******************************************************************{
  "error": {
    "message": "You requested a length 0 completion, but you did not set the 'echo' parameter. That means that we will return no data to you. (HINT: set 'echo' to true in order for the API to echo back the prompt to you.)",
    "type": "invalid_request_error",
    "param": null,
    "code": null
  }
}
******************************************************************
echo on
rem ################################################################################################################################################
rem FileName:          housekeeping_sre.bat
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
rem  15-May-20178                   REDACTED                                             Initial Version

rem call D:\JDAbatch\Batch_fwk\fwk\batchenv.bat

ECHO **************************HOUSEKEEPING STARTED************************************************  >> %LOG_FILE% 2>>&1
echo  %date% %time% >> %LOG_FILE% 2>>&1
Echo *************************************************************************************  >> %LOG_FILE% 2>>&1

set run_date=%date:~4,2%%date:~7,2%%date:~10,4%
set run_time=%date:~4,2%%date:~7,2%%date:~10,4%_%time:~0,2%%time:~3,2%%time:~6,2%
set run_time=%run_time: =0%

SET keepDD=30
SET logPath=D:\JDA\JDA2016_1_SRE\

SET logFileExt=ImportExport*.txt
SET _CmdResult=NONE

FOR /F "tokens=*" %%a IN ('FORFILES /P %logPath% /M %logFileExt% /D -%keepDD% /C "cmd /c DEL @file" 2^>^&1 ^| FINDSTR ERROR') DO SET _CmdResult=%%a
IF "%_CmdResult%" == "ERROR: No files found with the specified search criteria." ( 
    SET errorlevel=0 
 ) ELSE ( 
    SET errorlevel=1
 )
IF "%_CmdResult%" == "NONE" SET errorlevel=0

IF %ERRORLEVEL% == 1 GOTO errorblock

Echo Deleted Import/Export files from SRE   >> %LOG_FILE% 2>>&1


SET keepDD=30
SET logPath=D:\JDA\JDA2016_1_SRE\config\logs
SET logFileExt=*.*
SET _CmdResult=NONE

FOR /F "tokens=*" %%a IN ('FORFILES /P %logPath% /M %logFileExt% /D -%keepDD% /C "cmd /c DEL @file" 2^>^&1 ^| FINDSTR ERROR') DO SET _CmdResult=%%a
IF "%_CmdResult%" == "ERROR: No files found with the specified search criteria." ( 
    SET errorlevel=0 
 ) ELSE ( 
    SET errorlevel=1
 )
IF "%_CmdResult%" == "NONE" SET errorlevel=0
IF %ERRORLEVEL% == 1 GOTO errorblock

Echo Deleted Logs files from SRE   >> %LOG_FILE% 2>>&1

SET keepDD=30
SET logPath=D:\JDAbatch\log
SET logFileExt=*.*
SET _CmdResult=NONE

FOR /F "tokens=*" %%a IN ('FORFILES /P %logPath% /M %logFileExt% /D -%keepDD% /C "cmd /c DEL @file" 2^>^&1 ^| FINDSTR ERROR') DO SET _CmdResult=%%a
IF "%_CmdResult%" == "ERROR: No files found with the specified search criteria." ( 
    SET errorlevel=0 
 ) ELSE ( 
    SET errorlevel=1
 )
IF "%_CmdResult%" == "NONE" SET errorlevel=0

IF %ERRORLEVEL% == 1 GOTO errorblock
	
Echo Deleted batch log files from SRE   >> %LOG_FILE% 2>>&1



SET keepDD=30
SET logPath=D:\JDAbatch\data\in\archive
SET logFileExt=*.*
SET _CmdResult=NONE

FOR /F "tokens=*" %%a IN ('FORFILES /P %logPath% /M %logFileExt% /D -%keepDD% /C "cmd /c DEL @file" 2^>^&1 ^| FINDSTR ERROR') DO SET _CmdResult=%%a
IF "%_CmdResult%" == "ERROR: No files found with the specified search criteria." ( 
    SET errorlevel=0 
 ) ELSE ( 
    SET errorlevel=1
 )
IF "%_CmdResult%" == "NONE" SET errorlevel=0

IF %ERRORLEVEL% == 1 GOTO errorblock
	
Echo Deleted archive files from IN archive >> %LOG_FILE% 2>>&1


SET keepDD=30
SET logPath=D:\JDAbatch\data\out\archive
SET logFileExt=*.csv
SET _CmdResult=NONE
FOR /F "tokens=*" %%a IN ('FORFILES /P %logPath% /M %logFileExt% /D -%keepDD% /C "cmd /c DEL @file" 2^>^&1 ^| FINDSTR ERROR') DO SET _CmdResult=%%a
IF "%_CmdResult%" == "ERROR: No files found with the specified search criteria." ( 
    SET errorlevel=0 
 ) ELSE ( 
    SET errorlevel=1
 )
IF "%_CmdResult%" == "NONE" SET errorlevel=0

IF %ERRORLEVEL% == 1 GOTO errorblock
	
Echo Deleted archive files from Out archive >> %LOG_FILE% 2>>&1


set "_LIST=%TEMP%\%~n0.tmp"
SET keepDD=15
SET logPath=D:\jdabatch\data\out\archive
SET logFileExt=*.dat

> "%_LIST%" (
    for /F "delims=" %%F in ('
        forfiles /S /P "%logPath%" /M "%logFileExt%" /D -%keepDD% /C "cmd /C echo @file"
    ') do echo(%%~F
) && (
    cd /d D:\jdabatch\data\out\archive
    D:\java8\bin\jar -cMf "%run_date%.zip" @"%_LIST%"
)

Echo Archived files older than 15 Days from data/Out archive >> %LOG_FILE% 2>>&1

set "_LIST=%TEMP%\%~n0.tmp"
SET keepDD=15
SET logPath=D:\jdabatch\data\in\archive
SET logFileExt=*.dat

> "%_LIST%" (
    for /F "delims=" %%F in ('
        forfiles /S /P "%logPath%" /M "%logFileExt%" /D -%keepDD% /C "cmd /C echo @file"
    ') do echo(%%~F
) && (
    cd /d D:\jdabatch\data\in\archive
    D:\java8\bin\jar -cMf "%run_date%.zip" @"%_LIST%"
)

Echo Archived files older than 15 Days from data/In archive >> %LOG_FILE% 2>>&1

SET keepDD=15
SET logPath=D:\jdabatch\data\in\archive
SET logFileExt=*.dat
SET _CmdResult=NONE

FOR /F "tokens=*" %%a IN ('FORFILES /P %logPath% /M %logFileExt% /D -%keepDD% /C "cmd /c DEL @file" 2^>^&1 ^| FINDSTR ERROR') DO SET _CmdResult=%%a
IF "%_CmdResult%" == "ERROR: No files found with the specified search criteria." ( 
    SET errorlevel=0 
 ) ELSE ( 
    SET errorlevel=1
 )
IF "%_CmdResult%" == "NONE" SET errorlevel=0

IF %ERRORLEVEL% == 1 GOTO errorblock

Echo Deleted archived files from data/in archive   >> %LOG_FILE% 2>>&1

SET keepDD=15
SET logPath=D:\jdabatch\data\out\archive
SET logFileExt=*.dat
SET _CmdResult=NONE

FOR /F "tokens=*" %%a IN ('FORFILES /P %logPath% /M %logFileExt% /D -%keepDD% /C "cmd /c DEL @file" 2^>^&1 ^| FINDSTR ERROR') DO SET _CmdResult=%%a
IF "%_CmdResult%" == "ERROR: No files found with the specified search criteria." ( 
    SET errorlevel=0 
 ) ELSE ( 
    SET errorlevel=1
 )
IF "%_CmdResult%" == "NONE" SET errorlevel=0

IF %ERRORLEVEL% == 1 GOTO errorblock

Echo Deleted archived files from data/out archive   >> %LOG_FILE% 2>>&1

SET keepDD=30
SET logPath=D:\jdabatch\data\in\archive
SET logFileExt=*.zip
SET _CmdResult=NONE

FOR /F "tokens=*" %%a IN ('FORFILES /P %logPath% /M %logFileExt% /D -%keepDD% /C "cmd /c DEL @file" 2^>^&1 ^| FINDSTR ERROR') DO SET _CmdResult=%%a
IF "%_CmdResult%" == "ERROR: No files found with the specified search criteria." ( 
    SET errorlevel=0 
 ) ELSE ( 
    SET errorlevel=1
 )
IF "%_CmdResult%" == "NONE" SET errorlevel=0

IF %ERRORLEVEL% == 1 GOTO errorblock
	
Echo Deleted zip files older than 30 days in data/in archive   >> %LOG_FILE% 2>>&1

SET keepDD=30
SET logPath=D:\jdabatch\data\out\archive
SET logFileExt=*.zip
SET _CmdResult=NONE

FOR /F "tokens=*" %%a IN ('FORFILES /P %logPath% /M %logFileExt% /D -%keepDD% /C "cmd /c DEL @file" 2^>^&1 ^| FINDSTR ERROR') DO SET _CmdResult=%%a
IF "%_CmdResult%" == "ERROR: No files found with the specified search criteria." ( 
    SET errorlevel=0 
 ) ELSE ( 
    SET errorlevel=1
 )
IF "%_CmdResult%" == "NONE" SET errorlevel=0

IF %ERRORLEVEL% == 1 GOTO errorblock
	
Echo Deleted zip files older than 30 days in data/out archive   >> %LOG_FILE% 2>>&1

rem IF NOT %DATE:~0,3% == Mon goto end


goto end

:errorblock
popd
ECHO **************************HOUSEKEEPING SRE FAILED************************************************  >> %LOG_FILE% 2>>&1
echo HOUSEKEEPING SRE FAILED: %date% %time% >> %LOG_FILE% 2>>&1
Echo *************************************************************************************  >> %LOG_FILE% 2>>&1
echo Return Code = %ERRORLEVEL% >> %LOG_FILE% 2>>&1
exit /B 1
        



:end
ECHO **************************HOUSEKEEPING SRE ENDED************************************************  >> %LOG_FILE% 2>>&1
echo HOUSEKEEPING SRE ENDED: %date% %time% >> %LOG_FILE% 2>>&1
Echo *************************************************************************************   >> %LOG_FILE% 2>>&1
echo Return Code = %ERRORLEVEL% >> %LOG_FILE% 2>>&1
popd
exit /B 0

popd
