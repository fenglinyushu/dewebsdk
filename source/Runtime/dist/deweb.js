//-------------以下为deweb精简用的代码----------------------------
Vue.prototype.dwsetcookie = function(name, value, hours) {
	let expires = '';
	if (typeof hours !== 'undefined') {
	const date = new Date();
	date.setTime(date.getTime() + hours * 60 * 60 * 1000);
	expires = '; expires=' + date.toUTCString();
	}
	document.cookie = name + '=' + encodeURIComponent(value) + expires + '; path=/';
}
Vue.prototype.dwsetcookiepro = function(name, value, hours, path, domain) {
	const date = new Date();
	date.setTime(date.getTime() + (hours * 60 * 60 * 1000));
	const expires = "expires=" + date.toUTCString();
	let cookieString = name + "=" + value + "; " + expires;
	if (path) {
	cookieString += "; path=" + path;
	}
	if (domain) {
	cookieString += "; domain=" + domain;
	}
	document.cookie = cookieString;
}
Vue.prototype.dwgetcookie = function (name) {
	var arr,reg=new RegExp("(^| )"+name+"=([^;]*)(;|$)");
	if(arr=document.cookie.match(reg))
	return unescape(arr[2]);
	else
	return '';
}
Vue.prototype.procResp = function (data){
	if (data.m === "update"){
	try {
	eval(String(data.o));
	} catch (err) {
	console.log("error when procResp : ",String(data.o));
	}
	} else if (data.m === "html"){
	document.body.innerHTML="";
	document.write(String(data.o));
	document.close();
	} else if (data.m === "recreate"){
	let end = setInterval(function () { }, 10000);
	for (let i = 1; i <= end; i++) {
	clearInterval(i);
	}
	document.body.innerHTML="";
	document.write(String(data.o));
	document.close();
	} else if (data.m === "showform"){
	document.open();document.write(String(data.o));
	} else if (data.m === "wx_getuserprofile"){
	wx.getUserProfile({desc: "获取你的昵称、头像、地区及性别",success: res => {console.log("dw_success");},fail: res => {console.log("dw_false");return;}});
	}
}

//methods
function ToWebsite (e,n) {
	if (n==""){
		window.location.href = e
	}else{
		var aTag = document.createElement('a');
		aTag.setAttribute('href', e);
		aTag.setAttribute('target', n);
		aTag.click();
	};
}
function dwInputClick (e) {
	document.getElementById(e).click();
}
function dwInputChange (fid,e) {
	let oinp = document.getElementById(e+"__inp");
	console.log(oinp.files[i]);
	for (let i = 0; i < oinp.files.length; i++) {
		console.log(oinp.files[i].name);
		var sget = '{"m":"event","i":"'+fid+'","c":"'+e+'","e":"getfilename","v":"'+escape(oinp.files[i].name)+'"}';
		axios.post('/deweb/post',sget)
	}
}
function filterHandler(value, row, column) {
	const property = column['property'];
	return row[property] === value;
}
function dwInputSubmit (fid,destdir) {
	let that = this;
	let config = {};
	if (this.dw_upload__formhandle > 0) {
		fid = this.dw_upload__formhandle; 
		this.dw_upload__formhandle = 0;
		config = {headers: {'Content-Type': 'multipart/form-data','clientid': fid,'destdir': destdir,'shuntflag': 0}};
	} else {
		config = {headers: {'Content-Type': 'multipart/form-data','clientid': '135984','destdir': destdir,'shuntflag': 0}};
	};
	var sstart = '';
	for (let i = 0; i < document.getElementById("deweb__inp").files.length; i++) {
		let formData = new FormData();
		formData.append('file', document.getElementById("deweb__inp").files[i]);
		if ( i == 0 ) {
			sstart = '{"m":"event","i":"'+fid+'","c":"Form1_7","e":"onstartdock","v":"__start__"}';
			axios.post('/deweb/post',sstart, config).then(resp =>{that.procResp(resp.data)});
		};
		axios.post('/upload', formData, config).then(function (res) {
			if ( i == document.getElementById("deweb__inp").files.length-1 ) {
				var sget = '{"m":"event","i":"'+fid+'","c":"Form1_7","e":"onenddock","v":"__success__"}';
				axios.post('/deweb/post',sget, config).then(resp =>{that.procResp(resp.data)});
				document.getElementById("deweb__inp").value = null;
			};
		});
	};
}
function beforeunloadHandler (e) {
	e = e || window.event
	if (e) {
		axios.post('/deweb/post','{"m":"onbeforeunload","i":135984}',{headers:{shuntflag:0}})
	}
}
function dwnotify(caption,text) {
	this.$notify.warning({ title: caption, message: text, duration: 0,showClose: false });
}

