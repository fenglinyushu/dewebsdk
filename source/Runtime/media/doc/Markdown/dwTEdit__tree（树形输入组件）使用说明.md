## Edit__tree 树形表格组件

### 一、功能
	采用Edit为基础，显示树形节点供选择


### 二、基本使用
	1. 拖放一个TEdit控件，HelpKeyword设置为tree

	2. Hint属性
        (1) multipe 			整型，是否支持多选，1表示支持多选，其它不支持
		(2) clearable			整型，是否显示清除按钮，1为true
		(3) searchable			整型，是否支持搜索，1为true
		(4) openonclick 		整型，是否click时打开，1为true
		(5) openonfocus			整型，是否获取焦点时打开，1为true
		(6) clearonselect		整型，是否选择时清除，1为true
		(7) closeonselect		整型，是否选择时关闭，1为true
		(8) alwaysopen			整型，是否选择时关闭，1为true
		(9) appendtobody		整型，是否追加到body，1为true
		(10) limit				整型，限制数量
		(11) maxheight			整型，最大高度
		(12) disablebranchnodes	整型，是否支持选择有子节点的节点
		(13) options			字符串类型，如：[{id:'a',label:'a',children:[{id:'aa',label:'aa'}, {id:'ab',label:'ab'}]}, {id:'b',label:'b'}]
		
	3. 事件
			
