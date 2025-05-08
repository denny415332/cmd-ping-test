@ECHO OFF
SETLOCAL EnableDelayedExpansion

REM 設定命令提示字元的代碼頁為UTF-8，以正確顯示中文
CHCP 65001 > NUL

ECHO.
ECHO "此批次檔用於持續 ping 指定目標並在輸出中加入時間戳記"
ECHO "使用方法: ping-with-timestamp.bat [目標主機] [等待時間]"
ECHO "[目標主機] 預設為 localhost"
ECHO "[等待時間] 預設為 1 秒"
ECHO.

REM 設定預設值為 localhost
REM 可用數值包含: c02240073, c02240074
set "target=localhost"
REM 設定預設等待時間為 1 秒
set "wait_time=1"

REM 檢查是否有輸入參數
if not "%~1"=="" (
    set "target=%~1"
)
if not "%~2"=="" (
    set "wait_time=%~2"
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

REM 等待 %wait_time% 秒後再次檢查
TIMEOUT /T %wait_time% /NOBREAK

REM 回到迴圈開始
GOTO LOOP
