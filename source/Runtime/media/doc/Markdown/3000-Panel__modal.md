**<font size=8>Panel（弹出式面板）</font>**


## 1 功能？
主要用于在当前Form使用过程中弹出一个面板(Panel)，类似弹出另一个Modal窗体

## 2 基本使用教程

### 2.1 使用要求

- Panel_Modal仅能在DeWeb平台上使用。
DeWeb网址：[https://www.delphibbs.com](https://www.delphibbs.com)

### 2.2 添加Panel
在DeWeb工程的Form中加入一个TPanel控件，
修改其HelpKeyword为Modal

### 2.3 显示
该Panel在Visible为True时将在全屏显示一个遮罩层的基础上显示Panel  
width,height,top同IDE中指定的数值
水平居中

### 2.4 控制 
通过改变Panel的Visible控制显示/隐藏

## 注
Panel显示时所有其他非该Panel及内部控件将不可用，所以需要在Panel中增加关闭代码

  




