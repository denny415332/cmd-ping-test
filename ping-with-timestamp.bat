@ECHO OFF
SETLOCAL EnableDelayedExpansion

REM 設定預設值為 localhost
set "target=localhost"

REM 檢查是否有輸入參數
if not "%~1"=="" (
    set "target=%~1"
)

:LOOP
REM Ping 目標主機並將輸出導向臨時檔案
ping -n 1 %target% > temp.txt

REM 讀取臨時檔案的每一行並加上時間戳記
FOR /F "tokens=*" %%A IN (temp.txt) DO (
    SET "DATE_TIME=!DATE! !TIME!"
    ECHO [!DATE_TIME!] %%A
)

REM 刪除臨時檔案
DEL temp.txt

REM 輸出空行
ECHO.

REM 等待1秒
TIMEOUT /T 1 /NOBREAK

REM 回到迴圈開始
GOTO LOOP
