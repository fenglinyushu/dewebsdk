@echo off
mode con cols=48 lines=30
%~d0
cd %~dp0
title PostgreSQL Database Runtime Manager
set PGDATA=%CD%\data
set LOGFILE=%CD%\postgresql.log
cd bin
for /f "tokens=3" %%i in ('pg_ctl -V') do set pg_ver=%%i
set default_servicename=PostgreSQL_%pg_ver%
:: =====================================================================
:start
set servicename=
set registed_servicename=
set pg_exit_ext_info=

if not exist servicename (
echo; > servicename
)
for /f "tokens=*" %%i in (servicename) do set registed_servicename=%%i
if "X%registed_servicename%"=="X" (
set servicestatus=[Not Registered]
) else (
sc query "%registed_servicename%"
if errorlevel 1 (
set servicestatus=[Not Registered]
echo; > servicename
set registed_servicename=
) else (
set servicestatus=%registed_servicename%
)
)
pg_ctl status > nul 2>nul
if not errorlevel 1 (
if "X%registed_servicename%"=="X" (
set db_status=Running (closing the window will cause abnormal exit)
set pg_exit_ext_info=(Close the database properly)
) else (
set db_status=Running
)
) else (
set db_status=Not Started
)
if "X%db_status%"=="XNot Started" (
set x1=1
set x2=
set x4=
) else (
set x1=
set x2=2
set x4=4
)
if "X%registed_servicename%"=="X" (
set x5=5
set x6=
) else (
set x5=
set x6=6
)
:: ====================================================================
:menu
cls
echo Note: [Register or uninstall service] must be done using this script to maintain the service state; using external tools may cause this maintenance script to inaccurately determine service registration status and service name!
echo;
echo ------------------------------------------------
echo ^ Database Version: %pg_ver%
echo ^ Running Status: %db_status%
echo ^ Service Name: %servicestatus%
echo ------------------------------------------------
echo;
echo Please select an operation:
echo;
echo ^ ^ ^ ^ [ %x1% ]^ Start Database
echo;
echo ^ ^ ^ ^ [ %x2% ]^ Reload Configuration
echo;
echo ^ ^ ^ ^ [ 3 ]^ Restart Database
echo;
echo ^ ^ ^ ^ [ %x4% ]^ Shut Down Database
echo;
echo ^ ^ ^ ^ [ %x5% ]^ Register Service
echo;
echo ^ ^ ^ ^ [ %x6% ]^ Uninstall Service
echo;
echo ^ ^ ^ ^ [ R ]^ Refresh Status
echo;
echo ^ ^ ^ ^ [ Q ]^ Exit%pg_exit_ext_info%

choice /C 123456rq /N
set select=%errorlevel%
cls
if "X%select%"=="X1" (
if "X%x1%"=="X1" ( goto startdb ) else ( goto menu )
)
if "X%select%"=="X2" (
if "X%x2%"=="X2" ( goto reloaddb ) else ( goto menu )
)
if "X%select%"=="X3" goto restartdb
if "X%select%"=="X4" (
if "X%x4%"=="X4" ( goto shutdowndb ) else ( goto menu )
)
if "X%select%"=="X5" (
if "X%x5%"=="X5" ( goto register ) else ( goto menu )
)
if "X%select%"=="X6" (
if "X%x6%"=="X6" ( goto unregister ) else ( goto menu )
)
if "X%select%"=="X7" goto start
if "X%select%"=="X8" goto end

:: --------------- 1. Start Database ---------------
:startdb
if not "X%db_status%"=="XNot Started" (
set message=Database is already running, no need to start again!
set next=menu
goto message
)
set next=startdb-dostart
goto ensureinited
:startdb-dostart
if "X%registed_servicename%"=="X" (
pg_ctl -l %LOGFILE% start > nul
if errorlevel 1 (
pause
goto start
)
) else (
net start "%registed_servicename%"
if errorlevel 1 (
pause
goto start
)
)
set message=Database started successfully!
set next=start
goto message
:: --------------- 2. Reload Configuration ---------------
:reloaddb
if "X%db_status%"=="XNot Started" (
set message=Database is not started, no need to reload configuration!
set next=menu
goto message
)
pg_ctl reload > nul
if errorlevel 1 (
pause
goto start
) else (
set message=Configuration reloaded successfully (Note: some configuration changes require a database restart)!
set next=menu
goto message
)
:: --------------- 3. Restart Database ---------------
:restartdb
if "X%db_status%"=="XNot Started" (
choice /M Database is not started, start it now?
if errorlevel 2 ( goto menu ) else ( goto startdb )
)
pg_ctl restart > nul
if errorlevel 1 (
pause
goto start
)
set message=Database restarted successfully!
set next=start
goto message
:: --------------- 4. Shut Down Database ---------------
:shutdowndb
pg_ctl stop > nul
if errorlevel 1 (
pause
goto start
)
set message=Database shut down successfully
set next=start
goto message
:: --------------- 5. Register Service ---------------
:register
if not "X%registed_servicename%"=="X" (
set message=Service already registered, no need to register again!
set next=menu
goto message
)
set servicename=
set /p servicename=Enter service name (English only) [Enter M to return to menu, default: %default_servicename%]:
if /I "X%servicename%" EQU "Xm" (
goto menu
) else if "X%servicename%"=="X" (
set servicename=%default_servicename%
)
sc query "%servicename%" > nul
if not errorlevel 1 (
set message=Service name (%servicename%) is already taken, please enter a different one.
set next=register
goto message
)
pg_ctl register -N "%servicename%"
if errorlevel 1 (
echo register error
pause
goto start
)
echo %servicename%>servicename
net start "%servicename%"
set message=Service registered successfully, service name: %servicename%
set next=start
goto message
:: --------------- 6. Uninstall Service ---------------
:unregister
if "X%registed_servicename%"=="X" (
set message=Service is not registered yet!
set next=menu
goto message
)
pg_ctl unregister -N "%registed_servicename%"
echo; > servicename
set message=Service uninstalled successfully!
set next=start
goto message
::======================================================

:: --------------- Initialization ---------------
:ensureinited
IF NOT EXIST "%PGDATA%" (
echo;
echo Database not initialized, initializing...
initdb -E UTF-8 -A md5 -U postgres -W -D %PGDATA%
echo %errorlevel%
if not "x%errorlevel%"=="x0" (
echo /
echo Database initialization failed, please check system configuration!
pause
goto menu
)
echo;
echo Database initialized successfully!
echo;
echo Database
)
goto %next%
:: --------------- Output Message ---------------
:message
cls
echo;
echo;
echo;
echo;
echo ^ %message%(Press any key to return)
pause > nul
goto %next%
::======================================================

:end
if "X%registed_servicename%"=="X" (
if not "X%db_status%"=="XNot Started" (
echo;
echo;
echo;
echo ^ Shutting down database...
pg_ctl stop > nul
)
)