## TrackBar__mobile 移动端适用的分页组件

### 一、功能
	采用TrackBar为基础，显示分页栏
	共9个按钮，分别为 < 1 ... 7 8 9 ... 15 > 等距分布


### 二、基本使用
	1. 拖放一个TTrackBar控件，HelpKeyword设置为mobile

	2. 控件属性
		(1) Position	为当前页码，从0开始
		(2) PageSize 	为每页显示记录数
		(3) Max  		为总记录数
	
	3. Hint属性
        (1) background 			web颜色字符串，如"#fafafa",默认为透明色
        (2) color 				web颜色字符串，如"#000",默认为#969696
		(3) padding				整型，按钮组的左右间距，最左边按钮的左边距和最右边按钮的右边距
		
	3. 事件
		(1) OnChange
			
