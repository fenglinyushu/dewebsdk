## Button 按钮组件

### 一、功能
    用于按钮


### 二、基本使用
	1. 拖放一个TButton控件

	2. 基本属性
		(1) left/top/height/width/visible/enabled
		(2) Caption
		(3) Font
		(4) imageindex    		左侧图标，图标序号参见Source\ElementIcons
		(5) HotImageIndex 		右侧图标，图标序号参见Source\ElementIcons
		(6) ElevationRequired	设置属性为True时，单击一次后按钮即处于不可用状态，用于防止多次点击
		(7) Cancel				仅显示图标，Caption为空时，设置该项为True, 用于图标居中
		
		
	3. Hint扩展属性
		(1) type		字符串型，用于控制组件颜色样式，可选项有：primary/success/info/warning/danger/text
		(2) style		字符串型，用于控制组件外观样式，可选项有：plain/round/circle,可以多选，如{"style":"plain round"}
		(3) icon    	字符串型，用于控件组件左侧图标，图标名称请参见https://element.eleme.cn/#/zh-CN/component/icon
		(4) righticon   字符串型，用于控件组件右侧图标，图标名称请参见https://element.eleme.cn/#/zh-CN/component/icon
		
		//高级JS设置
		(5) onenter		字符串型，用于鼠标进入控件时，前端直接执行的JS代码。如{"onenter":"console.log('aaa');"}
		(5) onexit		字符串型，用于鼠标高开控件时，前端直接执行的JS代码。
		(5) onclick		字符串型，用于鼠标单击控件时，前端直接执行的JS代码。
		
		//高级css设置
		(98) dwstyle	字符串型，用于通过底层CSS控制组件样式，需要一定的CSS知识，如{"dwstyle":"border:solid 3px #0f0;"},详见dwstyle.md
		(99) dwattr		字符串型，用于通过底层CSS控制组件属性，需要一定的CSS知识，如{"dwattr":"plain round"},详见dwattr.md
	
	4. 事件
		(1) OnClick
		(2) OnEnter
		(3) OnExit
