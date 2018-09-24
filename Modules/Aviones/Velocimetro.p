#include <YSI\y_hooks>

// Gracias iTD, luego te enseño a usar arrays.

new PlayerText:VeloTD0[MAX_PLAYERS],
	PlayerText:VeloTD1[MAX_PLAYERS],
	PlayerText:VeloTD2[MAX_PLAYERS],
	PlayerText:VeloTD3[MAX_PLAYERS],
	PlayerText:VeloTD4[MAX_PLAYERS],
	PlayerText:VeloTD5[MAX_PLAYERS],
	PlayerText:VeloTD6[MAX_PLAYERS],
	PlayerText:VeloTD7[MAX_PLAYERS],
	PlayerText:VeloTD8[MAX_PLAYERS],
	PlayerText:VeloTD9[MAX_PLAYERS],
	PlayerText:VeloTD10[MAX_PLAYERS],
	VeloTimer[MAX_PLAYERS];

hook OnPlayerEnterVehicle(playerid, vehicleid, ispassenger){
	if(EsAvion(vehicleid)){
		PlayerTextDrawShow(playerid, VeloTD0[playerid]);
		PlayerTextDrawShow(playerid, VeloTD1[playerid]);
		PlayerTextDrawShow(playerid, VeloTD2[playerid]);
		PlayerTextDrawShow(playerid, VeloTD3[playerid]);
		PlayerTextDrawShow(playerid, VeloTD4[playerid]);
		PlayerTextDrawShow(playerid, VeloTD5[playerid]);
		PlayerTextDrawShow(playerid, VeloTD6[playerid]);
		PlayerTextDrawShow(playerid, VeloTD7[playerid]);
		PlayerTextDrawShow(playerid, VeloTD8[playerid]);
		PlayerTextDrawShow(playerid, VeloTD9[playerid]);
		PlayerTextDrawShow(playerid, VeloTD10[playerid]);
		VeloTimer[playerid] = SetTimerEx("CheckVelo", 250, true, "i", playerid);
	}
	return 1;
}
hook OnPlayerExitVehicle(playerid, vehicleid, ispassenger){
	if(EsAvion(vehicleid)){
		PlayerTextDrawHide(playerid, VeloTD0[playerid]);
		PlayerTextDrawHide(playerid, VeloTD1[playerid]);
		PlayerTextDrawHide(playerid, VeloTD2[playerid]);
		PlayerTextDrawHide(playerid, VeloTD3[playerid]);
		PlayerTextDrawHide(playerid, VeloTD4[playerid]);
		PlayerTextDrawHide(playerid, VeloTD5[playerid]);
		PlayerTextDrawHide(playerid, VeloTD6[playerid]);
		PlayerTextDrawHide(playerid, VeloTD7[playerid]);
		PlayerTextDrawHide(playerid, VeloTD8[playerid]);
		PlayerTextDrawHide(playerid, VeloTD9[playerid]);
		PlayerTextDrawHide(playerid, VeloTD10[playerid]);
		VeloTimer[playerid] = SetTimerEx("CheckVelo", 250, true, "i", playerid);
	}
	return 1;
}
hook OnPlayerDisconnect(playerid, reason){
	KillTimer(VeloTimer[playerid]);
	return 1;
}

/*
	Estados posibles:
	OP - Optimo. (Vida del avion >= 950) --
	TM - Turbulencia moderada, cuando llueve aparece. (GetPlayerWeather) --
	TE - Turbulencia extrema, tormenta de arena. ATERRIZAR YA. (Tiempo igual a 19) --
	CG - Check Gas, cuando la gasolina esta igual o menor al 20% 
	CE - Check Engine, el motor pudo haberse dañado. (vida menor/igual a 300.) 
	CP - Check Plane, algo puede estar fallando, hay que aterrizar lo antes posible (Vida menor al 600). --
	DP - Daño posible, cuando la vida del motor esta entre 600 y 950. --
	MD - El avion esta dañado, aterrizar de emergencia (Motor dañado, vida <= 250) --
	CC - Check Cargo, la carga del avion puede estar generando problemas. (Carga > 850kg en aviones pequeños.)
*/


