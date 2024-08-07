@echo off
IF %~x1==.wxapkg (
"%~dp0KillWxapkg_2.2.1_windows_amd64.exe" -id=%~n1 -in="%1" -restore -pretty
) ELSE (
@echo 拖动的文件必须是以微信小程序的AppID为文件名，.wxapkg为后缀的小程序文件
@echo ---------------------------
@echo 文件全路径：        %1
@echo 盘符：                 %~d1
@echo 路径：                 %~p1
@echo 文件+后缀名：        %~nx1
@echo 文件名：        %~n1
@echo 后缀名：        %~x1
@echo ---------------------------
)
pause