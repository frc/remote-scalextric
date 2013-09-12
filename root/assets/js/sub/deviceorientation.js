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

		xhr.open('POST', '/set-pwm.json', true); // TODO

		xhr.onreadystatechange = function() {
			if (xhr.readyState === 4 && xhr.status === 200) {
				console.log('message');
				// Do something if you feel like it
			}
		}
		
		xhr.send('v=' + data); // TODO
	}

	function deviceOrientationHandler(event) {
		var tilt = Math.ceil(event.beta) * -2,
			scale = document.getElementById('scale');

		if (tilt > 0 && tilt < 200) {
			scale.style.top = 100 - tilt + '%';
			// sendData(tilt); // TODO
			console.log('doajax');
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
