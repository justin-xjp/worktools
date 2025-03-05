# 准备模板文件
template = """
工程名称：{project_name}
设计单位：{design_unit}
建筑面积：{area}
地上层数：{floor_num}
地下层数：{underground_num}
结构类型：{structure_type}
抗震烈度：{seismic_intensity} """
# 读取模板文件
with open("template.txt", "r",encoding='utf-8') as f:
         template = f.read()
         # 替换占位符
         project_name = "A栋"
         design_unit = "甲级设计院"
         area = "10000平方米"
         floor_num = 22.2222
         underground_num = "2层"
         structure_type = "钢筋混凝土结构"
         seismic_intensity = "烈度6度"
         result = template.format(project_name=project_name, design_unit=design_unit, area=area, floor_num=floor_num, underground_num=underground_num, structure_type=structure_type, seismic_intensity=seismic_intensity)
# 生成计算书
with open("calculation_book.txt", "w") as f:
         f.write(result)