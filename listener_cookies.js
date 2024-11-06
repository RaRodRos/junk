	// Eventlistener al cargar la web
document.addEventListener("DOMContentLoaded", acordeonCorrecto);





	// Despliegue del acordeón correcto al seguir un enlace
		/*Para que funcione correctamente cada ID que pertenezca a un acordeon debe
	terminar en 'Acordeon', respetando las mayúsculas*/
function acordeonCorrecto() {

		/*Crear un escuchador que, al hacer click sobre los enlaces que terminan
		en 'Acordeon', genere cookies que permitan que se abra el acordeón
		correcto en la web de destino*/
	var todasCookies = document.cookie.split(';');

	var cookieActual = null;

	function irAcordeon(event) {
		if (event===undefined || event===null){
			event = window.event;
		}/*con esto, supuestamente, lograría que el eventlistener
		escuche el evento correctamente en Chrome*/
		var destino = event.target.getAttribute('href');
		destino = destino.slice((destino.indexOf("#")+1),);
		if (document.getElementById(destino)) {
			document.getElementById(destino).className = ' active'
		};
		document.cookie = "destinoAcordeon=" + destino + ";path=/";
	}

	document.querySelectorAll("[href*='Acordeon'").forEach(function (enlace){
		enlace.addEventListener("mousedown", function(event) {irAcordeon(event);})
		});

		/*Leer la cookie para el acordeón*/
	for (let i = todasCookies.length - 1; i >= 0; i--) {
		if (todasCookies[i].startsWith('destinoAcordeon=')) {
			cookieActual = todasCookies[i].replace('destinoAcordeon=','');
		};	
		
		if (document.getElementById(cookieActual)) {
			document.getElementById(cookieActual).className += ' active';
			break;
		}
	};
	document.cookie = 'destinoAcordeon=; expires=Thu, 01 Jan 1970 00:00:01 GMT; Path=/';
};// Despliegue del acordeón correcto al seguir un enlace
