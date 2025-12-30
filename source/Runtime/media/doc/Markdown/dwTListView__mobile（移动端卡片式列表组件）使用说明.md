## ListView 移动端卡片式列表组件

### 一、功能
    用于以卡片方式显示数据，支持增删改查，上下移动等功能


### 二、基本使用
	1. 拖放一个TListView控件

	2. 基本属性
		(1) left/top/height/width/visible/enabled
		(2) Font 		显示的默认字体
		(3) HelpContext	单条记录的显示高度(不包含上下边距)
		
	3. Hint扩展属性
		(1) module		数字型数组，如{"module":[0,1,0,1,1]},用于控制是否支持增删改查以及移动
		(2) selected	颜色字符串型，为选中卡片的边框颜色，默认为#6A5ACD，如{"selected":"#dadce6"}

		//高级css设置
		(96) cardstyle	字符串型，用于通过底层CSS控制卡片的样式，需要一定的CSS知识，如{"cardstyle":"border:solid 3px #0f0;"},详见dwstyle.md
		(97) cardattr	字符串型，用于通过底层CSS控制卡片的属性，需要一定的CSS知识，如{"cardattr":"plain round"},详见dwattr.md
		(98) dwstyle	字符串型，用于通过底层CSS控制组件样式，需要一定的CSS知识，如{"dwstyle":"border:solid 3px #0f0;"},详见dwstyle.md
		(99) dwattr		字符串型，用于通过底层CSS控制组件属性，需要一定的CSS知识，如{"dwattr":"plain round"},详见dwattr.md
	
	3. TListColumn的基本属性
		(1) Alignment	左/中/右对齐模式	
		(2) width  		宽度,如果下面TListColumn.Caption扩展属性指定了width, 则以扩展属性为准
		(3) 

	4. TListColumn.Caption扩展属性
		(1) type		字符串型，可选项有：image/combo/button/rate/integer/boolean/label, 默认为label, 如 {"type":"image"}
		(2) left   		数字型,为当前数据在卡片中显示的左边距,如果为第1个数据,则默认为10;否则,默认为上一数据的left
		(3) top			数字型,为当前数据在卡片中显示的顶边距,如果为第1个数据,则默认为10;否则,默认为上一数据的top+上一数据的height
		(4) right  		数字型,为当前数据在卡片中显示的右边距
		(5) bottom		数字型,为当前数据在卡片中显示的底边距
		(6) width  		数字型,为当前数据在卡片中显示的宽度
		(7) height		数字型,为当前数据在卡片中显示的高度
		(8) scale		浮点型,仅用于数据为rate数据缩放使用
		(9) fontname	字符串型,字体名称
		(10)fontsize	数字型,字体大小
		(11)fontcolor	颜色字符串型，字体颜色,如{"fontcolor":"#0000ff"}, 默认为ListView的字体颜色
		(12)fontbold	字符串型,字体粗体,可选项有:normal/bold/lighter/bolder等,默认为normal
		(13)fontitalic	字符串型,字体斜体,可选项有:normal/italic/oblique等,默认为normal
		(14)fontdecoration	字符串型,字体装饰,可选项有:underline/underline dotted/green wavy underline/underline overline #FF3028/none/unset等,默认为none	
		(15)min			数字型,最小值,仅用于type为integer类型
		(16)max			数字型,最大值,仅用于type为integer类型
		(17)list		字符串数组,仅用于type为boolean/combo类型


	5. 事件
		(1) OnClick
		(2) OnEnter
		(3) OnExit
		
### 三、修订记录
