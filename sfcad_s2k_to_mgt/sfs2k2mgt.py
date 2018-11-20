# -*- coding: utf-8 -*-
"""
Created on Thu Dec  7 11:40:09 2017

@author: XiePang
this program will translate *.s2k file SPACEFRAME FROM SFCAD (V2016) to mgt (medas gen file)
!!!NOTE
!!!not use for *.s2k from sap2000

code with learning.
"""
import re
import os
import time
#print("hello world")
import win32ui
MAT_data=[]#[[iMAT, TYPE, MNAME, SPHEAT, HEATCO, PLAST, TUNIT, bMASS, DAMPRATIO,[DATA1] :  2, ELAST, POISN, THERMAL, DEN, MASS,1, DB, CODE, NAME or 2, ELAST, POISN, FU, FY1, FY2, FY3, FY4, FY5, FY6, AFT, AFT2, AFT3, FY, AFV, AFV2, AFV3]...]
MAT_index={}
section_data=[]
section_index={}
frame_data=[]#[[; iEL, TYPE, iMAT, iPRO, iN1, iN2, ANGLE, iSUB]...]
load_data=[]
load_index={}#{loadName:ldtype}
combo_data=[]
dlg = win32ui.CreateFileDialog(1) # 1表示打开文件对话框
dlg.SetOFNInitialDir(r'E:\思考') # 设置打开文件对话框中的初始显示目录
dlg.DoModal()
fullpathname = dlg.GetPathName() # 获取选择的文件名称
print (fullpathname)
#fo = open(fullpathname,"r")
with open(fullpathname,"r") as fo:
    print ("打开文件")
    sflist=fo.readlines()

while True:#空行消除!!!此处有可能有漏洞
    try:
        sflist.remove("\n")
    except:
        break
# 定位文件位置在相同位置生成输出文件
# 转换当前位置为fullpathname位置

dirname = fullpathname[0:fullpathname.rfind("\\",)]
filename = fullpathname[fullpathname.rfind("\\")+1:]
outfile = filename[0:filename.find(".")] + ".mgt"
os.chdir(dirname)
print ("当前工作文件夹是：",os.getcwd())
# !!! 开始写入工作后，创建文件，如已存在将已存在文件改后缀名为.bac
# 如outfile存在，更改为.bac
if os.path.exists(dirname+"\\"+outfile) and os.path.isfile(dirname+"\\"+outfile):
    print("文件已存在，更改BAC")
    if os.path.exists(dirname+"\\"+outfile+".bac") and os.path.isfile(dirname+"\\"+outfile+".bac"):
        os.remove(outfile+".bac")
    os.rename(outfile,outfile+".bac")
with open(outfile,"w") as fw:#注意多行字符串格式
    fw.write(
""";-----------------------------------------------------
;  Midas Gen Text(MGT) File
;  transFrom SFCAD's S2K:{}
;  DATE & TIME : {}
;  Program written by rocxer
;-----------------------------------------------------
""".format(filename,time.strftime('%Y-%m-%d %a %H:%M:%S',time.localtime(time.time()))))
curenti=0
while curenti<len(sflist):
    c_line=sflist[curenti]
