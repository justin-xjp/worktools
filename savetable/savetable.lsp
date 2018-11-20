(prin1 "插件命令：bgdc")

(defun c:bgdc (/	   oldcolor    oldpltp	   dist	 pt    e1    e2
	     n	   fil_w x     str   nf	   st	 l     e     m
	     p1	   p2	 ttl   tt    ptx   pty
	    )
  (setvar "modemacro" "=表格导出中=");状态文字
  (command "_.undo" "m");设置返回点
  (command)
  (setvar "cmdecho" 0);显示状态开关
  (setq n 0)
  (setq oldcolor (getvar "cecolor"));当前颜色状态保存
  (setvar "CECOLOR" "red");设置工作颜色
  (setq oldpltp (getvar "PLINETYPE"));PLINETYPE指定是否使用优化的二维多段线。系统变量
  (setvar "PLINETYPE" 1);打开旧图形时不转换其中的多段线；PLINE 创建优化的多段线 
  (setq e1 nil)
  (setq ss (ssadd));ssadd 创建选择集
  (setq sh (ssadd))
  (setvar "osmode" 32);系统变量，设置执行对象捕捉。32，交点。15位2进制开关
  (initget 0 "Up Down Left Right");指定接下来的getxx函数可用选项。
  (princ "插件使用说明：单元格高度应一致，否则可能出错\n")
  (setq fx (getkword "确定表格生长方向Up/Down/<Down>:"))
					;(setq dist (getdist"\n>>**********>>输入行间距:")) 
  (setvar "osmode" 0);关闭捕捉
  (command);空行，对于autocad命令有确认效果。
  (print
    '>>**********>>注意将打开的写入文件关闭，或更换文件名！！！;不理解的提示
  )
  (while (setq pt (getpoint "\n>>**********>>点击选择关键字段:"));通过点选框内点，确定框区域。前期关闭了捕捉可以很方便的执行此动作。
    (command "_.boundary" "a" "i" "n" "" "" pt "");相当于'-boundary' a(高级选项) i(孤岛检测) n(NO) ，连续两个默认，pt(选的点) ,结束 。boundary会生成一个封闭的多段线。
    (command)
    (if	(= (cdr (assoc 0 (entget (entlast)))) "LWPOLYLINE");判断如果所选单元是"LWPOLYLINE",提取，否，nil
      (setq e2 (entlast))
      (setq e2 e1)
    )
					;(command "_.pedit" e2 "w" 1 "") 
    (command)
    (if	(/= e2 e1)
      (progn
	(setq ss (ssadd e2 ss))
	(setq e1 e2)
	(command "_.hatch" "s" e1 "")
	(command)
	(setq sh (ssadd (entlast) sh))
	(redraw e2 2)
	(setq n (+ n 1))
	(print '>>*****>>已选字段数:)
	(prin1 n)
      )
      (print '>>**********>>所选字段无效!!!)
    )
  )
  (getstring "选择结束后请将所有关键字段都至于视野内，ENTER键继续") 
  (setq fil_w (getfiled "请指定保存的文件" "e:\\" "csv" 1))
  (setq x (open fil_w "w"))
  (setq str "1")
  (setq nf 0)
  (while (/= str "")
    (setq str "")
    (setq st "")
    (setq l 0)
    (while (/= l n)
      (if (setq e (ssname ss l))
	(progn
;|
	  (setq m 4)
	  (setq p1 (reverse (entget e)))
	  (while (> m 0)
	    (setq p1 (cdr p1))
	    (setq m (- m 1))
	  )
	  (setq p1 (cdar p1))
	  (setq m 12)
	  (setq p2 (reverse (entget e)))
	  (while (> m 0)
	    (setq p2 (cdr p2))
	    (setq m (- m 1))
	  )
	  (setq p2 (cdar p2))
|;
	  (setq e (entget e))
	  (setq p1 (cdr (assoc 10 e)))
	  (setq e (cdr (member (assoc 10 e) e)))
;|
	  (while (or (= (cadr (assoc 10 e)) (car p1)) (= (caddr (assoc 10 e)) (cadr p1)))
	     (setq e (cdr (member (assoc 10 e) e)))
	  )
|;
          (setq e (cdr (member (assoc 10 e ) e)))
	  (setq p2 (cdr (assoc 10 e)))
	 
	 ; (command "_zoom" "w" (mapcar '+ p1 '(100 100)) (mapcar '+ p2 '(-100 -100)))
	  ;(command)
	  
	  (redraw)
	  (if (or (setq ttl (ssget "w" (mapcar '+ p1 '(50 50)) (mapcar '+ p2 '(-50 -50)) '((0 . "text"))))
		  (setq ttl (ssget "w" (mapcar '+ p1 '(50 50)) (mapcar '+ p2 '(-50 -50)) '((0 . "mtext"))))
	      )
	    (progn
	      (setq tt (cdr (assoc 1 (entget (ssname ttl 0)))))
					;(setq distx (abs (- (car p2) (car p1)))) 
	      (setq disty (abs (- (cadr p2) (cadr p1))))
	    )
	    (setq tt "")
	  )
	)
	(setq tt "")
      	)
      (setq st (strcat st tt ","))
      (setq str (strcat str tt))
      (setq l (+ l 1))
    )
    (print)
    (princ st)
    (write-line st x)
    (setq ptx (car p1))
    (setq pty (cadr p1));?????防止有z
    (cond
      ((= fx "Up") (setq pt (list ptx (+ pty disty) 0)))
      ((= fx "Down") (setq pt (list ptx (- pty disty) 0)))
      ((= fx nil) (setq pt (list ptx (- pty disty) 0)))
    )
    (setq nf (+ nf 1))
    (command "_.move" ss sh "" p1 pt)
    (command "_.pan" pt p1)
    (command)


  )
  (close x)
  (setvar "cecolor" oldcolor)
  (setvar "PLINETYPE" oldpltp)
  (command)
  (command "_.undo" "b")
  (command)
  (print '>>**********>>导出表格字段数:)
  (prin1 n)
  (print '>>**********>>导出表格行数:)
  (princ (itoa (- nf 1)))
  (prin1)
  (setvar "modemacro" "")
)