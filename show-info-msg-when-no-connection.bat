REM 此批次檔用於持續檢查指定主機的連線狀態，並在連線失敗時顯示訊息
REM 使用方法：show-info-msg-when-no-connection.bat [目標主機]（預設為 localhost）

@ECHO OFF

REM 設定預設值為 localhost
set "target=localhost"
SETLOCAL EnableDelayedExpansion

REM 設定命令提示字元的代碼頁為UTF-8，以正確顯示中文
CHCP 65001 > NUL

REM 檢查是否有輸入參數
if not "%~1"=="" (
    set "target=%~1"
)

ECHO 開始檢測連線到 %target%...
ECHO.

:LOOP
REM Ping 目標主機並將輸出導向到臨時檔案
ping -n 1 %target% > temp.txt

REM 檢查 ping 的結果
type temp.txt | find "Reply from" > nul
IF %ERRORLEVEL% EQU 0 (
    REM 連線正常
    ECHO [%DATE% %TIME%] 連線到 %target% 正常
) ELSE (
    REM 連線失敗，顯示 MSG
    ECHO [%DATE% %TIME%] 無法連線到 %target%
    MSG * /time:1 "警告：無法連線到 %target%！請檢查網路連線。"
)

REM 刪除臨時檔案
del temp.txt

REM 等待3秒後再次檢查
TIMEOUT /T 3 /NOBREAK > nul

REM 回到迴圈開始
GOTO LOOP
