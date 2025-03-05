(defun c:MoveText (/ ss i ent entData color userColor offsetDist alignmentPt rotAngle newAlignmentPt)
  ;; 提示用户输入颜色编号
  (princ "\n常见颜色编号：")
  (princ "\n1: 红, 2: 黄, 3: 绿, 4: 青, 5: 蓝, 6: 洋红, 7: 白")
  (setq userColor (getint "\n请输入要筛选的文字颜色编号: "))
  (if (not userColor)
    (progn
      (princ "\n未输入颜色编号。")
      (exit)
    )
  )

  ;; 选择文字对象
  (setq ss (ssget '((0 . "TEXT")))) ; 只选择文字对象
  (if (not ss)
    (progn
      (princ "\n未选择任何文字对象。")
      (exit)
    )
  )

  ;; 提示用户输入偏移距离
  (setq offsetDist (getdist "\n请输入偏移距离: "))
  (if (not offsetDist)
    (progn
      (princ "\n未输入偏移距离。")
      (exit)
    )
  )

  ;; 遍历选择集
  (setq i 0)
  (repeat (sslength ss)
    (setq ent (ssname ss i)) ; 获取当前对象
    (setq entData (entget ent)) ; 获取对象属性数据

    ;; 检查颜色属性是否与用户输入的颜色编号匹配
    (setq color (cdr (assoc 62 entData)))
    (if (= color userColor) ; 严格匹配颜色
      (progn
        ;; 获取文字的对齐点和旋转角度
        (setq alignmentPt (cdr (assoc 11 entData))) ; TextAlignmentPoint
        (setq rotAngle (cdr (assoc 50 entData))) ; 旋转角度（弧度）

        ;; 如果对齐点不存在（左对齐），则使用插入点
        (if (not alignmentPt)
          (setq alignmentPt (cdr (assoc 10 entData))) ; InsertionPoint
        )

        ;; 计算移动方向（结合旋转角度）
        (setq moveDir (angle '(0 0 0) (list (cos rotAngle) (sin rotAngle)))) ; 移动方向向量
        (setq moveOffset (polar '(0 0 0) (+ rotAngle (* pi 1.5)) offsetDist)) ; 向下移动（旋转角度 + 270度）

        ;; 计算新的对齐点
        (setq newAlignmentPt (list (+ (car alignmentPt) (car moveOffset)) (+ (cadr alignmentPt) (cadr moveOffset)) (caddr alignmentPt)))

        ;; 更新文字的对齐点
        (if (assoc 11 entData) ; 如果存在对齐点
          (entmod (subst (cons 11 newAlignmentPt) (assoc 11 entData) entData)) ; 更新对齐点
          (entmod (subst (cons 10 newAlignmentPt) (assoc 10 entData) entData)) ; 否则更新插入点
        )
      )
    )
    (setq i (1+ i)) ; 移动到下一个对象
  )
  (princ "\n操作完成！")
  (princ)
)