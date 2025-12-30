# Deweb 入门说明

---
## 1. 系统要求
首先，确保你的开发环境满足以下要求：

操作系统：Windows 操作系统
开发工具：Delphi 10.4.2 / 11.3 / 12.1
推荐版本：Delphi 12.1 （Version 29.0.50491.5718）

## 2 下载安装包并解压
目前最新版本：DeWeb20250420.7z
链接: https://pan.baidu.com/s/1vIm8i2unvJ8vHAreORrGAw?pwd=x6g6 提取码: x6g6
  
或在QQ群(120283369)：http://qm.qq.com/cgi-bin/qm/qr?_wv=1027&k=j5K5ZQB9Y6xvkZbAH0fLMZ7nklVo7XCe&authKey=XGsEBBw%2F0hVqkqQbz5xqTwfuii6CjCPMfWz51O8taNqIFyN58nNX78Y6rXHekhKD&noverify=0&group_code=120283369  
共享文件夹"01 DeWeb安装包"中下载最新版

解压

## 3. 打开例程数据库（必须！）

运行LiteSQL2008\LiteSQL.exe  
![](media/doc/img/litesql.jpg)

如果不运行数据库服务，DeWeb服务运行时会报错。后续可以去除

## 4. 编译DeWeb支持组件
具体步骤如下
- 首先，打开source\dwVcls\AllVcls.groupproj 
- 然后，在右侧工程组上点右键，选“build all”  
![](media/doc/img/dwVcls.jpg)
如果未编译支持组件，可能在后续的 Web 应用时显示空白

## 5. 核对版本号（必须！ 容易出错）
DeWeb开发包source\runtime目录中有3个服务端文件：DeWebServer.exe,DeWebServer1042.exe和DeWebServer113.exe，
分别适用于使用Delphi 12.1 / Delphi 10.4.2 / Delphi 11.3的开发环境

如果当前开发工具为Delphi 12.1，可以跳过本步骤

如果当前开发工具为Delphi 10.4.2，需要
- 重命名 DeWebServer.exe 为 DeWebServer12.exe
- 重命名 DeWebServer1042.exe 为 DeWebServer.exe

如果当前开发工具为Delphi 11.3，需要
- 重命名 DeWebServer.exe 为 DeWebServer12.exe
- 重命名 DeWebServer113.exe 为 DeWebServer.exe


## 6. 安装 DeWeb 属性编辑输入助手 dwAssist
dwAssist可以帮助开发过程中编辑DeWeb所需的必要的属性（大多数情况下为Hint）,如下
![](media/doc/img/dwassist1.jpg)

安装步骤如下
- 打开source\dwAssist\dwAssist.dpk
- 在右侧工程组dwAssist.bpl上点右键，选“install”  
![](media/doc/img/dwassist.jpg)

## 7. 编译第一个简单的 DeWeb 应用: Hello
现在，让我们开始开发一个简单的 Web 应用。
- 打开source\demos\01 Hello入门必看\hello.dpr
- 编译。**注**： 用F9编译，不要用Ctrl+Shift+F9
- 然后，在自动启动的DeWebServer界面上， 双击hello
![](media/doc/img/dws.jpg)
- 系统会自动启动浏览器， 并显示如下
![](media/doc/img/hello.jpg)
**注**： 
- 如果出现浏览器仅转圈，不显示图像时，   
请更换浏览器为现代浏览器，如Chrome(谷歌公司出品)、Edge（微软公司出口）、FireFox(Mozilla开发的自由及开放源代码的网页浏览器)等  
国产浏览器请使用极速模式  
- DeWebServer点右上角X号时， 会自动缩小为任务栏图标，未实际退出。 
需要退出的话，可以点“退出”按钮后确认退出。
如果已缩小为任务栏图标，可在该图标上右键， 点Exit退出
或者，直接点Delphi中的Program Reset 按钮（Ctrl+F2）![](media/doc/img/reset.png)

## 8. 编译第一个简单的 数据库 应用: DBHello
- 打开source\demos\02 DBHello数据库基础\dbhello.dpr
- 编译。**注**： 用F9编译，不要用Ctrl+Shift+F9
- 然后，在自动启动的DeWebServer界面上， 双击dbhello
- 系统会自动启动浏览器， 并显示如下
![](media/doc/img/dbhello.jpg)
- 在浏览器上点击“下一项”或“上一项”按钮， 可以查看数据表中不同用户的Name

## 9. 编译第一个综合应用: DWMS - DeWeb 仓库管理系统
- 首先，打开source\demos\glogin通用登录\gLogin.dpr。
gLogin是一个通用的登录模块，需要预先编译
- 编译，在DeWebServer启动后，直接退出
- 然后，打开source\demos\DWMS仓库管理系统\DWMS.dpr。
- 编译，系统自动启动浏览器后，首先打开gLogin登录，直接确定
- 进入DWMS仓库管理系统界面，如下
![](media/doc/img/dwms.png)

