@echo off 
mode con cols=48 lines=30
%~d0
cd %~dp0
title PostgreSQL数据库运行管理器
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
  set servicestatus=[未注册]
) else (
  sc query "%registed_servicename%" 
  if errorlevel 1 (
    set servicestatus=[未注册]
	echo; > servicename
	set registed_servicename=
  ) else (
    set servicestatus=%registed_servicename%
  )
)
pg_ctl status > nul 2>nul
if not errorlevel 1 (
  if "X%registed_servicename%"=="X" (
    set db_status=运行中（关闭窗口会非正常退出）
	set pg_exit_ext_info=（正确关闭数据库）
  ) else (
    set db_status=运行中
  )
) else (
  set db_status=未启动
)
if "X%db_status%"=="X未启动" (
  set x1=1
  set x2=^ 
  set x4=^ 
) else (
  set x1=^ 
  set x2=2
  set x4=4
)
if "X%registed_servicename%"=="X" (
  set x5=5
  set x6=^ 
) else (
  set x5=^ 
  set x6=6
)
:: ====================================================================
:menu
cls
echo 请注意：【注册或卸载服务】请务必使用这个脚本，因为要维护服务状态；若使用外部工具，可能会造成该维护脚本判断服务注册与否和服务名称不准确！
echo;
echo ------------------------------------------------
echo ^        数据库版本： %pg_ver%             
echo ^        运行状态： %db_status%             
echo ^        服务名称： %servicestatus%         
echo ------------------------------------------------
echo;
echo 请选择操作：
echo;
echo ^ ^ ^ ^ [ %x1% ]^ 启动数据库
echo;
echo ^ ^ ^ ^ [ %x2% ]^ 重新载入配置
echo;
echo ^ ^ ^ ^ [ 3 ]^ 重启数据库
echo;
echo ^ ^ ^ ^ [ %x4% ]^ 关闭数据库
echo;
echo ^ ^ ^ ^ [ %x5% ]^ 注册服务
echo;
echo ^ ^ ^ ^ [ %x6% ]^ 卸载服务
echo;
echo ^ ^ ^ ^ [ R ]^ 刷新状态
echo;
echo ^ ^ ^ ^ [ Q ]^ 退出%pg_exit_ext_info%

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

:: --------------- 1.启动数据库 ---------------
:startdb
if not "X%db_status%"=="X未启动" (
  set message=数据库正在运行，不需要再启动！
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
set message=数据库已成功启动!
set next=start
goto message
:: --------------- 2.重新载入配置 ---------------
:reloaddb
if "X%db_status%"=="X未启动" (
  set message=数据库未启动，不需要重新载入配置！
  set next=menu
  goto message
)
pg_ctl reload > nul
if errorlevel 1 (
  pause
  goto start
) else (
  set message=已成功重新载入配置（注意：部分配置项更改必须重启数据库）！
  set next=menu
  goto message
)
:: --------------- 3.重启数据库 ---------------
:restartdb
if "X%db_status%"=="X未启动" (
  choice /M 数据库未启动，是否现在启动？
  if errorlevel 2 ( goto menu ) else ( goto startdb )
)
pg_ctl restart > nul
if errorlevel 1 (
  pause
  goto start
)
set message=数据库重启成功！
set next=start
goto message
:: --------------- 4.关闭数据库 ---------------
:shutdowndb
pg_ctl stop > nul
if errorlevel 1 (
  pause
  goto start
)
set message=已成功关闭数据库
set next=start
goto message
:: --------------- 5.注册服务 ---------------
:register
if not "X%registed_servicename%"=="X" (
  set message=服务已注册，不需要重复注册！
  set next=menu
  goto message
)
set servicename=
set /p servicename=请输入服务名（全英文）[输入M返回菜单，默认：%default_servicename%]:
if /I "X%servicename%" EQU "Xm" (
  goto menu
) else if "X%servicename%"=="X" (
  set servicename=%default_servicename%
)
sc query "%servicename%" > nul
if not errorlevel 1 (
	set message=服务名称（%servicename%）已被占用，请重新输入。
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
set message=服务注册成功，服务名：%servicename%
set next=start
goto message
:: --------------- 6.卸载服务 ---------------
:unregister
if "X%registed_servicename%"=="X" (
  set message=服务还没注册呢！
  set next=menu
  goto message
)
pg_ctl unregister -N "%registed_servicename%"
echo; > servicename
set message=服务卸载成功！
set next=start
goto message
::======================================================

:: --------------- 初始化 ---------------
:ensureinited
IF NOT EXIST "%PGDATA%" (
  echo;
  echo 数据库未初始化，正在初始化...
  initdb -E UTF-8 -A md5 -U postgres -W -D %PGDATA%
  echo %errorlevel%
  if not "x%errorlevel%"=="x0" (
    echo /
	echo 数据库初始化失败，请检查系统配置！
	pause
	goto menu
  )
  echo;
  echo 数据库初始化成功！
  echo;
  echo 数据库
)
goto %next%
:: --------------- 输出消息 ---------------
:message
cls
echo;
echo;
echo;
echo;
echo ^    %message%(任意键返回)
pause > nul
goto %next%
::======================================================

:end
if "X%registed_servicename%"=="X" (
  if not "X%db_status%"=="X未启动" (
	echo;
	echo;
	echo;
	echo ^     正在关闭数据库...
    pg_ctl stop > nul
  )
)
