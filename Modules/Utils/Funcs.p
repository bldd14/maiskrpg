forward DelayKick(playerid, reason[]);


public DelayKick(playerid, reason[]){
	new fstring[70];
	format(fstring, sizeof(fstring), #DELAYEDKICK, reason);
	ShowPlayerDialog(playerid, EMPTY_DIALOG, DIALOG_STYLE_MSGBOX, #TITLE_KICK, fstring, #BUTTON1, "");
	return Kick(playerid);
}