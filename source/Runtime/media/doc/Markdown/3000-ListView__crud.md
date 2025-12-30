**<font size=8>ListView（数据库多功能版）</font>**


## 1 为什么要使用ListView（数据库多功能版）？
主要因为DBGrid在动态链接库（DLL）使用中容易造成内存泄漏，所以DeWeb推荐使用数据表格控件ListView（以下简称ListView_Crud）来显示数据。  
采用ListView_Crud，只需要放置一个ListView控件，简单的配置，就可能实现增加(create)、删除(delete)、编辑(update)和查询(read)等功能，还可以实现排序、分页等功能
## 2 功能

- 多字段模糊查询 
- 字段自动排序
- 自动分页
- 多表头
- 字段显示方式支持Check/序号/图片/Boolean/日期/进度条/按钮
- 支持多种汇总：平均值 /最大值/最小值
- 增加记录
- 删除记录/一次删除多条
- 编辑数据
- 多主题（待实现）
- 电脑/PC支持

## 3 基本使用教程

### 3.1 使用要求

- ListView_Crud仅能在DeWeb平台上使用。
DeWeb网址：[https://www.delphibbs.com](https://www.delphibbs.com)
- ListView_Crud目前仅支持FDQuery,其他控件陆续在后续开发中支持
- DeWeb开发需要基本掌握JSON数据格式，可参考[JSON教程（非常详细）](http://c.biancheng.net/json/)

### 3.2 添加ListView
在DeWeb工程的Form中加入一个TListView控件，
修改其HelpKeyword为crud

### 3.3 设置数据表查询
在Form中加入一个TFDQuery控件,Name为FDQuery1。
修改ListView控件的Hint为{"dataset":"FDQuery1"}

### 3.4 设置数据表字段
在ListView中添加Column,修改其Caption为
{"fieldname":"名称"}
其中"名称"为数据表的字段名称。
参考以上，添加多个Column

### 3.5 打开数据表查询
在Form的OnShow事件，添加代码如下
```pascal
procedure TForm1.FormShow(Sender: TObject);
begin
    FDQuery1.Close;
    FDQuery1.SQL.Text  := 'SELECT * FROM wms_Inventory';
    FDQuery1.Open;
end;
```
### 3.6 编译运行工程，即可显示数据表内容

## 4 Column(字段列)设置
Column(字段列)设置通过修改其Caption进行，应为JSON格式字符串。   

| 属性名称                   | 属性说明                 | 类型      | 默认值    | 可选项                                                         | 示例                                                                   |
|------------------------|----------------------|---------|--------|-------------------------------------------------------------|----------------------------------------------------------------------|
| type                   | 字段类型                 | 字符串     | string | string/check/index/boolean/image/progress/float/date/button | \{"type":"index"\}                                                   |
| fieldname              | 字段名称                 | 字符串     | 空      |                                                             | \{"fieldname":"username"\}                                           |
| list \(type为boolean时\) | 为显示和编辑时的选项           | 字符串数组   | 无      |                                                             | \{"type":"boolean","list":\["帅哥","美女"\]\}                            |
| list \(type为button时\)  | 为按钮的数量、标题和样式         | 字符串二维数组 | 无      |                                                             | \{"type":"button","list":\[\["编辑","primary"\],\["增加","success"\]\]\} |
| format \(type为float时\) | 为显示格式                | 字符串     | 无      |                                                             | \{"type":"float","format":"%f"\}                                     |
| format \(type为float时\) | 为显示格式                | 字符串     | 无      |                                                             | \{"type":"float","format":"%f"\}                                     |
| maxvalue               | 最大值，仅用于type为progress | 整型      | 100    |                                                             | \{"type":"progress","maxvalue":80\}                                  |
| maxvalue               | 最大值，仅用于type为progress | 整型      | 100    |                                                             | \{"type":"progress","maxvalue":80\}                                  |


Column(字段列)的Width属性即为显示列的宽度

## 5 进阶使用教程

### 5.1 移除模块
- 移除顶部栏（增加、删除、编辑、搜索）
在ListView的Hint中增加module属性（整型数组类型），置第0个值为0，类似 
{"dataset":"FDQuery1","module":[0,1,1,1,1,1]}

- 移除模块：增加、删除、编辑、搜索、分页
在ListView的Hint中增加module属性（整型数组类型），置对应的值为0，  
第1~5个值（序号从0开始，依序分别为：增加、删除、编辑、搜索、分页），类型  
{"dataset":"FDQuery1","module":[1,1,0,1,0,1]}  
上述为显示顶部栏、增加按钮、编辑按钮和分页，不显示删除按钮和搜索按钮  

### 5.2 设置
- 顶部栏高度、数据记录行高、顶部栏颜色等
|   属性        | Hint中Name    |  类型      |  默认值  |
|---------------|:-------------:|-----------:|---------:|
| 顶部栏高度    | topheight     | int        |      50  |
| 表头行高      | headerheight  | int        |      40  |
| 记录行高      | rowheight     | int        |      40  |
| 汇总行高      | summaryheight | int        |      40  |
| 分页每页数量  | pagesize      | int        |      10  |
| 表头背景色    | headbkcolor   | 颜色字符串 |'#f8f8f8' |
| hover行色     | hover         | 颜色字符串 |'#f5f5f5' |
| 记录行色      | record        | 颜色字符串 |'#e0f3ff' |

- 显示全表格线/只显示横线
通过设置ListView控件本身的Delphi属性BorderStyle 
bsSingle 表示为：显示全表格线
bsNone   表示为：只显示横线

### 5.3 多表头设置
- 多表头需要在Hint中设置merge（二维数组）属性 ，其中merge中的一个元素表示一个合并设置。如：  
{"merge":[[3,5,8,"基本信息"],[2,7,8,"通信地址"]]}
按格式展开显示如下：  
```json
{
    "merge":[
        [3,5,8,"基本信息"],
        [2,7,8,"通信地址"]
    ]
}
```
以上表示有2个合并项。  
第1个元素[3,5,8,"基本信息"]表示在3楼(示意图如下)合并，从第5列合并到第8列（从0开始），合并后标题为"基本信息"；  
第2个元素[2,7,8,"通信地址"]表示在2楼合并，从第7列合并到第8列（从0开始），合并后标题为"通信地址"  
最终效果如下  
![多表头示意图](./image/multiheader.jpg "多表头示意图")

### 5.4 汇总设置
通过控件的Hint中的summary属性设置  
summary属性为数组类型，如：  
{"summary":["汇总",[6,"sum","合计：%.0f"],[6,"avg","平均：%.0f"],[9,"max","最大：%.0f%%"],[9,"min","最小：%.0f%%"]]}
按格式展开显示如下：  
```json
{
  "summary": [
    "汇总",
    [6,"sum","合计：%.0f"],
    [6,"avg","平均：%.0f"],
    [9,"max","最大：%.0f%%"],
    [9,"min","最小：%.0f%%"]
  ]
}
```
说明如下  
第1项"汇总"为汇总栏的标题
后面每一项为一个汇总项，如：  
[6,"sum","合计：%.0f"]  
6 表示为第6列  
"sum" 表示为合计，类似可选 avg/min/max, 分别为:平均值/最小值/最大值/最小值  
"合计：%.0f" 为显示格式，参考Delphi的Format函数  




