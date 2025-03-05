### 1.1.{nz} 当前步骤：塔段{stepNo}

#### 1.受力条件
{topmiaoshu}。

本阶段最大构件重量：{gjzl}kg，

#### 2.起吊重力计算：

$G={gjzl}\times1.1\times9.81=${outG:.2f} kN

#### 3.攀根绳的静张力：

1）当抱杆为竖直状态时，计算得

$$
\begin【array】【ll】
\beta & =\arctan(\frac【\frac【B】【2】+0.5】【L_1】) \\
 & =\arctan(\frac【\frac【{TopB:.2f}】【2】+0.5】【{myL1}】)\\
 & ={outBeta0:.2f}\text【 °】
\end【array】
$$

$\omega=${outOmiga:.2f}°

$$
\begin【array】【ll】
F & = G \times \frac【\sin(\beta)】【\cos(\omega+\beta)】 \\
 & ={outG:.2f}\times \frac【\sin({outBeta0:.2f})】【\cos({outOmiga:.2f}+{outBeta0:.2f})】 \\
 & ={outF0:.2f}\text【 kN】
\end【array】
$$

2）当抱杆向构件倾斜B/3时，

$$
\begin【array】【ll】
\beta &=\arctan(\frac【B/2-B/3+0.5】【\sqrt【L^2-(B/3)^2】-L_1】)\\
 & =\arctan(\frac【{TopB:.2f}/2-{myTopB:.2f}/3+0.5】【(\sqrt【{myL}^2-({myTopB:.2f}/3)^2】-{myL1})】)\\
 & = {outBeta:.2f}\text【 °】
\end【array】
$$

