;;;�����÷�������
(if (= (type cal) nil)
  (arxload "geomcal.arx")
 )
;;;�ڲ�������������ת
(defun un:vecrot (p0 ang0);ang0���ǻ��ȱ�ʾ����angle�����õ�����
;;��p0ת���ɵ�λ����
;;Ӧ��p0���кϷ�����
(setq x0 (car p0))
(setq y0 (cadr p0))
(setq z0 (caddr p0))
(setq x1 (- (* x0 (cos ang0)) (* y0 (sin ang0))))
(setq y1 (+ (* x0 (sin ang0)) (* y0 (cos ang0))))
(list x1 y1 '0)
)
;;;������C:unitbd,
;;;unitbd�����ڸ˼�ֱ�߶��нڵ��ţ�λ���߶�ƫ�ϣ���
;;;�˼�����ͼ�������˸˼��ͺŵ�ͼֽ��������3D3S��
;;;������ᶪʧ�˼������ɵ��ļ��а���error������Ҫ�˹����ϡ���������ģ�ͺ��˹����顣
(defun C:unitbd	()			;ע��ֲ�����������

;;;״̬��ʼ��
	(setvar "modemacro" "=�˱�������=")	;״̬����
	(command "_.undo" "m")		;���÷��ص�
	(command)
	(setvar "cmdecho" 0)			;��ʾ״̬����
	(setq oldcolor (getvar "cecolor"))	;��ǰ��ɫ״̬����
	(setvar "CECOLOR" "red")		;���ù�����ɫ
	(setq oldpltp (getvar "PLINETYPE"))	;PLINETYPEָ���Ƿ�ʹ���Ż��Ķ�ά����ߡ�ϵͳ����
	(setvar "PLINETYPE" 1)		;�򿪾�ͼ��ʱ��ת�����еĶ���ߣ�PLINE �����Ż��Ķ���� 
	(setq oldosmode (getvar "osmode"))
	(setvar "osmode" 0)
;;;����������ʼ��
	(setq ssl (ssadd))
	(setq ttl (ssadd));����ѡ��
	(setq ssmax 0)
	(setq n 0)
	(setq elname nil)
	(setq el nil)
	(setq layers "0")
	(setq nod1 "")
	(setq nod2 "")
	(setq tti "");;ÿ����Ԫ���ֳ�ʼ��
	(setq ttj "")
	(setq p1 nil)
	(setq p2 nil)
	(setq p11 nil)
	(setq p12 nil)
	(setq p21 nil)
	(setq p22 nil)
	(setq ttl nil)
	
	
;;;��ѡ�˼�����line��pline����ѡ��ssl,�ж�ѡ�񼯵ĺϷ���
	(princ "��ѡ����Ҫ����ĸ˼�")
	(setq ssl (ssget '((0 . "LINE"))))	;û�а���PLINE�����
	(if (/= ssl nil)
		(progn
      ;;ѡ����ϣ����ļ������е���
			(setq fil_w (getfiled "��ָ��������ļ�" "e:\\" "csv" 1))
			(setq outfile (open fil_w "w"))
			(setq ssmax (sslength ssl))
			;;ָ����׼�㣬ȷ����ѡ������
			(command)
			(print "ȷ���������Ĺ�ϵ")
			(command)
			(setvar "osmode" 1)
			(setq basep (getpoint "ָ����׼��"));basep��Z���겻һ��Ϊ0
			(setvar "osmode" 0)
			(setq dp1 (getpoint "���ַ�Χ�����ϵ�"));������Ϊ��rec�����ο��á�
			(setq dp2 (getpoint "���ַ�Χ�����µ�"))
			(setq dp1 (mapcar '- dp1 basep));�ܼ�
			(setq dp2 (mapcar '- dp2 basep))
			(getstring "ѡ��������뽫���йؼ��ֶζ�������Ұ�ڣ�ENTER������")
;;;�����ȡssl�еĵ�Ԫ
			(while (< n ssmax)
				(progn
					(setq tti "");;ÿ����Ԫ���ֳ�ʼ��
					(setq ttj "")
					(setq layers "0")
					(setq elname (ssname ssl n))
					;(princ (entget elname))
					(setq el (entget elname))
					(setq p1 (cdr (assoc 10 el)))
					(setq p2 (cdr (assoc 11 el)))
					;(command "_zoom" "w" (mapcar '+ p1 '(-1000 1000)) (mapcar '+ p2 '(1000 -1000)))
					(setq layers (cdr (assoc 8 el)))
					;;����Ҫ��ץȡ���긽����text
					(setq p11 (mapcar '+ p1 dp1))
					(setq p12 (mapcar '+ p1 dp2));���Կ�����Z����Ļ��ǲ��Ƕ������㡣
					;;�ýӴ�ѡ��ķ�ʽ�õ�����,�����εõ�����
					(setq ttl (ssget "c" p11 p12 '((-4 . "<OR")(0 . "TEXT")(0 . "MTEXT")(-4 . "OR>"))))
					(if (= nil ttl) (setq tti "error")
					(setq tti (cdr (assoc 1 (entget (ssname ttl 0))))))
					(setq p21 (mapcar '+ p2 dp1))
					(setq p22 (mapcar '+ p2 dp2))
					(setq ttl (ssget "c" p21 p22 '((-4 . "<OR")(0 . "TEXT")(0 . "MTEXT")(-4 . "OR>"))))
					(if (= nil ttl) (setq ttj "error") 
					(setq ttj (cdr (assoc 1 (entget (ssname ttl 0))))))
					;;�����ݴ�����������ļ�
					(write-line (strcat tti "," ttj "," layers) outfile )
					(setq n (1+ n))
				)
			)

			(close outfile)			;�ر��ļ�
		)
		(princ "ѡ��Ϊ��")
	)

;;;��ȡ�˼������꣬�ڶ˸���ѡ��text/mtext�ı����洢Ϊnod1,nod2����ȡ�˼�����Ϣlayers,��ͼ����������ɫ�����ֲ㡣��nod1,nod2,layers�������ļ�



;;;״̬�ָ�
	(setvar "cecolor" oldcolor)		;�ָ���ʼ����
	(setvar "PLINETYPE" oldpltp)
	(setvar "osmode" oldosmode)
	(command)
	(command "_.undo" "b")		;�ص����ص㡣�����˾��޶���
	(command)
	(setvar "modemacro" "")		;���״̬
)

;;;������C:unithd,
;;;unithd�������ڣ��˼����������и������ϡ��¡���б�򣩵����ֽ���������
;;; �߶��нڵ��ţ�λ���߶˸�������ͼֽ��������MST��ͼ��
;;; ������ᶪʧ�˼������ɵ��ļ��а���error������Ҫ�˹����ϡ���������ģ�ͺ��˹����顣
(defun C:unithd	()			;ע��ֲ�����������

;;;״̬��ʼ��
	(setvar "modemacro" "=�˱�������=")	;״̬����
	(command "_.undo" "m")		;���÷��ص�
	(command)
	(setvar "cmdecho" 0)			;��ʾ״̬����
	(setq oldcolor (getvar "cecolor"))	;��ǰ��ɫ״̬����
	(setvar "CECOLOR" "red")		;���ù�����ɫ
	(setq oldpltp (getvar "PLINETYPE"))	;PLINETYPEָ���Ƿ�ʹ���Ż��Ķ�ά����ߡ�ϵͳ����
	(setvar "PLINETYPE" 1)		;�򿪾�ͼ��ʱ��ת�����еĶ���ߣ�PLINE �����Ż��Ķ���� 
	(setq oldosmode (getvar "osmode"))
	(setvar "osmode" 0)
;;;����������ʼ��
	(setq ssl (ssadd))
	(setq ttl (ssadd));����ѡ��
	(setq ssmax 0)
	(setq n 0)
	(setq elname nil)
	(setq el nil)
	(setq layers "0")
	(setq nod1 "")
	(setq nod2 "")
	(setq tti "");;ÿ����Ԫ���ֳ�ʼ��
	(setq ttj "")
	(setq p1 nil)
	(setq p2 nil)
	(setq p11 nil)
	(setq p12 nil)
	(setq p21 nil)
	(setq p22 nil)
	(setq ttl nil)
	(setq pmid nil)
	
;;;��ѡ�˼�����line��pline����ѡ��ssl,�ж�ѡ�񼯵ĺϷ���
	(princ "��ѡ����Ҫ����ĸ˼�")
	(setq ssl (ssget '((0 . "LINE"))))	;û�а���PLINE�����
	(if (/= ssl nil)
		(progn
      ;;ѡ����ϣ����ļ������е���
			(setq fil_w (getfiled "��ָ��������ļ�" "e:\\" "csv" 1))
			(setq outfile (open fil_w "w"))
			(setq ssmax (sslength ssl))
			;;ָ����׼�㣬ȷ����ѡ������
			(command)
			(print "ȷ���˲��������Ĺ�ϵ")
			(command)
			(setvar "osmode" 1)
			(setq basep (getpoint "ָ����׼��"));basep��Z���겻һ��Ϊ0
			(setvar "osmode" 0)
			(setq dp1 (getpoint "���ַ�Χ�����ϵ�"));������Ϊ��rec�����ο��á�
			(setq dp2 (getpoint "���ַ�Χ�����µ�"))
			(setq dp1 (mapcar '- dp1 basep));�ܼ�
			(setq dp2 (mapcar '- dp2 basep))
			;;ָ���е㼰���ַ�Χ
			(command)
			(print "ȷ�������������Ĺ�ϵ")
			(command)
			(setvar "osmode" 2)
			(setq mbp (getpoint "ָ���е��׼��"));basep��Z���겻һ��Ϊ0
			(setvar "osmode" 0)
			(setq mdp1 (getpoint "���ַ�Χ�����ϵ�"));������Ϊ��rec�����ο��á�
			(setq mdp2 (getpoint "���ַ�Χ�����µ�"))
			(setq mdp1 (mapcar '- mdp1 mbp));�ܼ�
			(setq mdp2 (mapcar '- mdp2 mbp))
			(getstring "ѡ��������뽫���йؼ��ֶζ�������Ұ�ڣ�ENTER������")
;;;�����ȡssl�еĵ�Ԫ
			(while (< n ssmax)
				(progn
					(setq tti "");;ÿ����Ԫ���ֳ�ʼ��
					(setq ttj "")
					(setq layers "0")
					(setq elname (ssname ssl n))
					;(princ (entget elname))
					(setq el (entget elname))
					(setq p1 (cdr (assoc 10 el)))
					(setq p2 (cdr (assoc 11 el)))
					;;�������е����꣬pmid�����ó���ѡ���е㸽������ֱ�߷���+/-��һ����Χ�ڵ�TEXT��Ϊ�˼����ࡣ�˼������硰4-22����ֻժȡ-��ǰ�����֡�
					(setq pmid (cal "(p1+p2)/2"))
					;;��dp1,dp2ת��һ��angb
					(setq angb (angle p1 p2))
					(setq mdp1 (un:vecrot mdp1 angb))
					(setq mdp2 (un:vecrot mdp2 angb))
					(setq mqb1 (un:vecrot mdp1 pi))
					(setq mqb2 (un:vecrot mdp2 pi))
					(cond
						;;�õ��ϻ��µ����֣�������󣬱��ERROR
						((/= (setq ttl (ssget "c" (mapcar '+ pmid mdp1) (mapcar '+ pmid mdp2) '((-4 . "<OR")(0 . "TEXT")(0 . "MTEXT")(-4 . "OR>")))) nil) (setq midtext (cdr (assoc 1 (entget (ssname ttl 0))))))
						((/= (setq ttl (ssget "c" (mapcar '+ pmid mqb1) (mapcar '+ pmid mqb2) '((-4 . "<OR")(0 . "TEXT")(0 . "MTEXT")(-4 . "OR>")))) nil) (setq midtext (cdr (assoc 1 (entget (ssname ttl 0))))))
						(T (setq ttl nil) (setq midtext "error"))
					)
					(setq layers (cdr (assoc 8 el)))
					;;����Ҫ��ץȡ���긽����text
					(setq p11 (mapcar '+ p1 dp1))
					(setq p12 (mapcar '+ p1 dp2));���Կ�����Z����Ļ��ǲ��Ƕ������㡣
					;;�ýӴ�ѡ��ķ�ʽ�õ�����,�����εõ�����
					(setq ttl (ssget "c" p11 p12 '((-4 . "<OR")(0 . "TEXT")(0 . "MTEXT")(-4 . "OR>"))))
					(if (= nil ttl) (setq tti "error")
					(setq tti (cdr (assoc 1 (entget (ssname ttl 0))))))
					(setq p21 (mapcar '+ p2 dp1))
					(setq p22 (mapcar '+ p2 dp2))
					(setq ttl (ssget "c" p21 p22 '((-4 . "<OR")(0 . "TEXT")(0 . "MTEXT")(-4 . "OR>"))))
					(if (= nil ttl) (setq ttj "error") 
					(setq ttj (cdr (assoc 1 (entget (ssname ttl 0))))))
					;;�����ݴ�����������ļ�
					;;;��ȡ�˼������꣬�ڶ˸���ѡ��text/mtext�ı����洢Ϊnod1,nod2����ȡ�˼�����Ϣlayers,��ͼ����������ɫ�����ֲ㡣��nod1,nod2,layers�������ļ�

					;;��errorʱ����¼��tti,ttj,layers,midtext,p1,p2���԰����˹����ҳ�����˼���
					(if (or (= tti "error") (= ttj "error") (= midtext "error"))
						(write-line (strcat tti "," ttj "," layers "," midtext "," (vl-princ-to-string p1) "," (vl-princ-to-string p2)) outfile)
						(write-line (strcat tti "," ttj "," layers "," midtext) outfile )
					)
					(setq n (1+ n))
				)
			)

			(close outfile)			;�ر��ļ�
		)
		(princ "ѡ��Ϊ��")
	)


;;;״̬�ָ�
	(setvar "cecolor" oldcolor)		;�ָ���ʼ����
	(setvar "PLINETYPE" oldpltp)
	(setvar "osmode" oldosmode)
	(command)
	(command "_.undo" "b")		;�ص����ص㡣�����˾��޶���
	(command)
	(setvar "modemacro" "")		;���״̬
)
;;;������C:sph3s
;;;��ͼ�е�������ڵ�����NODEid��Ӧ���������޸ĺ���Ը�3D3S��ڵ���Ƶ��롣
(defun c:sph3s()
;;;״̬��ʼ��
	(setvar "modemacro" "=������ڵ���nodeID=")	;״̬����
	(command "_.undo" "m")		;���÷��ص�
	(command)
	(setvar "cmdecho" 0)			;��ʾ״̬����
	(setq oldcolor (getvar "cecolor"))	;��ǰ��ɫ״̬����
	(setvar "CECOLOR" "red")		;���ù�����ɫ
	(setq oldpltp (getvar "PLINETYPE"))	;PLINETYPEָ���Ƿ�ʹ���Ż��Ķ�ά����ߡ�ϵͳ����
	(setvar "PLINETYPE" 1)		;�򿪾�ͼ��ʱ��ת�����еĶ���ߣ�PLINE �����Ż��Ķ���� 
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

;;; ��ѡ���账������circle����ѡ��ssl,�ж�ѡ�񼯵ĺϷ���
	(princ "��ѡ����Ҫ�������ڵ�")
	(setq ssl (ssget '((0 . "CIRCLE"))))	
	(if (/= ssl nil)
		(progn
      ;;ѡ����ϣ����ļ������е���
			(setq fil_w (getfiled "��ָ��������ļ�" "e:\\" "csv" 1))
			(setq outfile (open fil_w "w"))
			(setq ssmax (sslength ssl))
			;;ָ����׼�㣬ȷ����ѡ������
			(command)
			(print "ȷ���������Ĺ�ϵ")
			(command)
			(setvar "osmode" 4)
			(setq basep (getpoint "ָ��Բ��"));basep��Z���겻һ��Ϊ0
			(setvar "osmode" 0)
			(setq dp1 (getpoint "���ַ�Χ�����ϵ�"));feature:����Ӧ��Ϊ��rec�����ο��á�
			(setq dp2 (getpoint "���ַ�Χ�����µ�"))
			(setq dp1 (mapcar '- dp1 basep));�ܼ�
			(setq dp2 (mapcar '- dp2 basep))
			(getstring "ѡ��������뽫���йؼ��ֶζ�������Ұ�ڣ�ENTER������")
;;;�����ȡssl�еĵ�Ԫ
			(while (< n ssmax)
				(progn
					(setq tti "");;ÿ����Ԫ���ֳ�ʼ��
					(setq ttj "")
					(setq layers "0")
					(setq elname (ssname ssl n))
					;(princ (entget elname))
					(setq el (entget elname))
					(setq Cp1 (cdr (assoc 10 el)))
					;;ץȡ���֣�
					(if (/= (setq ttla (ssget "c" (mapcar '+ Cp1 dp1) (mapcar '+ Cp1 dp2) '((-4 . "<AND")(0 . "TEXT")(8	 . "nodeid")(-4 . "AND>")))) nil) (setq nid (cdr (assoc 1 (entget (ssname ttla 0))))) (setq nid "error"))
					(if (/= (setq ttlb (ssget "c" (mapcar '+ Cp1 dp1) (mapcar '+ Cp1 dp2) '((-4 . "<AND")(0 . "TEXT")(8 . "sphty")(-4 . "AND>")))) nil) (setq sphtype (cdr (assoc 1 (entget (ssname ttlb 0))))) (setq sphtype "error"))
					;;�����ݴ�����������ļ�
					;;"nid��"�̶�",sphtype[,Cp1]"
					(if (or (= nid "error") (= sphtype "error"))
						(write-line (strcat  nid ",�̶�," sphtype "," (vl-princ-to-string Cp1)) outfile)
						(write-line (strcat nid ",�̶�," sphtype ) outfile )
					)
					(setq n (1+ n))
				)
			)

			(close outfile)			;�ر��ļ�
		)
		(princ "ѡ��Ϊ��")
	)
	(prin1 '"������ڵ�" ssmax)
	;;;״̬�ָ�
	(setvar "cecolor" oldcolor)		;�ָ���ʼ����
	(setvar "PLINETYPE" oldpltp)
	(setvar "osmode" oldosmode)
	(command)
	(command "_.undo" "b")		;�ص����ص㡣�����˾��޶���
	(command)
	(setvar "modemacro" "")		;���״̬��

)