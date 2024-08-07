
1、创建文件：
wxmp-untie.bat
```bash
@echo off
IF %~x1==.wxapkg (
"%~dp0KillWxapkg_windows_amd64.exe" -id=%~n1 -in="%1" -restore -pretty
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
```

2、[去下载](https://github.com/Ackites/KillWxapkg/releases),将`KillWxapkg_版本号_windows_amd64.exe` 去掉版本号重命名为`KillWxapkg_windows_amd64.exe`放在bat同位置下（测试版本2.2.1）。


3、找到小程序文件，`文档\WeChat Files\Applet`，每个以`wx...`的文件夹就是一个小程序的文件，这个文件夹名称也是小程序的id。
将`文档\WeChat Files\Applet\wx0f5bd879a9b1c833\...\__APP__.wxapkg`文件，以`小程序id.wxapkg`重命名。

4、然后将这个文件拖到上面创建的bat文件，即可，这样就在`xx.wxapkg`文件所在文件中解出一个文件夹内容，这就是解出来的小程序源码。
