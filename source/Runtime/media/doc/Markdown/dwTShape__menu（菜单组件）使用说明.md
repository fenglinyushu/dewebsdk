## 菜单组件 Shape__menu

### 一、功能
	用于和TMainMenu配合，实现在网页中显示菜单
	主要解决仅原TMainMenu的DeWeb控件的2个问题：
	1. TMainMenu控件没有Left/Top/Width/Height属性, 界面不能占位，每次设置界面非常麻烦
	2. TMainMenu控件没有Hint属性，不能进行属性扩展


### 二、基本使用
	1. 拖放一个TMainMenu控件，HelpKeyword设置为xxx

	2. 拖放一个TShape控件， 设置HelpKeyword为menu
		Hint 中设置menu为上面TMainMenu的Name,
		如 {"menu":"MainMenu2"}
		如果TMainMenu控件的名称为MainMenu1, 则上述不用设置

	3. TShape控件属性
		(1) Brush.Color为菜单背景色
		(2) Pen.Color为菜单正常状态下字体颜色 
		(3) Height>=100 时垂直显示菜单，否则，水平显示
		(4) ShowHint 为True时合拢，反之为展开状态

	4. TShape控件Hint属性
		(1) menu 为指定对应的TMainMenu控件Name
		(2) activetextcolor 为菜单项激活状态时的字体颜色，默认为#ffd04b
		(3) dwloading 有此项，则点击菜单时自动显示进度条。需要在打开菜单项后增加代码关闭
		(4) activebkcolor 激活菜单菜单背景色，默认为#333A40（不可动态更新）
		(5) hovercolor Hover时颜色，默认为#434A50（不可动态更新）

	5. TMainMenu控件Hint属性
	
	6. TMenuItem控件Hint属性
		(1) indent 可以控制菜单项的缩进，如{"indent":10}