$$
\begin【array】【ll】
F & = G \times \frac【\sin(\beta)】【\cos(\omega+\beta)】 \\
 & = {outG:.2f}\times \frac【\sin({outBeta:.2f}】【\cos({outOmiga:.2f}+{outBeta:.2f})】 \\
 & = {outF:.2f} \text【 kN】
\end【array】
$$

#### 4.起吊绳的静张力：

1）抱杆为竖直状态时

$$
\begin【array】【ll】
T & = G \times \frac【\cos(\omega)】【\cos(\omega+\beta)】 \\
 & = {outG:.2f}\times \frac【\cos{outOmiga:.2f}】【\cos({outOmiga:.2f}+{outBeta0:.2f})】 \\
 & = {outT0:.2f} \text【 kN】
\end【array】
$$

2）抱杆向构件倾斜B/3时，

$$
\begin【array】【ll】
T & = G \times \frac【 \cos(\omega)】【\cos(\omega+\beta)】 \\
 & = {outG:.2f}\times \frac【 \cos{outOmiga:.2f}】【\cos({outOmiga:.2f}+{outBeta:.2f})】 \\
 & = {outT:.2f} \text【 kN】
\end【array】
$$

#### 5.拉线的静张力：

1）抱杆竖直时，

$$
\begin【array】【ll】
\alpha & = \arctan(\frac【2L_1】【B】)\\
&=\arctan(\frac【2\times {myL1}】【{myTopB:.2f}】)\\
&={outAlpha0:.2f}\text【 °】
\end【array】
$$

$$
\begin【array】【ll】
P_h & = \frac【\sin\beta】【\cos\alpha】 T\\
& = \frac【\sin({outBeta0:.2f})】【\cos({outAlpha0:.2f})】\times {outT0:.2f}\\
 & = {outPh0:.2f}\text【 kN】
\end【array】
$$

$$
\begin【array】【ll】
\theta & = \arctan(\frac【B】【2\sqrt【L_1^2+(\frac【B】【2】)^2】】)\\
 & = \arctan(\frac【{myTopB:.2f}】【2\times \sqrt【{myL1}^2+({myTopB:.2f}/2)^2】】)\\
 & = {outTheta_0:.2f}\text【 °】
\end【array】
$$

$$
\begin【array】【ll】
P_1 & = \frac【P_h】【2\cos\theta】 \\
 & = \frac【{outPh0:.2f}】【2\times \cos({outTheta_0:.2f})】 \\
 & = {outP10:.2f} \text【 kN】
\end【array】
$$

2）抱杆倾斜B/3时，

$$
\begin【array】【ll】
\alpha & = \arctan(\frac【6L_1】【5B】)\\
 & = \arctan(\frac【6\times {myL1}】【5\times{myTopB:.2f}】)\\
 & = {outAlpha:.2f}\text【 °】
\end【array】
$$

$$
\begin【array】【ll】
\delta & = \arcsin(\frac【B】【3L】)\\
& = \arcsin(\frac【{myTopB:.2f}】【3\times{myL}】)\\
& = {outDelta:.2f}\text【 °】
\end【array】
$$

$$
\begin【array】【ll】
P_h & = \frac【\sin(\beta+\delta)】【\cos(\alpha-\delta)】 T\\
& = \frac【\sin({outBeta:.2f}+{outDelta:.2f})】【\cos({outAlpha:.2f}-{outDelta:.2f})】\times{outT:.2f}\\
& =  {outPh:.2f} \text【 kN】
\end【array】
$$

$$
\begin【array】【ll】
\theta & = \arctan(\frac【B】【2\sqrt【L_1^2+(\frac【5B】【6】)^2】】)\\
 & = \arctan(\frac【{myTopB:.2f}】【(2\times \sqrt【{myL1}^2+({myTopB:.2f}\times 5/6)^2】)】)\\
 & = {outTheta:.2f}\text【 °】
\end【array】
$$

$$
\begin【array】【ll】
P_1 & = \frac【P_h】【2\cos\theta】 \\
 & = \frac【{outPh:.2f}】【(2\times\cos({outTheta:.2f}))】 \\
 & = {outP1:.2f} \text【 kN】
\end【array】
$$

#### 6.牵引绳的静张力

1）抱杆竖直时，

$T_q =1.04 \times T =$ {Tq_0:.2f} kN

2）抱杆倾斜B/3时，

$T_q =1.04 \times T =$ {Tq:.2f} kN

#### 7.抱杆轴向压力：

1）抱杆竖直状态

$$
\begin【array】【ll】
N & =\frac【\cos(\beta-\alpha)】【\cos\alpha】 T+T_q\\
 & =\frac【\cos({outBeta0:.2f}-{outAlpha0:.2f})】【\cos{outAlpha0:.2f}】\times {outT0:.2f}+{Tq_0:.2f}\\
 & ={outN0:.2f} \text【 kN】
\end【array】
$$

2）抱杆倾斜状态

$$
\begin【array】【ll】
N & = \frac【\cos (\beta-\alpha)】【\cos(\alpha-\delta)】 T +T_q\\
 & = \frac【\cos({outBeta:.2f}-{outAlpha:.2f})】【\cos({outAlpha:.2f}-{outDelta:.2f})】\times{outT:.2f}+{Tq:.2f}\\
 & = {outN:.2f} \text【 kN】
\end【array】
$$

#### 8.承托绳的静张力：

1）抱杆竖直状态

$\phi =\arctan(\frac【B】【2L_2】)=\arctan(\frac【{myTopB:.2f}】【2\times {myL2}】)=${outPhi:.2f} °

$\phi_1 =\arctan(\frac【B】【2\sqrt【L_2^2+(B/2)^2】】)=\arctan(\frac【{myTopB:.2f}】【2 \times \sqrt【{myL2}^2+({myTopB:.2f}/2)^2】】)=${outPhiL:.2f}°

$$
\begin【array】【ll】
S_1 & = \frac【(N+G_0)\times \sin\phi】【\sin(2\phi)】 \\
 & = \frac【({outN0:.2f}+{outG0:.2f})\times \sin({outPhi:.2f})】【\sin(2\times{outPhi:.2f})】 \\
 & = {outS10:.2f} \text【 kN】
\end【array】
$$

$$
\begin【array】【ll】
S & = \frac【6 S_1】【5\times 2\cos \phi_1 】 \\
 & = \frac【1.2 \times {outS10:.2f}】【2\times cos({outPhiL:.2f})】 \\
 & = {outS0:.2f} \text【 kN】
\end【array】
$$

2）抱杆倾斜状态

$$
\begin【array】【ll】
S_1 &= \frac【(N+G_0)\times \sin(\phi+\delta)】【\sin(2\phi)】 \\
 &=\frac【({outN:.2f}+{outG0:.2f})\times \sin({outPhi:.2f}+{outDelta:.2f})】【\sin(2\times {outPhi:.2f})】 \\
 & = {outS1:.2f}  \text【 kN】
\end【array】
$$

$$
\begin【array】【ll】
S & = \frac【6 S_1】【5\times 2\cos \phi_1 】 \\
 &= \frac【1.2\times {outS1:.2f}】【2 \times cos({outPhiL:.2f})】 \\
 &= {outS:.2f} \text【 kN】
\end【array】
$$