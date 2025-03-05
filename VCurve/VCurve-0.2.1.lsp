;;; 绘制定向钻竖向曲线图
;;;版本：v0.0.5
;;;适用于从“定向钻数据表格(CSV文件)”生成竖曲线
;;;表格格式 | 编号 | 深度 | 角度|



;;;函数初始化

(defun sp:s:parse (str1 deli / str lst)	;将字符串分割并返回成（list）用空格分隔
  (setq str (vl-string-translate deli " " str1))
  (setq str (strcat "(" str ")"))
  (setq lst (read str))
					;(mapcar 'vl-princ-to-string lst);将lst中的元素转为string存储。思考；可能对后续处理有利。
)



					;======================================================================
;;;主函数C:VCurve
;;;适用于从“定向钻数据表格”生成竖曲线
;;;表格格式 | 编号 | 深度 | 角度|
(defun C:VCurve	()

;;;状态初始化
  (setvar "modemacro" "====定向钻竖向图绘制中====") ;状态文字
  ; (command "_.undo" "m")		;设置返回点
  ; (command)
   (setvar "cmdecho" 0)			;显示状态开关
  ; (setq oldcolor (getvar "cecolor"))	;当前颜色状态保存
  ; (setvar "CECOLOR" "red")		;设置工作颜色
   (setq oldpltp (getvar "PLINETYPE"))	;PLINETYPE指定是否使用优化的二维多段线。系统变量
   (setvar "PLINETYPE" 1)		;打开旧图形时不转换其中的多段线；PLINE 创建优化的多段线 
   (setq oldosmode (getvar "osmode"))
   (setvar "osmode" 0)
;;;变量声明初始化
  (setq nn1 '())
  (setq ganchang (getreal "请输入杆件长度<3>"))
  (if (not ganchang) (setq ganchang 3))
  ; (setq ganchang 3)
   (setq pointss nil)
  (setq linss (ssadd))



;;;主任务
					;打开指定的文件
          (setq fil_r (getfiled "请指定打开的文件" "" "csv" 0))
          (setq readf (open fil_r "r"))
;;;按行读取信息,并存入allinone
					(while (/= nil (setq curentline (read-line readf)))
						(setq nn1 (append nn1 (list curentline)))
					)
					(close readf)

  ;;调试阶段假数据:
  ; (setq	nn1 '( "钻杆数,深度,角度"		      "1,0.8,-33"
	; 	  "2,1.8,-30"	    "3,2.3,-28"	      "4,3,-28"
	; 	  "5,3.8,-27"	    "6,4.5,-22"	      "7,5.1,-20"
	; 	  "8,5.5,-15"
	; 	 )
  ; )
					;(prin1 nn1)
  (setq nn1 (cdr nn1))
;;;;绘图
  (setq nn2 nn1)
  (setq p1 (getpoint "指定起始点"))
  (print)
  (command "pline" p1)
  (repeat (length nn1)
    (setq curent (car nn1)) ;"1,0.8,-33"
    (setq nn1 (cdr nn1))
    (setq temlst (sp:s:parse curent ",")) ;(1 0.8 -33)
    (setq ang1 (caddr temlst))
    (command (strcat "@"
		     (vl-prin1-to-string ganchang)
			"<"
		     (vl-prin1-to-string ang1)
	     )
    )
  )
  (command)

 ;;;加深度线
  (setq mypl (entget (entlast)))
  (setq pts nil)
      (foreach lst mypl
    (if (= (car lst) 10)
        (setq pts (append pts (list (cdr lst))))
    )
    )
  (setq pointss pts)

  (setq pts (cdr pts))
  (repeat (length pts)
    (setq curent (car nn2)) ;"1,0.8,-33"
    (setq nn2 (cdr nn2))
    (setq temlst (sp:s:parse curent ",")) ;(1 0.8 -33)
    (setq vleng (cadr temlst))
    (setq p1 (car pts))
    (setq pts (cdr pts))
    (command "line" p1)
    (command (strcat "@"
              (vl-prin1-to-string vleng)
              "<90")
    )
    (command)
    (ssadd (ssname (ssget "L") 0) linss)
  )
 ;;;拿到直线的端点
  (setq pts nil)
 (setq i (sslength linss))
 (repeat (sslength linss)
    (setq i (- i 1))
    (setq myline (entget (ssname linss i)))
    (foreach lst myline
      (if (= (car lst) 11)
          (setq pts (append pts (list (cdr lst))))
      )
    )
    ; (setq pts (append pts (cadr ptemp)))
 )
 (repeat (length pts)
    (setq p1 (car pts) )
    (setq pts (cdr pts))
    (setq p2 (car pts))
    (command "line" p1 p2)
    (command)
 )

 ;;;绘制点

 (setvar "pdmode" 35)
 (setvar "pdsize" 0.2)
 (foreach p1 pointss
    (command "point" p1)


 )

  




;;;状态恢复
  ; (setvar "cecolor" oldcolor)		;恢复初始设置
  (setvar "PLINETYPE" oldpltp)
  (setvar "osmode" oldosmode)
  (setvar "cmdecho" 1)	
  ; (command)
  ; (command "_.undo" "b")		;回到返回点。经常此句无动作
  ; (command)
  (setvar "modemacro" "")		;清空状态
)

