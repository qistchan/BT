@echo off

echo.
echo --------------------------------
echo start source %~n0
echo %0
echo --------------------------------
echo.

:: # determine ORACLE_SID
if not defined ORACLE_SID_TMP  goto next

FOR /F "tokens=1,2,3,4 delims=-" %%A IN ('echo %ORACLE_SID_TMP%') DO (
	set ORACLE_SID_PROD=%%A
	set ORACLE_SID_TEST=%%B
	set ORACLE_SID_DEV=%%C
	set ORACLE_SID_NXDEVTC11=%%D
)

::echo at %~n0 %ORACLE_SID_TEST% %TC_VERSION% %BT_PLM_SITE%
::pause

if /i "%BT_ENV%" == "prod" set ORACLE_SID=%ORACLE_SID_PROD%
if /i "%BT_ENV%" == "int"  set ORACLE_SID=%ORACLE_SID_TEST%
if /i "%BT_ENV%" == "test" set ORACLE_SID=%ORACLE_SID_TEST%
if /i "%BT_ENV%" == "dev"  set ORACLE_SID=%ORACLE_SID_DEV%
if /i "%BT_ENV%" == "NXDevTC11"  set ORACLE_SID=%ORACLE_SID_NXDEVTC11%


set ORACLE_SID_TMP=
set ORACLE_SID_PROD=
set ORACLE_SID_TEST=
set ORACLE_SID_DEV=
set ORACLE_SID_NXDEVTC11=
:next

:: CF: 13.9.16, Ras local Volume noch nicht eingerichtet, daher auf Zrh Server gesetzt
:: # Rastatt
if /i "%BT_PLM_SITE%" == "RAS" (
	set BT_UG_SERVER=chlupi99012srv.ad001.siemens.net
	set SPLM_SHR_DIR=\\chlupi99012srv.ad001.siemens.net\plmshare112
)

:: # Zug
if /i "%BT_PLM_SITE%" == "ZUG" (
	set BT_UG_SERVER=chlupi99012srv.ad001.siemens.net
	set SPLM_SHR_DIR=\\chlupi99012srv.ad001.siemens.net\plmshare112
)

:: # Peking
if /i "%BT_PLM_SITE%" == "PEK" (
	set BT_UG_SERVER=CNPEK01344.ad001.siemens.net
	set SPLM_SHR_DIR=\\CNPEK01344.ad001.siemens.net\plmshare112_test
)

:: # Kimpo
if /i "%BT_PLM_SITE%" == "KPO" (
	set BT_UG_SERVER=kr001s1056srv.ad001.siemens.net
	set SPLM_SHR_DIR=\\kr001s1056srv.ad001.siemens.net\plmshare112_test
)

:: # Buffalo Grove	
if /i "%BT_PLM_SITE%" == "BFG" (
	set BT_UG_SERVER=uslzua200kpsrv.ad001.siemens.net
	set SPLM_SHR_DIR=\\uslzua200kpsrv.ad001.siemens.net\plmshare112_test
)


if not defined ORACLE_SID                             goto next
rem c.franz, 3.7.16: client access auf tcdata ist für 4tier nicht notwendig
rem if not exist %SPLM_SHR_DIR%\tcdata\%ORACLE_SID%data    goto error_tcdata


:next
if not exist %SPLM_SHR_DIR%                            goto error_share

:: # Load Site Customization
echo call %SPLM_SHR_DIR%\start_apps\windows\BT_Site.bat
call %SPLM_SHR_DIR%\start_apps\windows\BT_Site.bat

:: # License server configuration
echo call %SPLM_SHR_DIR%\start_apps\windows\BT_PLM_License.bat
call %SPLM_SHR_DIR%\start_apps\windows\BT_PLM_License.bat

goto end

:error_tcdata
	cls
	color 7c
	echo.
	echo TC_DATA ^(%SPLM_SHR_DIR%\tcdata\%ORACLE_SID%data^) not exist
	echo.
	pause
	exit


:error_share
	cls
	color 7c
	echo.
	echo PLM Share ^(%SPLM_SHR_DIR%^) not exist
	echo.
	pause
	exit

:end
echo.
echo --------------------------------
echo end source %~n0
echo --------------------------------
echo.

rem pause

