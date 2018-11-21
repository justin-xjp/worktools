# worktools

目录下是在上班过程中编制的小工具，功能简单，仅作为自娱自乐和实践学习。

## tools list

1. savetable
2. scriptplot
3. sfcad_s2k_to_mgt
4. unittablebuilding

### savetable

autolisp下实现CAD表格导出。代码是从网上百度来的，具体原作者未知。学习实践过程中添加了注释笔记，并更改了局部显示效果。

目前存在的问题：

1. 随机出现“不能恢复原状态”，不想修正。

### scriptplot

使用autolisp实现的，根据mgt文件（midas gen的模型描述脚本）生成3维线模型，以不同杆件截面建立图层。后续计划实现体模型的生成。

### sfcad_s2k_to_mgt

一次奇葩文件的建模要求，据称是SFCAD生成的s2k文件，却不符合sap2000要求。

以python实现将所给文件按照格式组合成mgt文件。本程序不具有通用性。

### Unittablebuilding

实现从杆件布置图导出对应的杆件与节点关系表，不稳定。