function dwexecute(code) {
	eval(code);
}
function dwalert(code) {
	alert(code);
}
function dwwechat(wxtype,wxvalue) {
	var jo={};
	jo.m="wechat";
	jo.i=handle;
	jo.v=escape(wxvalue)
	jo.e=wxtype;
	axios.post('/deweb/post',escape(JSON.stringify(jo)),{headers:{shuntflag:0}})
	.then(resp =>{this.procResp(resp.data)});
	if (val !== null && val !== undefined && val !== '' && typeof val === 'object' && val.stopPropagation !== undefined){
		val.stopPropagation();
	};
}
Vue.prototype.processinputquery = function (val){
//function processinputquery(val) {
	this.input_query_visible = false;
	axios.post('/deweb/post','{"m":"interaction","i":'+this.input_query_handle+',"s":"inputquery","t":"'+this.input_query_method+'","v":"'+escape(this.input_query_inputdefault)+'"}',{headers:{shuntflag:0}})
	.then(resp =>{this.procResp(resp.data)});
}
Vue.prototype.dwevent = function (val,compname,compvalue,compevent,handle){
//function dwevent(val,compname,compvalue,compevent,handle) {
	var jo={};
	jo.m="event";
	jo.i=handle;
	jo.c=compname;
	try{
		jo.v=escape(eval(compvalue));
	} catch (e) {
		jo.v=escape(compvalue);
	}
	jo.e=compevent;
	axios.post('/deweb/post',escape(JSON.stringify(jo)),{headers:{shuntflag:0}})
	.then(resp =>{
		this.procResp(resp.data);
	});
	if (val !== null && val !== undefined && val !== '' && typeof val === 'object' && val.stopPropagation !== undefined){
		val.stopPropagation();
	};
}


//-------------以上为deweb精简用的代码----------------------------

//document.write("<script type='text/javascript' src='dist/dwmd5.js'></script>");
//<script src="dist/dwmd5.js"></script>
/*
 * A JavaScript implementation of the RSA Data Security, Inc. MD5 Message
 * Digest Algorithm, as defined in RFC 1321.
 * Version 2.1 Copyright (C) Paul Johnston 1999 - 2002.
 * Other contributors: Greg Holt, Andrew Kepert, Ydnar, Lostinet
 * Distributed under the BSD License
 * See http://pajhome.org.uk/crypt/md5 for more info.
 */

/*
 * Configurable variables. You may need to tweak these to be compatible with
 * the server-side, but the defaults work in most cases.
 */
var hexcase = 0;  /* hex output format. 0 - lowercase; 1 - uppercase        */
var b64pad  = ""; /* base-64 pad character. "=" for strict RFC compliance   */
var chrsz   = 8;  /* bits per input character. 8 - ASCII; 16 - Unicode      */

/*
 * These are the functions you'll usually want to call
 * They take string arguments and return either hex or base-64 encoded strings
 */
function hex_md5(s){ return binl2hex(core_md5(str2binl(s), s.length * chrsz));}
function b64_md5(s){ return binl2b64(core_md5(str2binl(s), s.length * chrsz));}
function str_md5(s){ return binl2str(core_md5(str2binl(s), s.length * chrsz));}
function hex_hmac_md5(key, data) { return binl2hex(core_hmac_md5(key, data)); }
function b64_hmac_md5(key, data) { return binl2b64(core_hmac_md5(key, data)); }
function str_hmac_md5(key, data) { return binl2str(core_hmac_md5(key, data)); }

