# 什么是scriptplot
scriptplot将由autocad中的lisp语言编写。实现从文件读入格式信息，自动生成3d实体模型的功能。读入的文件应符合Midas gen的MGT格式。（应有配套工具转换其他格式文件到MGT。比如3D3S和sap2000。）

由于autoCAD仅仅是一个绘图工具，并没有赋予属性功能。MGT模型中的一些描述将进行忽略。或后续改进。当前仅为实现最基础功能。

# MGT文件分析

## MGT关键字



| 关键字                  | 功能                           | 实例及备注                                                   |
| :---------------------- | :----------------------------- | :----------------------------------------------------------- |
| \*                      | 节提示符，一般后跟节描述关键字 | `* ISO-8859 text`为文件首行，8859编码默认不支持中文，但MGT中确实存在中文。此行好像不是mgt原有的 |
| ;                       | 行备注                         | 可在行首，也可在行中。注释掉；后的内容                       |
| \*VERSION               | 版本号                         |                                                              |
| \*UNIT                  | 单位系统                       | KN,M,J,C/N,MM,J,C/force, length, heat, temper                |
| \*STRUCTYPE             | 结构类型/结构常数              | ; iSTYP, iMASS, iSMAS, bMASSOFFSET, bSELFWEIGHT, GRAV, TEMPER, bALIGNBEAM, bALIGNSLAB, bROTRIGID/0, 1, 1, NO, NO, 9.806, 0, YES, NO, NO |
| \*REBAR-MATL-CODE       | 钢筋材料标准                   | ; CONC\_CODE, CONC\_MDB, SRC\_CODE, SRC\_MDB /GB10(RC), HRB400, GB10(RC), HRB400 |
| \*NODE                  | 节点                           | ; iNO, X, Y, Z                                               |
| \*ELEMENT               | 单元                           | 单元有4种：1. Frame Element; 2. Comp/Tens Truss; 3. Planar Element; 4. Solid Element。单元参数不同，注意区分 |
| \*MATERIAL              | 材料属性                       | 参数复杂注意区分                                             |
| \*MATL-COLOR            | 按材料设置颜色                 |                                                              |
| \*SECTION               | 截面库                         | 内容复杂，MGT中有详细描述                                    |
| \*SECT-COLOR            | 按截设置颜色                   | 可作为CAD层颜色                                              |
| \*DGN-SECT              | 设计过程中的截面库             | 内容格式和SECTION相同，并没有明白是什么内容                  |
| \*STLDCASE              | 工况                           | ; LCNAME, LCTYPE, DESC/DD,D,楼层恒荷载                       |
| \*DGN-CTRL              | 设计功能设置                   |                                                              |
| \*CONSTRAINT            | 约束条件                       | ; NODE\_LIST, CONST(Dx,Dy,Dz,Rx,Ry,Rz), GROUP/NODE\_LIST可以写成：1to11by2 |
| \*FRAME-RLS             | 单元释放                       |                                                              |
| \*USE-STLD, DL          | 荷载设置                       | 关键字带参数，再此关键字下可出现子关键字若干，直到遇见其他关键字。 |
| \*SELFWEIGHT, 0, 0, -1, | 自重设置                       | 子关键字，方向设置                                           |
| \*USE-STLD, WX          |                                |                                                              |
| \*CONLOAD               | 节点布载                       | 子关键字; NODE_LIST, FX, FY, FZ, MX, MY, MZ, GROUP           |
| \*BEAMLOAD              | 梁单元布载                     | 子关键字                                                     |
| \*FLOADTYPE             | 定义楼板荷载类型               |                                                              |
| \*FLOAD-COLOR           | 按楼板荷载类型设置颜色         |                                                              |
| \*FLOORLOAD             | 楼板荷载布载                   |                                                              |
| \*LOADCOMB              | 定义荷载组合                   | 以2行为组描述组合。                                          |
| \*LC-COLOR              | 按荷载工况设置颜色             |                                                              |
| \*ANAL-CTRL             | 分析设置选项                   |                                                              |
| \*DGN-MATL              | 设计过程中的材料库             |                                                              |
| \*ENDDATE               | 文件结束                       |                                                              |

此表总结自一个简单的模型，可能存在更复杂的情况。表格中已经包含了目前所需要的所有信息，其他内容留待以后补充完善。

根据我的目的，程序应该只对UINT NODE ELEMENT MATERIAL SECTION SECT-COLOR ENDDATE关键字及其内容做出反应。

# NODE节点读取
判断读入行内容，消除注释后，跳出条件包括：
- 以*开头的行（跳出，进入下一节，且循环中不能读取当前行：第一次进入的行读取在循环外，做纯净，循环结束时读取新的一行，并做纯净）
- ；开始的注释行，纯净后解决
- 
- 
## 节点数据的存储
[https://www.cnblogs.com/zinthos/p/4082446.html](https://www.cnblogs.com/zinthos/p/4082446.html)
中提到的方法，可以让所有的node资料单独建立名称为NODE-*的节点名称变量，用来存储和使用。

引申问题：
- 建立多少个变量（内存控制问题，会消耗LISP本身能够调动的资源，怎么建立以及怎么释放和回收）
- 

怎么存储点信息是目前的主要问题：
- 可以按照编号查询点
- 能够编号查重
- ~~？利用ASCII字符串自己构建存储格式？~~ 点坐标是（x,y,z)三种数据的，必然存在分割。字符串的方式不可行
- 按顺序存储点坐标到list，查询时按编号读取。
- 制作临时数据文件，按所需写入，每次查询都打开文件，遍历，返回，关闭文件。

**解决办法**

封装，构建NODE-INDEX, NODE-DATA表，构建函数对ADD,DELET,SEARCH,READ操作进行封装。原则上，数据文件不允许直接调用。

# 参考资料
[字符串分割  http://bbs.mjtd.com/thread-107150-1-1.html](http://bbs.mjtd.com/thread-107150-1-1.html)