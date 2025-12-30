## TreeView__grid 树形表格组件

### 一、功能
	采用TreeView为基础，显示树形表格，支持单元格内插入多种组件


### 二、基本使用
	1. 拖放一个TTreeView控件，HelpKeyword设置为grid

	2. 控件属性
		(1) Items为正常树形结构
		(2) 每个节点的Text应为JSON数组，且符合Hint中columns的设定
		(3) Color为背景颜色 

	4. Hint属性
		(1) columns 为树形表格中各列设置，应为一多JSON对象的JSON数组，如
		```javascript
		{
			"columns": 
			[
				{
					"type": "label",
					"caption": "功能菜单",
					"width": 200
				},
				{
					"type": "check",
					"caption": "可用",
					"width": 60
				},
				{
					"type": "check",
					"caption": "编辑",
					"width": 60
				},
				{
					"type": "check",
					"caption": "导出",
					"width": 60
				},
				{
					"type": "check",
					"caption": "功能1",
					"width": 60
				},
				{
					"type": "check",
					"caption": "功能2",
					"width": 60
				},
				{
					"type": "buttongroup",
					"caption": "功能2",
					"count": 2,
					"width": 150,
					"items": 
					[
						[
							"全选",
							"success",
							60
						],
						[
							"全不选",
							"primary",
							60
						]
					]
				}
			]
		}
		```
		(2) 
		(3) 
		(4) 
		(5) 
	5. 事件
		(1) 表格中插入的按钮click事件自动激活当前TreeView的OnEndDock事件，
		其中：
			Target: TObject; 为当前节点，可用TTreeNode(Target)取得
			X : Integer; 为按钮所在列
			Y : Integer; 为当前按钮在当前列中的序号，从0开始
		(2) 表格中插入的多选框(CheckBox)的change事件自动激活当前TreeView的OnEndDock事件，
		其中：
			Target: TObject; 为当前节点，可用TTreeNode(Target)取得
			X : Integer; 为所在列
			Y : Integer; 为change后的值，未选中为0，选中为-1
			
