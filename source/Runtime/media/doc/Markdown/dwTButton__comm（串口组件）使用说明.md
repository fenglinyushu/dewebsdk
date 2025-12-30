## Button__comm 串口收发组件

### 一、功能
    该控件在浏览器中通过串口收发数据


### 二、基本使用
	1. 拖放一个TButton控件，HelpKeyword设置为comm
	注：该TButton控件时在web界面上不显示。注意不要影响其他控件占位

	2. 基本属性
		
	3. Hint扩展属性
		(1) baudrate	波特率，数字型，默认为115200，例：{"baudrate":57600}
		(2) databits	数据位，数字型，默认为8，例：{"databits":8}
		(3) stopbits	停止位，数字型，默认为1，例：{"stopbits":1}
		(4) parity		奇偶校验位，字符串型，可选项有none/even/odd, 默认为none，例：{"parity":"none"}

	4. 方法
		(1) 打开端口。 需要先uses dwbase, 其中BtComm的用作串口的控件名称。注：由于浏览器安全限制，不能自动打开端口，需要点击操作
			//
			dwRunJS('this.'+dwFullName(BtComm)+'__OpenComm();',self);
		(2) 发送数据。其中EtSend.Text为拟发送的字符串数据 
			//
			dwRunJS('this.'+dwFullName(BtComm)+'__WriteComm("'+EtSend.Text+'");',self);
		(3) 关闭端口。 
			//
			dwRunJS('this.'+dwFullName(BtComm)+'__CloseComm();',self);
			
	5. 事件
		(1) 打开端口事件。  
		当端口打开时自动激活串口控件的OnKeyPress事件。  
		打开成功时，事件参数key为t;否则，key为f
		
		(2) 关闭端口事件。  
		当关闭端口时自动激活串口控件的OnKeyPress事件。  
		关闭成功时，事件参数key为1;否则，key为0
		
		(3) 串口接收到数据事件
		当串口接收到数据后，自动激活控件的OnEnter事件，数据值为当前控件的Caption
		
	6. 注意事件
		(1) 不是所有浏览器都支持串口通信。目前支持串口的浏览器包括：
			- Chrome (通过Web Serial API)
			- Edge (通过Web Serial API)
			- Opera (通过Web Serial API)
			- Firefox (通过Web Serial API)
			- Safari (通过WebHID API)
			请选用以上浏览器或与以上浏览器兼容的浏览器
		(2) 目前不支持发送中文字符，如果需要，需要自行处理乱码问题
		(3) 目前不支持仅支持发送字符串数据，不支持二进制数据