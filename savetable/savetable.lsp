(prin1 "������bgdc")

(defun c:bgdc (/	   oldcolor    oldpltp	   dist	 pt    e1    e2
	     n	   fil_w x     str   nf	   st	 l     e     m
	     p1	   p2	 ttl   tt    ptx   pty
	    )
  (setvar "modemacro" "=��񵼳���=");״̬����
  (command "_.undo" "m");���÷��ص�
  (command)
  (setvar "cmdecho" 0);��ʾ״̬����
  (setq n 0)
  (setq oldcolor (getvar "cecolor"));��ǰ��ɫ״̬����
  (setvar "CECOLOR" "red");���ù�����ɫ
  (setq oldpltp (getvar "PLINETYPE"));PLINETYPEָ���Ƿ�ʹ���Ż��Ķ�ά����ߡ�ϵͳ����
  (setvar "PLINETYPE" 1);�򿪾�ͼ��ʱ��ת�����еĶ���ߣ�PLINE �����Ż��Ķ���� 
  (setq e1 nil)
  (setq ss (ssadd));�߽����ssadd ����ѡ��
  (setq sh (ssadd));���������
  (setvar "osmode" 32);ϵͳ����������ִ�ж���׽��32�����㡣15λ2���ƿ���
  (initget 0 "Up Down Left Right");ָ����������getxx��������ѡ�
  (princ "���ʹ��˵������Ԫ��߶�Ӧһ�£�������ܳ���\n")
  (setq fx (getkword "ȷ�������������Up/Down/<Down>:"))
					;(setq dist (getdist"\n>>**********>>�����м��:")) 
  (setvar "osmode" 0);�رղ�׽
  (command);���У�����autocad������ȷ��Ч����
  (print
    '>>**********>>ע�⽫�򿪵�д���ļ��رգ�������ļ���������;��������ʾ
  )
  (while (setq pt (getpoint "\n>>**********>>���ѡ��ؼ��ֶ�:"));ͨ����ѡ���ڵ㣬ȷ��������ǰ�ڹر��˲�׽���Ժܷ����ִ�д˶�����
    (command "_.boundary" "a" "i" "n" "" "" pt "");�൱��'-boundary' a(�߼�ѡ��) i(�µ����) n(NO) ����������Ĭ�ϣ�pt(ѡ�ĵ�) ,���� ��boundary������һ����յĶ���ߡ�
    (command)
    (if	(= (cdr (assoc 0 (entget (entlast)))) "LWPOLYLINE");�ж������ѡ��Ԫ��"LWPOLYLINE",��ȡ.����ȡ�˸ոս�����boundary�����
      (setq e2 (entlast))
      (setq e2 e1)
    )
					;(command "_.pedit" e2 "w" 1 "") 
    (command)
    (if	(/= e2 e1)
      (progn
	(setq ss (ssadd e2 ss));add e2 to ssѡ��
	(setq e1 e2);����ǰѡ����
	(command "_.hatch" "s" e1 "");��䣬sѡ�����
	(command)
	(setq sh (ssadd (entlast) sh));������ɵ������ѡ��sh
	(redraw e2 2);�ػ�
	(setq n (+ n 1));����
	(print '>>*****>>��ѡ�ֶ���:)
	(prin1 n)
      )
      (print '>>**********>>��ѡ�ֶ���Ч!!!)
    )
  )
  (getstring "ѡ��������뽫���йؼ��ֶζ�������Ұ�ڣ�ENTER������") 
  (setq fil_w (getfiled "��ָ��������ļ�" "e:\\" "csv" 1))
  (setq x (open fil_w "w"))
  (setq str "1");�����ж�
  (setq nf 0)
  (while (/= str "");�����߼����ڷǿ�����Ϣ�£���ѡ��˳��һ����ȡTEXT��MTEXT��Ϣ����Ϊһ�У�д���ļ�����ѡ������һ���иߡ�ÿ�ζ��ж��иߣ����и߿ɲ�ͬ����һ��Ӧͳһ��
    (setq str "")
    (setq st "")
    (setq l 0)
    (while (/= l n)
      (if (setq e (ssname ss l));������ȡѡ��SS�е�ͼԪ����e
	(progn
;|
	  (setq m 4)
	  (setq p1 (reverse (entget e)));�õ�ͼԪ������Ϣ��������.������Ϊ�˱�֤ȡ������Ϣ�ǵ������Ϣ�ڵġ�
	  (while (> m 0)
	    (setq p1 (cdr p1))
	    (setq m (- m 1))
	  )
	  (setq p1 (cdar p1))
	  (setq m 12)
	  (setq p2 (reverse (entget e)))
	  (while (> m 0);ȥ��ǰ4��������cddddr������
	    (setq p2 (cdr p2))
	    (setq m (- m 1))
	  )
	  (setq p2 (cdar p2));��ȡ��5��
|;
	  (setq e (entget e))
	  (setq p1 (cdr (assoc 10 e)));��ȡ�����
	  (setq e (cdr (member (assoc 10 e) e)));��ȡ��������
;|
	  (while (or (= (cadr (assoc 10 e)) (car p1)) (= (caddr (assoc 10 e)) (cadr p1)))
	     (setq e (cdr (member (assoc 10 e) e)))
	  )
|;
          (setq e (cdr (member (assoc 10 e ) e)))
	  (setq p2 (cdr (assoc 10 e)));��ȡ�����
	 
	 ; (command "_zoom" "w" (mapcar '+ p1 '(100 100)) (mapcar '+ p2 '(-100 -100)))
	  ;(command)
	  
	  (redraw)
	  (if (or (setq ttl (ssget "w" (mapcar '+ p1 '(50 50)) (mapcar '+ p2 '(-50 -50)) '((0 . "text"))));ѡ�������ڣ�text��Ԫ�أ�������
		  (setq ttl (ssget "w" (mapcar '+ p1 '(50 50)) (mapcar '+ p2 '(-50 -50)) '((0 . "mtext"))))
	      )
	    (progn
	      (setq tt (cdr (assoc 1 (entget (ssname ttl 0)))));��ȡ����
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
    (write-line st x);д�����ļ�
    (setq ptx (car p1))
    (setq pty (cadr p1))
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
  (close x);�ر��ļ�
  (setvar "cecolor" oldcolor);�ָ���ʼ����
  (setvar "PLINETYPE" oldpltp)
  (command)
  (command "_.undo" "b");�ص����ص㡣�����˾��޶���
  (command)
  (print '>>**********>>��������ֶ���:)
  (prin1 n)
  (print '>>**********>>�����������:)
  (princ (itoa (- nf 1)))
  (prin1)
  (setvar "modemacro" "");���״̬
)