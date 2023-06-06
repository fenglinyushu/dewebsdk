
function dwEchartsInit(dom) {
	var oEcharts = echarts.init(document.getElementById(dom));
	var oOption = eval('this.'+dom);
	oEcharts.setOption(oOption);
}

