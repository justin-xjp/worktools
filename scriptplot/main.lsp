;;;坐标lst2str
(defun sp:polst2str (lst)
 (strcat (rtos (car lst)) "," (rtos (cadr lst)) "," (rtos (caddr lst))) 
	;是否根据unit将数值转换？
)
;字符处理======
(defun sp:s:parse (str1 deli / str lst);将字符串分割并返回成（list）
  (setq str (vl-string-translate deli " " str1))
  (setq str (strcat "(" str ")"))
  (setq lst (read str))
  ;(mapcar 'vl-princ-to-string lst);将lst中的元素转为string存储。思考；可能对后续处理有利。
 )
;;85.10 [功能] 字符串分割(纯lisp法)不能躲避空数据
;;改自梁雄啸str2lst 黄明儒 2013年8月9日
;;(parse10 "aa   10 b10x20.2" " ");("aa" "" "" "10" "b10x20.2")
;;(parse10 "aa   10 b10x20.2" ""),没作用，但不进入死循环
(defun sp:s:parse1 (str deli / I S STR1)
  (setq i 0 str1 "")
  (while (/= "" (setq s (substr str (setq i (1+ i)) 1)))
    (setq str1 (strcat str1
                       (if (= deli s)
                         "\" \""
                         s
                       )
               )
    )
  )
  (read (strcat "(\"" str1 "\")"))
)

(defun sp:delps	(nowline)
;;;删除读入字符串中的注释内容
					;  (print "删除注释,返回注释前的内容。消除最后的空格")
  (substr nowline 1 (vl-string-search ";" nowline))

)

;节点数据处理=====
(setq nddt (list))
(setq ndid (list))

(defun sp:s:nodeadd (id x)
	(setq ndid (append ndid (list id)))
  	(setq nddt (append nddt (list x)))

  )
(defun sp:s:nodesearch (id)
	(nth (1- id) nddt)
  )

(defun sp:noderead (/ lst)
;;;读入字符串中的节点信息
	(setq curentline (read-line file1))
    (setq pureline (sp:delps curentline))					;  (print "节点读取中")
  (while (/= 42 (ascii pureline));第一个文字不是*
	(setq lst (sp:s:parse pureline ","))
	(if lst 
    (sp:s:nodeadd (car lst) (cdr lst)))
	;分割pureline,去除空格并
    (setq curentline (read-line file1))
    (setq pureline (sp:delps curentline))
  )
)


;单元数据处理===================
(setq eldt (list))
(setq elid (list))

(defun sp:s:eladd (id x)
	(setq elid (append elid (list id)))
  	(setq eldt (append eldt (list x)))

  )
(defun sp:s:elsearch (id)
	(nth (1- id) eldt)
  )

(defun sp:elementread (/ lst)
;;;读入字符串中的单元信息
	(setq curentline (read-line file1))
    (setq pureline (sp:delps curentline))				
  (while (/= 42 (ascii pureline));第一个文字不是*
	(setq lst (sp:s:parse pureline ","))
	(if lst 
    (sp:s:eladd (car lst) (cdr lst)))
	;分割pureline,去除空格并
    (setq curentline (read-line file1))
    (setq pureline (sp:delps curentline))
  )
  ;(print "单元读取中")
)

;截面数据处理==========================
(setq sedt (list))
(setq seid (list))


(defun sp:s:secadd (id x)
	(setq seid (append seid (list id)))
  	(setq sedt (append sedt (list x)))

  )
(defun sp:s:secsearch (id)
	(nth (1- id) sedt)
  )

(defun sp:sectionread (/ lst)
	(setq curentline (read-line file1))
    (setq pureline (sp:delps curentline))				
  (while (/= 42 (ascii pureline));第一个文字不是*
	(if (/= pureline "") (setq lst (sp:s:parse1 pureline ",")))
	(if (/= pureline "") (sp:s:secadd (car lst) (cdr lst)))
	;分割pureline,去除空格并
    (setq curentline (read-line file1))
    (setq pureline (sp:delps curentline))
  )
  ;(print "单元读取中")
)



;截面颜色数据处理==================
(setq scdt (list))
(setq scid (list))


(defun sp:s:scladd (id x)
	(setq scid (append scid (list id)))
  	(setq scdt (append scdt (list x)))

  )
(defun sp:s:sclsearch (id)
	(nth (1- id) scdt)
  )

(defun sp:sec-colorread (/ lst)
	(setq curentline (read-line file1))
    (setq pureline (sp:delps curentline))				
  (while (/= 42 (ascii pureline));第一个文字不是*
	(setq lst (sp:s:parse pureline ","))
	(if lst 
    (sp:s:scladd (car lst) (cdr lst)))
	;分割pureline,去除空格并
    (setq curentline (read-line file1))
    (setq pureline (sp:delps curentline))
  )
  ;(print "单元读取中")
)

;====================这里是主程序，最终应该改为封装的独立命令=======================================


(setq
  file1	(open (getfiled "请选择需要打开的MGT文件" "e:\\" "mgt" 0) "r")
)
(print "成功打开") 
(print "开始读取文件内容")

;;;(print (strcat "开始读取" (last file1)))
(setq curentline (read-line file1))
(setq pureline (sp:delps curentline))
(while (/= "*ENDDATA" (vl-princ-to-string (read pureline)))
;;;当读入的STR不是*ENDDATA时，循环执行。读入的行写入CURENTLINE
;;;  (if (= "*ENDDATA" curentline) (print curentline))
;;;对读入的行进行前处理
;;;消除注释内容
					;	   (setq pureline (sp:delps curentline))

					;  (print "delet 注释")
					;  (set 'curentline (sp:delps curentline))
					;  (print "判断是否是关键字")
					;  (if (= "*REBAR-MATL-CODE" curentline)    sp:rebar-matl-coderead  )
  (if (= "*NODE" (vl-princ-to-string (read pureline)))
	
	;确认内容后读入下一行并进入数据处理
	(sp:noderead)
	)	
  (if (= "*ELEMENT" (vl-princ-to-string (read pureline)))
    		(sp:elementread)
  )
					;  (if (= "*GROUP" curentline) sp:groupread)
					;  (if (= "*MATERIAL" curentline) sp:materialread)
					;  (if (= "*MATL-COLOR" curentline) sp:matl-colorread)
   (if (= "*SECTION" (vl-princ-to-string (read pureline)))
    				(sp:sectionread)
   )
  (if (= "*ELEMENT" (vl-princ-to-string (read pureline)))
    		(sp:elementread)
  )
  					
  ;|
  (if (= "*SECT-COLOR" (vl-princ-to-string (read pureline)))
    (sp:sec-colorread)
   )
   |;
					;  (if (= "*DGN-SECT" curentline) sp:dgn-sectread)
					;  (if (= "*STLDCASE" curentline) sp:stldcaseread)
					;  (if (= "*CONSTRAINT" curentline) sp:constraintread)
					;  (if (= "*USE-STLD" curentline) sp:use-stldread)
					;  (if (= "*SELFWEIGHT" curentline) sp:selfweightread);属于stld的子项
					;  (if (= "*BEAMLOAD" curentline) sp:beamloadread)
					;  (if (= "*CONLOAD" curentline) sp:conloadread)
					;  (if (= "*FLOADTYPE" curentline) sp:floadtyperead)
					;  (if (= "*FLOAD-COLOR" curentline) sp:fload-colorread)
					;  (if (= "*FLOORLOAD" curentline) sp:floorloadread)
					;  (if (= "*LOADCOMB" curentline) sp:loadcombread)
					;  (if (= "*LC-COLOR" curentline) sp:lc-colorread)
					;  (if (= "*ANAL-CTRL" curentline) sp:anal-ctrlread)
					;  (if (= "*DGN-MATL" curentline) sp:dgn-matlread)
;如果章节ELEMENT和SECTION顺序不同，会跳过执行。
  (setq curentline (read-line file1))
  (setq pureline (sp:delps curentline))
)
;绘线图过程=======================
(prin1 "绘图")
(setq inum (length elid))
(while (> inum 0)
  
  (setq ndat (sp:s:elsearch inum))
  (setq isec (caddr ndat))
  (setq inam (vl-string-translate "<>/\\\":;?*|,=`" "-------------" (cadr (sp:s:secsearch isec))));读出是STR-做图层名合法处理
  ;(setq iclr ())颜色读取未处理，因为原文件模型是同颜色的
  
  (setq i-po (sp:s:nodesearch (cadddr ndat)))
  (setq j-po (sp:s:nodesearch (cadr (cdddr ndat))))
;;;图层处理
  (command "-layer" "m" (strcat inam "-line") "")
;;;画线
  (command "line" (sp:polst2str i-po) (sp:polst2str j-po) "")
;  (command "re")
  (setq inum (1- inum))
)

(print "结束文件读取")

(close file1)
(print "close the file")


