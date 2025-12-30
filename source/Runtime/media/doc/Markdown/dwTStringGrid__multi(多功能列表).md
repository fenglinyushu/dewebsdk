多功能表格StringGrid__multi
一、功能
    增强版StringGrid，每列支持多种类型，
    包括:
        - button 按钮，支持多个按钮
		- check 选择框
		- combo 组合框
		- date 日期型
		- dateTime 日期时间型
		- edit 编辑框
		- image 图片（暂未实现）
		- label 标签，默认值
		- memo 多行文本框（暂未实现）
		- progress 进度条
		- spin 数字滚动框
		- switch 布尔框
		- time 时间型
	另外支持扩展类型
		- calc 计算型，根据其他列的值自动更新
        
	
二、使用    
   拖放一个TStringGrid,  设置的HelpKeyword为multi
   
三、在程序中设置各列的第一行数据，以设置各列参数
	例如：
	```delphi
        Cells[0,0]  :=
                '{'
                    +'"type":"check",'
                    +'"caption":"选择"'
                +'}';
        Cells[1,0]  :=
               '{'
                   +'"type":"label",'
                   +'"caption":"姓名"'
               +'}';
	```
	通用的属性有
	- type 列类型，默认为label,可选项见上
	- caption 列标题，默认为空
	
四、详细设置
	1. button
	必须包含一个items属性，
	该属性为二维数组，其子数组中至少3个元素，分别为：按钮标题、按钮主题和按钮宽度
	例如：
	```delphi
        Cells[iCol,0]  :=
                '{'
                    +'"type":"button",'
                    +'"caption":"操作",'
                    +'"items":[["增加","primary",40],["减少","success",40],["删除","danger",40]]'
                +'}';
	```
	
	2. check
	Cells中字符串为true时为真，不区分大小写；否则为假
	例如：
	```delphi
        Cells[iCol,0]  :=
                '{'
                    +'"type":"check",'
                    +'"caption":"选择"'
                +'}';
	```
	
	3. combo
	必须包含一个list属性，
	该属性为一维字符串数组
	例如：
	```delphi
        Cells[iCol,0]  :=
               '{'
                   +'"type":"combo",'
                   +'"caption":"角色",'
                   +'"list":["管理员","质管员","业务员"]'
               +'}';
	```
	
	4. date
	日期格式为yyyy-MM-DD
	例如：
	```delphi
        Cells[iCol,0]  :=
               '{'
                   +'"type":"date",'
                   +'"caption":"入职日期"'
               +'}';
	```
	
	5. datetime
	格式为yyyy-MM-DD hh:mm:ss
	例如：
	```delphi
        Cells[iCol,0]  :=
               '{'
                   +'"type":"datetime",'
                   +'"caption":"最后登录"'
               +'}';
	```
	
	6. edit
	例如：
	```delphi
        Cells[iCol,0]  :=
               '{'
                   +'"type":"edit",'
                   +'"caption":"职务"'
               +'}';
	```
	
	7. image 图片（暂未实现）
	例如：
	```delphi
	```
	
	8. label
	例如：
	```delphi
        Cells[iCol,0]  :=
               '{'
                   +'"type":"label",'
                   +'"caption":"姓名"'
               +'}';
	```
	
	9. memo 多行文本框（暂未实现）
	例如：
	```delphi
	```
	
	10. progress 进度条
	Cells中字符串应为整数
	例如：
	```delphi
        Cells[iCol,0]  :=
               '{'
                   +'"type":"process",'
                   +'"caption":"工程进度"'
               +'}';
	```
	
	11. spin 数字滚动框
	Cells中字符串应为整数
	例如：
	```delphi
        Cells[iCol,0]  :=
               '{'
                   +'"type":"spin",'
                   +'"caption":"年龄"'
               +'}';
	```
	
	12. switch 布尔框
	Cells中字符串为true时为真，不区分大小写；否则为假
	例如：
	```delphi
        Cells[iCol,0]  :=
               '{'
                   +'"type":"switch",'
                   +'"caption":"在岗"'
               +'}';
	```
	
	13. time 日期型
	格式为hh:mm:ss
	例如：
	```delphi
        Cells[iCol,0]  :=
               '{'
                   +'"type":"time",'
                   +'"caption":"时间"'
               +'}';
	```
	
	14. calc 计算型
	有以下属性
	(1) mode 计算类型，字符型，选项：* / +
	(2) column 参与计算的列序号，整数型数组
	(3) k 参与计算的各列的系数，浮点型数字数组
	(4) decimal 整数，结果小数位数，默认2，-1表示使用千分位显示
	例如：
	```delphi
        Cells[iCol,0]  :=
               '{'
                   +'"type":"calc",'
                   +'"mode":"*",'
                   +'"column":[10,11],'
                   +'"k":[1,1],'
                   +'"decimal":-1,' //-1表示使用format %n
                   +'"align":"right",'
                   +'"caption":"全年薪资"'
               +'}';
	```
	
五、事件
	1. 修改Cells值前激活OnEndDrag事件，X，Y分别表示列号和行号
	2. 修改Cells值后激活OnEndDock事件，X，Y分别表示列号和行号
