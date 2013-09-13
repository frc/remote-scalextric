requirejs.config({
	baseUrl: '/assets/js/vendor',
	paths: {
		sub: '/assets/js/sub'
	}
});

requirejs(['sub/deviceorientation'],
function(device) {

	if (device.isOrientationSupported) {
		device.initOrientation();
	}

});