/*
 * Perform a simple self-test to see if the VM is working
 */
function md5_vm_test()
{
  return hex_md5("abc") == "900150983cd24fb0d6963f7d28e17f72";
}

/*
 * Calculate the MD5 of an array of little-endian words, and a bit length
 */
function core_md5(x, len)
{
  /* append padding */
  x[len >> 5] |= 0x80 << ((len) % 32);
  x[(((len + 64) >>> 9) << 4) + 14] = len;

  var a =  1732584193;
  var b = -271733879;
  var c = -1732584194;
  var d =  271733878;

  for(var i = 0; i < x.length; i += 16)
  {
    var olda = a;
    var oldb = b;
    var oldc = c;
    var oldd = d;

    a = md5_ff(a, b, c, d, x[i+ 0], 7 , -680876936);
    d = md5_ff(d, a, b, c, x[i+ 1], 12, -389564586);
    c = md5_ff(c, d, a, b, x[i+ 2], 17,  606105819);
    b = md5_ff(b, c, d, a, x[i+ 3], 22, -1044525330);
    a = md5_ff(a, b, c, d, x[i+ 4], 7 , -176418897);
    d = md5_ff(d, a, b, c, x[i+ 5], 12,  1200080426);
    c = md5_ff(c, d, a, b, x[i+ 6], 17, -1473231341);
    b = md5_ff(b, c, d, a, x[i+ 7], 22, -45705983);
    a = md5_ff(a, b, c, d, x[i+ 8], 7 ,  1770035416);
    d = md5_ff(d, a, b, c, x[i+ 9], 12, -1958414417);
    c = md5_ff(c, d, a, b, x[i+10], 17, -42063);
    b = md5_ff(b, c, d, a, x[i+11], 22, -1990404162);
    a = md5_ff(a, b, c, d, x[i+12], 7 ,  1804603682);
    d = md5_ff(d, a, b, c, x[i+13], 12, -40341101);
    c = md5_ff(c, d, a, b, x[i+14], 17, -1502002290);
    b = md5_ff(b, c, d, a, x[i+15], 22,  1236535329);

    a = md5_gg(a, b, c, d, x[i+ 1], 5 , -165796510);
    d = md5_gg(d, a, b, c, x[i+ 6], 9 , -1069501632);
    c = md5_gg(c, d, a, b, x[i+11], 14,  643717713);
    b = md5_gg(b, c, d, a, x[i+ 0], 20, -373897302);
    a = md5_gg(a, b, c, d, x[i+ 5], 5 , -701558691);
    d = md5_gg(d, a, b, c, x[i+10], 9 ,  38016083);
    c = md5_gg(c, d, a, b, x[i+15], 14, -660478335);
    b = md5_gg(b, c, d, a, x[i+ 4], 20, -405537848);
    a = md5_gg(a, b, c, d, x[i+ 9], 5 ,  568446438);
    d = md5_gg(d, a, b, c, x[i+14], 9 , -1019803690);
    c = md5_gg(c, d, a, b, x[i+ 3], 14, -187363961);
    b = md5_gg(b, c, d, a, x[i+ 8], 20,  1163531501);
    a = md5_gg(a, b, c, d, x[i+13], 5 , -1444681467);
    d = md5_gg(d, a, b, c, x[i+ 2], 9 , -51403784);
    c = md5_gg(c, d, a, b, x[i+ 7], 14,  1735328473);
    b = md5_gg(b, c, d, a, x[i+12], 20, -1926607734);

    a = md5_hh(a, b, c, d, x[i+ 5], 4 , -378558);
    d = md5_hh(d, a, b, c, x[i+ 8], 11, -2022574463);
    c = md5_hh(c, d, a, b, x[i+11], 16,  1839030562);
    b = md5_hh(b, c, d, a, x[i+14], 23, -35309556);
    a = md5_hh(a, b, c, d, x[i+ 1], 4 , -1530992060);
    d = md5_hh(d, a, b, c, x[i+ 4], 11,  1272893353);
    c = md5_hh(c, d, a, b, x[i+ 7], 16, -155497632);
    b = md5_hh(b, c, d, a, x[i+10], 23, -1094730640);
    a = md5_hh(a, b, c, d, x[i+13], 4 ,  681279174);
    d = md5_hh(d, a, b, c, x[i+ 0], 11, -358537222);
    c = md5_hh(c, d, a, b, x[i+ 3], 16, -722521979);
    b = md5_hh(b, c, d, a, x[i+ 6], 23,  76029189);
    a = md5_hh(a, b, c, d, x[i+ 9], 4 , -640364487);
    d = md5_hh(d, a, b, c, x[i+12], 11, -421815835);
    c = md5_hh(c, d, a, b, x[i+15], 16,  530742520);
    b = md5_hh(b, c, d, a, x[i+ 2], 23, -995338651);

    a = md5_ii(a, b, c, d, x[i+ 0], 6 , -198630844);
    d = md5_ii(d, a, b, c, x[i+ 7], 10,  1126891415);
    c = md5_ii(c, d, a, b, x[i+14], 15, -1416354905);
    b = md5_ii(b, c, d, a, x[i+ 5], 21, -57434055);
    a = md5_ii(a, b, c, d, x[i+12], 6 ,  1700485571);
    d = md5_ii(d, a, b, c, x[i+ 3], 10, -1894986606);
    c = md5_ii(c, d, a, b, x[i+10], 15, -1051523);
    b = md5_ii(b, c, d, a, x[i+ 1], 21, -2054922799);
    a = md5_ii(a, b, c, d, x[i+ 8], 6 ,  1873313359);
    d = md5_ii(d, a, b, c, x[i+15], 10, -30611744);
    c = md5_ii(c, d, a, b, x[i+ 6], 15, -1560198380);
    b = md5_ii(b, c, d, a, x[i+13], 21,  1309151649);
    a = md5_ii(a, b, c, d, x[i+ 4], 6 , -145523070);
    d = md5_ii(d, a, b, c, x[i+11], 10, -1120210379);
    c = md5_ii(c, d, a, b, x[i+ 2], 15,  718787259);
    b = md5_ii(b, c, d, a, x[i+ 9], 21, -343485551);

    a = safe_add(a, olda);
    b = safe_add(b, oldb);
    c = safe_add(c, oldc);
    d = safe_add(d, oldd);
  }
  return Array(a, b, c, d);

}

