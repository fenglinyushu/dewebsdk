# 欢迎使用 `QuickCard` 移动端快速增删改查模块

### 1. 简要介绍

QuickCard是一款基于 [DeWeb](https://www.delphibbs.com)，为快速创建“增删改查”应的web功能模块；轻量且强大：支持智能模糊查询/多字段模糊查询、自动排序、自动分页等。

#### 演示案例

##### [QuickCard案例](https://www.delphibbs.com/QuickCard)

### 2. 使用入门

#### 2.1 DeWeb入门

请参看[DeWeb入门](https://www.delphibbs.com/doc#/)

#### 2.2 QuickCard入门

- （1）复制一个DeWeb的应用，建议hello；
- （2）删除Form1的全部控件和事件代码；
- （3）Form1中拖入TFDConnection和对应的FireDac支持控件  
       如果数据库是Access，则拖入TFDPhysMSAccessDriverLink；
       如果数据库是MSSQL， 则拖入TFDPhysMSSQLDriverLink；
       如果数据库是MySQL， 则拖入TFDPhysMySQLDriverLink；
	   ...
	   
- （4）在dpr工程文件代码dwLoad函数中增加指定数据库连接代码，如下//<....//>中部分

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
  //QuickCard 必须的变量
  qaConfig : string;
  ```
- （5）设置Form1的OnMouseUp事件代码如下（当浏览器切换大小时激活OnMouseUp事件）

```pascal
procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
    //设置当前为移动端模式
    dwSetMobileMode(Self,360,740);
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
    //取得QuickCard的配置，赋给qaConfig变量
    qaConfig    := StyleName;

    //自动创建QuickCard模块
    dwCard(self,FDConnection1,True,'');
end;
```

- （8）编译即可！


### 3. 高级配置

#### 3.1 配置字段

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

再编译已增加了字段goodscode

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

再编译已增加了字段的中文标题  

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

再编译已根据设置更新了各字段的显示宽度

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

再编译已根据设置更新了各字段的显示对齐方式

- 更改字段的类型，有string, auto, check, combo,combopair, dbcombo, integer,money, date, time, datetime等，默认为string

| 类型 | 说明 | 备注 |
| --- | --- | --- |
| string |字符串类型  |默认  |
| auto |自增类型  |新增和编辑时禁止修改  | 
| check | 选择类型 |  |
| combo | 列表选择类型 | 具体选项由当前节点的list数组决定 |
| combopair | 键值对列表选择类型 | 具体选项由当前节点的list数组决定，如[["家电类","0"],["五金类","1"],["生活类","2"],["服饰类","3"]] |
| dbcombo |数据库列表选择类型  | 具体选项由当前字段在数据表内值决定 |
| integer |整数类型 |  |
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
			"name": "goodsname",
			"caption": "货品名称",
			"width": 180,
			"fontsize":18,
			"fontbold":"bold"
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
			"width": 120,
			"fontname":"Georgia"
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

再编译已根据设置更新了各字段的类型

- 其他字段属性设置

| 属性 | 说明 | 示例 |备注 |
| --- | --- | --- |--- |
| must | 是否必填 | "must":1 | |
| readonly | 是否只读  | "readonly":1 | |
| query| 是否加入多字段查询  | "query":1 | |
| default| 新增时默认值  | "default":"华为" | |
| max | 最大值  | "max":999 |如果是date类型时，"max": "2025-12-31"，其他time/dateime时也类似处理 |
| min | 最小值  | "min":0 | |
| list | 选项值  | "list": ["","部","个","支"] | 仅当combo和combopair类型时有效|
| table | 数据表名称  | "table":"dw_role" |仅type为dbcombo时有效,默认为当前表名 |
| field | 字段名称  | "field":"rolename" |仅type为dbcombo时有效,默认为当前字段名 |
| left | 字段显示左边界  | "left":20 |第1个字段默认为10，其他字段默认为上一字段的left |
| right | 字段显示右边界  | "right":20 | |
| width | 字段显示宽度  | "width":120 |默认为100 |
| top | 字段显示上边界  | "top":20 |第1个字段默认为10，其他字段如果有left或right,则默认上一字段top, 否则默认为上一字段的top+上一字段的height |
| bottom | 字段显示下边界  | "bottom":20 | |
| height | 字段显示高度  | "height":30 | 默认为字体大小*1.5取整|
| fontname | 字体名称  | "fontname":"Georgia" | |



#### 3.2 配置数据表显示属性

| 属性 | 说明 | 示例 |备注 |
| --- | --- | --- |--- |
| table | 数据表名 | "table":"dw_member" |必填 |
| where | 数据表过滤条件  |"where":"id>10"  | 默认为空值|
| pagesize| 每页显示数据行数 |"pagesize":20  | 默认5|
| edit|是否可编辑  | "edit":1 |默认1 |
| new|是否可新增  | "new":0 |默认1 |
| delete|是否可删除  | "delete":0  |默认1 |
| print| 是否显示打印按钮 | "print":1 |默认1 |
| defaultquerymode|默认查询模式  | "defaultquerymode":1 |0：不显示，1：智能模糊查询；2：多字段查询。默认如果有单字段查询，则为模式2，否则为模式1 |
| switch| 是否显示切换查询模式按钮 | "switch":1 |默认1 |
| fields|当前拟显示的字段数组  |  |必须 |
| margin|默认各部分显示边距  | "margin":20 |默认10 |
| radius| 圆角半径  |"radius":2  | 默认5 |


### 4. 常见问题

### 5. 更新记录
2024-01-23 
	1. 开始写说明文档