funcion CheckVelo(playerid){
	if(!IsPlayerInAnyVehicle(playerid)) return KillTimer(VeloTimer[playerid]);
	new tstr[21], velocidad;
	velocidad = GetPlayerSpeed(playerid);
	/*
		1 KM ~ 0.53995 nudos
		VelPlayer ~ ? nudos
	*/
	velocidad = int:floatadd(Float:velocidad, 0.53995);

	format(tstr, sizeof(tstr), "Velocidad: %d nudos", velocidad);
	PlayerTextDrawSetString(playerid, VeloTD1[playerid], tstr);

	if(GetPlayerWeather(playerid) == 8 || GetPlayerWeather(playerid) == 16){
		PlayerTextDrawSetString(playerid, VeloTD10[playerid], "Estado: TM");
		PlayerTextDrawColor(playerid, VeloTD10[playerid], 0xD0E514AF);
	}
	if(GetPlayerWeather(playerid) == 19){
		PlayerTextDrawSetString(playerid, VeloTD10[playerid], "Estado: TE");
		PlayerTextDrawColor(playerid, VeloTD10[playerid], 0xEF2809AF);
	}
	
	new Float:Vida, motor, lights, alarm, doors, bonnet, boot, objective;
	GetVehicleParamsEx(GetPlayerVehicleID(playerid), motor, lights, alarm, doors, bonnet, boot, objective);
	GetVehicleHealth(GetPlayerVehicleID(playerid), Vida);
	if(Vida >= 950){
		PlayerTextDrawSetString(playerid, VeloTD10[playerid], "Estado: OP");
		PlayerTextDrawColor(playerid, VeloTD10[playerid], 8388863);
	} else if(Vida < 950 && Vida >= 600){
		PlayerTextDrawSetString(playerid, VeloTD10[playerid], "Estado: DP");
		PlayerTextDrawColor(playerid, VeloTD10[playerid], 0xD0E514AF);
	} else if(Vida < 600 && Vida >= 300){
		PlayerTextDrawSetString(playerid, VeloTD10[playerid], "Estado: CP");
		PlayerTextDrawColor(playerid, VeloTD10[playerid], 0xEF2809AF);
		new rand = random(300)+1;
		if(rand < 10 && motor != 0){
			SetVehicleParamsEx(GetPlayerVehicleID(playerid), 0, 0, 0, 0, 0, 0, 0);
			SendClientMessage(playerid, -1, "Algo esta mal, el motor se apago. Reportar inmediatamente a ATC.");
		}
	} else {
		PlayerTextDrawSetString(playerid, VeloTD10[playerid], "Estado: MD");
		PlayerTextDrawColor(playerid, VeloTD10[playerid], 0xEF2809AF);
		new rand = random(1000)+1;
		if(rand < 10 && motor != 0){
			SetVehicleParamsEx(GetPlayerVehicleID(playerid), 0, 0, 0, 0, 0, 0, 0);
			SendClientMessage(playerid, -1, "Algo esta mal, el motor se apago. Reportar inmediatamente a ATC.");
		}
	}

	/* Hacer sistema de gasolina ahora, xd.*/
	return 1;
}


