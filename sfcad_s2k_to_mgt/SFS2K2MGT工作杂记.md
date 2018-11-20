# SFS2K2MGT工作杂记

## JOINT块

节点列表

### 数据样例
>```
> JOINT
>   1  X=-203.5  Y=5.2089  Z=0.0797
>   2  X=-203.5  Y=10.418  Z=0.0797
>   3  X=-203.5  Y=0  Z=0
>   4  X=-203.5  Y=15.627  Z=0
>```

### 输出样例

>```
>*NODE    ; Nodes
> ; iNO, X, Y, Z
>
>
>      1, 0, 0, 0
>      2, 0, 0, 9
>      3, 20, 0, 0
>      4, 20, 0, 9
>```

### 实现方法

#### 1.使用str.split()将原数据行转成list

> ```python
> teststr="    1  X=-203.5  Y=5.2089  Z=0.0797"
> teststr.split()
> Out[21]: ['1', 'X=-203.5', 'Y=5.2089', 'Z=0.0797']
> ```

#### 2.使用str.partition(str1)将数据分成可取用模式

> ```python
> teststr.split()[1].partition("=")
> Out[24]: ('X', '=', '-203.5')
> teststr.split()[1].partition("=")[2]
> Out[26]: '-203.5'
> ```

#### 3. 用str.join()连接序列成字符串输出到文件

```python
testlist=teststr.split()

",".join([testlist[0],testlist[1].partition("=")[2],testlist[2].partition("=")[2],testlist[3].partition("=")[2]])

Out[30]: '1,-203.5,5.2089,0.0797'
fw.write("    "+",  ".join([testlist[0],testlist[1].partition("=")[2],testlist[2].partition("=")[2],testlist[3].partition("=")[2]]+"\n")
```

## RESTRAINT块

约束列表，数据样本不全，此模块只做了铰接刚性限制

### 数据样例

> ```
> RESTRAINT
>   ADD=367  DOF=UY,UZ
>   ADD=370  DOF=UZ
>   ADD=371  DOF=UZ
>   ADD=373  DOF=UZ
>   ADD=375  DOF=UZ
> ```

### 输出样例

> ```
> *CONSTRAINT    ; Supports
> ; NODE_LIST, CONST(Dx,Dy,Dz,Rx,Ry,Rz), GROUP
>    1 3 5 24 26 28 47 49 51 103 105 107 127 129 131, 111000, 
> ```

### 实现方法

两种文件的表达方式迥异，应先将所有数据读入，汇总一并输出。也可单个输出。数据源没有组的概念。

**汇总输出优势** ：mgt文件简练，以约束方式汇总

**单个输出优势** ：处理程序编写容易

原则：以先实现后优化的方式开发。使用单个输出，快速完成任务。

#### str.split()和str.partition()联合使用，提取“=”后关键字

> ```python
>
> teststr="   ADD=367  DOF=UY,UZ"
>
> testlist=teststr.split()
>
> testlist
> Out[39]: ['ADD=367', 'DOF=UY,UZ']
>
> testlist[0].partition("=")
> Out[40]: ('ADD', '=', '367')
>
> testlist[0].partition("=")
> Out[41]: ('ADD', '=', '367')
>
> testlist[1].partition("=")[2].partition(",")
> Out[42]: ('UY', ',', 'UZ')
>
> testlist[1].partition("=")[2].split(",")
> Out[43]: ['UY', 'UZ']
> ```

#### 关键字处理以及输出

UY,UZ=011000，应该使用二进制编码计算。

```python
Res_id=testlist[0].partition("=")[2] #string
dof=0
dof_dick={"UX":32,"UY":16,"UZ":8}# UX=2^5=32  UY=2^4=16  UZ=2^3=8
if testlist[1].partition("=")[0].upper()=="DOF":
	doflist=testlist[1].partition("=")[2].split(",") #list
	for info in doflist:
    	dof=dof+dof_dick[info]
Res_const=str(bin(dof)[2:]).rjust(6,"0") #string "011000"
fw.write("    "+Res_id+" ,  "+Res_const+" ,  \n")
```