#    c_line=re.match("^(.*);?.*",c_line,re.L)#洁净语句剔除注释，目前没能完成任务。也许不需要。
    kw_pattern="(SYSTEM|JOINT|RESTRAINT|SPRING|MATERIAL|FRAME SECTION|FRAME|LOADS|COMBO|OUTPUT|END)"#frame section 不会与frame混淆，前后顺序决定要先满足前面就可以跳出匹配，不能调换此顺序.
    keyword=re.match(kw_pattern,c_line,re.I)
    if keyword:
        keyword=keyword.group(1)
        if keyword == "SYSTEM":
            print("转入SYSTEM处理模块")
            with open(outfile,"a") as fw:
                fw.write('*UNIT    ;Unit Syttem\n; FORCE, LENGTH, HEAT, TEMPER\n')
                curenti=curenti+1
                c_line=sflist[curenti]
                matchline=re.search('.*LENGTH=(\w+)\s.*FORCE=(\w+)\s.*',c_line)
                fw.write(matchline.group(2).upper()+','+matchline.group(1).upper()+',J,C\n')
        elif keyword == "JOINT":
            print("转入JOINT处理模块")
            with open(outfile,"a") as fw:
                fw.write("*NODE    ; Nodes\n; iNO, X, Y, Z\n")
                while sflist[curenti+1].startswith(" "):
                    curenti=curenti+1
                    c_line=sflist[curenti]
                    linelist=c_line.split()
                    fw.write("    "+",  ".join([linelist[0],linelist[1].partition("=")[2],linelist[2].partition("=")[2],linelist[3].partition("=")[2]])+"\n")
        elif keyword == "RESTRAINT":
            print("转入RESTRAINT处理模块")
            with open(outfile,"a") as fw:
                fw.write("*CONSTRAINT    ; Supports\n ; NODE_LIST, CONST(Dx,Dy,Dz,Rx,Ry,Rz), GROUP\n")
                while sflist[curenti+1].startswith(" "):#块内循环
                    curenti=curenti+1
                    c_line=sflist[curenti]
                    linelist=c_line.split()
                    Res_id=linelist[0].partition("=")[2] #string
                    dof=0
                    dof_dick={"UX":32,"UY":16,"UZ":8}# UX=2^5=32  UY=2^4=16  UZ=2^3=8
                    if linelist[1].partition("=")[0].upper()=="DOF":
                        doflist=linelist[1].partition("=")[2].split(",") #list                       
                        for info in doflist:
                            dof=dof+dof_dick[info]
                        Res_const=str(bin(dof)[2:]).rjust(6,"0") #string "011000"
                        fw.write("    "+Res_id+" ,  "+Res_const+" ,  \n")
        elif keyword == "SPRING":
            print("转入SPRING处理模块")
            with open(outfile,"a") as fw:
                fw.write("""*SPRING    ; Point Spring Supports
; NODE_LIST, Type, SDx, SDy, SDz, SRx, SRy, SRz, GROUP, FROMTYPE, EFFAREA, Kx, Ky, Kz                                                  ; LINEAR
; NODE_LIST, Type, Direction, Vx, Vy, Vz, Stiffness, GROUP, FROMTYPE, EFFAREA                                                          ; COMP, TENS
; NODE_LIST, Type, Multi-Linear Type, Direction, Vx, Vy, Vz, ax, ay, bx, by, cx, cy, dx,\n""")
                while sflist[curenti+1].startswith(" "):#块内循环
                    curenti=curenti+1
                    c_line=sflist[curenti]
                    mid_info=c_line.lstrip().split(" ",1) #return a list
                    Spr_id=mid_info[0].partition("=")[2] #string
                    Sprlist=mid_info[1].split() #list
                    SDx="0";SDy="0";SDz="0";SRx="0";SRy="0";SRz="0"
                    for info in Sprlist:
                        mid_info=info.partition("=")
                        if mid_info[0].upper()=="UX":
                            SDx=mid_info[2]
                        elif mid_info[0].upper()=="UY":
                            SDy=mid_info[2]
                        elif mid_info[0].upper()=="UZ":
                            SDz=mid_info[2]
                        else:
                            print("spring data infomation error!")
                    fw.write("    "+Spr_id+" ,  LINEAR ,  "+" ,  ".join([SDx,SDy,SDz,SRx,SRy,SRz])+" , NO, 0, 0, 0, 0, 0\n")
        elif keyword == "MATERIAL":
            print("转入MATERIALT处理模块")
            with open(outfile,"a") as fw:
                fw.write("""*MATERIAL    ; Material
; iMAT, TYPE, MNAME, SPHEAT, HEATCO, PLAST, TUNIT, bMASS, DAMPRATIO, [DATA1]           ; STEEL, CONC, USER
; iMAT, TYPE, MNAME, SPHEAT, HEATCO, PLAST, TUNIT, bMASS, DAMPRATIO, [DATA2], [DATA2]  ; SRC
; [DATA1] : 1, DB, NAME, CODE, USEELAST, ELAST
; [DATA1] : 2, ELAST, POISN, THERMAL, DEN, MASS
; [DATA1] : 3, Ex, Ey, Ez, Tx, Ty, Tz, Sxy, Sxz, Syz, Pxy, Pxz, Pyz, DEN, MASS         ; Orthotropic
; [DATA2] : 1, DB, NAME, CODE, USEELAST, ELAST or 2, ELAST, POISN, THERMAL, DEN, MASS  ;\n""")
                iMAT=0
                TYPE="USER"
                MNAME=""
                SPHEAT=0
                HEATCO=0
                PLAST=""
                TUNIT="C"
                bMASS="NO"
                DAMPRATIO=0
                DATA1_type=2
                ELAST=0
                POISN=0
                THERMAL=0
                DEN=0
                MASS=0
                FY=0
                while sflist[curenti+1].startswith(" "):
                    curenti=curenti+1
                    matline_comb=sflist[curenti]
                    iMAT=iMAT+1                    
                    if sflist[curenti+1].startswith(" "):#对下一行的判断
                        matline_comb=matline_comb+sflist[curenti+1]
                        curenti=curenti+1
                        matlist=matline_comb.lstrip().split()
                        for info in matlist:
                            mid_info=info.partition("=")
                            if mid_info[0].upper()=="NAME":
                                MNAME=mid_info[2]
                            elif mid_info[0].upper()=="W":
                                DEN=float(mid_info[2])
                            elif mid_info[0].upper()=="E":
                                ELAST=float(mid_info[2])
                            elif mid_info[0].upper()=="U":
                                POISN=float(mid_info[2])
                            elif mid_info[0].upper()=="A":
                                THERMAL=float(mid_info[2])
                            elif mid_info[0].upper()=="FY":
                                FY=float(mid_info[2])
                        MAT_data.append([iMAT,TYPE,MNAME,SPHEAT,HEATCO,PLAST,TUNIT,bMASS,DAMPRATIO,DATA1_type,ELAST,POISN,THERMAL,DEN,MASS])
                        MAT_index[str(MNAME)]=str(iMAT)#中转查询用
                    
                    else:
                        print("单行数据处理，未编写")
                for i in MAT_data:
                    fw.write("    "+str(i[0])+" , ")
                    for j in i[1:-1]:
                        fw.write(str(j)+" , ")
                    fw.write(str(i[-1])+"\n")
                
        elif keyword == "FRAME SECTION":
            print("转入FRAME SECTION处理模块")
            with open(outfile,"a") as fw:
                fw.write("""*SECTION    ; Section
; iSEC, TYPE, SNAME, [OFFSET], bSD, bWE, SHAPE, [DATA1], [DATA2]                    ; 1st line - DB/USER
; [OFFSET] : OFFSET, iCENT, iREF, iHORZ, HUSER, iVERT, VUSER
; [DATA1] : 1, DB, NAME or 2, D1, D2, D3, D4, D5, D6, D7, D8, D9, D10 \n""")
                while sflist[curenti+1].startswith(" "):
                    curenti=curenti+1
                    c_line=sflist[curenti]
                    linelist=c_line.split()
                    section_data.append([linelist[0].partition("=")[2],linelist[1].partition("=")[2],linelist[2].partition("=")[2],linelist[3].partition("=")[2].partition(",")[0],linelist[3].partition("=")[2].partition(",")[2]])
                for i in section_data:
                    section_index[i[0]]=MAT_index[i[1]]
                    if i[2].upper()=="P":
                        fw.write("    "+i[0]+", DBUSER   ,"+"P"+str(float(i[3])*1000)+"x"+str(float(i[4])*1000)+" , CC ,0,0,0,0,0,0,YES,NO,"+i[2]+", 2,"+i[3]+","+i[4]+", 0,0,0,0,0,0,0,0 \n")
                    
        elif keyword == "FRAME":
            print("转入FRAME处理模块")
            #偷懒处理，人为判断所有数据均是网壳，为二力杆受力体系
            with open(outfile,"a") as fw:
                fw.write("""*ELEMENT    ; Elements
; iEL, TYPE, iMAT, iPRO, iN1, iN2, ANGLE, iSUB, EXVAL, iOPT(EXVAL2) ; Frame  Element \n""")
                while sflist[curenti+1].startswith(" "):
                    curenti=curenti+1
                    linelist=sflist[curenti].split()
                    #按MGT格式存储信息
                    frame_data.append([linelist[0],"TRUSS",section_index[linelist[2].partition("=")[2]],linelist[2].partition("=")[2],linelist[1].partition("=")[2].partition(",")[0],linelist[1].partition("=")[2].partition(",")[2],"0","0"])
                for info in frame_data:
                    fw.write("    "+",".join(info)+"\n")
                
        elif keyword == "LOADS":
            print("转入LOADS处理模块")
            #数据会比较多
            
            SW=""
            while sflist[curenti+1].startswith(" "):
                
                
                while sflist[curenti+1].lstrip().startswith("NAME"):
                    curenti=curenti+1
                    linelist=sflist[curenti].split()
                    NAME=linelist[0].partition("=")[2]
                    if NAME.upper()=="DL":
                        SW=linelist[1].partition("=")[2]
                        lctype="D"
                    elif NAME.upper()=="LL":
                        lctype="L"
                    curenti=curenti+1
                    linelist=sflist[curenti].split()
                    TYPE=linelist[0].partition("=")[2]
                    if TYPE.upper()=="TEMPERATURE":
                        lctype="T"
                        if len(linelist)>1 and linelist[1].partition("=")[0].upper()=="ELEM":
                            ldtype="*ELTEMPER"
                        else:
                            ldtype="*CONLOAD"
                    elif TYPE.upper()=="FORCE":
                        ldtype="*CONLOAD"
                    else:
                        print("荷载TYPE错误，未考虑类型："+TYPE)
                                        
                    conload=[]
                    while sflist[curenti+1].startswith(" ") and (not sflist[curenti+1].lstrip().startswith("NAME")):
                       
                        curenti=curenti+1
                        linelist=sflist[curenti].split()

                        if lctype!="T":
                            #*CONLOAD    ; Nodal Loads
                            #; NODE_LIST, FX, FY, FZ, MX, MY, MZ, GROUP
                            data=["0"for x in range(7)];data.append("")#fx="0";fy="0";fz="0";mx="0";my="0";mz="0";group=""
                            data[0]=linelist[0].partition("=")[2] #string
                        
                            for i in linelist[1:]:
                                if i.partition("=")[0].upper()=="UZ":
                                    data[3]=i.partition("=")[2]
                                else:
                                    print("非法荷载方向")
                        else:
                            #*ELTEMPER    ; Element Temperatures
                            #; ELEM_LIST, TEMPER, GROUP
                            data=["" for x in range(3)]
                            data[0]=linelist[0].partition("=")[2]#string="*"
                            for i in linelist[1:]:
                                if i.partition("=")[0]=="T":
                                    data[1]=i.partition("=")[2]
                                else:
                                    print("非法温度描述")
                        
                        conload.append(data)
                    load_data.append([NAME,ldtype,conload])
                    load_index[NAME]=lctype
                    
            #输出到文件
            with open(outfile,"a") as fw:
                fw.write('''*STLDCASE    ; Static Load Cases
; LCNAME, LCTYPE, DESC \n''')
                for i in [x[0] for x in load_data]:
                    fw.write("    "+i+","+load_index[i]+",  \n")
                if len(SW)>0:
                    fw.write("    Self Weight ,  D  , 自重  \n")
                    fw.write('''*USE-STLD, Self Weight

; *SELFWEIGHT, X, Y, Z, GROUP
*SELFWEIGHT, 0, 0, {}, 

; End of data for load case [Self Weight] -------------------------\n'''.format(SW))
                for i in load_data:
                    NAME=i[0]
                    ldtype=i[1]
                    fw.write("*USE-STLD, {}\n\n{}".format(NAME,ldtype))
                    if ldtype=="*CONLOAD":
                        fw.write("   ; Nodal Loads\n; NODE_LIST, FX, FY, FZ, MX, MY, MZ, GROUP\n")
                        for info in i[2]:
                            fw.write("    "+",".join(info)+"\n")
                    elif ldtype=="*ELTEMPER":
                        fw.write("   ; Element Temperatures\n; ELEM_LIST, TEMPER, GROUP\n")
                        for info in i[2]:
                            #temper=info[1]
                            if info[0]=="*":
                                for frameid in [x[0] for x in frame_data]:
                                    fw.write("    {} , ".format(frameid)+" ,  ".join(info[1:])+"\n")
                    else:
                        print("荷载TYPE出错2,这个出现太奇怪了")
                    
                    
        elif keyword == "COMBO":
            print("转入COMBO处理模块")
            data1=[]
            combname=""
            kind="STEEL"
            active="ACTIVE"
            bES="0"
            iTYPE="0"
            DESC=""
            iSERV_TYPE="0"
            nLCOMTYPE="0"
            data2=["ST","Self Weight","1.2"]
            namespc=2
            mid_data2=[]
            while sflist[curenti+1].startswith(" "):
                curenti=curenti+1
                if sflist[curenti].lstrip().startswith("NAME"):
                    if len(data1)>0:
                        for info in mid_data2:
                            data2.append("ST")
                            data2.extend(info)
                            DESC=DESC+info[1]+info[0]+"+"#最后一项会多一个“+”
                        DESC=DESC.rstrip("+")
                        data1.extend([DESC,iSERV_TYPE,nLCOMTYPE])
                        combo_data.append([data1,data2])
                        #初始化
                        data1=[]
                        data2=["ST","Self Weight","1.2"]
                        DESC=""
                        mid_data2=[]
                    combname="NAME="+sflist[curenti].split()[0].partition("=")[2]
                    data1.extend([combname,kind,active,bES,iTYPE])
                    namespc=sflist[curenti].count(" ",0,5)
                elif sflist[curenti].count(" ",0,5)>namespc:
                    linelist=sflist[curenti].split()
                    mid_data2.append([linelist[0].partition("=")[2],linelist[1].partition("=")[2]])
                    #data2.extend(["ST",mid_data2[]])#另外实现
                else:
                    print("COMBO数据处理异常")
                
            if len(data1)>0:#最后一次压入
                for info in mid_data2:
                    data2.append("ST")
                    data2.extend(info)
                    DESC=DESC+info[1]+info[0]+"+"
                DESC=DESC.rstrip("+")
                data1.extend([DESC,iSERV_TYPE,nLCOMTYPE])
                combo_data.append([data1,data2])    
            #输出到文件
            with open(outfile,"a") as fw:
                fw.write('''
*LOADCOMB    ; Combinations
; NAME=NAME, KIND, ACTIVE, bES, iTYPE, DESC, iSERV-TYPE, nLCOMTYPE   ; line 1
;      ANAL1, LCNAME1, FACT1, ...                                    ; from line 2\n''')
                for info in combo_data:
                    fw.write("\t"+" , ".join(info[0])+"\n"+"\t"+" , ".join(info[1])+"\n")
                fw.write("\n")
                    
        elif keyword == "OUTPUT":
            print("转入OUTPUT处理模块")
        elif keyword == "END":
            print("转入END处理模块")
            with open(outfile,"a") as fw:
                fw.write("*ENDDATA")
            break
        else :
            print("为什么会到这里来？")
    curenti=curenti+1