hook OnPlayerConnect(playerid){
	VeloTD0[playerid] = CreatePlayerTextDraw(playerid, 510.333312, 432.492584, "usebox");
	PlayerTextDrawLetterSize(playerid, VeloTD0[playerid], 0.000000, -3.589093);
	PlayerTextDrawTextSize(playerid, VeloTD0[playerid], 623.666625, 0.000000);
	PlayerTextDrawAlignment(playerid, VeloTD0[playerid], 1);
	PlayerTextDrawColor(playerid, VeloTD0[playerid], 0);
	PlayerTextDrawUseBox(playerid, VeloTD0[playerid], true);
	PlayerTextDrawBoxColor(playerid, VeloTD0[playerid], 102);
	PlayerTextDrawSetShadow(playerid, VeloTD0[playerid], 0);
	PlayerTextDrawSetOutline(playerid, VeloTD0[playerid], 0);
	PlayerTextDrawFont(playerid, VeloTD0[playerid], 0);

	VeloTD1[playerid] = CreatePlayerTextDraw(playerid, 512.333312, 407.348052, "Velocidad: 999 nudos");
	PlayerTextDrawLetterSize(playerid, VeloTD1[playerid], 0.295999, 1.923555);
	PlayerTextDrawAlignment(playerid, VeloTD1[playerid], 1);
	PlayerTextDrawColor(playerid, VeloTD1[playerid], -1);
	PlayerTextDrawSetShadow(playerid, VeloTD1[playerid], 0);
	PlayerTextDrawSetOutline(playerid, VeloTD1[playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, VeloTD1[playerid], 51);
	PlayerTextDrawFont(playerid, VeloTD1[playerid], 1);
	PlayerTextDrawSetProportional(playerid, VeloTD1[playerid], 1);

	VeloTD2[playerid] = CreatePlayerTextDraw(playerid, 503.333160, 103.288970, "Frecuencia:");
	PlayerTextDrawLetterSize(playerid, VeloTD2[playerid], 0.335999, 1.666370);
	PlayerTextDrawAlignment(playerid, VeloTD2[playerid], 1);
	PlayerTextDrawColor(playerid, VeloTD2[playerid], -5963521);
	PlayerTextDrawSetShadow(playerid, VeloTD2[playerid], 0);
	PlayerTextDrawSetOutline(playerid, VeloTD2[playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, VeloTD2[playerid], 51);
	PlayerTextDrawFont(playerid, VeloTD2[playerid], 1);
	PlayerTextDrawSetProportional(playerid, VeloTD2[playerid], 1);

	VeloTD3[playerid] = CreatePlayerTextDraw(playerid, 574.666442, 104.118507, "LV-00");
	PlayerTextDrawLetterSize(playerid, VeloTD3[playerid], 0.384666, 1.678814);
	PlayerTextDrawAlignment(playerid, VeloTD3[playerid], 1);
	PlayerTextDrawColor(playerid, VeloTD3[playerid], -1);
	PlayerTextDrawSetShadow(playerid, VeloTD3[playerid], 0);
	PlayerTextDrawSetOutline(playerid, VeloTD3[playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, VeloTD3[playerid], 51);
	PlayerTextDrawFont(playerid, VeloTD3[playerid], 1);
	PlayerTextDrawSetProportional(playerid, VeloTD3[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, VeloTD3[playerid], true);

	VeloTD4[playerid] = CreatePlayerTextDraw(playerid, 625.666625, 389.766662, "usebox");
	PlayerTextDrawLetterSize(playerid, VeloTD4[playerid], 0.000000, -4.280452);
	PlayerTextDrawTextSize(playerid, VeloTD4[playerid], 508.666656, 0.000000);
	PlayerTextDrawAlignment(playerid, VeloTD4[playerid], 1);
	PlayerTextDrawColor(playerid, VeloTD4[playerid], 0);
	PlayerTextDrawUseBox(playerid, VeloTD4[playerid], true);
	PlayerTextDrawBoxColor(playerid, VeloTD4[playerid], 102);
	PlayerTextDrawSetShadow(playerid, VeloTD4[playerid], 0);
	PlayerTextDrawSetOutline(playerid, VeloTD4[playerid], 0);
	PlayerTextDrawFont(playerid, VeloTD4[playerid], 0);

	VeloTD5[playerid] = CreatePlayerTextDraw(playerid, 522.333312, 353.837036, "Aeropuerto cercano:");
	PlayerTextDrawLetterSize(playerid, VeloTD5[playerid], 0.253333, 1.645629);
	PlayerTextDrawAlignment(playerid, VeloTD5[playerid], 1);
	PlayerTextDrawColor(playerid, VeloTD5[playerid], -1);
	PlayerTextDrawSetShadow(playerid, VeloTD5[playerid], 0);
	PlayerTextDrawSetOutline(playerid, VeloTD5[playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, VeloTD5[playerid], 51);
	PlayerTextDrawFont(playerid, VeloTD5[playerid], 1);
	PlayerTextDrawSetProportional(playerid, VeloTD5[playerid], 1);

	VeloTD6[playerid] = CreatePlayerTextDraw(playerid, 512.666748, 370.014862, "Las Venturas (1000m)");
	PlayerTextDrawLetterSize(playerid, VeloTD6[playerid], 0.288666, 1.633185);
	PlayerTextDrawAlignment(playerid, VeloTD6[playerid], 1);
	PlayerTextDrawColor(playerid, VeloTD6[playerid], -5963521);
	PlayerTextDrawSetShadow(playerid, VeloTD6[playerid], 0);
	PlayerTextDrawSetOutline(playerid, VeloTD6[playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, VeloTD6[playerid], 51);
	PlayerTextDrawFont(playerid, VeloTD6[playerid], 1);
	PlayerTextDrawSetProportional(playerid, VeloTD6[playerid], 1);

	VeloTD7[playerid] = CreatePlayerTextDraw(playerid, 216.666671, 361.974060, "usebox");
	PlayerTextDrawLetterSize(playerid, VeloTD7[playerid], 0.000000, 1.803498);
	PlayerTextDrawTextSize(playerid, VeloTD7[playerid], 136.666671, 0.000000);
	PlayerTextDrawAlignment(playerid, VeloTD7[playerid], 1);
	PlayerTextDrawColor(playerid, VeloTD7[playerid], 0);
	PlayerTextDrawUseBox(playerid, VeloTD7[playerid], true);
	PlayerTextDrawBoxColor(playerid, VeloTD7[playerid], 102);
	PlayerTextDrawSetShadow(playerid, VeloTD7[playerid], 0);
	PlayerTextDrawSetOutline(playerid, VeloTD7[playerid], 0);
	PlayerTextDrawFont(playerid, VeloTD7[playerid], 0);

	VeloTD8[playerid] = CreatePlayerTextDraw(playerid, 141.000015, 361.303619, "Gas: 100%");
	PlayerTextDrawLetterSize(playerid, VeloTD8[playerid], 0.374333, 1.716148);
	PlayerTextDrawAlignment(playerid, VeloTD8[playerid], 1);
	PlayerTextDrawColor(playerid, VeloTD8[playerid], 8388863);
	PlayerTextDrawSetShadow(playerid, VeloTD8[playerid], 0);
	PlayerTextDrawSetOutline(playerid, VeloTD8[playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, VeloTD8[playerid], 51);
	PlayerTextDrawFont(playerid, VeloTD8[playerid], 1);
	PlayerTextDrawSetProportional(playerid, VeloTD8[playerid], 1);

	VeloTD9[playerid] = CreatePlayerTextDraw(playerid, 218.333328, 391.425933, "usebox");
	PlayerTextDrawLetterSize(playerid, VeloTD9[playerid], 0.000000, 1.849586);
	PlayerTextDrawTextSize(playerid, VeloTD9[playerid], 137.000000, 0.000000);
	PlayerTextDrawAlignment(playerid, VeloTD9[playerid], 1);
	PlayerTextDrawColor(playerid, VeloTD9[playerid], 0);
	PlayerTextDrawUseBox(playerid, VeloTD9[playerid], true);
	PlayerTextDrawBoxColor(playerid, VeloTD9[playerid], 102);
	PlayerTextDrawSetShadow(playerid, VeloTD9[playerid], 0);
	PlayerTextDrawSetOutline(playerid, VeloTD9[playerid], 0);
	PlayerTextDrawFont(playerid, VeloTD9[playerid], 0);

	VeloTD10[playerid] = CreatePlayerTextDraw(playerid, 140.666702, 391.585083, "Estado: ATC");
	PlayerTextDrawLetterSize(playerid, VeloTD10[playerid], 0.364000, 1.653925);
	PlayerTextDrawAlignment(playerid, VeloTD10[playerid], 1);
	PlayerTextDrawColor(playerid, VeloTD10[playerid], 8388863);
	PlayerTextDrawSetShadow(playerid, VeloTD10[playerid], 0);
	PlayerTextDrawSetOutline(playerid, VeloTD10[playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, VeloTD10[playerid], 51);
	PlayerTextDrawFont(playerid, VeloTD10[playerid], 1);
	PlayerTextDrawSetProportional(playerid, VeloTD10[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, VeloTD10[playerid], true);
	return 1;
}