## SPRING块

弹簧约束

### 数据样例

> ```
> SPRING
>   ADD=367  UX=2000
>   ADD=370  UX=100000  UY=100000
>   ADD=371  UX=100000  UY=100000
>   ADD=373  UX=100000  UY=100000
>   ADD=375  UX=100000  UY=100000
> ```

### 输出样例

> ```
> *SPRING    ; Point Spring Supports
> ; NODE_LIST, Type, SDx, SDy, SDz, SRx, SRy, SRz, GROUP, FROMTYPE, EFFAREA, Kx, Ky, Kz                                                  ; LINEAR
> ; NODE_LIST, Type, Direction, Vx, Vy, Vz, Stiffness, GROUP, FROMTYPE, EFFAREA                                                          ; COMP, TENS
> ; NODE_LIST, Type, Multi-Linear Type, Direction, Vx, Vy, Vz, ax, ay, bx, by, cx, cy, dx, dy, ex, ey, fx, fy, GROUP, FROMTYPE, EFFAREA  ; MULTI
>    146, LINEAR, 100, 1e+014, 300, 400, 1e+016, 600, NO, 0, 0, 0, 0, 0, 0, , 0, 0, 0, 0, 0
>    15 40 63, LINEAR, 2000, 0, 0, 0, 0, 0, NO, 0, 0, 0, 0, 0, 0, , 0, 0, 0, 0, 0
>    57 , LINEAR, 100, 200, 300, 400, 500, 600, NO, 0, 0, 0, 0, 0, 0, , 0, 0, 0, 0, 0
> ```

### 实现方法

```python
mid_info=c_line.lstrip().split(" ",1) #return a list
Spr_id=mid_info[0].partition("=")[2] #string
Sprlist=mid_info[1].split() #list
SDx=0;SDy=0;SDz=0;SRx=0;SRy=0;SRz=0
for info in Sprlist:
    mid_info=info.partition("=")
    if mid_info[0].upper()=="UX":
        SDx=mid_info[2]
    elif mid_info[0].upper()=="UY":
        SDy=mid_info[2]
    elif .......:
        .......
    else :
        print("Spring data infomation wrong")
```



## MATERIAL数据块

### 数据样例

> ```
> MATERIAL
>   NAME=STEEL  IDES=S  W=78.5
>     E=2.06E+08  U=.3  A=.0000117  FY=2.150E+05
> ```

A=0.0000117热膨胀系数，FY=2.150E+05 材料强度（Q235），IDES不知道，数据跳过

### 输出样例