/*
 * These functions implement the four basic operations the algorithm uses.
 */
function md5_cmn(q, a, b, x, s, t)
{
  return safe_add(bit_rol(safe_add(safe_add(a, q), safe_add(x, t)), s),b);
}
function md5_ff(a, b, c, d, x, s, t)
{
  return md5_cmn((b & c) | ((~b) & d), a, b, x, s, t);
}
function md5_gg(a, b, c, d, x, s, t)
{
  return md5_cmn((b & d) | (c & (~d)), a, b, x, s, t);
}
function md5_hh(a, b, c, d, x, s, t)
{
  return md5_cmn(b ^ c ^ d, a, b, x, s, t);
}
function md5_ii(a, b, c, d, x, s, t)
{
  return md5_cmn(c ^ (b | (~d)), a, b, x, s, t);
}

/*
 * Calculate the HMAC-MD5, of a key and some data
 */
function core_hmac_md5(key, data)
{
  var bkey = str2binl(key);
  if(bkey.length > 16) bkey = core_md5(bkey, key.length * chrsz);

  var ipad = Array(16), opad = Array(16);
  for(var i = 0; i < 16; i++)
  {
    ipad[i] = bkey[i] ^ 0x36363636;
    opad[i] = bkey[i] ^ 0x5C5C5C5C;
  }

  var hash = core_md5(ipad.concat(str2binl(data)), 512 + data.length * chrsz);
  return core_md5(opad.concat(hash), 512 + 128);
}

/*
 * Add integers, wrapping at 2^32. This uses 16-bit operations internally
 * to work around bugs in some JS interpreters.
 */
