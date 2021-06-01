// Hide URL Parameters.js
//https://gist.github.com/ScottKaye/5158488#file-hide-url-parameters-js

function getURLParameter(name) {
	return decodeURI((RegExp(name + '=' + '(.+?)(&|$)').exec(location.search) || [, null])[1]);
}

function hideURLParams() {
	// Parámetros para ocultar (es decir,? success = value,? error = value, etc.)
	var hide = ['id', 'op'];
	for (var h in hide) {
		if (getURLParameter(h)) {
			history.replaceState(null, document.getElementsByTagName("title")[0].innerHTML, window.location.pathname);
		}
	}
}

//Ejecuta onload, puedes hacerlo tú mismo si quieres hacerlo de otra manera
window.onload = hideURLParams;