> ```
> *MATERIAL    ; Material
> ; iMAT, TYPE, MNAME, SPHEAT, HEATCO, PLAST, TUNIT, bMASS, DAMPRATIO, [DATA1]           ; STEEL, CONC, USER
> ; iMAT, TYPE, MNAME, SPHEAT, HEATCO, PLAST, TUNIT, bMASS, DAMPRATIO, [DATA2], [DATA2]  ; SRC
> ; [DATA1] : 1, DB, NAME, CODE, USEELAST, ELAST
> ; [DATA1] : 2, ELAST, POISN, THERMAL, DEN, MASS
> ; [DATA1] : 3, Ex, Ey, Ez, Tx, Ty, Tz, Sxy, Sxz, Syz, Pxy, Pxz, Pyz, DEN, MASS         ; Orthotropic
> ; [DATA2] : 1, DB, NAME, CODE, USEELAST, ELAST or 2, ELAST, POISN, THERMAL, DEN, MASS
>     1, STEEL, Grade3            , 0, 0, , C, NO, 0.02, 1, GB(S)      ,            , Grade3        , NO, 2.06e+008
>     
> *DGN-MATL    ; Modify Steel(Concrete) Material
> ; iMAT, TYPE, MNAME, [DATA1]                                    ; STEEL
> ; iMAT, TYPE, MNAME, [DATA2], [R-DATA], FCI, bSERV, SHORT, LONG ; CONC
> ; iMAT, TYPE, MNAME, [DATA3], [DATA2], [R-DATA]                 ; SRC
> ; iMAT, TYPE, MNAME, [DATA5]                                    ; STEEL(None) & KSCE-ASD05
> ; [DATA1] : 1, DB, CODE, NAME or 2, ELAST, POISN, FU, FY1, FY2, FY3, FY4
> ;           FY5, FY6, AFT, AFT2, AFT3, FY, AFV, AFV2, AFV3
> ; [DATA2] : 1, DB, CODE, NAME or 2, FC, CHK, LAMBDA
> ; [DATA3] : 1, DB, CODE, NAME or 2, ELAST, FU, FY1, FY2, FY3, FY4
> ;              FY5, FY6, AFT, AFT2, AFT3, FY, AFV, AFV2, AFV3
> ; [DATA4] : 1, DB, CODE, NAME or 2, FC
> ; [DATA5] : 3, ELAST, POISN, AL1, AL2, AL3, AL4, AL5, AL6, AL7, AL8, AL9, AL10
> ;              MIN1, MIN2, MIN3
> ; [R-DATA]: RBCODE, RBMAIN, RBSUB, FY(R), FYS
>     1, STEEL, Grade3            , 1, GB(S)      ,            ,Grade3        , 2, 0, , , , 0, 0,NO,0.0000e+000,     0,, 0, 0,0, 0, 0,0, 0, 0,0, 0, 0,0, 0, 0,0.0000e+000,     0,, 0, 0,0, 0, 0,0, 0, 0,0, 0, 0,0, 0, 0,0.0000e+000,     0,, 0, 0,0, 0, 0,0, 0, 0,0, 0, 0,0, 0, 0,
>     2, STEEL, Q235NAME          , 1, GB12(S)    ,            ,Q235          , 2, 0, , , , 0, 0,NO,0.0000e+000,     0,, 0, 0,0, 0, 0,0, 0, 0,0, 0, 0,0, 0, 0,0.0000e+000,     0,, 0, 0,0, 0, 0,0, 0, 0,0, 0, 0,0, 0, 0,0.0000e+000,     0,, 0, 0,0, 0, 0,0, 0, 0,0, 0, 0,0, 0, 0,
>
> ```

### 实现

S2K里是两行表示同一个数据，需要将两行合并。文件中其他章节也存在两行并列描述同一事物的地方，应在这里统一考虑解决办法。

```python
while sflist[curenti+1].startswith(" "):
                    curenti=curenti+1
                    matline_comb=sflist[curenti]
                    if sflist[curenti+1].startswith(" "):
                        matline_comb=matline_comb+sflist[curenti+1]
                        curenti=curenti+1
```

> ; iMAT, TYPE, MNAME, SPHEAT, HEATCO, PLAST, TUNIT, bMASS, DAMPRATIO, [DATA1]  1, DB, NAME, CODE, USEELAST, ELAST
>
>  1,  STEEL,     Grade3  ,   0        ,        0      ,             , C       ,        NO, 0.02              ,               1, GB(S)  ,       , Grade3 , NO      , 2.06e+008

这是内部定义的国家规范选择方式，这里应该按3 USER来定义=

>iMAT, TYPE, MNAME, SPHEAT, HEATCO, PLAST, TUNIT, bMASS, DAMPRATIO,[DATA1] :  2, ELAST, POISN, THERMAL, DEN, MASS
>
>​    3, USER , usersteel , 比热111, 传热导率222,塑性材料没有为空 ,温度单位 C, 是否使用质量密度YES, 阻尼比0.02,数据种类 2（3为各向异性）, 弹性模量2.0600e+008,  泊松比 0.3, 热膨胀系数1.1700e-005, 容重 78.5,质量密度  7.85