function safe_add(x, y)
{
  var lsw = (x & 0xFFFF) + (y & 0xFFFF);
  var msw = (x >> 16) + (y >> 16) + (lsw >> 16);
  return (msw << 16) | (lsw & 0xFFFF);
}

/*
 * Bitwise rotate a 32-bit number to the left.
 */
function bit_rol(num, cnt)
{
  return (num << cnt) | (num >>> (32 - cnt));
}

/*
 * Convert a string to an array of little-endian words
 * If chrsz is ASCII, characters >255 have their hi-byte silently ignored.
 */
function str2binl(str)
{
  var bin = Array();
  var mask = (1 << chrsz) - 1;
  for(var i = 0; i < str.length * chrsz; i += chrsz)
    bin[i>>5] |= (str.charCodeAt(i / chrsz) & mask) << (i%32);
  return bin;
}

/*
 * Convert an array of little-endian words to a string
 */
function binl2str(bin)
{
  var str = "";
  var mask = (1 << chrsz) - 1;
  for(var i = 0; i < bin.length * 32; i += chrsz)
    str += String.fromCharCode((bin[i>>5] >>> (i % 32)) & mask);
  return str;
}

/*
 * Convert an array of little-endian words to a hex string.
 */
function binl2hex(binarray)
{
  var hex_tab = hexcase ? "0123456789ABCDEF" : "0123456789abcdef";
  var str = "";
  for(var i = 0; i < binarray.length * 4; i++)
  {
    str += hex_tab.charAt((binarray[i>>2] >> ((i%4)*8+4)) & 0xF) +
           hex_tab.charAt((binarray[i>>2] >> ((i%4)*8  )) & 0xF);
  }
  return str;
}

/*
 * Convert an array of little-endian words to a base-64 string
 */
function binl2b64(binarray)
{
  var tab = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
  var str = "";
  for(var i = 0; i < binarray.length * 4; i += 3)
  {
    var triplet = (((binarray[i   >> 2] >> 8 * ( i   %4)) & 0xFF) << 16)
                | (((binarray[i+1 >> 2] >> 8 * ((i+1)%4)) & 0xFF) << 8 )
                |  ((binarray[i+2 >> 2] >> 8 * ((i+2)%4)) & 0xFF);
    for(var j = 0; j < 4; j++)
    {
      if(i * 8 + j * 6 > binarray.length * 32) str += b64pad;
      else str += tab.charAt((triplet >> 6*(3-j)) & 0x3F);
    }
  }
  return str;
}
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

function dwSetVar(sValue){
	var jo = {};
	jo.m = "event";
	jo.c = window._this.name;
	jo.i = window._this.clientid;
	jo.v = sValue;
	jo.e = "onvar";
	//console.log(jo);
	axios.post('/deweb/post',escape(JSON.stringify(jo)),{headers:{shuntflag:2051}})
	.then(resp =>{window._this.procResp(resp.data)});
	//console.log('dwSetVar success2');

}

function shareToQQ(title, url, pic) {
	var shareUrl = encodeURIComponent("https://www.example.com");  
	var title = encodeURIComponent("分享标题");  
	var summary = encodeURIComponent("分享摘要");  

	var qqShareUrl = "mqq://share/to_fri?src_type=app&version=1&file_type=jpg&file_data=" + shareUrl + "&title=" + title + "&summary=" + summary;  
	
	window.location.href = qqShareUrl; // 打开QQ分享链接  
}
function shareToQQOld(title, url, pic) {
    var param = {
      url: url || 'www.baidu.com',
      /*分享地址*/
      desc: '',
      /*分享理由(可选)*/
      title: title || '',
      /*分享标题(可选)*/
      summary: '',
      /*分享描述(可选)*/
      pics: pic || '',
      /*分享图片(可选)*/
      flash: '',
      /*视频地址(可选)*/
      site: '' /*分享来源 (可选) */
    };
    var s = [];
    for (var i in param) {
      s.push(i + '=' + encodeURIComponent(param[i] || ''));
    }
    var targetUrl = "https://connect.qq.com/widget/shareqq/index.html?" + s.join('&');
    window.open(targetUrl, '_blank', 'height=520, width=720');
}

