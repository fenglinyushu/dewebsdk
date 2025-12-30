
function psSet6D(viewer,id,lon,lat,alt,heading,pitch,roll) 
{
	console.log("psSet6D");
	//更新实体位置姿态
	var pos = new  Cesium.Cartesian3.fromDegrees(lon,lat,alt);
	viewer.entities.getById(id).position = pos;
	let hpr = new Cesium.HeadingPitchRoll((heading-90)*3.1415/180,pitch*3.1415/180,-roll*3.1415/180);
	let ori = Cesium.Transforms.headingPitchRollQuaternion(pos,hpr);
	viewer.entities.getById(id).orientation = ori;

	
	//添加航迹点
	let _route = viewer.entities.getById(id+'_route');
	if (_route.polyline.positions == undefined) {
		_route.polyline.positions = new Cesium.Cartesian3.fromDegreesArrayHeights([
			lon, lat, alt
		]);
	} else {
		let poss = _route.polyline.positions.getValue();
		poss.push(pos);
		_route.polyline.positions = poss;
	}

}

 