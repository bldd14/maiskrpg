#include <YSI\y_hooks>

new bool:UsuarioLogueo[MAX_PLAYERS];

enum Players
{
	jID,
	jPassword[65],
	jSalt[11],
	jAdmin,
	bool:jBaneado,
	jNivelPiloto, // Used for LevelCalc.
	jVuelos, // Used for LevelCalc.
	jVPromedio, // Used for LevelCalc.
	Float:jPos[4],
	Float:jStats[2], // Armour && Health.
	PStats[5], // Skin, money, bank money, age, gender.
	jPilotGroup[2], // Pilot Group, Group ID and role in group.
	jFaction,
	jRank
}
new Info[MAX_PLAYERS][Players];

hook OnPlayerConnect(playerid){
	UsuarioLogueo[playerid] = false;
	new query[36+MAX_PLAYER_NAME];
	GetPlayerName(playerid, query, sizeof(query));
	mysql_format(Handle, query, sizeof(query), "SELECT * FROM players WHERE Name = '%e'", query);
	new Cache:result = mysql_query(Handle, query, true);
	new rows = cache_get_row_count();

	if(rows){
		Info[playerid][jBaneado] = bool:cache_get_field_content_int(0, "Baneado");
		if(Info[playerid][jBaneado] == true){
			DelayKick(playerid, #BANNED);
			cache_delete(result);
			return 1;
		}
		Info[playerid][jID] = cache_get_field_content_int(0, "ID");
		cache_get_field_content(0, "Password", Info[playerid][jPassword]);
		cache_get_field_content(0, "Salt", Info[playerid][jSalt]);
		ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, #TITLE_LOGIN, #LOGIN_INFO, #BUTTON3, #BUTTON4);
	} else {
		ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, #TITLE_REGISTER, #REGISTER_INFO, #BUTTON3, #BUTTON2);
	}
	cache_delete(result);
	return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]){
	if(dialogid == DIALOG_LOGIN){
		if(!response) return Kick(playerid);
		new temp_hash[65];
		SHA256_PassHash(inputtext, Info[playerid][jSalt], temp_hash, 65);
		if(!strcmp(inputtext, temp_hash)){
			new query[36+MAX_PLAYER_NAME];
			UsuarioLogueo[playerid] = true;
			GetPlayerName(playerid, query, sizeof(query));
			mysql_format(Handle, query, sizeof(query), "SELECT * FROM players WHERE Name = '%e'", query);
			new Cache:result = mysql_query(Handle, query, true);
			Info[playerid][jAdmin] = cache_get_field_content_int(0, "Admin");
			Info[playerid][jNivelPiloto] = cache_get_field_content_int(0, "NivelPiloto");
			Info[playerid][jVuelos] = cache_get_field_content_int(0, "Vuelos");
			Info[playerid][jVPromedio] = cache_get_field_content_int(0, "VPromedio");
			Info[playerid][jPos][0] = cache_get_field_content_float(0, "X");
			Info[playerid][jPos][1] = cache_get_field_content_float(0, "Y");
			Info[playerid][jPos][2] = cache_get_field_content_float(0, "Z");
			Info[playerid][jPos][3] = cache_get_field_content_float(0, "A");
			Info[playerid][jStats][0] = cache_get_field_content_float(0, "Vida");
			Info[playerid][jStats][1] = cache_get_field_content_float(0, "Armadura");
			Info[playerid][PStats][0] = cache_get_field_content_int(0, "Skin");
			Info[playerid][PStats][1] = cache_get_field_content_int(0, "Dinero");
			Info[playerid][PStats][2] = cache_get_field_content_int(0, "Banco");
			Info[playerid][PStats][3] = cache_get_field_content_int(0, "Edad");
			Info[playerid][PStats][4] = cache_get_field_content_int(0, "Genero");
			Info[playerid][jPilotGroup][0] = cache_get_field_content_int(0, "GroupID");
			Info[playerid][jPilotGroup][1] = cache_get_field_content_int(0, "GroupRole");
			Info[playerid][jFaction] = cache_get_field_content_int(0, "Faction");
			Info[playerid][jRank] = cache_get_field_content_int(0, "Rank");
			cache_delete(result);

			SetSpawnInfo(playerid, NO_TEAM, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
			SpawnPlayer(playerid);
		} else {
			ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, #TITLE_LOGIN_ERROR, #LOGIN_INFO_ERROR, #BUTTON3, #BUTTON4);
		}
	}
	if(dialogid == DIALOG_REGISTER){
		if(!response) return Kick(playerid);
		if(strlen(inputtext) > 30 || strlen(inputtext) < 4) return ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, #TITLE_REGISTER_ERROR, #REGISTER_INFO_ERROR, #BUTTON3, #BUTTON2);
		for(new i; i < 10; i++){
			Info[playerid][jSalt][i] = random(79) + 47;
		}
		Info[playerid][jSalt][10] = 0;
		SHA256_PassHash(inputtext, Info[playerid][jSalt], Info[playerid][jPassword], 65);
		/* Terminar registro -- Estoy pensando en unas cosas para hacerlo interesante */
		SetSpawnInfo(playerid, NO_TEAM, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0); 
		SpawnPlayer(playerid);
	}
	return 0;
}

hook OnPlayerDisconnect(playerid, reason){
	if(!UsuarioLogueo[playerid]) return 1;
	new query[215+MAX_PLAYER_NAME], nombre[MAX_PLAYER_NAME], Float:stats[6];
	GetPlayerName(playerid, nombre, MAX_PLAYER_NAME);
	GetPlayerPos(playerid, stats[0], stats[1], stats[2]);
	GetPlayerFacingAngle(playerid, stats[3]);
	GetPlayerHealth(playerid, stats[4]);
	GetPlayerArmour(playerid, stats[5]);

	mysql_format(Handle, query, sizeof(query), "UPDATE players SET Admin = '%d', NivelPiloto = '%d', Vuelos = '%d', VPromedio = '%d', X = '%f', Y = '%f', Z = '%f', A = '%f', Vida = '%f', Armadura = '%f' WHERE Name = '%e'", 
		Info[playerid][jAdmin],
		Info[playerid][jNivelPiloto],
		Info[playerid][jVuelos],
		Info[playerid][jVPromedio],
		stats[0],stats[1],stats[2],stats[3],stats[0],stats[4],stats[5],nombre);
	mysql_query(Handle, query, false);

	mysql_format(Handle, query, sizeof(query), "UPDATE players SET Skin = '%d', Dinero = '%d', Banco = '%d', Edad = '%d', Genero = '%d', GroupID = '%d', GroupRole = '%d', Faction = '%d', Rank = '%d' WHERE Name = '%e'", 
		Info[playerid][PStats][0],
		Info[playerid][PStats][1],
		Info[playerid][PStats][2],
		Info[playerid][PStats][3],
		Info[playerid][PStats][4],
		Info[playerid][jPilotGroup][0],
		Info[playerid][jPilotGroup][1],
		Info[playerid][jFaction],
		Info[playerid][jRank],
		nombre
		);
	mysql_query(Handle, query, false);
	return 1;
}