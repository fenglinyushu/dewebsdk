## dwTListView__card 卡片式列表组件

### 一、功能
	采用ListView为基础，以卡片形式显示数据
	支持在卡片中显示image(图片)、button（按钮）、rate（徽标）、check（选中）、boolean（逻辑）、link（链接）、string（文本）等类型


### 二、基本使用
	1. 拖放一个TListView控件，HelpKeyword设置为card

	2. 基本属性
		(1) Visible
		(2) Enabled
		(3) Font
		(4) Left/Top/Width/Height
		(5) Color
		(6) HelpContext	每个卡片的高度，默认为0时，高度为140，不包含上下边距；如不为0，则为卡片高度
		
	
	3. Hint属性
        (1) cardattr 			字符串类型，卡片html中额外的attr设置，直接加入到类似以下xxx的位置，<div xxx style="">aaa</div>
		(2) cardstyle			字符串类型，卡片html中额外的style设置,直接加入到style="...;xxx"的最后xxx的位置，一般用于控制边框和背景颜色
		(3) module			    整型数组，如"module": [1,0,0,1,1], 每个子项分别表示是否显示增删改查移：0/1/2/3/4
		(4) type 				字符串类型，可选项为image/button/rate/check/boolean/link/string,其中string为默认，可不设置

		(5) 			
		(6) 
		(7) 
		(8) 
		(9) 
		
	4. TListColumn的Caption扩展的属性
		(1) 所有类型都支持的属性
			- left/top/width/height/right/bottom	整型，用于控制显示位置
			默认第一个元素的left为10，top为10；
			每个元素的默认高度为 Round(joColumn.fontsize*1.5)
			默认left为上一元素的left
			默认top为上一元素的top + 上一元素的height
			
			- dwattr 			字符串类型，额外的attr设置，直接加入到类似以下xxx的位置，<div xxx style="">aaa</div>
			- dwstyle			字符串类型，额外的style设置,直接加入到style="...;xxx"的最后xxx的位置，一般用于控制边框和背景颜色
			- fontname			字符串类型
			- fontsize			整型
			- fontcolor			字符串类型，如#00f
			- fontbold			字符串类型，normal/bold
			- fontitalic		字符串类型，normal/italic
			- fontdecoration	字符串类型，normal/overline/line-through/underline/blink
			
		(2) image
			- src				字符串变量，如"media/images/wmp/32/b0.png"
		(3) button
			- caption			字符串变量，如"系统处理"
		(4) boolean
			- list			    2个元素字符串数组，如"list":["未处理","已处理"]
		
	5. 事件
		(1) 点击时触发ListView的OnEndDrag事件，后2个参数分别为列序号和记录序号，0开始
		    如果当前记录序号发生改变（点击了另一元素），同时触发ListView的OnChange事件
			