```python
float(".0000117")
 Out:1.17e-05
可以直接使用数据
```

#### 字典还是列表存储？

MATERIAL的原数据对应在mgt中两个数据章节：*MATERIAL和 *DGN-MATL。

大部分数据在两个章节都是重复，但在DGN中才有材料强度的选项。需要单独输入？

~~构建一个list~~

~~MATDATA=[iMAT, TYPE, MNAME, SPHEAT, HEATCO, PLAST, TUNIT, bMASS, DAMPRATIO,[DATA1] :  2, ELAST, POISN, THERMAL, DEN, MASS,1, DB, CODE, NAME or 2, ELAST, POISN, FU, FY1, FY2, FY3, FY4, FY5, FY6, AFT, AFT2, AFT3, FY, AFV, AFV2, AFV3]~~

使用MAT_data=[[iMat,TYPE,MNAME,.....]...]存储不同的数据

使用MAT_index={MNAME:iMAT...}存储对应关系。

## FRAME SECTION块

### 数据样例

> ```
> FRAME SECTION
>   NAME=1  MAT=STEEL  SH=P  T=0.0755,0.0035
>   NAME=2  MAT=STEEL  SH=P  T=0.0885,0.00375
> ```
>
> sh=p代表外形是圆管
>
> T=0.0755,0.0035 是数据，

### 输出样例

> ```
> *SECTION    ; Section
> ; iSEC, TYPE, SNAME, [OFFSET], bSD, bWE, SHAPE, [DATA1], [DATA2]                    ; 1st line - DB/USER
> ; iSEC, TYPE, SNAME, [OFFSET], bSD, bWE, SHAPE, BLT, D1, ..., D8, iCEL              ; 1st line - VALUE
> ;       AREA, ASy, ASz, Ixx, Iyy, Izz                                               ; 2nd line
> ;       CyP, CyM, CzP, CzM, QyB, QzB, PERI_OUT, PERI_IN, Cy, Cz                     ; 3rd line
> ;       Y1, Y2, Y3, Y4, Z1, Z2, Z3, Z4, Zyy, Zzz                                    ; 4th line
> ; iSEC, TYPE, SNAME, [OFFSET], bSD, bWE, SHAPE, ELAST, DEN, POIS, POIC, SF, THERMAL ; 1st line - SRC
> ;       D1, D2, [SRC]                                                               ; 2nd line
> ; iSEC, TYPE, SNAME, [OFFSET], bSD, bWE, SHAPE, 1, DB, NAME1, NAME2, D1, D2         ; 1st line - COMBINED
> ; iSEC, TYPE, SNAME, [OFFSET], bSD, bWE, SHAPE, 2, D11, D12, D13, D14, D15, D21, D22, D23, D24
> ; iSEC, TYPE, SNAME, [OFFSET2], bSD, bWE, SHAPE, iyVAR, izVAR, STYPE                ; 1st line - TAPERED
> ;       DB, NAME1, NAME2                                                            ; 2nd line(STYPE=DB)
> ;       [DIM1], [DIM2]                                                              ; 2nd line(STYPE=USER)
> ;       D11, D12, D13, D14, D15, D16, D17, D18                                      ; 2nd line(STYPE=VALUE)
> ;       AREA1, ASy1, ASz1, Ixx1, Iyy1, Izz1                                         ; 3rd line(STYPE=VALUE)
> ;       CyP1, CyM1, CzP1, CzM1, QyB1, QzB1, PERI_OUT1, PERI_IN1, Cy1, Cz1           ; 4th line(STYPE=VALUE)
> ;       Y11, Y12, Y13, Y14, Z11, Z12, Z13, Z14, Zyy1, Zyy2                          ; 5th line(STYPE=VALUE)
> ;       D21, D22, D23, D24, D25, D26, D27, D28                                      ; 6th line(STYPE=VALUE)
> ;       AREA2, ASy2, ASz2, Ixx2, Iyy2, Izz2                                         ; 7th line(STYPE=VALUE)
> ;       CyP2, CyM2, CzP2, CzM2, QyB2, QzB2, PERI_OUT2, PERI_IN2, Cy2, Cz2           ; 8th line(STYPE=VALUE)
> ;       Y21, Y22, Y23, Y24, Z21, Z22, Z23, Z24, Zyy2, Zzz2                          ; 9th line(STYPE=VALUE)
> ; [DATA1] : 1, DB, NAME or 2, D1, D2, D3, D4, D5, D6, D7, D8, D9, D10
> ; [DATA2] : CCSHAPE or iCEL or iN1, iN2
> ; [SRC]  : 1, DB, NAME1, NAME2 or 2, D1, D2, D3, D4, D5, D6, D7, D8, D9, D10, iN1, iN2
> ; [DIM1], [DIM2] : D1, D2, D3, D4, D5, D6, D7, D8
> ; [OFFSET] : OFFSET, iCENT, iREF, iHORZ, HUSER, iVERT, VUSER
> ; [OFFSET2]: OFFSET, iCENT, iREF, iHORZ, HUSERI, HUSERJ, iVERT, VUSERI, VUSERJ
>     1, DBUSER    , HN 400x200x8/13   , CC, 0, 0, 0, 0, 0, 0, YES, NO, H  , 1, GB-YB, HN 400x200x8/13
>     8, DBUSER    , p775x35           , CC, 0, 0, 0, 0, 0, 0, YES, NO, P  , 2, 0.0775, 0.0035, 0, 0, 0, 0, 0, 0, 0, 0
>
> ```

