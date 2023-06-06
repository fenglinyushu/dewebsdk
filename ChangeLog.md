# 更新日志

## 2023-04-23

### 新增
* 开始写更新日志  

### 修复

* 从表新增后，再点主表新增，显示中间空白  
* 新增点OK后，报错，但可以新增记录。   
解决方案：通过post前加一行,解决 
```delphi
FDQuery1.FetchOptions.RecsSkip  := -1;
```

## 2023-04-22

### 修复

* dwTTimer.dpr的几处调试后未恢复的笔误

## 2023-04-21

### 新增
* 增加了TMemo__usescomp控件，以解决子窗体部分控件不能正常显示的bug

### 更新
* 修改了TForm控件，配合DWS更新, 解决子窗体upload后，激活主窗体的StartDock/EndDock事件的问题
  修改后激活对应窗体的 StartDock/EndDock事件的问题
* 更新了TCalendar控件，以显示日历 
