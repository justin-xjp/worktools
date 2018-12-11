;;;函数用法声明：
(if (= (type cal) nil)
  (arxload "geomcal.arx")
 )
;;;内部函数，向量旋转
(defun un:vecrot (p0 ang0);ang0须是弧度表示，用angle函数得到即可
;;将p0转换成单位向量
;;应对p0进行合法检验
(setq x0 (car p0))
(setq y0 (cadr p0))
(setq z0 (caddr p0))
(setq x1 (- (* x0 (cos ang0)) (* y0 (sin ang0))))
(setq y1 (+ (* x0 (sin ang0)) (* y0 (cos ang0))))
(list x1 y1 '0)
)
;;;主函数C:unitbd,
;;;unitbd适用于杆件直线端有节点编号（位于线端偏上），
;;;杆件所在图层区分了杆件型号的图纸。类似于3D3S。
;;;本命令会丢失杆件，生成的文件中包含error的线需要人工补上。建议生成模型后人工复查。
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

;;;主函数C:unithd,
;;;unithd是适用于，杆件类型由线中附近（上、下、左、斜向）的文字进行描述，
;;; 线端有节点编号（位于线端附近）的图纸，类似于MST出图。
;;; 本命令会丢失杆件，生成的文件中包含error的线需要人工补上。建议生成模型后人工复查。
(defun C:unithd	()			;注意局部变量的声明

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
	(setq pmid nil)
	
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
			(print "确定端部文字与点的关系")
			(command)
			(setvar "osmode" 1)
			(setq basep (getpoint "指定基准点"));basep的Z坐标不一定为0
			(setvar "osmode" 0)
			(setq dp1 (getpoint "文字范围的左上点"));后续改为用rec做矩形块获得。
			(setq dp2 (getpoint "文字范围的右下点"))
			(setq dp1 (mapcar '- dp1 basep));能减
			(setq dp2 (mapcar '- dp2 basep))
			;;指定中点及文字范围
			(command)
			(print "确定杆中文字与点的关系")
			(command)
			(setvar "osmode" 2)
			(setq mbp (getpoint "指定中点基准点"));basep的Z坐标不一定为0
			(setvar "osmode" 0)
			(setq mdp1 (getpoint "文字范围的左上点"));后续改为用rec做矩形块获得。
			(setq mdp2 (getpoint "文字范围的右下点"))
			(setq mdp1 (mapcar '- mdp1 mbp));能减
			(setq mdp2 (mapcar '- mdp2 mbp))
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
					;;增设线中点坐标，pmid，并用尝试选用中点附件，垂直线方向，+/-，一定范围内的TEXT作为杆件分类。杆件分类如“4-22”，只摘取-号前的数字。
					(setq pmid (cal "(p1+p2)/2"))
					;;将dp1,dp2转动一个angb
					(setq angb (angle p1 p2))
					(setq mdp1 (un:vecrot mdp1 angb))
					(setq mdp2 (un:vecrot mdp2 angb))
					(setq mqb1 (un:vecrot mdp1 pi))
					(setq mqb2 (un:vecrot mdp2 pi))
					(cond
						;;拿到上或下的文字，如果错误，标记ERROR
						((/= (setq ttl (ssget "c" (mapcar '+ pmid mdp1) (mapcar '+ pmid mdp2) '((-4 . "<OR")(0 . "TEXT")(0 . "MTEXT")(-4 . "OR>")))) nil) (setq midtext (cdr (assoc 1 (entget (ssname ttl 0))))))
						((/= (setq ttl (ssget "c" (mapcar '+ pmid mqb1) (mapcar '+ pmid mqb2) '((-4 . "<OR")(0 . "TEXT")(0 . "MTEXT")(-4 . "OR>")))) nil) (setq midtext (cdr (assoc 1 (entget (ssname ttl 0))))))
						(T (setq ttl nil) (setq midtext "error"))
					)
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
					;;;提取杆件端坐标，在端附近选出text/mtext文本，存储为nod1,nod2。提取杆件层信息layers,以图层名（或颜色）区分层。按nod1,nod2,layers导出到文件

					;;当error时，记录下tti,ttj,layers,midtext,p1,p2，以帮助人工查找出错误杆件。
					(if (or (= tti "error") (= ttj "error") (= midtext "error"))
						(write-line (strcat tti "," ttj "," layers "," midtext "," (vl-princ-to-string p1) "," (vl-princ-to-string p2)) outfile)
						(write-line (strcat tti "," ttj "," layers "," midtext) outfile )
					)
					(setq n (1+ n))
				)
			)

			(close outfile)			;关闭文件
		)
		(princ "选择集为空")
	)


;;;状态恢复
	(setvar "cecolor" oldcolor)		;恢复初始设置
	(setvar "PLINETYPE" oldpltp)
	(setvar "osmode" oldosmode)
	(command)
	(command "_.undo" "b")		;回到返回点。经常此句无动作
	(command)
	(setvar "modemacro" "")		;清空状态
)
;;;主函数C:sph3s
;;;将图中的网架球节点编号与NODEid对应起来，经修改后可以给3D3S球节点设计导入。
(defun c:sph3s()
;;;状态初始化
	(setvar "modemacro" "=网架球节点与nodeID=")	;状态文字
	(command "_.undo" "m")		;设置返回点
	(command)
	(setvar "cmdecho" 0)			;显示状态开关
	(setq oldcolor (getvar "cecolor"))	;当前颜色状态保存
	(setvar "CECOLOR" "red")		;设置工作颜色
	(setq oldpltp (getvar "PLINETYPE"))	;PLINETYPE指定是否使用优化的二维多段线。系统变量
	(setvar "PLINETYPE" 1)		;打开旧图形时不转换其中的多段线；PLINE 创建优化的多段线 
	(setq oldosmode (getvar "osmode"))
	(setvar "osmode" 0)
;;; var:
	(setq ssl (ssadd))
	(setq ssmax 0)
	(setq Cp1 nil)
	(setq ttla nil)
	(setq ttlb nil)
	(setq nid "")
	(setq sphtype "")
	(setq n 0)
	(setq elname nil)
	(setq el nil)

;;; 框选所需处理区域，circle进入选择集ssl,判断选择集的合法性
	(princ "请选择需要处理的球节点")
	(setq ssl (ssget '((0 . "CIRCLE"))))	
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
			(setvar "osmode" 4)
			(setq basep (getpoint "指定圆心"));basep的Z坐标不一定为0
			(setvar "osmode" 0)
			(setq dp1 (getpoint "文字范围的左上点"));feature:后续应改为用rec做矩形块获得。
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
					(setq Cp1 (cdr (assoc 10 el)))
					;;抓取文字，
					(if (/= (setq ttla (ssget "c" (mapcar '+ Cp1 dp1) (mapcar '+ Cp1 dp2) '((-4 . "<AND")(0 . "TEXT")(8	 . "nodeid")(-4 . "AND>")))) nil) (setq nid (cdr (assoc 1 (entget (ssname ttla 0))))) (setq nid "error"))
					(if (/= (setq ttlb (ssget "c" (mapcar '+ Cp1 dp1) (mapcar '+ Cp1 dp2) '((-4 . "<AND")(0 . "TEXT")(8 . "sphty")(-4 . "AND>")))) nil) (setq sphtype (cdr (assoc 1 (entget (ssname ttlb 0))))) (setq sphtype "error"))
					;;将内容串起来输出到文件
					;;"nid，"固定",sphtype[,Cp1]"
					(if (or (= nid "error") (= sphtype "error"))
						(write-line (strcat  nid ",固定," sphtype "," (vl-princ-to-string Cp1)) outfile)
						(write-line (strcat nid ",固定," sphtype ) outfile )
					)
					(setq n (1+ n))
				)
			)

			(close outfile)			;关闭文件
		)
		(princ "选择集为空")
	)
	(prin1 '"共输出节点" ssmax)
	;;;状态恢复
	(setvar "cecolor" oldcolor)		;恢复初始设置
	(setvar "PLINETYPE" oldpltp)
	(setvar "osmode" oldosmode)
	(command)
	(command "_.undo" "b")		;回到返回点。经常此句无动作
	(command)
	(setvar "modemacro" "")		;清空状态栏

)