function dwLoadResourcesIfNotExists(resources, callback) {
  let loadedCount = 0; // 记录已加载资源数量
  let totalCount = resources.length; // 总资源数量

  // 判断并加载资源
  function checkAndLoad(resource) {
    return new Promise((resolve, reject) => {
      if (resource.type === 'js') {
        // 如果JS文件未加载
        if (typeof window[resource.globalVar] === 'undefined') {
          let script = document.createElement('script');
          script.src = resource.url;
          script.onload = () => {
            //console.log(resource.globalVar + ' has been loaded.');
            resolve();
          };
          script.onerror = () => {
            console.error('Failed to load ' + resource.globalVar);
            reject();
          };
          document.head.appendChild(script);
        } else {
          //console.log(resource.globalVar + ' is already loaded.');
          resolve(); // 已加载则直接返回
        }
      } else if (resource.type === 'css') {
        // 如果CSS文件未加载
        const existingLink = Array.from(document.head.getElementsByTagName('link')).find(link => link.href === resource.url);
        if (!existingLink) {
          let link = document.createElement('link');
          link.rel = 'stylesheet';
          link.href = resource.url;
          link.onload = () => {
            //console.log(resource.url + ' CSS has been loaded.');
            resolve();
          };
          link.onerror = () => {
            console.error('Failed to load ' + resource.url + ' CSS');
            reject();
          };
          document.head.appendChild(link);
        } else {
          //console.log(resource.url + ' CSS is already loaded.');
          resolve(); // 已加载则直接返回
        }
      }
    });
  }

  // 加载所有资源，依次执行
  function loadSequentially(resources) {
    if (resources.length === 0) {
      // 所有资源加载完成
      //console.log('All resources have been loaded successfully.');
      if (typeof callback === 'function') {
        callback();
      }
      return Promise.resolve(); // 资源加载完成
    }

    const resource = resources[0]; // 当前资源
    return checkAndLoad(resource)
      .then(() => loadSequentially(resources.slice(1))) // 继续加载下一个资源
      .catch((error) => {
        console.error('Error loading resource:', error);
        return Promise.reject(error);  // 返回错误，确保失败不会继续加载
      });
  }

  // 对每个资源进行加载和检查
  let resourcesToLoad = resources.map(resource => {
    return new Promise((resolve) => {
      // 每个资源加载时进行检查，确保加载完毕后再进行下一步
      const checkResourceLoaded = setInterval(() => {
        if (resource.type === 'js' && typeof window[resource.globalVar] !== 'undefined') {
          //console.log(resource.globalVar + ' is already loaded.');
          clearInterval(checkResourceLoaded); // 资源已加载，停止检查
          resolve();
        } else if (resource.type === 'css') {
          const existingLink = Array.from(document.head.getElementsByTagName('link')).find(link => link.href === resource.url);
          if (existingLink) {
            //console.log(resource.url + ' CSS is already loaded.');
            clearInterval(checkResourceLoaded); // CSS已加载，停止检查
            resolve();
          }
        } else {
          // 如果资源未加载，开始加载资源
          checkAndLoad(resource).then(resolve).catch(resolve);
        }
      }, 100); // 每100ms检查一次
    });
  });

  // 所有资源的加载任务
  Promise.all(resourcesToLoad)
    .then(() => {
      //console.log('All resources have been loaded successfully.');
      // 执行回调
      if (typeof callback === 'function') {
        callback();
      }
    })
    .catch((error) => {
      console.error('Some resources failed to load:', error);
    });
}

/*
// 示例使用
loadResourcesIfNotExists([
  { type: 'js', globalVar: 'jQuery', url: 'https://code.jquery.com/jquery-3.6.0.min.js' },
  { type: 'js', globalVar: 'Lodash', url: 'https://cdnjs.cloudflare.com/ajax/libs/lodash.js/4.17.21/lodash.min.js' },
  { type: 'css', url: 'https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css' }
], function() {
  console.log('All resources (JS & CSS) loaded, now you can use them!');
});
*/

