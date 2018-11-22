;;;主函数C:unitbd,
(defun C:unitbd	()			;注意局部变量的声明

;;;状态初始化
	(setvar "modemacro" "=杆表生成器=")	;状态文字
	(command "_.undo" "m")		;设置返回点
	(command)
	(setvar "cmdecho" 0)			;显示状态开关
	(setq oldcolor (getvar "cecolor"))	;当前颜色状态保存
	(setvar "CECOLOR" "red")		;设置工作颜色
	(setq oldpltp (getvar "PLINETYPE"))	;PLINETYPE指定是否使用优化的二维多段线。系统变量
	(setvar "PLINETYPE" 1)		;打开旧图形时不转换其中的多段线；PLINE 创建优化的多段线 
	(setq oldosmode (getvar "osmode"))
	(setvar "osmode" 0)
;;;变量声明初始化
	(setq ssl (ssadd))
	(setq ttl (ssadd));文字选择集
	(setq ssmax 0)
	(setq n 0)
	(setq elname nil)
	(setq el nil)
	(setq layers "0")
	(setq nod1 "")
	(setq nod2 "")
	(setq tti "");;每个单元文字初始化
	(setq ttj "")
	(setq p1 nil)
	(setq p2 nil)
	(setq p11 nil)
	(setq p12 nil)
	(setq p21 nil)
	(setq p22 nil)
	(setq ttl nil)
	
	
;;;框选杆件区域，line、pline进入选择集ssl,判断选择集的合法性
	(princ "请选择需要处理的杆件")
	(setq ssl (ssget '((0 . "LINE"))))	;没有包含PLINE情况。
	(if (/= ssl nil)
		(progn
      ;;选择完毕，打开文件并进行导出
			(setq fil_w (getfiled "请指定保存的文件" "e:\\" "csv" 1))
			(setq outfile (open fil_w "w"))
			(setq ssmax (sslength ssl))
			;;指定基准点，确定框选用向量
			(command)
			(print "确定文字与点的关系")
			(command)
			(setvar "osmode" 1)
			(setq basep (getpoint "指定基准点"));basep的Z坐标不一定为0
			(setvar "osmode" 0)
			(setq dp1 (getpoint "文字范围的左上点"));后续改为用rec做矩形块获得。
			(setq dp2 (getpoint "文字范围的右下点"))
			(setq dp1 (mapcar '- dp1 basep));能减
			(setq dp2 (mapcar '- dp2 basep))
			(getstring "选择结束后请将所有关键字段都至于视野内，ENTER键继续")
;;;逐个提取ssl中的单元
			(while (< n ssmax)
				(progn
					(setq tti "");;每个单元文字初始化
					(setq ttj "")
					(setq layers "0")
					(setq elname (ssname ssl n))
					;(princ (entget elname))
					(setq el (entget elname))
					(setq p1 (cdr (assoc 10 el)))
					(setq p2 (cdr (assoc 11 el)))
					;(command "_zoom" "w" (mapcar '+ p1 '(-1000 1000)) (mapcar '+ p2 '(1000 -1000)))
					(setq layers (cdr (assoc 8 el)))
					;;这里要把抓取坐标附近的text
					(setq p11 (mapcar '+ p1 dp1))
					(setq p12 (mapcar '+ p1 dp2));试试看不动Z坐标的话是不是都能满足。
					;;用接触选择的方式得到文字,分两次得到两个
					(setq ttl (ssget "c" p11 p12 '((-4 . "<OR")(0 . "TEXT")(0 . "MTEXT")(-4 . "OR>"))))
					(if (= nil ttl) (setq tti "error")
					(setq tti (cdr (assoc 1 (entget (ssname ttl 0))))))
					(setq p21 (mapcar '+ p2 dp1))
					(setq p22 (mapcar '+ p2 dp2))
					(setq ttl (ssget "c" p21 p22 '((-4 . "<OR")(0 . "TEXT")(0 . "MTEXT")(-4 . "OR>"))))
					(if (= nil ttl) (setq ttj "error") 
					(setq ttj (cdr (assoc 1 (entget (ssname ttl 0))))))
					;;将内容串起来输出到文件
					(write-line (strcat tti "," ttj "," layers) outfile )
					(setq n (1+ n))
				)
			)

			(close outfile)			;关闭文件
		)
		(princ "选择集为空")
	)

;;;提取杆件端坐标，在端附近选出text/mtext文本，存储为nod1,nod2。提取杆件层信息layers,以图层名（或颜色）区分层。按nod1,nod2,layers导出到文件



;;;状态恢复
	(setvar "cecolor" oldcolor)		;恢复初始设置
	(setvar "PLINETYPE" oldpltp)
	(setvar "osmode" oldosmode)
	(command)
	(command "_.undo" "b")		;回到返回点。经常此句无动作
	(command)
	(setvar "modemacro" "")		;清空状态
)