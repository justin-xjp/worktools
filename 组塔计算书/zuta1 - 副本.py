#组塔计算书生成器，仅生成塔段内数据。争取做到数据汇总输出
import math,os
from datetime import datetime
# 获取当前时间
current_time = datetime.now();

# 格式化时间路径
timePath = current_time.strftime('%Y%m%d%H%M%S');
#全局变量
resultlist=[];

def getBeta(_topB:float,_topD,_L2:float,_L:float):
    return math.atan2(_topD/2-_topB/3+0.5,math.sqrt(_L**2-(_topB/3)**2)-_L2);
def getBeta0(_topB:float,_L2:float,_L:float):
    return math.atan2(_topB/2+0.5,_L-_L2);
def getDelta(_topB,_L):
    return math.asin(_topB/3/_L);
def getAlpha2(_topB,_L1):
    return math.atan(1.2*_L1/_topB);
def getTheta(_topB,_L1,_tilted):
    if _tilted == 0 :
        return math.atan2(_topB/2,math.sqrt(_L1**2+(_topB/2)**2));
    else:
        return math.atan2(_topB/2,math.sqrt(_L1**2+(_topB*5/6)**2));


def getF(_omiga,_beta,_Gforce):
    return math.sin(_beta)/math.cos(_omiga+_beta)*_Gforce;
def getT(_omiga,_beta,_Gforce):
    return math.cos(_omiga)/math.cos(_omiga+_beta)*_Gforce;
def getPh(_alpha,_beta,_delta,_Tforce):
    return math.sin(_beta+_delta)/math.cos(_alpha+_delta)*_Tforce;
def getN(_alpha,_beta,_delta,_Tforce,_yita):
    return math.cos(_beta-_alpha)/math.cos(_alpha+_delta)*_Tforce-_yita*_Tforce;
def getP1(_ph,_theta):
    return _ph/(2*math.cos(_theta));

def getPhi(_topB,_L2):
    return math.atan(_topB/(2*_L2));
def getPhiL(_topB,_L2):
    return math.atan2(_topB/2,math.sqrt(_L2**2+_topB**2/4));

def getS1(_Phi,_delta,_N,_G0):
    #倾斜的时候δ=0
    return (_N+G0)*math.sin(_Phi+_delta)/math.sin(2*_Phi);
def getS(_S1,_phiL):
    return 1.2*_S1/(2*math.cos(_phiL));

