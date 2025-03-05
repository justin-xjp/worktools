echo off
rem 拖进一个目录作为 源目录,然后拖入新目录作为目标目录，加个源目录下的子目录Target，然后回车实现动态软链接
echo "================================"
echo 动态软链接工具，Link目录（生成的软链接路径），需要拖入Target目录（软链接的源文件夹路径），然后回车关联目录（/J，实现目录链接共享）
echo "================================"
set /p Link=请拖入目标目录并回车:
set /p Target=请拖入源目录并回车:
rem 取最后一个文件夹名

dir %Target% /b /a:d > tempdir.txt

for /f %%m in (tempdir.txt) do (
rem 得到了每个目录的名，然后组合
rem echo %%m
mklink /D %Link%\%%m %Target%\%%m
echo  "================================"
)

del /f /q tempdir.txt
pause