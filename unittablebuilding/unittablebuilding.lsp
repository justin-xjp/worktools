;;;������C:unitbd,
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