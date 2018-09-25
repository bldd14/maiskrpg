#include <a_samp>
#include <a_mysql>
#include <Pawn.CMD>
#include <sscanf2>
#include <streamer>

#define funcion%0(%1) forward%0(%1); public%0(%1)

enum {
	EMPTY_DIALOG,
 	DIALOG_LOGIN,
	DIALOG_REGISTER,
	DIALOG_AGE,
	DIALOG_GENDER,
	DIALOG_INGRESO
}

#pragma option -d3
#pragma option -E

/* Modulos */
#include "Modules/Server/Clima.p"

#include "Modules/Data/MySQL.p"
#include "Modules/Data/Players.p"

#include "Modules/Utils/Funcs.p"

#include "Modules/Aviones/Velocimetro.p"
#include "Modules/Aviones/Gasolina.p"

CMD:aviontest(playerid){
	new Float:X, Float:Y, Float:Z;
	GetPlayerPos(playerid, X, Y, Z);
	CreateVehicle(519, X, Y, Z, 0, 0, 0, 0, 0);
	return 1;
}

main(){
	print("[SERVIDOR]: Iniciando");
}