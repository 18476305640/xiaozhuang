# 查看占用端口的进程
lsof -i:<端口>
# 杀掉进程
kill -9 <进程号>
# 查看占用的端口
netstat -tunlp 
-t (tcp) 仅显示tcp相关选项
-u (udp)仅显示udp相关选项
-n 拒绝显示别名，能显示数字的全部转化为数字
-l 仅列出在Listen(监听)的服务状态
-p 显示建立相关链接的程序名
# 查看进程执行的命令
ps -aux | grep java
# 查找文件
find /usr/local/ -name "*nginx*"
# 使用IDEA远程调试
java -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005 -jar XXX.jar
