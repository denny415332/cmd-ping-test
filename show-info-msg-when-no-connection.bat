@ECHO OFF
SETLOCAL EnableDelayedExpansion

REM 設定命令提示字元的代碼頁為UTF-8，以正確顯示中文
CHCP 65001 > NUL

ECHO.
ECHO "此批次檔用於持續檢查指定主機的連線狀態，並在連線失敗時顯示訊息"
ECHO "使用方法: show-info-msg-when-no-connection.bat [目標主機] [等待時間]"
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

ECHO 開始檢測連線到 %target%...
ECHO.

:LOOP
REM 設定臨時檔案名稱
SET "temp_file=temp_show_info_msg_when_no_connection.txt"

REM Ping 目標主機並將輸出導向到臨時檔案
ping -n 1 %target% > %temp_file%

REM 檢查 ping 的結果
type %temp_file% | find "Reply from" | find "time=" > nul
IF %ERRORLEVEL% EQU 0 (
    REM 連線正常
    ECHO [%DATE% %TIME%] 連線到 %target% 正常
) ELSE (
    REM 連線失敗，顯示 MSG 訊息
    ECHO [%DATE% %TIME%] 無法連線到 %target%
    MSG * /time:%wait_time% "警告：無法連線到 %target%！請檢查網路連線。"
)

@REM REM 刪除臨時檔案
@REM del %temp_file%

REM 等待 %wait_time% 秒後再次檢查
TIMEOUT /T %wait_time% /NOBREAK > nul

REM 回到迴圈開始
GOTO LOOP
