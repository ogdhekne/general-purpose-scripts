REM ---------------------------------------------------------------------------------------------------------------
REM  Import Data Pump script for Oracle Database
REM  This script is licenced under GPLv3 ; you can get your copy from https://www.gnu.org/licenses/gpl-3.0.en.html
REM  (C) Omkar Dhekne ; ogdhekne@yahoo.in ; github: https://github.com/ogdhekne
REM ---------------------------------------------------------------------------------------------------------------

@ECHO OFF
ECHO +-------------------------------+
ECHO +   Import Data Pump Script     +
ECHO +-------------------------------+
ECHO:

REM -- User Input : Press any key to continue --
ECHO Press any key to continue
PAUSE

REM -- Environment Variables --
SET /P USER="Enter Username: "
SET /P PASS="Enter Password: "
SET /P DB="Enter Database name: "
SET /P LOCATION="Enter Virtual Directory name: "
SET /P DMP="Enter Dumpfile name : "

REM -- For getting 'today' variable --
for /f %%x in ('wmic path win32_utctime get /format:list ^| findstr "="') do set %%x
set today=%Year%-%Month%-%Day%

REM -- Import Data Pump Utility Command --
IMPDP %USER%/%PASS%@%DB% DUMPFILE=%DMP% LOGFILE=IMP-%USER%-%DB%-%today%.log DIRECTORY=%LOCATION% REMAP_SCHEMA=%USER%:%USER% TABLE_EXISTS_ACTION=REPLACE

REM -- User Input : Press any key to quit this window --
ECHO Press any key to quit this window.
PAUSE
