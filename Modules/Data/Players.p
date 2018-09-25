#include <YSI\y_hooks>

new bool:UsuarioLogueo[MAX_PLAYERS];

enum PlayerInfo
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
	PStats[4], 	// Skin, money, bank money, age.
	bool:jGenero, 
	jPilotGroup[2], // Pilot Group, Group ID and role in group.
	jFaction,
	jRank
}
new Info[MAX_PLAYERS][PlayerInfo];

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
			DelayKick(playerid, "Baneado del servidor");
			cache_delete(result);
			return 1;
		}
		cache_get_field_content(0, "Password", Info[playerid][jPassword]);
		cache_get_field_content(0, "Salt", Info[playerid][jSalt]);
		ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Ingreso", "Bienvenido de nuevo\n\nIngresa tu clave:", "Ingresar", "Salir");
	} else {
		ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "Registro", "Bienvenido a Maisk RPG\n\nIngresa una clave:", "Ingresar", "Cancelar");
	}
	cache_delete(result);
	return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]){
	if(dialogid == DIALOG_LOGIN){
		if(!response) return Kick(playerid);
		new temp_hash[65];
		SHA256_PassHash(inputtext, Info[playerid][jSalt], temp_hash, 65);
		if(!strcmp(Info[playerid][jPassword], temp_hash)){
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
			Info[playerid][jGenero] = bool:cache_get_field_content_int(0, "Genero");
			Info[playerid][jPilotGroup][0] = cache_get_field_content_int(0, "GroupID");
			Info[playerid][jPilotGroup][1] = cache_get_field_content_int(0, "GroupRole");
			Info[playerid][jFaction] = cache_get_field_content_int(0, "Faction");
			Info[playerid][jRank] = cache_get_field_content_int(0, "Rank");
			cache_delete(result);

			SetSpawnInfo(playerid, NO_TEAM, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
			SpawnPlayer(playerid);
		} else {
			ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Ingreso - Error", "Error - clave incorrecta\n\nIngresa tu clave:", "Ingresar", "Salir");
		}
	}
	if(dialogid == DIALOG_REGISTER){
		if(!response) return Kick(playerid);
		if(strlen(inputtext) > 30 || strlen(inputtext) < 4) return ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "Registro - Error", "Error, la clave debe tener al menos\n4 caracteres y no ser mayor a 30 caracteres\nIngresa una clave valida:", "Ingresar", "Cancelar");
		for(new i; i < 10; i++){
			Info[playerid][jSalt][i] = random(79) + 47;
		}
		Info[playerid][jSalt][10] = 0;
		SHA256_PassHash(inputtext, Info[playerid][jSalt], Info[playerid][jPassword], 65);
		/* Terminar registro -- Estoy pensando en unas cosas para hacerlo interesante */
		ShowPlayerDialog(playerid, DIALOG_AGE, DIALOG_STYLE_INPUT, "Edad", "Ingresa la edad de tu personaje", "Ingresar", "Salir");
	}
	if(dialogid == DIALOG_AGE){
		if(!response) return Kick(playerid);
		if(strval(inputtext) < 18 || strlen(inputtext) > 70) return ShowPlayerDialog(playerid, DIALOG_AGE, DIALOG_STYLE_INPUT, "Edad - Error", "Ingresa la edad de tu personaje\n\nError: Debe estar entre 18 y 70 años", "Ingresar", "Salir");
		Info[playerid][PStats][3] = strval(inputtext);
		ShowPlayerDialog(playerid, DIALOG_GENDER, DIALOG_STYLE_MSGBOX, "Genero", "Elige el genero de tu personaje.", "Masculino", "Femenino");
		return 1;
	}
	if(dialogid == DIALOG_GENDER){
		if(response){
			Info[playerid][jGenero] = false;
		} else {
			Info[playerid][jGenero] = true;
		}
		new query[200];
		GetPlayerName(playerid, query, sizeof(query));
		mysql_format(Handle, query, sizeof(query), "INSERT INTO players (Name, Password, Salt, Edad, Genero) VALUES ('%e', '%e', '%e', '%d', '%d')", 
			query,
			Info[playerid][jPassword],
			Info[playerid][jSalt],
			Info[playerid][PStats][3],
			Info[playerid][jGenero]);
		mysql_query(Handle, query, false);

		ShowPlayerDialog(playerid, DIALOG_INGRESO, DIALOG_STYLE_LIST, "Modo de juego", "Campaña (Misiones)\nMundo libre (Solo)\nMundo libre (Multijugador)", "Elegiir", "");
		return 1;
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
		Info[playerid][jGenero],
		Info[playerid][jPilotGroup][0],
		Info[playerid][jPilotGroup][1],
		Info[playerid][jFaction],
		Info[playerid][jRank],
		nombre
		);
	mysql_query(Handle, query, false);
	return 1;
}