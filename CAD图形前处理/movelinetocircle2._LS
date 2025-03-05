(defun c:moveLineToCircle (/ ss i ent entType circleList lineList intersectPoint nearestPoint)
  ;; 提示用户选择图形
  (if (setq ss (ssget '((0 . "CIRCLE,LINE")))) ; 只选择圆和直线
    (progn
      ;; 遍历选择集，筛选出圆和直线
      (setq i 0)
      (while (< i (sslength ss))
        (setq ent (ssname ss i))
        (setq entType (cdr (assoc 0 (entget ent))))
        (cond
          ((= entType "CIRCLE") ; 如果是圆，加入圆列表
           (setq circleList (cons ent circleList)))
          ((= entType "LINE") ; 如果是直线，加入直线列表
           (setq lineList (cons ent lineList)))
        )
        (setq i (1+ i))
      )
      
      ;; 对每个圆执行操作
      (foreach circle circleList
        ;; 获取圆的圆心和半径
        (setq circleData (entget circle))
        (setq center (cdr (assoc 10 circleData))) ; 圆心
        (setq radius (cdr (assoc 40 circleData))) ; 半径
        
        ;; 遍历直线列表，找到与圆相交的直线
        (foreach line lineList
          ;; 获取直线的起点和终点
          (setq lineData (entget line))
          (setq p1 (cdr (assoc 10 lineData))) ; 起点
          (setq p2 (cdr (assoc 11 lineData))); 终点
          ;; 计算直线与圆相交
          ;;(setq intersectPoints (intersectLineCircle p1 p2 center radius))
          (setq distStart (distance p1 center))
          (setq distEnd (distance p2 center))
          ;; 如果有交点，找到距离圆心最近的点
          (if (or (<= distStart radius) (<= distEnd radius))
	        (progn
              ;; 将离圆心最近的端点移动到圆心
              (if (< distStart distEnd)
                (entmod (subst (cons 10 center) (assoc 10 lineData) lineData)) ; 移动起点
                (entmod (subst (cons 11 center) (assoc 11 lineData) lineData)) ; 移动终点
                )  
             )
          )
        )
      )
    )
    (princ "\n未选择任何图形。")
  )
  (princ)
)

;;重写直线与圆相交判断.修改以上，通过构造一个函数判断直线是否相交，函数判断直线的两个端点与圆心的距离，如果存在一个端点距离圆心的距离小于等于半径，则认为相交


