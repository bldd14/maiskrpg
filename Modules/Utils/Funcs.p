funcion DelayKick(playerid, reason[]){
	new fstring[70];
	format(fstring, sizeof(fstring), "Fuiste expulsado del servidor, razon:\n%s", reason);
	ShowPlayerDialog(playerid, EMPTY_DIALOG, DIALOG_STYLE_MSGBOX, "Expulsion", fstring, "Aceptar", "");
	return SetTimerEx("Kickear", 500, false, "i", playerid);
}

funcion Kickear(playerid) return Kick(playerid);

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
    return floatround(ST[3]/0.53995);
}