### 实现方法

## FREAM块

### 数据样例

> ```
> FRAME
>   1  J=306,351  SEC=10  NSEG=1  IREL=R2,R3  JREL=R2,R3
>   2  J=261,306  SEC=8  NSEG=1  IREL=R2,R3  JREL=R2,R3
> ```
>
> 数据样式统一

### 输出样例

> ```
> *ELEMENT    ; Elements
> ; iEL, TYPE, iMAT, iPRO, iN1, iN2, ANGLE, iSUB, EXVAL, iOPT(EXVAL2) ; Frame  Element
>      1, BEAM  ,    1,     1,     1,    20,     0,     0
>      2, TRUSS ,    1,     1,     3,    86,     0,     0
>
> *FRAME-RLS    ; Beam End Release
> ; ELEM_LIST, bVALUE, FLAG-i, Fxi, Fyi, Fzi, Mxi, Myi, Mzi        ; 1st line
> ;                    FLAG-j, Fxj, Fyj, Fzj, Mxj, Myj, Mzj, GROUP ; 2nd line
>     10,  NO, 000011, 0, 0, 0, 0, 0, 0
>              000011, 0, 0, 0, 0, 0, 0, 
>     18,  NO, 000011, 0, 0, 0, 0, 0, 0
>              000011, 0, 0, 0, 0, 0, 0, 
> ```

### 实现方法

使用frame_data=[[1  ,    ....]....]按MGT模式存储。

## LOADS块

### 数据样例

> ```
> LOADS
>   NAME=DL  SW=1.2  #sw=self weight自重
>     TYPE=FORCE
>       ADD=1  UZ=-7.51
>       ADD=2  UZ=-7.51
>       ADD=3  UZ=-5.67
>
>   NAME=LL
>     TYPE=FORCE
>       ADD=1  UZ=-3.71
>       ADD=2  UZ=-3.71
>       ADD=3  UZ=-3.71
>       ADD=4  UZ=-3.71
>
>   NAME=+TEMP
>     TYPE=TEMPERATURE  ELEM=FRAME
>       ADD=*  T=25
>
>   NAME=-TEMP
>     TYPE=TEMPERATURE  ELEM=FRAME
>       ADD=*  T=-25
>   
>
> ```

