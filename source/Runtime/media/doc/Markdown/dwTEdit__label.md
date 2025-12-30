
### 问：如何确定是否当前为移动端访问 ?
### 答：  
可以通过读取浏览器UserAgent来实现
**User Agent**，简称 **UA**，是一个特殊字符串头，使得服务器能够识别客户使用的操作系统及版本、CPU 类型、浏览器及版本、浏览器渲染引擎、浏览器语言、浏览器插件等。
在DeWeb中可以通过dwGetProp(Self,'requestuseragent')取得(OnCreate事件取不到)
```
    //判断是否移动端
    sUA := lowercase(dwGetProp(Self,'requestuseragent'));
    if (Pos('iphone',sUA)>0) or (Pos('ipod',sUA)>0) or (Pos('android',sUA)>0) or (Pos('windows phone',sUA)>0) then begin
        。。。。。。。
        //
        LaTitle.Caption := '参考资料';
    end;
```

