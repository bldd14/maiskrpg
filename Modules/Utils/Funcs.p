forward DelayKick(playerid, reason[]);


public DelayKick(playerid, reason[]){
	new fstring[70];
	format(fstring, sizeof(fstring), "Fuiste expulsado del servidor, razon:\n%s", reason);
	ShowPlayerDialog(playerid, EMPTY_DIALOG, DIALOG_STYLE_MSGBOX, "Expulsion", fstring, #BUTTON1, "");
	return Kick(playerid);
}