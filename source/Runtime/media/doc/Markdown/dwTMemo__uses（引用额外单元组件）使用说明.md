## Memo__uses 引用额外单元组件

### 一、功能
    该控件仅用于引用额外的JS/css，类似在生成的HTML中的增加以下引用：
    <script src="dist/axios.min.js" type="text/javascript"></script>
    <link rel="stylesheet" type="text/css" href="dist/theme-chalk/index.css" />
    <script src="dist/_easyplayer/EasyPlayer-element.min.js"></script>


### 二、基本使用
	1. 拖放一个TMemo控件，HelpKeyword设置为uses

	2. 基本属性
		(1) 设置ScrollBars为ssBoth，注意：必须设置！ 否则可能报错
		(2) 打开Lines， 在编辑框内输入拟引用的JS/css
		
	3. 事件
		无	
