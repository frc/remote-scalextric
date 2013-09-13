define(function() {

	function deviceOrientationEventSupported() {
		if (window.DeviceOrientationEvent) {
			return true;
		} else {
			return false;
		}
	}

	function sendData(data) {
		var xhr = new XMLHttpRequest();
		xhr.open('GET', '/set-pwm.json?v=' + data, true); // TODO
		xhr.send();
	    console.log('v=' + data);
	}

	function deviceOrientationHandler(event) {
		var tilt = Math.ceil(event.beta) * -2,
			scale = document.getElementById('scale');

		if (tilt > 0 && tilt < 200) {
			scale.style.top = 100 - tilt + '%';
			sendData(tilt);
		}
	}

	function initDeviceOrientation() {
		if (deviceOrientationEventSupported) {
			window.addEventListener('deviceorientation', deviceOrientationHandler, false);
			return true;
		} else {
			return false;
		}
	}

	console.log('Module loaded: Device Orientation');

	return {
		isOrientationSupported: deviceOrientationEventSupported(),
		initOrientation: initDeviceOrientation
	};

});
