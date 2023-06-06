document.write("<script type='text/javascript' src='dist/dwmd5.js'></script>");
function getOs(){
	var ua = navigator.userAgent;
	isWindowsPhone = /(?:Windows Phone)/.test(ua);
	isSymbian = /(?:SymbianOS)/.test(ua) || isWindowsPhone;
	isAndroid = /(?:Android)/.test(ua);
	isFireFox = /(?:Firefox)/.test(ua);
	isChrome = /(?:Chrome|CriOS)/.test(ua); 
	isTablet = /(?:iPad|PlayBook)/.test(ua) || (isAndroid && !/(?:Mobile)/.test(ua)) || (isFireFox && /(?:Tablet)/.test(ua));
	isPhone = /(?:iPhone)/.test(ua) && !isTablet ;   //|| (?:iPhone)/.test(ua) && !isTablet;
	if (!isPhone && !isAndroid && !isSymbian) {
		return 1;
	} else if (isAndroid){
		return 2;
	} else if (isPhone){
		return 3;
	} else if (isTablet){
		return 4;
	} else {
		return 0;
	}
}

function getCanvasId () {  
	var canvas = document.getElementById('canvas'); 
	if (canvas == null) {
		canvas = document.createElement('canvas');
	}
	const ctx = canvas.getContext('2d')  
	ctx.font = '16px Arial'  
	ctx.fillStyle = '#ccc'  
	ctx.fillText('deweb', 2, 2)  
	const b64 = canvas.toDataURL().replace("data:image/png;base64,", "");
	return hex_md5(b64);
}
