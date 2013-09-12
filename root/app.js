requirejs.config({
	baseUrl: '../assets/js/vendor',
	paths: {
		sub: '../sub'
	}
});

requirejs(['sub/deviceorientation'],
function(device) {

	if (device.isOrientationSupported) {
		device.initOrientation();
	}

});
