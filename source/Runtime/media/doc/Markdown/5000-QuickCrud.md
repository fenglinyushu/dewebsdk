# 欢迎使用 `QuickCrud` 快速增删改查模块

### 1. 简要介绍

QuickCrud是一款基于 [DeWeb](https://www.delphibbs.com)，为快速创建“增删改查”应的web功能模块；轻量且强大：支持一主多从、水平/垂直布局、智能模糊查询/多字段模糊查询、自动排序、自动分页、打印、导出Excel、自定义按钮等。

#### 演示案例

##### [QuickCrud入门案例](https://www.delphibbs.com/quickcrudhello)

##### [QuickCrud主表案例](https://www.delphibbs.com/quickcrudmaster)

##### [QuickCrud一主三从案例](https://www.delphibbs.com/quickcrud)

##### [QuickCrud主从水平排列案例](https://www.delphibbs.com/quickcrudhorz)

### 2. 使用入门

#### 2.1 DeWeb入门

请参看[DeWeb入门](https://www.delphibbs.com/doc#/)

#### 2.2 QuickCrud入门

- （1）复制一个DeWeb的应用，建议hello；
- （2）删除Form1的全部控件和事件代码；
- （3）在dpr工程文件代码dwLoad函数中增加指定数据库连接代码，如下//<....//>中部分

```delphi
function dwLoad(AParams:String;
	AConnection:Pointer;
	AApp:TApplication;
	AScreen:TScreen):
	TForm;stdcall;
begin
    //
    Application := AApp;
    Screen      := AScreen;
    //

    //
    Form1       := TForm1.Create(nil);

    //<------以下用于为窗体中的FDConnection1指定数据库连接----------------------
    //需要uses引用 dwBase, 注意在sharemem后面.  下面有2种方法,可选用一种
    //根据 id (序号，0开始) 获取数据库连接
    Form1.FDConnection1.SharedCliHandle   := dwGetCliHandleByID(AParams,0);

    //根据 Name (不区分大小写) 获取数据库连接
    //Form1.FDConnection1.SharedCliHandle   := dwGetCliHandleByName(AParams,'dwAccess');
    //>-------------------------------------------------------------------------


    Result      := Form1;
end;
```

- （4）在Form1的public中增加变量
  
  ```delphi
  //QuickCrud 必须的变量
  qcConfig : string;
  ```
- （5）设置Form1的OnMouseUp事件代码如下

```pascal
procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
    //设置当前为PC(电脑端)模式
    dwSetPCMode(Self);
end;
```

- （6）修改Form1的StyleName为如下的[JSON](https://juejin.cn/post/6906710287781494797)格式字符串
  注意：双引号、冒号、方括号、花括号和逗号必须为半角

```json
{
	"table": "dwf_goods",
	"fields": 
	[
		{
			"name": "id",
			"type": "auto"
		},
		{
			"name": "goodsname"
		}
	]
}
````

其中：
table 表示 当前数据库的表名称；
fields 表示 当前数据表拟显示的字段数组
name 表示 当前数据表拟显示字段的字段名称
type 表示 当前数据表拟显示字段的字段类型，后面有详细说明

- （7）设置Form1的OnShow事件代码为

```
procedure TForm1.FormShow(Sender: TObject);
begin
    //取得QuickCrud的配置，赋给qcConfig变量
    qcConfig    := StyleName;

    //自动创建CRUD模块
    dwCrud(self,FDConnection1,False,'');
end;
```

- （8）编译即可！

效果图如：

![QuickCrudHello效果图](../../image/doc/quickcrud1.jpg "QuickCrudHello")

以上全部代码请参考[QuickCrudHello](https://www.delphibbs.com/download/source/quickcrudhello.zip)

### 3. 高级配置

#### 3.1 配置主表字段

- 增加主表字段可以通过编辑StyleName属性

```
{
	"table": "dwf_goods",
	"fields": 
	[
		{
			"name": "id",
			"type": "auto"
		},
		{
			"name": "goodsname"
		},
		{
			"name": "goodscode"
		}
	]
}
```

再编译已增加了字段goodscode，效果图如：

![QuickCrud增加字段效果图](../../image/doc/quickcrud2.jpg "QuickCrudHello")

- 修改字段显示标题，可以通过修改StyleName属性的fields中各子节点的caption值，如下

```
{
	"table": "dwf_goods",
	"fields": 
	[
		{
			"name": "id",
			"type": "auto"
		},
		{
			"name": "goodsname",
			"caption": "货品名称"
		},
		{
			"name": "goodscode",
			"caption": "编码"
		}
	]
}
```

再编译已增加了字段的中文标题，效果图如：

![QuickCrud增加标题效果图](../../image/doc/quickcrud3.jpg "QuickCrud Field Caption")

- 更改字段显示宽度（默认120像素），可以通过修改StyleName属性的fields中各子节点的width值，如下

```
{
	"table": "dwf_goods",
	"fields": 
	[
		{
			"name": "id",
			"type": "auto",
            "width":80
		},
		{
			"name": "goodsname",
			"caption": "货品名称",
            "width":200
		},
		{
			"name": "goodscode",
			"caption": "编码",
            "width":150
		}
	]
}
```

再编译已根据设置更新了各字段的显示宽度，效果图如：

![QuickCrud增加标题效果图](../../image/doc/quickcrud4.jpg "QuickCrud Field Width")

- 更改字段的对齐方式（默认居中显示），可以通过修改StyleName属性的fields中各子节点的align值，如下

```
{
	"table": "dwf_goods",
	"fields": 
	[
		{
			"name": "id",
			"type": "auto",
			"width": 80
		},
		{
			"name": "goodsname",
			"caption": "货品名称",
            		"align":"left",
			"width": 200
		},
		{
			"name": "goodscode",
			"caption": "编码",
            		"align":"right",
			"width": 150
		}
	]
}
```

再编译已根据设置更新了各字段的显示对齐方式，效果图如：

![QuickCrud 字段对齐方式效果图](../../image/doc/quickcrud5.jpg "QuickCrud Field Align")

- 更改字段的类型，有string, auto, integer, combo, dbcombo, money, date, time, datetime等，默认为string

| 类型 | 说明 | 备注 |
| --- | --- | --- |
| string |字符串类型  |默认  |
| auto |自增类型  |新增和编辑时禁止修改  | 
| integer |整数类型 |  |
| combo | 列表选择类型 | 具体选项由当前节点的list数组决定 |
| dbcombo |数据库列表选择类型  | 具体选项由当前字段在数据表内值决定 |
| money |金额类型  |显示时自动保留2位小数，千分位显示  |
| date | 日期型 | 格式：yyyy-MM-dd |
| time | 时间型 | 格式：hh:mm:ss |
| datetime | 日期时间型 | 格式：yyyy-MM-dd hh:mm:ss |

可以通过修改StyleName属性的fields中各子节点的type值，如下

```
{
	"table": "dwf_goods",
	"fields": 
	[
		{
			"name": "id",
			"caption": "id",
			"width": 50,
			"align": "center",
			"type": "auto"
		},
		{
			"name": "goodsname",
			"caption": "货品名称",
			"width": 180
		},
		{
			"name": "goodscode",
			"caption": "编码",
			"width": 100
		},
		{
			"name": "provider",
			"caption": "供应商",
			"type": "dbcombo",
			"width": 160
		},
		{
			"name": "spec",
			"caption": "规格",
			"width": 120
		},
		{
			"name": "unit",
			"type": "combo",
			"caption": "单位",
			"list": 
			[
				"",
				"部",
				"个",
				"支",
				"台",
				"米",
				"辆",
				"套"
			],
			"width": 60
		},
		{
			"name": "inprice",
			"caption": "进价",
			"width": 80,
			"align": "right",
			"type": "money"
		},
		{
			"name": "price",
			"caption": "售价",
			"width": 80,
			"type": "money",
			"align": "right"
		},
		{
			"name": "updatetime",
			"caption": "生产日期",
			"width": 120,
			"type": "date"
		},
		{
			"name": "description",
			"caption": "备注",
			"width": 120
		}
	]
}
```

再编译已根据设置更新了各字段的类型，效果图如：

![QuickCrud 字段类型效果图](../../image/doc/quickcrud6.jpg "QuickCrud Field Type")

- 其他字段属性设置

| 属性 | 说明 | 示例 |备注 |
| --- | --- | --- |--- |
| must | 是否必填 | "must":1 | |
| readonly | 是否只读  | "readonly":1 | |
| sort | 是否排序  | "sort":1 | |
| query| 是否加入多字段查询  | "query":1 | |
| default| 新增时默认值  | "default":"华为" | |
| max | 最大值  | "max":999 |如果是date类型时，"max": "2025-12-31"，其他time/dateime时也类似处理 |
| min | 最小值  | "min":0 | |
| list | 选项值  | "list": ["","部","个","支"] | 仅当combo类型时有效|

#### 3.2 配置主表显示属性

| 属性 | 说明 | 示例 |备注 |
| --- | --- | --- |--- |
| table | 数据表名 | "table":"dw_member" |必填 |
| where | 数据表过滤条件  |"where":"id>10"  | 默认为空值|
| pagesize| 每页显示数据行数 |"pagesize":20  | 默认5|
| rowheight | 数据行高度  |"rowheight":35  |45 |
| edit|是否可编辑  | "edit":1 |默认1 |
| new|是否可新增  | "new":0 |默认1 |
| delete|是否可删除  | "delete":0  |默认1 |
| print| 是否显示打印按钮 | "print":1 |默认1 |
| defaultquerymode|默认查询面板样式  | "defaultquerymode":1 |0：不显示，1：智能模糊查询；2：多字段查询。默认如果有单字段查询，则为模式2，否则为模式1 |
| hide|是否显示“隐藏”按钮  |"hide":0  |仅主从表显示时有效 |
| fields|当前拟显示的字段数组  |  |必须 |
| margin|默认各部分显示边距  | "margin":20 |默认10 |
| radius| 圆角半径  |"radius":2  | 默认5 |
| editwidth|编辑/新增面板的宽度  |"editwidth":600  |默认360 |
| defaulteditmax| 编辑/新增时是否默认最大显示 |"defaulteditmax":1  |默认0 |
| datawidth| 编辑/新增时每字段宽度 |"datawidth":400  |默认320 |
| buttoncaption| 是否显示功能按钮标题 | "buttoncaption":2 |0:全不显示,1:全显示;2:部分显示 |
| slavepagesize| 从表每页显示数据行数 |"slavepagesize":10  |默认5,仅主从表时有效 |
| slaverowheight| 从表数据行高度 |"slaverowheight":40  |默认45,仅主从表时有效 |
| mainwidth| 主表显示宽度 |"mainwidth":700  |如果为主从表,且有此属性,则主从表水平排列,否则垂直排列 |

#### 3.3 配置主从表

##### 3.3.1 基本配置

- 先添加slave数组节点
- 在slave数组中添加若干个从表子节点,结构和主表基本相似
- 从表的特别设置(主表有的不再描述)
  | 属性 | 说明 | 示例 |备注 |
| --- | --- | --- |--- |
| caption|当前从表页面标题 |"caption" : "销售记录" |必须 |
| imgeindex|当前从表页面图标 |"imageindex" : 60 |见https://element.eleme.cn/#/zh-CN/component/icon |
|masterfield |当前从表对应的主表字段 |"masterfield" : "id" | |
|slavefield | 当前与主表字段对应的字段| "slavefield" : "gid"| |
基本配置文件如下:
  
  

```
{
   "table" : "dwf_goods",
   "fields" : [
      {
         "name" : "id",
         "caption" : "id",
         "width" : 50,
         "align" : "center",
         "type" : "auto"
      },
      {
         "name" : "goodsname",
         "caption" : "货品名称",
         "width" : 180,
         "type" : "string",
         "must" : 1,
         "query" : 1,
         "sort" : 1,
         "default" : "未命名"
      },
      {
         "name" : "description",
         "caption" : "备注",
         "width" : 150
      }
   ],
   "slave" : [
      {
         "caption" : "详细参数",
         "table" : "dwf_goodsex",
         "imageindex" : 58,
         "masterfield" : "id",
         "slavefield" : "gid",
         "fields" : [
            {
               "name" : "id",
               "caption" : "id",
               "width" : 80,
               "align" : "center",
               "sort" : 1,
               "type" : "auto"
            },
            {
               "name" : "gid",
               "caption" : "货品ID",
               "align" : "left",
               "must" : 1,
               "query" : 1,
               "type" : "integer",
               "width" : 80
            },
            {
               "name" : "title",
               "caption" : "属性名称",
               "must" : 1,
               "width" : 120,
               "query" : 1,
               "default" : "新属性"
            },
            {
               "name" : "value",
               "caption" : "属性值",
               "readonly" : 1,
               "query" : 1,
               "width" : 180,
               "default" : "新值",
               "must" : 1
            }
         ]
      },
      {
         "caption" : "销售记录",
         "table" : "dwf_outport",
         "imageindex" : 60,
         "masterfield" : "id",
         "slavefield" : "gid",
         "fields" : [
            {
               "name" : "id",
               "caption" : "id",
               "width" : 50,
               "align" : "center",
               "type" : "auto"
            },
            {
               "name" : "gid",
               "caption" : "货品ID",
               "type" : "integer",
               "width" : 80
            },
            {
               "name" : "operator",
               "caption" : "经办人",
               "query" : 1,
               "width" : 120,
               "must" : 1
            }
         ]
      }
   ]
}
```

### 4. 常见问题

### 5. 更新记录

最新更新于 2023.07.09