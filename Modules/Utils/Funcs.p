funcion DelayKick(playerid, reason[]){
	new fstring[70];
	format(fstring, sizeof(fstring), "Fuiste expulsado del servidor, razon:\n%s", reason);
	ShowPlayerDialog(playerid, EMPTY_DIALOG, DIALOG_STYLE_MSGBOX, "Expulsion", fstring, "Aceptar", "");
	return SetTimerEx("Kickear", 500, false, "i", playerid);
}

funcion Kickear(playerid) return Kick(playerid);

/*funcion EsAvion(vehicleid){
	switch(vehicleid){
		case 417: return true;
		case 425: return true;
		case 447: return true;
		case 460: return true;
		case 469: return true;
		case 476: return true;
		case 487 .. 488: return true;
		case 497: return true;
		case 511 .. 513: return true;
		case 519 .. 520: return true;
		case 548: return true; 
		case 553: return true;
		case 563: return true;
		case 577: return true;
		case 592 .. 593: return true;
	}
	return false;
}*/

stock EsAvion(vehicleid)
{
    new modelid = GetVehicleModel(vehicleid);
    if(modelid == 593 || modelid == 592 || modelid == 577 || modelid == 511 || modelid == 512 || modelid == 520 || modelid == 553 || modelid == 476 || modelid == 519 || modelid == 460 || modelid == 513)
        return true;
    return false;
}


stock GetPlayerSpeed(playerid) // by Misco
{
    new Float:ST[4];
    if(IsPlayerInAnyVehicle(playerid))
        GetVehicleVelocity(GetPlayerVehicleID(playerid),ST[0],ST[1],ST[2]);
        else GetPlayerVelocity(playerid,ST[0],ST[1],ST[2]);
    ST[3] = floatsqroot(floatpower(floatabs(ST[0]), 2.0) + floatpower(floatabs(ST[1]), 2.0) + floatpower(floatabs(ST[2]), 2.0)) * 100.3;
    return floatround(ST[3]);
}

funcion GetPlayerWeather(playerid) return ClimaServidor;