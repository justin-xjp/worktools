;;;坐标lst2str
(defun sp:polst2str (lst)
 (strcat (rtos (car lst)) "," (rtos (cadr lst)) "," (rtos (caddr lst))) 
	;是否根据unit将数值转换？
)
;字符处理======
(defun sp:s:parse (str1 deli / str lst);将字符串分割并返回成（list）用空格分隔
  (setq str (vl-string-translate deli " " str1))
  (setq str (strcat "(" str ")"))
  (setq lst (read str))
  ;(mapcar 'vl-princ-to-string lst);将lst中的元素转为string存储。思考；可能对后续处理有利。
 )
;;85.10 [功能] 字符串分割(纯lisp法)不能躲避空数据
;;改自梁雄啸str2lst 黄明儒 2013年8月9日
;;(parse10 "aa   10 b10x20.2" " ");("aa" "" "" "10" "b10x20.2")
;;(parse10 "aa   10 b10x20.2" ""),没作用，但不进入死循环
(defun sp:s:parse1 (str deli / I S STR1);保留空格用逗号分开成逐个小字符串
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
  (substr nowline 1 (vl-string-search ";" nowline));substr 的1位是第一个字符，此行掐头去尾留当间。

)

;节点数据处理=====
(setq nddt (list));((id x y z)...)

(defun sp:noderead (/ lst)
;;;读入字符串中的节点信息
	(setq curentline (read-line file1))
    (setq pureline (sp:delps curentline))					;  (print "节点读取中")
  (while (/= 42 (ascii pureline));第一个文字不是*
	(setq lst (sp:s:parse pureline ","))
	(if lst 
    (setq nddt (append nddt (list lst))))
	;分割pureline,去除空格并
    (setq curentline (read-line file1))
    (setq pureline (sp:delps curentline))
  )
)


;单元数据处理===================
(setq eldt (list));((iEL TYPE iMAT iPRO i-po j-po angle iSUB)...)

; (defun sp:s:eladd (id x)
	; (setq elid (append elid (list id)))
  	; (setq eldt (append eldt (list x)))

  ; )
; (defun sp:s:elsearch (id)
	; (nth (1- id) eldt)
  ; )

(defun sp:elementread (/ lst)
;;;读入字符串中的单元信息
	(setq curentline (read-line file1))
    (setq pureline (sp:delps curentline))				
  (while (/= 42 (ascii pureline));第一个文字不是*
	(setq lst (sp:s:parse pureline ","))
	(if lst 
    (setq eldt (append eldt (list lst))))
	;分割pureline,去除空格并
    (setq curentline (read-line file1))
    (setq pureline (sp:delps curentline))
  )
  ;(print "单元读取中")
)

;截面数据处理==========================
(setq sedt (list));默认网架情况只涉及：iSEC, TYPE, SNAME, [OFFSET], bSD, bWE, SHAPE, [DATA1]1, DB, NAME or 2, D1, D2, D3, D4, D5, D6, D7, D8, D9, D10, [DATA2]CCSHAPE or iCEL or iN1, iN2
; (setq seid (list))


; (defun sp:s:secadd (id x)
	; (setq seid (append seid (list id)))
  	; (setq sedt (append sedt (list x)))

  ; )
; (defun sp:s:secsearch (id)
	; (nth (1- id) sedt)
  ; )

(defun sp:sectionread (/ lst)
	(setq curentline (read-line file1))
    (setq pureline (sp:delps curentline))				
  (while (/= 42 (ascii pureline));第一个文字不是*
	(if (/= pureline "")
	(progn
	(setq lst (sp:s:parse1 pureline ","))
	(setq sedt (append sedt (list lst)))))
	;分割pureline,去除空格并
    (setq curentline (read-line file1))
    (setq pureline (sp:delps curentline))
  )
  ;(print "单元读取中")
)

;截面颜色数据处理==================
(setq scdt (list))
; (setq scid (list))


; (defun sp:s:scladd (id x)
	; (setq scid (append scid (list id)))
  	; (setq scdt (append scdt (list x)))

  ; )
; (defun sp:s:sclsearch (id)
	; (nth (1- id) scdt)
  ; )

(defun sp:sec-colorread (/ lst)
	(setq curentline (read-line file1))
    (setq pureline (sp:delps curentline))				
  (while (/= 42 (ascii pureline));第一个文字不是*
	(setq lst (sp:s:parse pureline ","))
	(if lst 
    (setq scdt (append scdt lst)))
	;分割pureline,去除空格并
    (setq curentline (read-line file1))
    (setq pureline (sp:delps curentline))
  )
  ;(print "单元读取中")
)

;====================这里是主程序，最终应该改为封装的独立命令=======================================
(print "导入MGT文件命令：drmgt")

(defun C:drmgt ()

(setq
  file1	(open (getfiled "请选择需要打开的MGT文件" "e:\\" "mgt" 0) "r")
)
(print "成功打开") 
(print "开始读取文件内容")

;;;(print (strcat "开始读取" (last file1)))
(setq curentline (read-line file1))
(setq pureline (sp:delps curentline))
;;;设置循环开关
(setq whilekey 1)
(while whilekey
;;;当读入的STR不是*ENDDATA时，循环执行。读入的行写入CURENTLINE
;;;对读入的行进行前处理
;;;消除注释内容
					
;;; cond条件满足其一就会执行并跳出，当pureline开头不是特定字符且不是*号就会读取下一行，不会出现ENDDATA漏判
;;; 
	(cond 
		((= "*NODE" (vl-princ-to-string (read pureline))) (sp:noderead))
		((= "*ELEMENT" (vl-princ-to-string (read pureline))) (sp:elementread))
		((= "*SECTION" (vl-princ-to-string (read pureline))) (sp:sectionread))
					 ; ; (if (= "*GROUP" curentline) sp:groupread)
					 ; ; (if (= "*MATERIAL" curentline) sp:materialread)
					 ; ; (if (= "*MATL-COLOR" curentline) sp:matl-colorread)
		((= "*SECT-COLOR" (vl-princ-to-string (read pureline))) (sp:sec-colorread))
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
		((= "*ENDDATA" (vl-princ-to-string (read pureline))) (setq whilekey nil))
		(t (progn 	
				(setq curentline (read-line file1))
				(setq pureline (sp:delps curentline))
			)
		)
	)

	
)
(print "结束文件读取")
(close file1)
(print "close the file")
;;;绘线图过程=======================
(prin1 "绘图")
(setq inum 0);单元总数
(while (/= nil (setq ndat (cdar eldt)))
  ;;ndat=（TYPE iMAT iPRO iN1 iN2 ANGLE iSUB）
  ;(setq ndat (cdar eldt));单元id不连续，不能用inum调用id。
  (setq eldt (cdr eldt))
  (setq isec (caddr ndat));iPRO 截面编号
  (setq ilayername (vl-string-translate "<>/\\\":;?*|,=`" "-------------" (caddr (nth (1- isec) sedt))));读出是STR-做图层名合法处理,inam是图层名
  ;(setq iclr ())颜色读取未处理，因为原文件模型是同颜色的
  
  (setq i-po (cdr (assoc (cadddr ndat) nddt)))
  (setq j-po (cdr (assoc (cadr (cdddr ndat)) nddt)))
;;;图层处理
  (command "-layer" "m" (strcat ilayername "-line") "")
;;;画线
  (command "line" (sp:polst2str i-po) (sp:polst2str j-po) "")
  (command)
  (setq inum (1+ inum))
  
;  (command "re")
)


(prin1 inum)
)
