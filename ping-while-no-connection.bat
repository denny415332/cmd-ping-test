@ECHO OFF
SETLOCAL EnableDelayedExpansion

REM 設定命令提示字元的代碼頁為UTF-8，以正確顯示中文
CHCP 65001 > NUL

ECHO.
ECHO "此批次檔用於持續 ping 指定目標直到連線成功，可用於監控網路恢復狀態"
ECHO "使用方法: ping-while-no-connection.bat [目標主機] [等待時間]"
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
SET "temp_file=temp_ping_while_no_connection.txt"
SET "temp_file2=temp2_ping_while_no_connection.txt"

REM Ping 目標主機並將輸出導向到臨時檔案
ping -n 1 %target% > %temp_file%

REM 讀取並替換文字
type %temp_file% | ^
findstr /v "Ping statistics" | ^
findstr /v "Packets:" | ^
findstr /v "Approximate" | ^
findstr /v "Minimum" | ^
findstr /v "Maximum" | ^
findstr /v "Average" > %temp_file2%

REM 替換文字並顯示
for /f "tokens=*" %%a in (%temp_file2%) do (
    set "line=%%a"
    set "line=!line:Reply from=收到來自!"
    set "line=!line:bytes=位元組!"
    set "line=!line:time=時間!"
    set "line=!line:TTL=存活時間!"
    set "line=!line:Request timed out=請求超時!"
    set "line=!line:Destination host unreachable=目標主機無法到達!"
    echo !line!
)

REM 檢查連線狀態
findstr "Reply from" %temp_file% > nul
IF ERRORLEVEL 1 (
    @REM DEL %temp_file% %temp_file2%
    TIMEOUT /T %wait_time% /NOBREAK
    GOTO LOOP
)

REM 如果收到回應，則結束程式並顯示時間
@REM DEL %temp_file% %temp_file2%
ECHO.
ECHO 在 %DATE% %TIME% 收到回應
MSG * "在 %DATE% %TIME% 收到回應"
GOTO END

:END
ECHO.
ECHO 已結束
