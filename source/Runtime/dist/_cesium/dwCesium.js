/*
本单元为DeWeb中使用cesium的单元
*/

//添加实体，同时设置其6自由度
//viewer：控件全名，如panel1
//id为实体名称,如plane
//uri为模型文件网址，media/cesium/Cesium_Air.glb
//lon, lat, alt, heading, pitch, roll为6自由度值
//minsize, maxscale：最小尺寸和最大缩放，一般可取128，20000
function dwcAddEntity(viewer, id, uri, lon, lat, alt, heading, pitch, roll, minsize, maxscale) {
	var position = null;
	let color = Cesium.Color.fromRandom();
	color = Cesium.Color.LIGHTPINK.withAlpha(1);
	position =  new Cesium.Cartesian3.fromDegrees(lon, lat, alt);
	//console.log(viewer);
	viewer.entities.add({
		id: id,
		name: "model" + id,
		position: position,
		orientation: Cesium.Transforms.headingPitchRollQuaternion(
			position,
			new Cesium.HeadingPitchRoll(
				Cesium.Math.toRadians(heading-90), // 设置这个属性即可（顺时针旋转的角度值）
				Cesium.Math.toRadians(pitch),
				Cesium.Math.toRadians(roll)
			)
		),
		model: {
			uri: uri,
			minimumPixelSize: minsize,
			maxumunScale: minsize,
			heightReference: Cesium.HeightReference.RELATIVE_TO_GROUND,
			modelMatrix: Cesium.Transforms.eastNorthUpToFixedFrame(position),
		},
		show: true,
	});
}

function dwcSelect(viewer,id)
{
	//selectionIndicator: true, //确认实体选中是启用的
	
	const entity = viewer.entities.getById(id)//根据id获取到指定实体
	viewer.trackedEntity = entity;	
}



//添加航线
function dwcAddRoute(viewer,id,lon,lat,alt,width,color)
{
	//console.log("dwcAddRoute");
	viewer.entities.add({
		id: id,
		polyline: {
			show: true, //是否显示，默认显示
			positions: Cesium.Cartesian3.fromDegreesArrayHeights([
				lon, lat, alt
			]),
			width: width, //线的宽度（像素），默认为1
			granularity: Cesium.Math.RADIANS_PER_DEGREE,
			material: Cesium.Color.fromCssColorString(color), //线的颜色，默认为白色
			arcType: Cesium.ArcType.RHUMB,
			clampToGround: false,
			shadows: Cesium.ShadowMode.DISABLED,
			classificationType: Cesium.ClassificationType.BOTH,
			zIndex: 0,
		}
	});
}	

function dwcSet3D(viewer,id,lon,lat,alt) 
{
	//console.log("dwcSet3D");
	viewer.entities.getById(id).position = Cesium.Cartesian3.fromDegrees(lon, lat, alt);
}

function dwcSet6D(viewer,id,lon,lat,alt,heading,pitch,roll) 
{
	//console.log("dwcSet6D");
	let a = Date.now();
	//console.log(a); //1523619204809;
	//更新实体位置姿态
	var pos = new  Cesium.Cartesian3.fromDegrees(lon,lat,alt);
	viewer.entities.getById(id).position = pos;
	let hpr = new Cesium.HeadingPitchRoll((heading-90)*3.1415/180,pitch*3.1415/180,-roll*3.1415/180);
	let ori = Cesium.Transforms.headingPitchRollQuaternion(pos,hpr);
	viewer.entities.getById(id).orientation = ori;

}

 