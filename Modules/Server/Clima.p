#include <YSI\y_hooks>

new ClimaServidor, bool:WeatherMalo;

#pragma unused WeatherMalo // Se usara luego, necesito poner esto por que uso el -E

hook OnGameModeInit(){
	SetTimer("Clima", 1000*60*55, true);
	return 1;
}

funcion Clima(){
	new weather = random(20)+1;
	if(weather == 19){
		SendClientMessageToAll(-1, "[SAN]: Se aproxima una tormenta de arena.");
		SendClientMessageToAll(-1, "[SAN]: Se cancelaron todos los vuelos, todos los aviones deben aterrizar de emergencia.");
		WeatherMalo = true;
	}
	SetTimerEx("ClimaPoner", 1000*60*5, false, "i", weather);
	return 1;
}

funcion ClimaPoner(weatherid) return SetWeather(weatherid);