;;;����lst2str
(defun sp:polst2str (lst)
 (strcat (rtos (car lst)) "," (rtos (cadr lst)) "," (rtos (caddr lst))) 
	;�Ƿ����unit����ֵת����
)
;�ַ�����======
(defun sp:s:parse (str1 deli / str lst);���ַ����ָ���سɣ�list��
  (setq str (vl-string-translate deli " " str1))
  (setq str (strcat "(" str ")"))
  (setq lst (read str))
  ;(mapcar 'vl-princ-to-string lst);��lst�е�Ԫ��תΪstring�洢��˼�������ܶԺ�������������
 )
;;85.10 [����] �ַ����ָ�(��lisp��)���ܶ�ܿ�����
;;��������Хstr2lst ������ 2013��8��9��
;;(parse10 "aa   10 b10x20.2" " ");("aa" "" "" "10" "b10x20.2")
;;(parse10 "aa   10 b10x20.2" ""),û���ã�����������ѭ��
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
;;;ɾ�������ַ����е�ע������
					;  (print "ɾ��ע��,����ע��ǰ�����ݡ��������Ŀո�")
  (substr nowline 1 (vl-string-search ";" nowline))

)

;�ڵ����ݴ���=====
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
;;;�����ַ����еĽڵ���Ϣ
	(setq curentline (read-line file1))
    (setq pureline (sp:delps curentline))					;  (print "�ڵ��ȡ��")
  (while (/= 42 (ascii pureline));��һ�����ֲ���*
	(setq lst (sp:s:parse pureline ","))
	(if lst 
    (sp:s:nodeadd (car lst) (cdr lst)))
	;�ָ�pureline,ȥ���ո�
    (setq curentline (read-line file1))
    (setq pureline (sp:delps curentline))
  )
)


;��Ԫ���ݴ���===================
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
;;;�����ַ����еĵ�Ԫ��Ϣ
	(setq curentline (read-line file1))
    (setq pureline (sp:delps curentline))				
  (while (/= 42 (ascii pureline));��һ�����ֲ���*
	(setq lst (sp:s:parse pureline ","))
	(if lst 
    (sp:s:eladd (car lst) (cdr lst)))
	;�ָ�pureline,ȥ���ո�
    (setq curentline (read-line file1))
    (setq pureline (sp:delps curentline))
  )
  ;(print "��Ԫ��ȡ��")
)

;�������ݴ���==========================
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
  (while (/= 42 (ascii pureline));��һ�����ֲ���*
	(if (/= pureline "") (setq lst (sp:s:parse1 pureline ",")))
	(if (/= pureline "") (sp:s:secadd (car lst) (cdr lst)))
	;�ָ�pureline,ȥ���ո�
    (setq curentline (read-line file1))
    (setq pureline (sp:delps curentline))
  )
  ;(print "��Ԫ��ȡ��")
)



;������ɫ���ݴ���==================
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
  (while (/= 42 (ascii pureline));��һ�����ֲ���*
	(setq lst (sp:s:parse pureline ","))
	(if lst 
    (sp:s:scladd (car lst) (cdr lst)))
	;�ָ�pureline,ȥ���ո�
    (setq curentline (read-line file1))
    (setq pureline (sp:delps curentline))
  )
  ;(print "��Ԫ��ȡ��")
)

;====================����������������Ӧ�ø�Ϊ��װ�Ķ�������=======================================


(setq
  file1	(open (getfiled "��ѡ����Ҫ�򿪵�MGT�ļ�" "e:\\" "mgt" 0) "r")
)
(print "�ɹ���") 
(print "��ʼ��ȡ�ļ�����")

;;;(print (strcat "��ʼ��ȡ" (last file1)))
(setq curentline (read-line file1))
(setq pureline (sp:delps curentline))
(while (/= "*ENDDATA" (vl-princ-to-string (read pureline)))
;;;�������STR����*ENDDATAʱ��ѭ��ִ�С��������д��CURENTLINE
;;;  (if (= "*ENDDATA" curentline) (print curentline))
;;;�Զ�����н���ǰ����
;;;����ע������
					;	   (setq pureline (sp:delps curentline))

					;  (print "delet ע��")
					;  (set 'curentline (sp:delps curentline))
					;  (print "�ж��Ƿ��ǹؼ���")
					;  (if (= "*REBAR-MATL-CODE" curentline)    sp:rebar-matl-coderead  )
  (if (= "*NODE" (vl-princ-to-string (read pureline)))
	
	;ȷ�����ݺ������һ�в��������ݴ���
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
					;  (if (= "*SELFWEIGHT" curentline) sp:selfweightread);����stld������
					;  (if (= "*BEAMLOAD" curentline) sp:beamloadread)
					;  (if (= "*CONLOAD" curentline) sp:conloadread)
					;  (if (= "*FLOADTYPE" curentline) sp:floadtyperead)
					;  (if (= "*FLOAD-COLOR" curentline) sp:fload-colorread)
					;  (if (= "*FLOORLOAD" curentline) sp:floorloadread)
					;  (if (= "*LOADCOMB" curentline) sp:loadcombread)
					;  (if (= "*LC-COLOR" curentline) sp:lc-colorread)
					;  (if (= "*ANAL-CTRL" curentline) sp:anal-ctrlread)
					;  (if (= "*DGN-MATL" curentline) sp:dgn-matlread)
;����½�ELEMENT��SECTION˳��ͬ��������ִ�С�
  (setq curentline (read-line file1))
  (setq pureline (sp:delps curentline))
)
;����ͼ����=======================
(prin1 "��ͼ")
(setq inum (length elid))
(while (> inum 0)
  
  (setq ndat (sp:s:elsearch inum))
  (setq isec (caddr ndat))
  (setq inam (vl-string-translate "<>/\\\":;?*|,=`" "-------------" (cadr (sp:s:secsearch isec))));������STR-��ͼ�����Ϸ�����
  ;(setq iclr ())��ɫ��ȡδ������Ϊԭ�ļ�ģ����ͬ��ɫ��
  
  (setq i-po (sp:s:nodesearch (cadddr ndat)))
  (setq j-po (sp:s:nodesearch (cadr (cdddr ndat))))
;;;ͼ�㴦��
  (command "-layer" "m" (strcat inam "-line") "")
;;;����
  (command "line" (sp:polst2str i-po) (sp:polst2str j-po) "")
;  (command "re")
  (setq inum (1- inum))
)

(print "�����ļ���ȡ")

(close file1)
(print "close the file")