### 输出样例

跟荷载相关的数据有多个模块

> ```
> *STLDCASE    ; Static Load Cases
> ; LCNAME, LCTYPE, DESC
>    Self Weight, D , 自重
>    DL   , D , 楼面恒荷载
>    LL   , L , 楼面活荷载
>    LR   , LR, 屋面活荷载
>    WX   , W , X轴方向风荷载
>    WY   , W , Y轴方向风荷载
>    +TEMP, T , 说明温度荷载
> ```

> ```
> *USE-STLD, Self Weight
>
> ; *SELFWEIGHT, X, Y, Z, GROUP
> *SELFWEIGHT, 0, 0, -1, 
>
> ; End of data for load case [Self Weight] -------------------------
>
> ```

> ```
> *USE-STLD, +TEMP
>
> *ELTEMPER    ; Element Temperatures
> ; ELEM_LIST, TEMPER, GROUP
>     11, 25, 
>     19, 25, 
>    151, 25, 
>    162, 25, 
>    163, 25, 
>    172, 25, 
>    173, 25, 
>    188, 25, 
>    194, 25, 
>
> ; End of data for load case [+TEMP] -------------------------
> ```

> ```
> *USE-STLD, DL
>
> *CONLOAD    ; Nodal Loads
> ; NODE_LIST, FX, FY, FZ, MX, MY, MZ, GROUP
>   64, 0, 0, -0.35, 0, 0, 0, 
>   65, 0, 0, -0.35, 0, 0, 0, 
>
> ; End of data for load case [DL] -------------------------
>
> *USE-STLD, LL
>
> *CONLOAD    ; Nodal Loads
> ; NODE_LIST, FX, FY, FZ, MX, MY, MZ, GROUP
>   12, 0, 0, -0.35, 0, 0, 0, 
>   17, 0, 0, -0.35, 0, 0, 0, 
>   18, 0, 0, -0.35, 0, 0, 0, 
> ```
>
> 

### 实现方法

分块实现，提取数据到 load_data,和 ldcase

按MGT格式提取，全部提取以后统一输出

##  COMBO块

### 数据样例

> ```
> COMBO
>   NAME=DSTL1
>     LOAD=DL  SF=1.2
>     LOAD=LL  SF=1.4
>   NAME=DSTL2
>     LOAD=DL  SF=1.2
>     LOAD=+TEMP  SF=1.4
>   NAME=DSTL7
>     LOAD=DL  SF=1
> ```
>
> 多行情况

### 输出样例

> ```
> *LOADCOMB    ; Combinations
> ; NAME=NAME, KIND, ACTIVE, bES, iTYPE, DESC, iSERV-TYPE, nLCOMTYPE   ; line 1
> ;      ANAL1, LCNAME1, FACT1, ...                                    ; from line 2
>    NAME=sLCB1, STEEL, ACTIVE, 0, 0, 1.2D + 1.4L + 1.4(0.7)(L+LR), 0, 0
>         ST, Self Weight, 1.2, ST, DL, 1.2, ST, LL, 1.4, ST, LR, 0.98
>    NAME=sLCB2, STEEL, ACTIVE, 0, 0, 1.2D + 1.4((0.7)L+LR), 0, 0
>         ST, Self Weight, 1.2, ST, DL, 1.2, ST, LL, 0.98, ST, LR, 1.4
> ```
>
> KIND={GEN:一般 , STEEL:钢结构 , CONC: 混凝土 ,ext.}
>
> ACTIVE={ACTIVE:激活；INACTIVE:钝化；ACTIVE:钢结构中基本；SERVICE:标准；SPECIAL：特殊；VERTICAL：竖向；STRENGTH:混凝土基本}
>
> iTYPE={0:相加；1：包络；2：abs(钢结构中没有);3:SRSS；}
>
> ANAL1={ST:基本组合参数；CBS：嵌套组合}
>
> 

## CX_FREEZE编译打包

