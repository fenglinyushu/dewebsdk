**<font size=6>Image</font>**

### 说明
图片显示控件  

### 基本属性
- left 
- top
- height
- width
- align
- AlignWithMargins
- Anchors
- Caption
- Enabled
- Font (如果在扩展属性中指定了颜色样式type,以扩展属性优先)
- IncrementalDisplay
  如果指定此项为True, 则点击可以查看图片，支持缩放、旋转
- Proportional 
  是否锁定纵横向比例 
- Stretch
  是否缩放
- Visible


### 扩展属性
| 属性名称            | 属性说明      | 类型    | 默认值 | 可选项                                 | 示例                                                 |
|-----------------|-----------|-------|-----|-------------------------------------|----------------------------------------------------|
| src             | 图片的源文件      | 字符串   | 无   |  | {"src":"media/images/logo.png"}   |
| href            | 图片点击响应的链接(新页面打开)     | 字符串   | 无   |      | {"href":"https://www.delphibbs.com"}                                |
| hrefself        | 图片点击响应的链接(当前页面打开)     | 字符串   | 无   |      | {"href":"https://www.delphibbs.com"}                                |
| radius          | 圆角设置      | 字符串   | 无   |                                     | \{"radius":"5px 5px 0px 0px"\} |

### 高阶属性
- dwstyle
用于通过html的行内式修改样式，此项添加到当前节点的style尾部，注意以分号结束。  
如：{"dwstyle":"border:solid 2px #0f0;"}
在Hint中设置此项后，将会为控件增加一个宽度2像素，绿色的边框  
注：请在熟悉CSS和相关web组件使用的基础上谨慎使用！  

- dwattr
用于通过html的行内式修改样式  
注：请在熟悉CSS和相关web组件使用的基础上谨慎使用！  

- onenter
可在前端直接执行一段javascript代码。  
{"onenter":"this.Button1__cap='enter';"}  
注意：此时不是执行Delphi中该Button的OnEnter的代码，此处代码需要符合javascript规范；  


- onclick
可在前端直接执行一段javascript代码。  
{"onclick":"this.Button1__cap='click';"}  
注意：此时不是执行Delphi中该Button的OnClick的代码，此处代码需要符合javascript规范；  


- onexit
可在前端直接执行一段javascript代码。  
{"onexit":"this.Button1__cap='exit';"}  
注意：此时不是执行Delphi中该Button的OnExit的代码，此处代码需要符合javascript规范；  



### 支持事件
- OnEnter
- OnClick
- OnExit


-end.