#逐行读取数据
with open('info.csv','r',encoding='utf-8') as infoFile:
    #跳过第一行
    infoFile.readline();
    nz=1;
    for line in infoFile:
        stepNo,isCircle,TopB,gjzl,bazl,myL,myL2,myYita = line.split(',');
        if isCircle == "1":
            myTopB=float(TopB)/math.sqrt(2);
            topmiaoshu="外接圆直径D="+TopB+"m，4点承托点组成矩形边长：B=D*√(2)/2="+"{:.2f}".format(myTopB)+"m";
            TopB=float(TopB);
        else:
            myTopB=float(TopB);
            TopB=myTopB;
            topmiaoshu="B="+"{:.2f}".format(myTopB)+"m";
        print(topmiaoshu);
        G=float(gjzl)*1.1*9.81;
        outG=G/1000;
        G0=float(bazl)*1.1*9.81;
        outG0=G0/1000;
        myL=float(myL);
        myL2=float(myL2);
        myYita=float(myYita);
        myL1=myL-myL2;
        #对圆形截面调整边界
        myBeta=getBeta(myTopB,TopB,myL2,myL);
        outBeta=myBeta*180/math.pi;

        myOmiga=45*math.pi/180;

        myBeta0=getBeta0(TopB,myL2,myL);
        outBeta0=myBeta0*180/math.pi;

        F=getF(myOmiga,myBeta,G);
        F_0=getF(myOmiga,myBeta0,G);
        outF0=F_0/1000;

        outF=F/1000;
        T_0=getT(myOmiga,myBeta0,G);
        outT0=T_0/1000;
        T=getT(myOmiga,myBeta,G);
        outT=T/1000;
        myAlpha0=math.atan(myL1/myTopB*2);
        outAlpha0=myAlpha0*180/math.pi;
        myAlpha2=getAlpha2(myTopB,myL1);
        outAlpha=myAlpha2*180/math.pi;
        myDelta=getDelta(myTopB,myL);
        outDelta=myDelta*180/math.pi;
        Ph=getPh(myAlpha2,myBeta,myDelta,T);
        outPh=Ph/1000;
        Ph_0=getPh(myAlpha0,myBeta0,0,T_0);
        outPh0=Ph_0/1000;
        myTheta_0=getTheta(myTopB,myL1,0);
        outTheta_0=myTheta_0*180/math.pi;
        myTheta=getTheta(myTopB,myL1,1);
        outTheta=myTheta*180/math.pi;
        p1=getP1(Ph,myTheta);
        outP1=p1/1000;
        p1_0=getP1(Ph_0,myTheta_0);
        outP10=p1_0/1000;
        Tq=1.04*T/1000;
        Tq_0=1.04*T_0/1000;
        N=getN(myAlpha2,myBeta,myDelta,T,myYita);
        outN=N/1000;
        N_0=getN(myAlpha0,myBeta0,0,T_0,myYita);
        outN0=N_0/1000;
        myPhi=getPhi(myTopB,myL2);
        outPhi=myPhi*180/math.pi;
        myPhiL=getPhiL(myTopB,myL2);
        outPhiL=myPhiL*180/math.pi;

        myS1_0=getS1(myPhi,0,N_0,G0);
        outS10=myS1_0/1000;
        myS_0=getS(myS1_0,myPhiL);
        outS0=myS_0/1000;
        myS1=getS1(myPhi,myDelta,N,G0);
        outS1=myS1/1000;
        myS=getS(myS1,myPhiL);
        outS=myS/1000;

        with open("steptemp.txt", "r",encoding='utf-8') as f:
            template = f.read()
            #替换占位符
            result = template.format(stepNo=stepNo,topmiaoshu=topmiaoshu,gjzl=gjzl,outG=outG,B=myTopB,L1=myL1,outBeta=outBeta,outF0=outF0,L=myL,outBeta0=outBeta0,outF=outF,outT=outT,outT0=outT0,outAlpha0=outAlpha0,outAlpha=outAlpha,outPh0=outPh0,outDelta=outDelta,outPh=outPh,L2=myL2,outTheta_0=outTheta_0,outTheta=outTheta,outP10=outP10,outP1=outP1,Tq=Tq,Tq_0=Tq_0,outN0=outN0,outN=outN,outPhi=outPhi,outPhiL=outPhiL,outS10=outS10,outS0=outS0,outS1=outS1,outS=outS,outG0=outG0,TopB=TopB,nz=nz)
        # 生成计算书
        nz=nz+1;
        os.makedirs(timePath,exist_ok=True);
        filePath=timePath+"/塔段"+stepNo+".txt";
        with open(filePath, "w") as f:
            f.write(result)
        #将数据添加到list
        #塔段，起吊重力,Phi,Phil,#不倾斜时的alpha,beta,theta,F,T,Ph,P1,Tq,N,S1,S,#倾斜的重复alpha,beta,theta,F,T,Ph,P1,Tq,N,S1,S
        resultlist.append([stepNo,G,outPhi,outPhiL,outAlpha0,outBeta0,outTheta_0,outF0,outT0,outPh0,outP10,Tq_0,outN0,outS10,outS0,outAlpha,outBeta,outDelta,outTheta,outF,outT,outPh,outP1,Tq,outN,outS1,outS]);
# 将数据存储到表格
resultlist.insert(0,['塔段','起吊重力kN','Phi','Phil','#不倾斜时的alpha0','beta0','theta0','F0','T0','Ph0','P10','Tq0','N0','S10','S0','#倾斜的重复alpha','beta','delta','theta','F','T','Ph','P1','Tq','N','S1','S']);
with open(timePath+'/resultlist.csv', 'w') as file:
    # 遍历2维列表的每一行
    for row in resultlist:
        # 将行转换为字符串，并用逗号分隔每个元素
        line = ','.join(str(x) for x in row)
        # 将行写入文件
        file.write(line + '\n')



