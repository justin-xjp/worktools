;;;����lst2str
(defun sp:polst2str (lst)
 (strcat (rtos (car lst)) "," (rtos (cadr lst)) "," (rtos (caddr lst))) 
	;�Ƿ����unit����ֵת����
)
;�ַ�����======
(defun sp:s:parse (str1 deli / str lst);���ַ����ָ���سɣ�list���ÿո�ָ�
  (setq str (vl-string-translate deli " " str1))
  (setq str (strcat "(" str ")"))
  (setq lst (read str))
  ;(mapcar 'vl-princ-to-string lst);��lst�е�Ԫ��תΪstring�洢��˼�������ܶԺ�������������
 )
;;85.10 [����] �ַ����ָ�(��lisp��)���ܶ�ܿ�����
;;��������Хstr2lst ������ 2013��8��9��
;;(parse10 "aa   10 b10x20.2" " ");("aa" "" "" "10" "b10x20.2")
;;(parse10 "aa   10 b10x20.2" ""),û���ã�����������ѭ��
(defun sp:s:parse1 (str deli / I S STR1);�����ո��ö��ŷֿ������С�ַ���
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
  (substr nowline 1 (vl-string-search ";" nowline));substr ��1λ�ǵ�һ���ַ���������ͷȥβ�����䡣

)

;�ڵ����ݴ���=====
(setq nddt (list));((id x y z)...)

(defun sp:noderead (/ lst)
;;;�����ַ����еĽڵ���Ϣ
	(setq curentline (read-line file1))
    (setq pureline (sp:delps curentline))					;  (print "�ڵ��ȡ��")
  (while (/= 42 (ascii pureline));��һ�����ֲ���*
	(setq lst (sp:s:parse pureline ","))
	(if lst 
    (setq nddt (append nddt (list lst))))
	;�ָ�pureline,ȥ���ո�
    (setq curentline (read-line file1))
    (setq pureline (sp:delps curentline))
  )
)


;��Ԫ���ݴ���===================
(setq eldt (list));((iEL TYPE iMAT iPRO i-po j-po angle iSUB)...)

; (defun sp:s:eladd (id x)
	; (setq elid (append elid (list id)))
  	; (setq eldt (append eldt (list x)))

  ; )
; (defun sp:s:elsearch (id)
	; (nth (1- id) eldt)
  ; )

(defun sp:elementread (/ lst)
;;;�����ַ����еĵ�Ԫ��Ϣ
	(setq curentline (read-line file1))
    (setq pureline (sp:delps curentline))				
  (while (/= 42 (ascii pureline));��һ�����ֲ���*
	(setq lst (sp:s:parse pureline ","))
	(if lst 
    (setq eldt (append eldt (list lst))))
	;�ָ�pureline,ȥ���ո�
    (setq curentline (read-line file1))
    (setq pureline (sp:delps curentline))
  )
  ;(print "��Ԫ��ȡ��")
)

;�������ݴ���==========================
(setq sedt (list));Ĭ���������ֻ�漰��iSEC, TYPE, SNAME, [OFFSET], bSD, bWE, SHAPE, [DATA1]1, DB, NAME or 2, D1, D2, D3, D4, D5, D6, D7, D8, D9, D10, [DATA2]CCSHAPE or iCEL or iN1, iN2
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
  (while (/= 42 (ascii pureline));��һ�����ֲ���*
	(if (/= pureline "")
	(progn
	(setq lst (sp:s:parse1 pureline ","))
	(setq sedt (append sedt (list lst)))))
	;�ָ�pureline,ȥ���ո�
    (setq curentline (read-line file1))
    (setq pureline (sp:delps curentline))
  )
  ;(print "��Ԫ��ȡ��")
)

;������ɫ���ݴ���==================
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
  (while (/= 42 (ascii pureline));��һ�����ֲ���*
	(setq lst (sp:s:parse pureline ","))
	(if lst 
    (setq scdt (append scdt lst)))
	;�ָ�pureline,ȥ���ո�
    (setq curentline (read-line file1))
    (setq pureline (sp:delps curentline))
  )
  ;(print "��Ԫ��ȡ��")
)

;====================����������������Ӧ�ø�Ϊ��װ�Ķ�������=======================================
(print "����MGT�ļ����drmgt")

(defun C:drmgt ()

(setq
  file1	(open (getfiled "��ѡ����Ҫ�򿪵�MGT�ļ�" "e:\\" "mgt" 0) "r")
)
(print "�ɹ���") 
(print "��ʼ��ȡ�ļ�����")

;;;(print (strcat "��ʼ��ȡ" (last file1)))
(setq curentline (read-line file1))
(setq pureline (sp:delps curentline))
;;;����ѭ������
(setq whilekey 1)
(while whilekey
;;;�������STR����*ENDDATAʱ��ѭ��ִ�С��������д��CURENTLINE
;;;�Զ�����н���ǰ����
;;;����ע������
					
;;; cond����������һ�ͻ�ִ�в���������pureline��ͷ�����ض��ַ��Ҳ���*�žͻ��ȡ��һ�У��������ENDDATA©��
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
		((= "*ENDDATA" (vl-princ-to-string (read pureline))) (setq whilekey nil))
		(t (progn 	
				(setq curentline (read-line file1))
				(setq pureline (sp:delps curentline))
			)
		)
	)

	
)
(print "�����ļ���ȡ")
(close file1)
(print "close the file")
;;;����ͼ����=======================
(prin1 "��ͼ")
(setq inum 0);��Ԫ����
(while (/= nil (setq ndat (cdar eldt)))
  ;;ndat=��TYPE iMAT iPRO iN1 iN2 ANGLE iSUB��
  ;(setq ndat (cdar eldt));��Ԫid��������������inum����id��
  (setq eldt (cdr eldt))
  (setq isec (caddr ndat));iPRO ������
  (setq ilayername (vl-string-translate "<>/\\\":;?*|,=`" "-------------" (caddr (nth (1- isec) sedt))));������STR-��ͼ�����Ϸ�����,inam��ͼ����
  ;(setq iclr ())��ɫ��ȡδ������Ϊԭ�ļ�ģ����ͬ��ɫ��
  
  (setq i-po (cdr (assoc (cadddr ndat) nddt)))
  (setq j-po (cdr (assoc (cadr (cdddr ndat)) nddt)))
;;;ͼ�㴦��
  (command "-layer" "m" (strcat ilayername "-line") "")
;;;����
  (command "line" (sp:polst2str i-po) (sp:polst2str j-po) "")
  (command)
  (setq inum (1+ inum))
  
;  (command "re")
)


(prin1 inum)
)
