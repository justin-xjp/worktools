# READme

都是selina目录下的批处理文件，有些在用，有些也不再管了。很容易的东西。

## 使用说明

将批处理脚本放在%path%包含的目录下，也可以手动添加到%path%

## mount 和 unmount 

挂载（弹出）机内虚拟硬盘。（呀，含有本地信息了！）

## unlede

关闭一个VBOX下的虚拟电脑。

## poweron & poweroff

打开lede，并挂载VHD

关闭lede 和弹出VHD

## mkworkfloder

在当前目录下建立工作用目录结构。需将此文件添加到右键菜单。

### 添加命令到右键菜单

1. 管理员运行`regedit` , 在`计算机\HKEY_CLASSES_ROOT\Directory\Background\shell\`下新建“项”`mkworkfloder`
2. 改`mkworkfloder`下默认值为“新建工作目录集”
3. 在`mkworkfloder`下新建项`command`, 改默认值为 **脚本位置**